import 'package:devcycle_flutter_client_sdk/dvc_event.dart';
import 'package:flutter/services.dart';
import 'package:uuid/uuid.dart';
import 'package:logger/logger.dart';

import 'devcycle_flutter_client_sdk_platform_interface.dart';
import 'dvc_user.dart';
import 'dvc_options.dart';
import 'dvc_variable.dart';
import 'dvc_feature.dart';

export 'dvc_user.dart';
export 'dvc_event.dart';
export 'dvc_options.dart';
export 'dvc_feature.dart';
export 'dvc_variable.dart';

typedef ErrorCallback = void Function([Error? error]);
typedef VariablesCallback = void Function(
    Error? error, Map<String, DVCVariable> variables);

class DVCClient {
  static const _methodChannel = MethodChannel('devcycle_flutter_client_sdk');

  static const _uuid = Uuid();
  static final _logger = Logger();

  Future<void>? _clientReady;

  /// Callback triggered on client initialization
  ErrorCallback? _clientInitializedCallback;
  // Map of variable keys to a list of variable objects, used to update variable values
  final Map<String, List<DVCVariable>> _variableInstances = {};
  // Map of callback IDs to user update callbacks. The ID is generated when identify is called
  final Map<String, VariablesCallback> _identifyCallbacks = {};
  // Map of callback IDs to user update callbacks. The ID is generated when reset is called
  final Map<String, VariablesCallback> _resetCallbacks = {};
  // Map of callback IDs to user update callbacks. The ID is generated when flushEvents is called
  final Map<String, ErrorCallback> _eventCallbacks = {};

  DVCClient._builder(DVCClientBuilder builder);

  _init(String environmentKey, DVCUser user, DVCOptions? options) {
    _methodChannel.setMethodCallHandler(_handleCallbacks);
    _clientReady = DevCycleFlutterClientSdkPlatform.instance
        .initialize(environmentKey, user, options);
  }

  _trackVariable(DVCVariable? variable) {
    if (variable?.key == null) return;
    String key = variable?.key as String;
    _variableInstances[key] = _variableInstances[key] ?? [];
    _variableInstances[key]?.add(variable!);
  }

  Future<void> _handleCallbacks(MethodCall call) async {
    final error = call.arguments['error'];
    if (error != null) {
      _logger.e(error);
    }

    switch (call.method) {
      case 'clientInitialized':
        if (_clientInitializedCallback != null) {
          _clientInitializedCallback!(error);
        }
        break;
      case 'variableUpdated':
        final key = call.arguments['key'];
        final updatedValue = call.arguments['value'];
        List<DVCVariable> variableInstances = _variableInstances[key] ?? [];
        for (final v in variableInstances) {
          if (v.callback != null) {
            v.value = updatedValue;
            v.callback!(updatedValue);
          }
        }
        break;
      case 'userIdentified':
        VariablesCallback? callback =
            _identifyCallbacks[call.arguments['callbackId']];
        if (callback == null) {
          return;
        }
        if (error != null) {
          callback(error, {});
          _identifyCallbacks.remove(call.arguments['callbackId']);
          return;
        }

        Map<String, DVCVariable> parsedVariables = {};
        Map<String, Map<String, dynamic>> variables =
            call.arguments['variables'];
        for (final entry in variables.entries) {
          parsedVariables[entry.key] = DVCVariable.fromCodec(entry.value);
        }
        callback(null, parsedVariables);
        _identifyCallbacks.remove(call.arguments['callbackId']);
        break;
      case 'userReset':
        VariablesCallback? callback =
            _resetCallbacks[call.arguments['callbackId']];
        if (callback == null) {
          return;
        }
        if (error != null) {
          callback(error, {});
          _resetCallbacks.remove(call.arguments['callbackId']);
          return;
        }
        Map<String, DVCVariable> parsedVariables = {};
        Map<String, Map<String, dynamic>> variables =
            call.arguments['variables'];
        for (final entry in variables.entries) {
          parsedVariables[entry.key] = DVCVariable.fromCodec(entry.value);
        }
        callback(null, parsedVariables);
        _resetCallbacks.remove(call.arguments['callbackId']);
        break;
      case 'eventsFlushed':
        ErrorCallback? callback = _eventCallbacks[call.arguments['callbackId']];
        if (callback == null) {
          return;
        }
        if (error != null) {
          callback(error);
          _eventCallbacks.remove(call.arguments['callbackId']);
          return;
        }
        callback();
        _eventCallbacks.remove(call.arguments['callbackId']);
        break;
    }
  }

  DVCClient onInitialized(ErrorCallback callback) {
    _clientInitializedCallback = callback;
    return this;
  }

  Future<String?> getPlatformVersion() async {
    await _clientReady;
    return DevCycleFlutterClientSdkPlatform.instance.getPlatformVersion();
  }

  Future<void> identifyUser(DVCUser user, [VariablesCallback? callback]) async {
    await _clientReady;
    if (callback != null) {
      String callbackId = _uuid.v4();
      _identifyCallbacks[callbackId] = callback;
      DevCycleFlutterClientSdkPlatform.instance.identifyUser(user, callbackId);
    } else {
      DevCycleFlutterClientSdkPlatform.instance.identifyUser(user);
    }
  }

  Future<void> resetUser([VariablesCallback? callback]) async {
    await _clientReady;
    if (callback != null) {
      String callbackId = _uuid.v4();
      _resetCallbacks[callbackId] = callback;
      DevCycleFlutterClientSdkPlatform.instance.resetUser(callbackId);
    } else {
      DevCycleFlutterClientSdkPlatform.instance.resetUser();
    }
  }

  Future<DVCVariable?> variable(String key, dynamic defaultValue) async {
    await _clientReady;
    final variable = await DevCycleFlutterClientSdkPlatform.instance
        .variable(key, defaultValue);
    _trackVariable(variable);
    return variable;
  }

  Future<Map<String, DVCFeature>> allFeatures() async {
    await _clientReady;
    final features =
        await DevCycleFlutterClientSdkPlatform.instance.allFeatures();
    return features;
  }

  Future<Map<String, DVCVariable>> allVariables() async {
    await _clientReady;
    final variables =
        await DevCycleFlutterClientSdkPlatform.instance.allVariables();
    variables.values.forEach(_trackVariable);
    return variables;
  }

  Future<void> track(DVCEvent event) async {
    await _clientReady;
    DevCycleFlutterClientSdkPlatform.instance.track(event);
  }

  Future<void> flushEvents([ErrorCallback? callback]) async {
    await _clientReady;
    if (callback != null) {
      String callbackId = _uuid.v4();
      _eventCallbacks[callbackId] = callback;
      DevCycleFlutterClientSdkPlatform.instance.flushEvents(callbackId);
    } else {
      DevCycleFlutterClientSdkPlatform.instance.flushEvents();
    }
  }
}

class DVCClientBuilder {
  String? _environmentKey;
  DVCUser? _user;
  DVCOptions? _options;

  DVCClientBuilder environmentKey(String environmentKey) {
    _environmentKey = environmentKey;
    return this;
  }

  DVCClientBuilder user(DVCUser user) {
    _user = user;
    return this;
  }

  DVCClientBuilder options(DVCOptions options) {
    _options = options;
    return this;
  }

  DVCClient build() {
    if (_environmentKey == null) throw Exception("SDK key must be set");
    if (_user == null) throw Exception("User must be set");
    DVCClient client = DVCClient._builder(this);
    client._init(_environmentKey!, _user!, _options);
    return client;
  }
}
