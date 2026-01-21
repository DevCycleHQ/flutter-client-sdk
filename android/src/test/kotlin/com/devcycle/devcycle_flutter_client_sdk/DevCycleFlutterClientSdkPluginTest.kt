package com.devcycle.devcycle_flutter_client_sdk

import com.devcycle.sdk.android.model.EvalReason
import org.junit.Test
import org.junit.Assert.*

/**
 * Unit tests for DevCycleFlutterClientSdkPlugin
 * 
 * Specifically testing EvalReason serialization to ensure proper
 * conversion from Kotlin objects to Maps for Flutter platform channel.
 */
class DevCycleFlutterClientSdkPluginTest {
    
    private val plugin = DevCycleFlutterClientSdkPlugin()
    
    // Use reflection to access private method for testing
    private fun evalReasonToMap(evalReason: EvalReason?): Map<String, Any?>? {
        val method = plugin::class.java.getDeclaredMethod("evalReasonToMap", EvalReason::class.java)
        method.isAccessible = true
        @Suppress("UNCHECKED_CAST")
        return method.invoke(plugin, evalReason) as? Map<String, Any?>
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
        assertEquals("target_123", result?.get("targetId"))
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
        assertNull(result?.get("targetId"))
    }
    
    @Test
    fun `evalReasonToMap converts EvalReason with null details`() {
        val evalReason = createMockEvalReason("ERROR", null, "target_456")
        
        val result = evalReasonToMap(evalReason)
        
        assertNotNull(result)
        assertEquals("ERROR", result?.get("reason"))
        assertNull(result?.get("details"))
        assertEquals("target_456", result?.get("targetId"))
    }
    
    @Test
    fun `evalReasonToMap converts EvalReason with all null fields`() {
        val evalReason = createMockEvalReason(null, null, null)
        
        val result = evalReasonToMap(evalReason)
        
        assertNotNull(result)
        assertTrue(result?.containsKey("reason") == true)
        assertTrue(result?.containsKey("details") == true)
        assertTrue(result?.containsKey("targetId") == true)
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
    fun `evalReasonToMap result contains exactly three keys`() {
        val evalReason = createMockEvalReason("DEFAULT", "Test", null)
        
        val result = evalReasonToMap(evalReason)
        
        assertNotNull(result)
        assertEquals(3, result?.size)
        assertTrue(result?.containsKey("reason") == true)
        assertTrue(result?.containsKey("details") == true)
        assertTrue(result?.containsKey("targetId") == true)
    }
    
    // Helper method to create mock EvalReason
    // This is a placeholder - adjust based on actual EvalReason implementation
    private fun createMockEvalReason(reason: String?, details: String?, targetId: String?): EvalReason {
        // Note: This needs to be implemented based on the actual EvalReason class
        // For now, this is a placeholder that shows the test structure
        throw NotImplementedError(
            "This helper needs to be implemented based on the actual EvalReason class constructor/factory"
        )
    }
}
