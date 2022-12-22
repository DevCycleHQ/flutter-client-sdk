import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:devcycle_flutter_client_sdk/devcycle_flutter_client_sdk_method_channel.dart';

void main() {
  MethodChannelDevcycleFlutterClientSdk platform = MethodChannelDevcycleFlutterClientSdk();
  const MethodChannel channel = MethodChannel('devcycle_flutter_client_sdk');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });
}
