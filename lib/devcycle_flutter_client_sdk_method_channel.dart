import 'package:devcycle_flutter_client_sdk/devcycle_flutter_client_sdk.dart';
import 'package:devcycle_flutter_client_sdk/variable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'devcycle_flutter_client_sdk_platform_interface.dart';
import 'feature.dart';
import 'variable.dart';

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
  void initialize(String environmentKey, DVCUser user, DVCOptions? options) {
    Map<String, dynamic> codecUser = user.toCodec();
    Map<String, dynamic>? codecOptions = options?.toCodec();
    methodChannel.invokeMethod('initialize', {
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
  Future<Variable?> variable(String key, dynamic defaultValue) async {
    Map<String, dynamic> result = await methodChannel.invokeMethod('variable', {"key": key, "defaultValue": defaultValue}) ?? {};
    Variable? variable = result.isNotEmpty ? Variable.fromCodec(result) : null;
    return variable;
  }

  @override
  Future<Map<String, Feature>> allFeatures() async {
    Map<String, Map<String, dynamic>> result =
        await methodChannel.invokeMethod('allFeatures') ?? {};
    Map<String, Feature> features = {};

    result.forEach((key, value) => features[key] = Feature.fromCodec(value));
    return features;
  }

  @override
  Future<Map<String, Variable>> allVariables() async {
    Map<String, Map<String, dynamic>> result =
        await methodChannel.invokeMethod('allVariables') ?? {};
    Map<String, Variable> variables = {};

    result.forEach((key, value) => variables[key] = Variable.fromCodec(value));
    return variables;
  }

  void track(DVCEvent event) {
    Map<String, dynamic> codecEvent = event.toCodec();
    methodChannel.invokeMethod('track', {"event": codecEvent});
  }
}
