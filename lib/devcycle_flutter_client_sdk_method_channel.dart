import 'package:devcycle_flutter_client_sdk/devcycle_flutter_client_sdk.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'devcycle_flutter_client_sdk_platform_interface.dart';

/// An implementation of [DevCycleFlutterClientSdkPlatform] that uses method channels.
class MethodChannelDevCycleFlutterClientSdk
    extends DevCycleFlutterClientSdkPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('devcycle_flutter_client_sdk');

  @override
  Future<String?> getPlatformVersion() async {
    final version =
        await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  Future<void> initialize(String environmentKey, DVCUser user, DVCOptions? options) async {
    Map<String, dynamic> codecUser = user.toCodec();
    Map<String, dynamic>? codecOptions = options?.toCodec();
    await methodChannel.invokeMethod('initialize', {
      "environmentKey": environmentKey,
      "user": codecUser,
      "options": codecOptions
    });
  }

  @override
  void identifyUser(DVCUser user, [String? callbackId]) {
    Map<String, dynamic> codecUser = user.toCodec();
    methodChannel.invokeMethod(
        'identifyUser', {"user": codecUser, "callbackId": callbackId});
  }

  @override
  void resetUser([String? callbackId]) {
    methodChannel.invokeMethod('resetUser', {"callbackId": callbackId});
  }

  @override
  Future<DVCVariable?> variable(String key, dynamic defaultValue) async {
    final result = await methodChannel.invokeMethod(
      'variable',
      {"key": key, "defaultValue": defaultValue}
    ) ?? {};
    final map = Map<String, dynamic>.from(result);
    DVCVariable? variable = map.isNotEmpty ? DVCVariable.fromCodec(map) : null;
    return variable;
  }

  @override
  Future<Map<String, DVCFeature>> allFeatures() async {
    final result = await methodChannel.invokeMethod('allFeatures') ?? {};
    final map = Map<String, dynamic>.from(result);
    Map<String, DVCFeature> features = {};

    map.forEach((key, value) {
      final codec = Map<String, dynamic>.from(value);
      features[key] = DVCFeature.fromCodec(codec);
    });
    return features;
  }

  @override
  Future<Map<String, DVCVariable>> allVariables() async {
    final result = await methodChannel.invokeMethod('allVariables') ?? {};
    final map = Map<String, dynamic>.from(result);
    Map<String, DVCVariable> variables = {};

    map.forEach((key, value) {
      final codec = Map<String, dynamic>.from(value);
      variables[key] = DVCVariable.fromCodec(codec);
    });
    return variables;
  }

  @override
  void track(DVCEvent event) {
    Map<String, dynamic> codecEvent = event.toCodec();
    methodChannel.invokeMethod('track', codecEvent);
  }

  @override
  void flushEvents([String? callbackId]) {
    methodChannel.invokeMethod('flushEvents', {"callbackId": callbackId});
  }
}
