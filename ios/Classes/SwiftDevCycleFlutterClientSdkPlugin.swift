import Flutter
import UIKit

import DevCycle

public class SwiftDevCycleFlutterClientSdkPlugin: NSObject, FlutterPlugin {
  private var dvcClient: DVCClient?
  private let channel: FlutterMethodChannel
    
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
    let _callbackId = args?["callbackId"] as? String

    if let userArg = args?["user"] as? [String: Any] {
      user = getUserFromDict(dict: userArg)
    }
    
    switch call.method {
    case "initialize":
      let envKey = args?["environmentKey"] as? String
      let options = args?["options"] as? [String: Any]
      if let dvcUser = user, let dvcKey = envKey {
        self.dvcClient = try? DVCClient.builder()
          .environmentKey(dvcKey)
          .user(dvcUser)
          .options(getOptionsFromDict(dict: options ?? [:] ))
          .build(onInitialized: { error in
            var callbackArgs: [String:Any] = [
              "callbackId": _callbackId
            ]
            if (error != nil) {
              callbackArgs["error"] = error
              self.channel.invokeMethod("clientInitialized", arguments: callbackArgs)
            } else {
              self.channel.invokeMethod("clientInitialized", arguments: callbackArgs)
            }
        })
      }
      result(nil)
    case "identifyUser":
      if let dvcUser = user {
        try? self.dvcClient?.identifyUser(user: dvcUser, callback: { error, variables in
          var callbackArgs: [String:Any] = [
            "callbackId": _callbackId
          ]
          if (error != nil) {
            callbackArgs["error"] = error
            self.channel.invokeMethod("userIdentified", arguments: callbackArgs)
          } else {
            callbackArgs["variables"] = self.variablesToMap(variables: variables ?? [:])
            self.channel.invokeMethod("userIdentified", arguments: callbackArgs)
          }
        })
      }
      result(nil)
    case "resetUser":
      try? self.dvcClient?.resetUser(callback: { error, variables in
        var callbackArgs: [String:Any] = [
          "callbackId": _callbackId
        ]
        if (error != nil) {
          callbackArgs["error"] = error
          self.channel.invokeMethod("userReset", arguments: callbackArgs)
        } else {
          callbackArgs["variables"] = self.variablesToMap(variables: variables ?? [:])
          self.channel.invokeMethod("userReset", arguments: callbackArgs)
        }
      })
      result(nil)
    case "allFeatures":
      result(self.featuresToMap(self.dvcClient?.allFeatures()))
    case "allVariables":
      result(self.variablesToMap(self.dvcClient?.allVariables()))
    case "getPlatformVersion":
      result("iOS " + UIDevice.current.systemVersion)
    case "variable":
      if let dvcClient = self.dvcClient, let varKey = args?["key"] as? String, let varDefaultValue = args?["defaultValue"] as? String {
        let variable = self.dvcClient.variable(key: varKey, defaultValue: varDefaultValue)
        result(variable)
      } else {
        result(nil)
      }
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
  
  private func getOptionsFromDict(dict: [String: Any?]) -> DVCOptions {
    let optionsBuilder = DVCOptions.builder()
    
    if let flushEventsIntervalMs = dict["flushEventsIntervalMs"] as? Int {
      optionsBuilder.flushEventsIntervalMs(flushEventsIntervalMs)
    }
    
    if let disableEventLogging = dict["disableEventLogging"] as? Bool {
      optionsBuilder.disableEventLogging(disableEventLogging)
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

    let options = optionsBuilder.build()
    return options
  }

  private func variablesToMap(variables: [String: Variable]) -> [String: Any] {
    var map: [String: Any] = [:]
    for (key, value) in variables {
        map[key] = self.variableToMap(variable: value as! DVCVariable<Any>)
    }
    return map
  }

  private func variableToMap(variable: DVCVariable<Any>) -> [String: Any] {
    var map: [String: Any] = [:]
    map["id"] = variable._id
    map["key"] = variable.key
    map["type"] = variable.type
    map["value"] = variable.value
    map["evalReason"] = variable.evalReason
    return map
  }

  private func featuresToMap(features: [String: Feature]) -> [String: Any] {
    var map: [String: Any] = [:]
    for (key, value) in features {
        map[key] = self.featureToMap(feature: value)
    }
    return map
  }

  private func featureToMap(feature: Feature) -> [String: String] {
    var map: [String: String] = [:]
    map["id"] = feature._id
    map["key"] = feature.key
    map["type"] = feature.type
    map["variation"] = feature.variation
    map["evalReason"] = feature.evalReason
    map["variationKey"] = feature.variationKey
    map["variationName"] = feature.variationName
    return map
  }
}
