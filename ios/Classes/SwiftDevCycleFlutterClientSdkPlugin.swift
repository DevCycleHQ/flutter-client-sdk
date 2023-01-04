import Flutter
import UIKit

public class SwiftDevCycleFlutterClientSdkPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "devcycle_flutter_client_sdk", binaryMessenger: registrar.messenger())
    let instance = SwiftDevCycleFlutterClientSdkPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    result("iOS " + UIDevice.current.systemVersion)
  }
}
