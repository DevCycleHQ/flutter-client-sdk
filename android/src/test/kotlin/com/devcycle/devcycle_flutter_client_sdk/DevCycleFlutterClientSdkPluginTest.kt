package com.devcycle.devcycle_flutter_client_sdk

import com.devcycle.sdk.android.model.EvalReason
import org.junit.Test
import org.junit.Assert.*

/**
 * Unit tests for DevCycleFlutterClientSdkPlugin
 * 
 * Specifically testing EvalReason serialization to ensure proper
 * conversion from Kotlin objects to Maps for Flutter platform channel.
 * 
 * Note: The evalReasonToMap method is internal (package-private) to allow
 * direct testing without reflection, which is fragile and breaks with obfuscation.
 */
class DevCycleFlutterClientSdkPluginTest {
    
    private val plugin = DevCycleFlutterClientSdkPlugin()
    
    // Direct access to internal method - no reflection needed
    private fun evalReasonToMap(evalReason: EvalReason?): Map<String, Any?>? {
        return plugin.evalReasonToMap(evalReason)
    }
    
    @Test
    fun `evalReasonToMap converts complete EvalReason to Map`() {
        // Note: This test assumes EvalReason has a constructor or factory method
        // Adjust based on actual EvalReason implementation
        val evalReason = createMockEvalReason("TARGETING_MATCH", "Email AND App Version", "target_123")
        
        val result = evalReasonToMap(evalReason)
        
        assertNotNull(result)
        assertEquals("TARGETING_MATCH", result?.get("reason"))
        assertEquals("Email AND App Version", result?.get("details"))
        assertEquals("target_123", result?.get("target_id"))
    }
    
    @Test
    fun `evalReasonToMap handles null EvalReason`() {
        val result = evalReasonToMap(null)
        
        assertNull(result)
    }
    
    @Test
    fun `evalReasonToMap converts EvalReason with null targetId`() {
        val evalReason = createMockEvalReason("DEFAULT", "User Not Targeted", null)
        
        val result = evalReasonToMap(evalReason)
        
        assertNotNull(result)
        assertEquals("DEFAULT", result?.get("reason"))
        assertEquals("User Not Targeted", result?.get("details"))
        assertNull(result?.get("target_id"))
    }
    
    @Test
    fun `evalReasonToMap converts EvalReason with null details`() {
        val evalReason = createMockEvalReason("ERROR", null, "target_456")
        
        val result = evalReasonToMap(evalReason)
        
        assertNotNull(result)
        assertEquals("ERROR", result?.get("reason"))
        assertNull(result?.get("details"))
        assertEquals("target_456", result?.get("target_id"))
    }
    
    @Test
    fun `evalReasonToMap converts EvalReason with null optional fields`() {
        // EvalReason.reason is non-nullable with default "", so we test with default reason
        val evalReason = EvalReason(reason = "", details = null, targetId = null)
        
        val result = evalReasonToMap(evalReason)
        
        assertNotNull(result)
        assertEquals(3, result?.size)
        // EvalReason.reason has default value "" per Android SDK data class definition
        assertEquals("", result?.get("reason"))
        assertNull(result?.get("details"))
        assertNull(result?.get("target_id"))
    }
    
    @Test
    fun `evalReasonToMap returns serializable types only`() {
        val evalReason = createMockEvalReason("TARGETING_MATCH", "Test", "id123")
        
        val result = evalReasonToMap(evalReason)
        
        assertNotNull(result)
        result?.values?.forEach { value ->
            // All values must be null or basic types that Flutter can serialize
            assertTrue(
                value == null ||
                value is String ||
                value is Number ||
                value is Boolean ||
                value is List<*> ||
                value is Map<*, *>
            )
        }
    }
    
    @Test
    fun `evalReasonToMap converts different reason types`() {
        val reasonTypes = listOf(
            "DEFAULT",
            "TARGETING_MATCH",
            "CONFIG_NOT_READY",
            "VARIABLE_NOT_FOUND",
            "ERROR",
            "BOOTSTRAP",
            "STALE"
        )
        
        for (reasonType in reasonTypes) {
            val evalReason = createMockEvalReason(reasonType, "Details for $reasonType", null)
            val result = evalReasonToMap(evalReason)
            
            assertNotNull("Result should not be null for reason type: $reasonType", result)
            assertEquals(reasonType, result?.get("reason"))
            assertEquals("Details for $reasonType", result?.get("details"))
        }
    }
    
    @Test
    fun `evalReasonToMap result contains exactly three keys with correct values`() {
        val evalReason = createMockEvalReason("DEFAULT", "Test details", null)
        
        val result = evalReasonToMap(evalReason)
        
        assertNotNull(result)
        assertEquals(3, result?.size)
        assertEquals("DEFAULT", result?.get("reason"))
        assertEquals("Test details", result?.get("details"))
        assertNull(result?.get("target_id"))
    }
    
    @Test
    fun `evalReasonToMap works with EvalReason constructor directly`() {
        // Test using actual EvalReason API without helper to ensure real-world accuracy
        val evalReason = EvalReason(
            reason = "TARGETING_MATCH",
            details = "User ID",
            targetId = "6970d55494529ca5258ea054"
        )
        
        val result = evalReasonToMap(evalReason)
        
        assertNotNull(result)
        assertEquals("TARGETING_MATCH", result?.get("reason"))
        assertEquals("User ID", result?.get("details"))
        assertEquals("6970d55494529ca5258ea054", result?.get("target_id"))
    }
    
    @Test
    fun `evalReasonToMap handles EvalReason with default values`() {
        // Test using EvalReason's default parameter values
        val evalReason = EvalReason()  // Uses defaults: reason="", details=null, targetId=null
        
        val result = evalReasonToMap(evalReason)
        
        assertNotNull(result)
        assertEquals("", result?.get("reason"))
        assertNull(result?.get("details"))
        assertNull(result?.get("target_id"))
    }
    
    /**
     * Helper method to create EvalReason instances for testing.
     * 
     * Uses the actual EvalReason data class constructor from the Android SDK:
     * data class EvalReason(
     *     val reason: String = "",           // Non-nullable with default
     *     val details: String? = null,       // Nullable
     *     val targetId: String? = null       // Nullable
     * )
     * 
     * Note: This directly uses the EvalReason API to ensure tests reflect real-world behavior.
     */
    private fun createMockEvalReason(reason: String, details: String?, targetId: String?): EvalReason {
        return EvalReason(
            reason = reason,
            details = details,
            targetId = targetId
        )
    }
}
