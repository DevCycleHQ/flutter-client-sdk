
import 'devcycle_flutter_client_sdk_platform_interface.dart';
import 'dvc_user.dart';
import 'dvc_options.dart';

export 'dvc_user.dart';
export 'dvc_event.dart';

class DVCClient {
  String? environmentKey;
  DVCUser? user;
  DVCOptions? options;

  DVCClient._builder(DVCClientBuilder builder) :
    environmentKey = builder._environmentKey,
    user = builder._user,
    options = builder._options;

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
    return DVCClient._builder(this);
  }
}
