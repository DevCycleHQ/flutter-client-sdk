import 'package:devcycle_flutter_client_sdk/devcycle_flutter_client_sdk_platform_interface.dart';
import 'package:devcycle_flutter_client_sdk/dvc_callback.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:devcycle_flutter_client_sdk/devcycle_flutter_client_sdk.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockDevCycleFlutterClientSdkPlatform
    with MockPlatformInterfaceMixin
    implements DevCycleFlutterClientSdkPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');

  @override
  void initialize(String environmentKey, DVCUser user, DVCOptions? options) {}

  @override
  void identifyUser(DVCUser user, [DVCCallback? callback]) {}

  @override
  void resetUser([DVCCallback? callback]) {}
}

void main() {
    TestWidgetsFlutterBinding.ensureInitialized();
  test('builds correct user object', () {
    DVCUser user = DVCUserBuilder()
      .userId('user1')
      .isAnonymous(false)
      .email('test@example.com')
      .name('a b')
      .country('de')
      .build();
    expect(user.userId, equals('user1'));
    expect(user.isAnonymous, isFalse);
    expect(user.email, equals('test@example.com'));
    expect(user.name, equals('a b'));
    expect(user.country, equals('de'));
  });

  test('creates map from user object', () {
    DVCUser user = DVCUserBuilder()
      .userId('user1')
      .isAnonymous(false)
      .email('test@example.com')
      .name('a b')
      .country('de')
      .build();
    Map<String, dynamic> codecUser = user.toCodec();
    expect(codecUser['userId'], equals('user1'));
    expect(codecUser['isAnonymous'], isFalse);
    expect(codecUser['email'], equals('test@example.com'));
    expect(codecUser['name'], equals('a b'));
    expect(codecUser['country'], equals('de'));
  });

  test('identify user correctly', () {
    DVCUser user = DVCUserBuilder()
      .userId('user1')
      .isAnonymous(false)
      .email('test@example.com')
      .name('a b')
      .country('de')
      .build();
    DVCClient devcycleFlutterClientSdkPlugin = DVCClientBuilder()
      .environmentKey('SDK_KEY')
      .user(user)
      .build();
    devcycleFlutterClientSdkPlugin.identifyUser(user);
    expect(devcycleFlutterClientSdkPlugin.user.userId, 'user1');
    expect(devcycleFlutterClientSdkPlugin.user.isAnonymous, isFalse);
    expect(devcycleFlutterClientSdkPlugin.user.email, 'test@example.com');
    expect(devcycleFlutterClientSdkPlugin.user.name, 'a b');
    expect(devcycleFlutterClientSdkPlugin.user.country, 'de');
  });

  test('reset user from client', (){
    DVCUser user = DVCUserBuilder()
      .userId('user1')
      .isAnonymous(false)
      .email('test@example.com')
      .name('a b')
      .country('de')
      .build();
    DVCClient devcycleFlutterClientSdkPlugin = DVCClientBuilder()
      .environmentKey('SDK_KEY')
      .user(user)
      .build();
    devcycleFlutterClientSdkPlugin.resetUser();
    expect(devcycleFlutterClientSdkPlugin.user.isAnonymous, isTrue);
    expect(devcycleFlutterClientSdkPlugin.user.email, isNull);
    expect(devcycleFlutterClientSdkPlugin.user.name, isNull);
    expect(devcycleFlutterClientSdkPlugin.user.country, isNull);
  });
}