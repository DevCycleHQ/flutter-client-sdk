
import 'devcycle_flutter_client_sdk_platform_interface.dart';

class DVCClient {
  Future<String?> getPlatformVersion() {
    return DevCycleFlutterClientSdkPlatform.instance.getPlatformVersion();
  }
}