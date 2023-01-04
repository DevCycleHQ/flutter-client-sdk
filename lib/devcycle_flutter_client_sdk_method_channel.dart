import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'devcycle_flutter_client_sdk_platform_interface.dart';
import 'dvc_user.dart';
import 'dvc_options.dart';

/// An implementation of [DevCycleFlutterClientSdkPlatform] that uses method channels.
class MethodChannelDevCycleFlutterClientSdk extends DevCycleFlutterClientSdkPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('devcycle_flutter_client_sdk');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  void initialize(String environmentKey, DVCUser user, DVCOptions? options) {
    Map<String, dynamic> codecUser = user.toCodec();
    Map<String, dynamic>? codecOptions = options?.toCodec();
    methodChannel.invokeMethod(
      'initialize',
      { "environmentKey": environmentKey, "user": codecUser, "options": codecOptions }
    );
  }
}
