import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'devcycle_flutter_client_sdk_method_channel.dart';

abstract class DevCycleFlutterClientSdkPlatform extends PlatformInterface {
  /// Constructs a DevCycleFlutterClientSdkPlatform.
  DevCycleFlutterClientSdkPlatform() : super(token: _token);

  static final Object _token = Object();

  static DevCycleFlutterClientSdkPlatform _instance = MethodChannelDevCycleFlutterClientSdk();

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
}
