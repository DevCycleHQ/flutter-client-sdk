package com.devcycle.devcycle_flutter_client_sdk

import android.content.Context
import android.os.Handler
import android.os.Looper
import androidx.annotation.NonNull
import com.devcycle.sdk.android.api.*
import com.devcycle.sdk.android.model.*

import kotlin.collections.*
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/** DevCycleFlutterClientSdkPlugin */
class DevCycleFlutterClientSdkPlugin: FlutterPlugin, MethodCallHandler {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var channel : MethodChannel
  private lateinit var context: Context
  private lateinit var client: DVCClient

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    context = flutterPluginBinding.applicationContext
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "devcycle_flutter_client_sdk")
    channel.setMethodCallHandler(this)
  }

  private fun callFlutter(method: String, arguments: Any?) {
    // invokeMethod must be called on main thread
    if (Looper.myLooper() == Looper.getMainLooper()) {
      channel.invokeMethod(method, arguments)
    } else {
      // Call ourselves on the main thread
      Handler(Looper.getMainLooper()).post { callFlutter(method, arguments) }
    }
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull res: Result) {
    when (call.method) {
      "initialize" -> {
        client = DVCClient
          .builder()
          .withContext(context)
          .withEnvironmentKey(call.argument("environmentKey")!!)
          .withUser(getUserFromMap(call.argument("user")!!))
          .withOptions(getOptionsFromMap(call.argument("options")))
          .build()

        client.onInitialized(object : DVCCallback<String> {
          override fun onSuccess(result: String) {
            callFlutter("clientInitialized", null)
          }

          override fun onError(t: Throwable) {
            callFlutter("clientInitialized", t.message)
          }
        })
      }
      "identifyUser" -> {
        val user = getUserFromMap(call.argument("user")!!)
        val callbackId = call.argument("callbackId") as String?
        val callback = object: DVCCallback<Map<String, Variable<Any>>> {
          override fun onSuccess(result: Map<String, Variable<Any>>) {
            val args = mutableMapOf<String, Any?>()
            args["error"] = null
            args["callbackId"] = callbackId
            args["variables"] = variablesToMap(result)
            callFlutter("userIdentified", args)
          }
          override fun onError(t: Throwable) {
            val args = mutableMapOf<String, Any?>()
            args["error"] = t
            args["callbackId"] = callbackId
            callFlutter("userIdentified", args)
          }
        }

        client.identifyUser(user, callback)
      }
      "resetUser" -> {
        val callbackId = call.argument("callbackId") as String?
        val callback = object: DVCCallback<Map<String, Variable<Any>>> {
          override fun onSuccess(result: Map<String, Variable<Any>>) {
            val args = mutableMapOf<String, Any?>()
            args["error"] = null
            args["callbackId"] = callbackId
            args["variables"] = variablesToMap(result)
            callFlutter("userReset", args)
          }
          override fun onError(t: Throwable) {
            val args = mutableMapOf<String, Any?>()
            args["error"] = t
            args["callbackId"] = callbackId
            callFlutter("userReset", args)
          }
        }

        client.resetUser(callback)
      }
      "variable" -> {
        if (::client.isInitialized) {
          val response = HashMap<String, Any>()
          val variable = client.variable(call.argument("key")!!, call.argument("defaultValue")!!)
          response[variable.key] = variable
          res.success(response)
        }
        res.success(null)
      }
      "allFeatures" -> {
        val features = featuresToMap(client.allFeatures())
        res.success(features)
      }
      "allVariables" -> {
        val variables = variablesToMap(client.allVariables())
        res.success(variables)
      }
      "getPlatformVersion" -> {
        res.success("Android ${android.os.Build.VERSION.RELEASE}")
      }
      else -> {
        res.notImplemented()
      }
    }
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }

  private fun getUserFromMap(map: Map<String, Any>): DVCUser {
    val userBuilder = DVCUser.builder()

    val anonymous = map["anonymous"] as? Boolean
    if (anonymous is Boolean) userBuilder.withIsAnonymous(anonymous)

    val userId = map["userId"] as? String
    if (userId is String) userBuilder.withUserId(userId)

    val email = map["email"] as? String
    if (email is String) userBuilder.withEmail(email)

    val name = map["name"] as? String
    if (name is String) userBuilder.withName(name)

    val country = map["country"] as? String
    if (country is String) userBuilder.withCountry(country)

    if (map["customData"] != null) {
      userBuilder.withCustomData(map["customData"] as Map<String, Any>)
    }

    if (map["privateCustomData"] != null) {
      userBuilder.withPrivateCustomData(map["privateCustomData"] as Map<String, Any>)
    }

    return userBuilder.build()
  }

  private fun getOptionsFromMap(map: Map<String, Any>?): DVCOptions {
    val builder = DVCOptions.builder()

    if (map != null) {
      val flushEventsIntervalMs = map["flushEventsIntervalMs"] as? Long
      if (flushEventsIntervalMs is Long) builder.flushEventsIntervalMs(flushEventsIntervalMs)

      val disableEventLogging = map["flushEventsIntervalMs"] as? Boolean
      if (disableEventLogging is Boolean) builder.disableEventLogging(disableEventLogging)

      val configCacheTTL = map["configCacheTTL"] as? Long
      if (configCacheTTL is Long) builder.configCacheTTL(configCacheTTL)

      val disableConfigCache = map["disableConfigCache"] as? Boolean
      if (disableConfigCache is Boolean) builder.disableConfigCache(disableConfigCache)
    }

    return builder.build()
  }

  private fun featuresToMap(features: Map<String, Feature>?): Map<String, Map<String, Any?>> {
    val map = mutableMapOf<String, Map<String, Any?>>()

    features?.forEach { (key, feature) ->
      map[key] = featureToMap(feature)
    }

    return map
  }

  private fun featureToMap(feature: Feature): Map<String, Any?> {
    val featureAsMap = mutableMapOf<String, Any?>()
    featureAsMap["id"] = feature.id
    featureAsMap["key"] = feature.key
    featureAsMap["type"] = feature.type.toString()
    featureAsMap["variation"] = feature.variation
    featureAsMap["evalReason"] = feature.evalReason
    featureAsMap["variationName"] = feature.variationName
    featureAsMap["variationKey"] = feature.variationKey

    return featureAsMap
  }

  private fun variablesToMap(variables: Map<String, Variable<Any>>?): Map<String, Map<String, Any?>> {
    val map = mutableMapOf<String, Map<String, Any?>>()

    variables?.forEach { (key, variable) ->
      map[key] = variableToMap(variable)
    }

    return map
  }

  private fun variableToMap(variable: Variable<Any>): Map<String, Any?> {
    val variableAsMap = mutableMapOf<String, Any?>()
    variableAsMap["id"] = variable.id
    variableAsMap["key"] = variable.key
    variableAsMap["type"] = variable.type.toString()
    variableAsMap["value"] = variable.value
    variableAsMap["evalReason"] = variable.evalReason

    return variableAsMap
  }
}
