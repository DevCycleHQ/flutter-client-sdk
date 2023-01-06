import 'package:flutter/services.dart';
import 'package:uuid/uuid.dart';

import 'devcycle_flutter_client_sdk_platform_interface.dart';
import 'dvc_user.dart';
import 'dvc_options.dart';
import 'variable.dart';

export 'dvc_user.dart';
export 'dvc_event.dart';
export 'dvc_options.dart';

typedef ClientInitializedCallback = void Function(Error? error);
typedef VariableUpdateCallback = void Function(Variable variable);
typedef UserUpdateCallback = void Function(Map<String, Variable> variables);

class DVCClient {
  static const _methodChannel = MethodChannel('devcycle_flutter_client_sdk');

  static const _uuid = Uuid();

  /// Callback triggered on client initialization
  ClientInitializedCallback? _clientInitializedCallback;
  //. Map of variable keys to a list of variable update callbacks
  Map<String, List<VariableUpdateCallback>> _variableUpdateCallbacks = Map();
  // Map of callback IDs to user update callbacks. The ID is generated when identify is called
  Map<String, UserUpdateCallback> _identifyCallbacks = Map();
  // Map of callback IDs to user update callbacks. The ID is generated when reset is called
  Map<String, UserUpdateCallback> _resetCallbacks = Map();

  DVCClient._builder(DVCClientBuilder builder);

  _init(String environmentKey, DVCUser user, DVCOptions? options) {
    _methodChannel.setMethodCallHandler(_handleCallbacks);
    DevCycleFlutterClientSdkPlatform.instance
        .initialize(environmentKey, user, options);
  }

  Future<void> _handleCallbacks(MethodCall call) async {
    switch (call.method) {
      case 'clientInitialized':
        if (_clientInitializedCallback != null) {
          _clientInitializedCallback!(call.arguments);
        }
        break;
      case 'variableUpdated':
        Variable variable = Variable.fromCodec(call.arguments);
        List<VariableUpdateCallback> callbacks =
            _variableUpdateCallbacks[variable.key] ?? [];
        for (final callback in callbacks) {
          callback(variable);
        }
        break;
      case 'userIdentified':
        UserUpdateCallback? callback =
            _identifyCallbacks[call.arguments['callbackId']];
        final error = call.arguments['error'];
        if (callback == null) {
          return;
        }
        if (error != null) {
          print(error);
          callback(error);
          return;
        }

        Map<String, Variable> parsedVariables = Map();
        Map<String, Map<String, dynamic>> variables =
            call.arguments['variables'];
        for (final entry in variables.entries) {
          parsedVariables[entry.key] = Variable.fromCodec({
            "id": entry.value["id"],
            "key": entry.value["key"],
            "type": entry.value["type"],
            "value": entry.value["value"],
          });
        }
        callback(parsedVariables);
        _identifyCallbacks.remove(call.arguments['callbackId']);
        break;
      case 'userReset':
        final error = call.arguments['error'];
        UserUpdateCallback? callback =
            _resetCallbacks[call.arguments['callbackId']];
        if (callback == null) {
          return;
        }
        if (error != null) {
          print(error);
          callback(error);
          return;
        }
        Map<String, Variable> parsedVariables = Map();
        Map<String, Map<String, dynamic>> variables =
            call.arguments['variables'];
        for (final entry in variables.entries) {
          parsedVariables[entry.key] = Variable.fromCodec({
            "id": entry.value["id"],
            "key": entry.value["key"],
            "type": entry.value["type"],
            "value": entry.value["value"],
          });
        }
        callback(parsedVariables);
        _resetCallbacks.remove(call.arguments['callbackId']);
        break;
    }
  }

  Future<String?> getPlatformVersion() {
    return DevCycleFlutterClientSdkPlatform.instance.getPlatformVersion();
  }

  void identifyUser(DVCUser user, [UserUpdateCallback? callback]) {
    if (callback != null) {
      String callbackId = _uuid.v4();
      _identifyCallbacks[callbackId] = callback;
      DevCycleFlutterClientSdkPlatform.instance.identifyUser(user, callbackId);
    } else {
      DevCycleFlutterClientSdkPlatform.instance.identifyUser(user);
    }
  }

  void resetUser([UserUpdateCallback? callback]) {
    if (callback != null) {
      String callbackId = _uuid.v4();
      _resetCallbacks[callbackId] = callback;
      DevCycleFlutterClientSdkPlatform.instance.resetUser(callbackId);
    } else {
      DevCycleFlutterClientSdkPlatform.instance.resetUser();
    }
  }
}

class DVCClientBuilder {
  String? _environmentKey;
  DVCUser? _user;
  DVCOptions? _options;

  DVCClientBuilder environmentKey(String environmentKey) {
    this._environmentKey = environmentKey;
    return this;
  }

  DVCClientBuilder user(DVCUser user) {
    this._user = user;
    return this;
  }

  DVCClientBuilder options(DVCOptions options) {
    this._options = options;
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
