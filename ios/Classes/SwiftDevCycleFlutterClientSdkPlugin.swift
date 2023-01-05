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
    let args = call.arguments as? [String: Any]
    let envKey = args?["environmentKey"] as? String
    var user: DVCUser?
    if let userArg = args?["user"] as? [String: Any] {
      user = getUserFromDict(dict: userArg)
    }
    
    let options = args?["options"] as? [String: Any]
    
    switch call.method {
    case "initialize":
      if let dvcUser = user, let dvcKey = envKey {
        self.dvcClient = try? DVCClient.builder()
          .environmentKey(dvcKey)
          .user(dvcUser)
          .options(getOptionsFromDict(dict: options ?? [:] ))
          .build(onInitialized: { error in
            if (error != nil) {
              self.channel.invokeMethod("clientInitialized", arguments: error)
            } else {
              self.channel.invokeMethod("clientInitialized", arguments: nil)
            }
        })
      }
      result(nil)
    case "getPlatformVersion":
      result("iOS " + UIDevice.current.systemVersion)
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
}
