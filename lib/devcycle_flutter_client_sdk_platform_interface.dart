import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'devcycle_flutter_client_sdk_method_channel.dart';

abstract class DevcycleFlutterClientSdkPlatform extends PlatformInterface {
  /// Constructs a DevcycleFlutterClientSdkPlatform.
  DevcycleFlutterClientSdkPlatform() : super(token: _token);

  static final Object _token = Object();

  static DevcycleFlutterClientSdkPlatform _instance = MethodChannelDevcycleFlutterClientSdk();

  /// The default instance of [DevcycleFlutterClientSdkPlatform] to use.
  ///
  /// Defaults to [MethodChannelDevcycleFlutterClientSdk].
  static DevcycleFlutterClientSdkPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [DevcycleFlutterClientSdkPlatform] when
  /// they register themselves.
  static set instance(DevcycleFlutterClientSdkPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
