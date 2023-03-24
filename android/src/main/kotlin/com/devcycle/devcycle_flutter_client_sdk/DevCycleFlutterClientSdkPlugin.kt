package com.devcycle.devcycle_flutter_client_sdk

import android.content.Context
import android.os.Handler
import android.os.Looper
import androidx.annotation.NonNull
import com.devcycle.sdk.android.api.*
import com.devcycle.sdk.android.model.*
import com.devcycle.sdk.android.util.LogLevel

import kotlin.collections.*
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import org.json.JSONArray
import org.json.JSONObject
import java.math.BigDecimal
import java.text.SimpleDateFormat

/** DevCycleFlutterClientSdkPlugin */
class DevCycleFlutterClientSdkPlugin: FlutterPlugin, MethodCallHandler {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var channel : MethodChannel
  private lateinit var context: Context
  private lateinit var client: DVCClient
  private var stringVariableUpdates = mutableMapOf<String, Variable<String>>()
  private var numberVariableUpdates = mutableMapOf<String, Variable<Number>>()
  private var booleanVariableUpdates = mutableMapOf<String, Variable<Boolean>>()
  private var jsonArrayVariableUpdates = mutableMapOf<String, Variable<JSONArray>>()
  private var jsonObjectVariableUpdates = mutableMapOf<String, Variable<JSONObject>>()


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
    val args = mutableMapOf<String, Any?>()
    when (call.method) {
      "initialize" -> {
        val codecOptions: Map<String, Any>? = call.argument("options")
        val logLevel = getLogLevelFromMap(codecOptions)
        val clientBuilder = DVCClient
          .builder()
          .withContext(context)
          .withSDKKey(call.argument("sdkKey")!!)
          .withUser(getUserFromMap(call.argument("user")!!))
          .withOptions(getOptionsFromMap(codecOptions))
        if (logLevel is LogLevel) {
          clientBuilder.withLogLevel(logLevel)
        }

        client = clientBuilder.build()

        client.onInitialized(object : DVCCallback<String> {
          override fun onSuccess(result: String) {
            callFlutter("clientInitialized", args)
          }

          override fun onError(t: Throwable) {
            args["error"] = t.message
            callFlutter("clientInitialized", t.message)
          }
        })
        res.success(null)
      }
      "identifyUser" -> {
        val user = getUserFromMap(call.argument("user")!!)
        args["callbackId"] = call.argument("callbackId") as String?
        val callback = object: DVCCallback<Map<String, BaseConfigVariable>> {
          override fun onSuccess(result: Map<String, BaseConfigVariable>) {
            args["variables"] = variablesToMap(result)
            callFlutter("userIdentified", args)
          }
          override fun onError(t: Throwable) {
            args["error"] = t.message
            callFlutter("userIdentified", args)
          }
        }

        client.identifyUser(user, callback)
      }
      "resetUser" -> {
        args["callbackId"] = call.argument("callbackId") as String?
        val callback = object: DVCCallback<Map<String, BaseConfigVariable>> {
          override fun onSuccess(result: Map<String, BaseConfigVariable>) {
            args["variables"] = variablesToMap(result)
            callFlutter("userReset", args)
          }
          override fun onError(t: Throwable) {
            args["error"] = t.message
            callFlutter("userReset", args)
          }
        }

        client.resetUser(callback)
      }
      "variable" -> {
        val key: String = call.argument("key")!!

        when (call.argument<Any>("defaultValue")) {
          is String -> {
            val defaultValue = call.argument<String>("defaultValue")
            val variable = client.variable(key, defaultValue!!)
            watchForVariableUpdate(variable, stringVariableUpdates)
            res.success(variableToMap(variable))
          }
          is Boolean -> {
            val defaultValue = call.argument<Boolean>("defaultValue")
            val variable = client.variable(key, defaultValue!!)
            watchForVariableUpdate(variable, booleanVariableUpdates)
            res.success(variableToMap(variable))
          }
          is Number -> {
            val defaultValue = call.argument<Number>("defaultValue")
            val variable = client.variable(key, defaultValue!!)
            watchForVariableUpdate(variable, numberVariableUpdates)
            res.success(variableToMap(variable))
          }
          is HashMap<*, *> -> {
            val defaultValue = call.argument<HashMap<*, *>>("defaultValue")
            val variable = client.variable(key, JSONObject(defaultValue))
            watchForVariableUpdate(variable, jsonObjectVariableUpdates)
            res.success(variableToMap(variable))
          }
          is List<*> -> {
            val defaultValue = call.argument<List<*>>("defaultValue")
            val variable = client.variable(key, JSONArray(defaultValue))
            watchForVariableUpdate(variable, jsonArrayVariableUpdates)
            res.success(variableToMap(variable))
          }
        }
      }
      "allFeatures" -> {
        val features = featuresToMap(client.allFeatures())
        res.success(features)
      }
      "allVariables" -> {
        val variables = variablesToMap(client.allVariables())
        res.success(variables)
      }
      "track" -> {
        val event = getEventFromMap(call.argument("event")!!)
        client.track(event)
      }
      "flushEvents" -> {
        args["callbackId"] = call.argument("callbackId") as String?
        val callback = object: DVCCallback<String> {
          override fun onSuccess(result: String) {
            args["result"] = result
            callFlutter("eventsFlushed", args)
          }

          override fun onError(t: Throwable) {
            args["error"] = t.message
            callFlutter("flushEvents", args)
          }
        }

        client.flushEvents(callback)
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

  private fun getEventFromMap(map: Map<String, Any>): DVCEvent {
    val eventBuilder = DVCEvent.builder()

    val type = map["type"] as? String
    if (type is String) eventBuilder.withType(type)

    val target = map["target"] as? String
    if (target is String) eventBuilder.withTarget(target)

    val valueStr = map["value"] as? String
    if (valueStr != null && valueStr != "null") {
      try {
        val value = BigDecimal(valueStr)
        eventBuilder.withValue(value)
      } catch (e: NumberFormatException) {
        throw e
      }
    }

    val dateStr = map["date"] as? String
    if (dateStr is String) {
      val format = SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
      val date = format.parse(dateStr)
      eventBuilder.withDate(date)
    }


    if (map["metaData"] != null) {
      eventBuilder.withMetaData(map["metaData"] as Map<String, Any>)
    }

    return eventBuilder.build()
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

  private fun getLogLevelFromMap(map: Map<String, Any>?): LogLevel? {
    val logLevelString = map?.get("logLevel") as String?
    val logLevelMap = mapOf(
      "debug" to LogLevel.DEBUG,
      "info" to LogLevel.INFO,
      "warn" to LogLevel.WARN,
      "error" to LogLevel.ERROR
    )

    if (logLevelString in logLevelMap) {
      return logLevelMap[logLevelString]
    }

    return null
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

  private fun variablesToMap(variables: Map<String, BaseConfigVariable>?): Map<String, Map<String, Any?>> {
    val map = mutableMapOf<String, Map<String, Any?>>()

    variables?.forEach { (key, variable) ->
      map[key] = variableToMap(variable)
    }

    return map
  }

  private fun variableToMap(variable: BaseConfigVariable): Map<String, Any?> {
    val variableAsMap = mutableMapOf<String, Any?>()
    var value = variable.value
    variableAsMap["id"] = variable.id
    variableAsMap["key"] = variable.key
    variableAsMap["type"] = variable.type.toString()
    variableAsMap["value"] = value
    variableAsMap["evalReason"] = variable.evalReason

    if (value is JSONObject) variableAsMap["value"] = value.toMap()
    if (value is JSONArray) variableAsMap["value"] = value.toMap()

    return variableAsMap
  }

  private fun <T> variableToMap(variable: Variable<T>): Map<String, Any?> {
    val variableAsMap = mutableMapOf<String, Any?>()
    var value = variable.value
    variableAsMap["id"] = variable.id
    variableAsMap["key"] = variable.key
    variableAsMap["type"] = variable.type.toString()
    variableAsMap["value"] = value
    variableAsMap["evalReason"] = variable.evalReason

    if (value is JSONObject) variableAsMap["value"] = value.toMap()
    if (value is JSONArray) variableAsMap["value"] = value.toMap()

    return variableAsMap
  }

  private fun <T> watchForVariableUpdate(variable: Variable<T>, variableUpdateMap: MutableMap<String, Variable<T>>) {
    if (variable.key !in variableUpdateMap) {
      variable.onUpdate { result: Variable<T> ->
        var value = result.value
        val args = mutableMapOf(
          "key" to result.key,
          "value" to value
        )
        if (value is JSONObject) args["value"] = value.toMap()
        if (value is JSONArray) args["value"] = value.toMap()
        callFlutter("variableUpdated", args)
      }
      variableUpdateMap[variable.key] = (variable)
    }
  }

  private fun JSONArray.toMap(): List<*> {
    val map = (0 until this.length()).associate { Pair(it.toString(), this[it]) }
    return JSONObject(map).toMap().values.toList()
  }

  private fun JSONObject.toMap(): Map<String, *> = keys().asSequence().associateWith {
    when (val value = this[it])
    {
      is JSONArray -> value.toMap()
      is JSONObject -> value.toMap()
      JSONObject.NULL -> null
      else            -> value
    }
  }
}