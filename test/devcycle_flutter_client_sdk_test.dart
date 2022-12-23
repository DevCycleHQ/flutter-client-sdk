import 'package:flutter_test/flutter_test.dart';
import 'package:devcycle_flutter_client_sdk/devcycle_flutter_client_sdk.dart';
import 'package:devcycle_flutter_client_sdk/devcycle_flutter_client_sdk_platform_interface.dart';
import 'package:devcycle_flutter_client_sdk/devcycle_flutter_client_sdk_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockDevcycleFlutterClientSdkPlatform
    with MockPlatformInterfaceMixin
    implements DevcycleFlutterClientSdkPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final DevcycleFlutterClientSdkPlatform initialPlatform = DevcycleFlutterClientSdkPlatform.instance;

  test('$MethodChannelDevcycleFlutterClientSdk is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelDevcycleFlutterClientSdk>());
  });

  test('getPlatformVersion', () async {
    DVCClient devcycleFlutterClientSdkPlugin = DVCClient();
    MockDevcycleFlutterClientSdkPlatform fakePlatform = MockDevcycleFlutterClientSdkPlatform();
    DevcycleFlutterClientSdkPlatform.instance = fakePlatform;

    expect(await devcycleFlutterClientSdkPlugin.getPlatformVersion(), '42');
  });
}
