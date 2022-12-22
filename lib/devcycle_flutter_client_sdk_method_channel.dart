import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'devcycle_flutter_client_sdk_platform_interface.dart';

/// An implementation of [DevcycleFlutterClientSdkPlatform] that uses method channels.
class MethodChannelDevcycleFlutterClientSdk extends DevcycleFlutterClientSdkPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('devcycle_flutter_client_sdk');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
