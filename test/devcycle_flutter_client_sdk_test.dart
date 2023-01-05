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
}
