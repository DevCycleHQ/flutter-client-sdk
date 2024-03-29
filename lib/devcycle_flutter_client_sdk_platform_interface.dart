import 'package:devcycle_flutter_client_sdk/devcycle_flutter_client_sdk.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'devcycle_flutter_client_sdk_method_channel.dart';

abstract class DevCycleFlutterClientSdkPlatform extends PlatformInterface {
  /// Constructs a DevCycleFlutterClientSdkPlatform.
  DevCycleFlutterClientSdkPlatform() : super(token: _token);

  static final Object _token = Object();

  static DevCycleFlutterClientSdkPlatform _instance =
      MethodChannelDevCycleFlutterClientSdk();

  /// The default instance of [DevCycleFlutterClientSdkPlatform] to use.
  ///
  /// Defaults to [MethodChannelDevCycleFlutterClientSdk].
  static DevCycleFlutterClientSdkPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [DevCycleFlutterClientSdkPlatform] when
  /// they register themselves.
  static set instance(DevCycleFlutterClientSdkPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<void> initializeDevCycle(
      String sdkKey,
      DevCycleUser user,
      DevCycleOptions? options
  ) {
    throw UnimplementedError('initializeDevCycle() has not been implemented.');
  }

  void identifyUser(DevCycleUser user, [String? callbackId]) {
    throw UnimplementedError('identifyUser() has not been implemented.');
  }

  void resetUser([String? callbackId]) {
    throw UnimplementedError('resetUser() has not been implemented.');
  }

  Future<DVCVariable> variable(String key, dynamic defaultValue) {
    throw UnimplementedError('variable() has not been implemented.');
  }

  Future<Map<String, DVCFeature>> allFeatures() {
    throw UnimplementedError('allFeatures() has not been implemented.');
  }

  Future<Map<String, DVCVariable>> allVariables() {
    throw UnimplementedError('allVariables() has not been implemented.');
  }

  void track(DevCycleEvent event) {
    throw UnimplementedError('track() has not been implemented.');
  }

  void flushEvents([String? callbackId]) {
    throw UnimplementedError('flushEvents() has not been implemented.');
  }
}
