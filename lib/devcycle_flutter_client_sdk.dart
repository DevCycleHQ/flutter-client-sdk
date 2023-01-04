import 'package:flutter/services.dart';

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
  String environmentKey;
  DVCUser user;
  DVCOptions? options;

  static const _methodChannel = MethodChannel('devcycle_flutter_client_sdk');

  /// Callback triggered on client initialization
  ClientInitializedCallback? _clientInitializedCallback;
  //. Map of variable keys to a list of variable update callbacks
  Map<String, List<VariableUpdateCallback>> _variableUpdateCallbacks = Map();
  // Map of callback IDs to user update callbacks. The ID is generated when identify is called
  Map<String, UserUpdateCallback> _identifyCallbacks = Map();
  // Map of callback IDs to user update callbacks. The ID is generated when reset is called
  Map<String, UserUpdateCallback> _resetCallbacks = Map();

  DVCClient._builder(DVCClientBuilder builder) :
    environmentKey = builder._environmentKey!,
    user = builder._user!,
    options = builder._options;

  Future<void> _handleCallbacks(MethodCall call) async {
    switch (call.method) {
      case 'clientInitialized':
        if (_clientInitializedCallback != null) {
          _clientInitializedCallback!(call.arguments);
        }
        break;
      case 'variableUpdated':
        Variable variable = Variable.fromCodec(call.arguments);
        List<VariableUpdateCallback> callbacks = _variableUpdateCallbacks[variable.key] ?? [];
        for (final callback in callbacks) {
          callback(variable);
        }
        break;
    }
  }

  _init() {
    _methodChannel.setMethodCallHandler(_handleCallbacks);
    DevCycleFlutterClientSdkPlatform.instance.initialize(environmentKey, user, options);
  }

  Future<String?> getPlatformVersion() {
    return DevCycleFlutterClientSdkPlatform.instance.getPlatformVersion();
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
    client._init();
    return client;
  }
}
