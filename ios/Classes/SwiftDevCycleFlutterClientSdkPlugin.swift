import Flutter
import UIKit

import DevCycle

public class SwiftDevCycleFlutterClientSdkPlugin: NSObject, FlutterPlugin {
  private var dvcClient: DVCClient?
  private let channel: FlutterMethodChannel
  private var variableUpdates: [String: DVCVariable<Any>] = [:]
    
  private init(channel: FlutterMethodChannel) {
    self.channel = channel
  }
  
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "devcycle_flutter_client_sdk", binaryMessenger: registrar.messenger())
    let instance = SwiftDevCycleFlutterClientSdkPlugin(channel: channel)
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    var user: DVCUser?
    let args = call.arguments as? [String: Any]
    let callbackId = args?["callbackId"] as? String
    var callbackArgs: [String:Any] = [:]

    if let userArg = args?["user"] as? [String: Any] {
      user = getUserFromDict(dict: userArg)
    }
    
    switch call.method {
    case "initializeDevCycle":
      let sdkKey = args?["sdkKey"] as? String
      let options = args?["options"] as? [String: Any]
      if let dvcUser = user, let dvcKey = sdkKey {
        self.dvcClient = try? DVCClient.builder()
          .sdkKey(dvcKey)
          .user(dvcUser)
          .options(getOptionsFromDict(dict: options ?? [:] ))
          .build(onInitialized: { error in
            if (error != nil) {
              callbackArgs["error"] = "\(String(describing: error))"
            }
            self.channel.invokeMethod("clientInitialized", arguments: callbackArgs)
        })
      }
      result(nil)
    case "identifyUser":
      if let dvcUser = user {
        try? self.dvcClient?.identifyUser(user: dvcUser, callback: { error, variables in
          callbackArgs["callbackId"] = callbackId
          if (error != nil) {
            callbackArgs["error"] = "\(String(describing: error))"
          } else {
            callbackArgs["variables"] = self.variablesToMap(variables: variables ?? [:])
          }
          self.channel.invokeMethod("userIdentified", arguments: callbackArgs)
        })
      }
      result(nil)
    case "resetUser":
      try? self.dvcClient?.resetUser(callback: { error, variables in
        callbackArgs["callbackId"] = callbackId
        if (error != nil) {
          callbackArgs["error"] = "\(String(describing: error))"
        } else {
          callbackArgs["variables"] = self.variablesToMap(variables: variables ?? [:])
        }
        self.channel.invokeMethod("userReset", arguments: callbackArgs)
      })
      result(nil)
    case "allFeatures":
        result(featuresToMap(features: self.dvcClient?.allFeatures() ?? [:]))
    case "allVariables":
        result(variablesToMap(variables: self.dvcClient?.allVariables() ?? [:]))
    case "getPlatformVersion":
      result("iOS " + UIDevice.current.systemVersion)
    case "variable":
      if let dvcClient = self.dvcClient, let varKey = args?["key"] as? String, let varDefaultValue = args?["defaultValue"] as? Any {
        let variable = dvcClient.variable(key: varKey, defaultValue: varDefaultValue)
        if !self.variableUpdates.contains(where: { $0.key == variable.key }) {
          variable.onUpdate(handler: { newValue in
            callbackArgs["key"] = variable.key
            callbackArgs["value"] = variable.value
            self.channel.invokeMethod("variableUpdated", arguments: callbackArgs)
          })
          self.variableUpdates[variable.key] = variable
        }
        let codecVariable = dvcVariableToMap(variable: variable)
        result(codecVariable)
      } else {
        result(nil)
      }
    case "track":
      if let event = args?["event"] as? [String: Any], let dvcEvent = getEventFromDict(dict: event) {
        self.dvcClient?.track(dvcEvent)
      }
    case "flushEvents":
      self.dvcClient?.flushEvents(callback: { error in
        callbackArgs["callbackId"] = callbackId
        if (error != nil) {
          callbackArgs["error"] = "\(String(describing: error))"
        }
        self.channel.invokeMethod("eventsFlushed", arguments: callbackArgs)
      })
      result(nil)
    default:
      result(FlutterMethodNotImplemented)
    }
  }
  
  private func getUserFromDict(dict: [String: Any?]) -> DVCUser? {
    let userBuilder = DVCUser.builder()
    
    if let userId = dict["userId"] as? String {
      userBuilder.userId(userId)
    }

    if let isAnonymous = dict["isAnonymous"] as? Bool {
      userBuilder.isAnonymous(isAnonymous)
    }
    
    if let email = dict["email"] as? String {
      userBuilder.email(email)
    }
    
    if let name = dict["name"] as? String {
      userBuilder.name(name)
    }
    
    if let country = dict["country"] as? String {
      userBuilder.country(country)
    }
    
    if let customData = dict["customData"] as? [String: Any] {
      userBuilder.customData(customData)
    }
    
    if let privateCustomData = dict["privateCustomData"] as? [String: Any] {
      userBuilder.privateCustomData(privateCustomData)
    }

    let user = try? userBuilder.build()
    return user
  }
  
  private func getOptionsFromDict(dict: [String: Any?]) -> DevCycleOptions {
    let optionsBuilder = DevCycleOptions.builder()
    
    if let flushEventsIntervalMs = dict["flushEventsIntervalMs"] as? Int {
      optionsBuilder.flushEventsIntervalMs(flushEventsIntervalMs)
    }
    
    if let disableEventLogging = dict["disableEventLogging"] as? Bool {
      optionsBuilder.disableEventLogging(disableEventLogging)
    }

    if let disableAutomaticEventLogging = dict["disableAutomaticEventLogging"] as? Bool {
      optionsBuilder.disableAutomaticEventLogging(disableAutomaticEventLogging)
    }

    if let disableCustomEventLogging = dict["disableCustomEventLogging"] as? Bool {
      optionsBuilder.disableCustomEventLogging(disableCustomEventLogging)
    }
    
    if let enableEdgeDB = dict["enableEdgeDB"] as? Bool {
      optionsBuilder.enableEdgeDB(enableEdgeDB)
    }
    
    if let configCacheTTL = dict["configCacheTTL"] as? Int {
      optionsBuilder.configCacheTTL(configCacheTTL)
    }
    
    if let disableConfigCache = dict["disableConfigCache"] as? Bool {
      optionsBuilder.disableConfigCache(disableConfigCache)
    }
      
    if let disableRealtimeUpdates = dict["disableRealtimeUpdates"] as? Bool {
        optionsBuilder.disableRealtimeUpdates(disableRealtimeUpdates)
    }
    
    let logLevelMap = [
      "debug": LogLevel.debug,
      "info": LogLevel.info,
      "warn": LogLevel.warn,
      "error": LogLevel.error
    ]
    
    if let codecLogLevel = dict["logLevel"] as? String, let logLevel = logLevelMap[codecLogLevel] {
      optionsBuilder.logLevel(logLevel)
    }

    if let apiProxyUrl = dict["apiProxyUrl"] as? String {
        optionsBuilder.apiProxyURL(apiProxyUrl)
    }

    if let eventsApiProxyUrl = dict["eventsApiProxyUrl"] as? String {
        optionsBuilder.eventsApiProxyURL(eventsApiProxyUrl)
    }

    let options = optionsBuilder.build()
    return options
  }
  
  private func getEventFromDict(dict: [String: Any?]) -> DVCEvent? {
    let eventBuilder = DVCEvent.builder()
    
    if let type = dict["type"] as? String {
      eventBuilder.type(type)
    }
    
    if let target = dict["target"] as? String {
      eventBuilder.target(target)
    }
    
    let dateFormatter = ISO8601DateFormatter()
    dateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
    if let dateString = dict["date"] as? String, let date = dateFormatter.date(from: dateString) {
      eventBuilder.clientDate(date)
    }
    
    if let value = dict["value"] as? String, let doubleValue = Double(value) {
      eventBuilder.value(doubleValue)
    }
    
    if let metaData = dict["metaData"] as? [String: Any] {
      eventBuilder.metaData(metaData)
    }
    
    let event = try? eventBuilder.build()
    return event
  }

  private func variablesToMap(variables: [String: Variable]) -> [String: Any] {
    var map: [String: Any] = [:]
    for (key, value) in variables {
        map[key] = variableToMap(variable: value)
    }
    return map
  }

  private func variableToMap(variable: Variable) -> [String: Any] {
    var map: [String: Any] = [:]
    map["id"] = variable._id
    map["key"] = variable.key
    map["type"] = variable.type
    map["value"] = variable.value
    map["evalReason"] = variable.evalReason
    return map
  }
    
  private func dvcVariableToMap(variable: DVCVariable<Any>) -> [String: Any] {
    var map: [String: Any] = [:]
    map["key"] = variable.key
    map["type"] = variable.type
    map["value"] = variable.value
    map["evalReason"] = variable.evalReason
    map["isDefaulted"] = variable.isDefaulted
    return map
  }

  private func featuresToMap(features: [String: Feature]) -> [String: Any] {
    var map: [String: Any] = [:]
    for (key, value) in features {
        map[key] = featureToMap(feature: value)
    }
    return map
  }

  private func featureToMap(feature: Feature) -> [String: String] {
    var map: [String: String] = [:]
    map["id"] = feature._id
    map["key"] = feature.key
    map["type"] = feature.type
    map["variation"] = feature._variation
    map["evalReason"] = feature.evalReason
    map["variationKey"] = feature.variationKey
    map["variationName"] = feature.variationName
    return map
  }
}
