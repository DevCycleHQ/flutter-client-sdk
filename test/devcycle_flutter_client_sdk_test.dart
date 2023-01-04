import 'package:flutter_test/flutter_test.dart';
import 'package:devcycle_flutter_client_sdk/devcycle_flutter_client_sdk.dart';
import 'package:devcycle_flutter_client_sdk/devcycle_flutter_client_sdk_platform_interface.dart';
import 'package:devcycle_flutter_client_sdk/devcycle_flutter_client_sdk_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockDevCycleFlutterClientSdkPlatform
    with MockPlatformInterfaceMixin
    implements DevCycleFlutterClientSdkPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');

  @override
  void initialize(String environmentKey, DVCUser user, DVCOptions? options) {}
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final DevCycleFlutterClientSdkPlatform initialPlatform = DevCycleFlutterClientSdkPlatform.instance;

  test('$MethodChannelDevCycleFlutterClientSdk is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelDevCycleFlutterClientSdk>());
  });

  test('getPlatformVersion', () async {
    DVCUser user = DVCUserBuilder().userId('123').build();
    DVCClient devcycleFlutterClientSdkPlugin = DVCClientBuilder()
      .environmentKey('SDK_KEY')
      .user(user)
      .build();
    MockDevCycleFlutterClientSdkPlatform fakePlatform = MockDevCycleFlutterClientSdkPlatform();
    DevCycleFlutterClientSdkPlatform.instance = fakePlatform;

    expect(await devcycleFlutterClientSdkPlugin.getPlatformVersion(), '42');
  });
}
