
import 'devcycle_flutter_client_sdk_platform_interface.dart';

class DevcycleFlutterClientSdk {
  Future<String?> getPlatformVersion() {
    return DevcycleFlutterClientSdkPlatform.instance.getPlatformVersion();
  }
}