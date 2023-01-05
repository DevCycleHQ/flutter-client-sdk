import 'package:devcycle_flutter_client_sdk/dvc_callback.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:devcycle_flutter_client_sdk/devcycle_flutter_client_sdk.dart';
import 'package:devcycle_flutter_client_sdk/devcycle_flutter_client_sdk_platform_interface.dart';
import 'package:devcycle_flutter_client_sdk/devcycle_flutter_client_sdk_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

bool hasInitialized = false;
class MockDevCycleFlutterClientSdkPlatform
    with MockPlatformInterfaceMixin
    implements DevCycleFlutterClientSdkPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');

  @override
  void initialize(String environmentKey, DVCUser user, DVCOptions? options) {
    hasInitialized = true;
  }
  
  @override
  void identifyUser(DVCUser user, [DVCCallback? callback]) {}

  @override
  void resetUser([DVCCallback? callback]) {}
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final DevCycleFlutterClientSdkPlatform initialPlatform = DevCycleFlutterClientSdkPlatform.instance;
  MockDevCycleFlutterClientSdkPlatform mockPlatform = MockDevCycleFlutterClientSdkPlatform();
  DevCycleFlutterClientSdkPlatform.instance = mockPlatform;

  setUp(() {
    hasInitialized = false;
  });

  test('$MethodChannelDevCycleFlutterClientSdk is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelDevCycleFlutterClientSdk>());
  });

  group('initialize', () {
    test('initializes with only required params', () async {
      DVCUser user = DVCUserBuilder().userId('123').build();
      DVCClientBuilder()
        .user(user)
        .environmentKey('123')
        .build();
      expect(hasInitialized, isTrue);
    });

    test('initializes with all available params', () async {
      DVCUser user = DVCUserBuilder().userId('123').build();
      DVCOptions options = DVCOptionsBuilder().configCacheTTL(100).enableEdgeDB(true).build();
      DVCClientBuilder()
        .user(user)
        .environmentKey('123')
        .options(options)
        .build();
      expect(hasInitialized, isTrue);
    });

    test('fails to initialize without an environment key', () async {
      DVCUser user = DVCUserBuilder().userId('123').build();
      DVCClientBuilder clientBuilder = DVCClientBuilder().user(user);

      expect(clientBuilder.build, throwsException);
    });

    test('fails to initialize without a user', () async {
      DVCClientBuilder clientBuilder = DVCClientBuilder().environmentKey('123');

      expect(clientBuilder.build, throwsException);
    });
  });

  group('identifyUser', (){
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
  });

group('resetUser', (){
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
    expect(devcycleFlutterClientSdkPlugin.user.email, isNot('test@example.com'));
    expect(devcycleFlutterClientSdkPlugin.user.name, isNull);
    expect(devcycleFlutterClientSdkPlugin.user.country, isNull);
  });
});
}
