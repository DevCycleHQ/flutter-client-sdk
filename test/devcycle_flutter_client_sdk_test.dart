import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:devcycle_flutter_client_sdk/devcycle_flutter_client_sdk.dart';
import 'package:devcycle_flutter_client_sdk/devcycle_flutter_client_sdk_platform_interface.dart';
import 'package:devcycle_flutter_client_sdk/devcycle_flutter_client_sdk_method_channel.dart';

void main() {
  final DevCycleFlutterClientSdkPlatform initialPlatform =
      DevCycleFlutterClientSdkPlatform.instance;
  MethodChannelDevCycleFlutterClientSdk platform =
      MethodChannelDevCycleFlutterClientSdk();

  MethodCall? methodCall;
  handler(MethodCall mc) async {
    methodCall = mc;
  }

  TestWidgetsFlutterBinding.ensureInitialized();
  TestDefaultBinaryMessengerBinding.instance?.defaultBinaryMessenger
      .setMockMethodCallHandler(platform.methodChannel, handler);

  DevCycleFlutterClientSdkPlatform.instance = platform;

  setUp(() {
    methodCall = null;
  });

  test('$MethodChannelDevCycleFlutterClientSdk is the default instance', () {
    expect(
        initialPlatform, isInstanceOf<MethodChannelDevCycleFlutterClientSdk>());
  });

  group('initialize', () {
    test('initializes with only required params', () async {
      DVCUser user = DVCUserBuilder().userId('user1').build();
      DVCClientBuilder().user(user).environmentKey('123').build();
      expect(methodCall?.method, 'initialize');
      expect(methodCall?.arguments, {
        "environmentKey": "123",
        "user": {"userId": "user1"},
        "options": null
      });
    });

    test('initializes with all available params', () async {
      DVCUser user = DVCUserBuilder().userId('user1').build();
      DVCOptions options =
          DVCOptionsBuilder().configCacheTTL(100).enableEdgeDB(true).build();
      DVCClientBuilder()
          .user(user)
          .environmentKey('123')
          .options(options)
          .build();
      expect(methodCall?.method, 'initialize');
      expect(methodCall?.arguments, {
        "environmentKey": "123",
        "user": {"userId": "user1"},
        "options": {"configCacheTTL": 100, "enableEdgeDB": true}
      });
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

  group('identifyUser', () {
    test('identify user correctly', () {
      DVCUser user1 = DVCUserBuilder()
          .userId('user1')
          .isAnonymous(false)
          .email('test@example.com')
          .name('a b')
          .country('de')
          .build();
      DVCUser user2 = DVCUserBuilder()
          .userId('user2')
          .isAnonymous(false)
          .email('test_2@example.com')
          .name('c d')
          .country('ca')
          .build();

      DVCClient devcycleFlutterClientSdkPlugin =
          DVCClientBuilder().environmentKey('SDK_KEY').user(user1).build();
      devcycleFlutterClientSdkPlugin.identifyUser(user2);
      expect(methodCall?.method, 'identifyUser');
      expect(methodCall?.arguments, {
        'user': {
          'userId': 'user2',
          'isAnonymous': false,
          'email': 'test_2@example.com',
          'name': 'c d',
          'country': 'ca'
        },
        'callbackId': null
      });
    });
  });

  group('resetUser', () {
    test('reset user from client', () {
      DVCUser user = DVCUserBuilder()
          .userId('user1')
          .isAnonymous(false)
          .email('test@example.com')
          .name('a b')
          .country('de')
          .build();
      DVCClient devcycleFlutterClientSdkPlugin =
          DVCClientBuilder().environmentKey('SDK_KEY').user(user).build();
      devcycleFlutterClientSdkPlugin.resetUser();
      expect(methodCall?.method, 'resetUser');
      expect(methodCall?.arguments, {'callbackId': null});
    });
  });

  group('variable', () {
    test('get variable', () {
      DVCUser user = DVCUserBuilder().userId('user1').build();
      DVCClient devcycleFlutterClientSdkPlugin =
          DVCClientBuilder().environmentKey('SDK_KEY').user(user).build();
      devcycleFlutterClientSdkPlugin.variable('test-key', 'default-value');
      expect(methodCall?.method, 'variable');
      expect(methodCall?.arguments,
          {'key': 'test-key', 'defaultValue': 'default-value'});
    });
  });

  group('allFeatures', () {
    test('fetch all features', () {
      DVCUser user = DVCUserBuilder().userId('user1').build();
      DVCClient devcycleFlutterClientSdkPlugin =
          DVCClientBuilder().user(user).environmentKey('123').build();
      devcycleFlutterClientSdkPlugin.allFeatures();
      expect(methodCall?.method, 'allFeatures');
    });
  });

  group('allVariables', () {
    test('fetch all variables', () {
      DVCUser user = DVCUserBuilder().userId('user1').build();
      DVCClient devcycleFlutterClientSdkPlugin =
          DVCClientBuilder().user(user).environmentKey('123').build();
      devcycleFlutterClientSdkPlugin.allVariables();
      expect(methodCall?.method, 'allVariables');
    });
  });
  group('track', () {
    test('track event with no properties', () {
      DVCUser user = DVCUserBuilder().userId('user1').build();
      DVCClient devcycleFlutterClientSdkPlugin =
          DVCClientBuilder().environmentKey('SDK_KEY').user(user).build();
      DVCEvent event =
          DVCEventBuilder().type('my event type').target('my target').build();

      devcycleFlutterClientSdkPlugin.track(event);
      expect(methodCall?.method, 'track');
      expect(methodCall?.arguments, event.toCodec());
    });

    test('track event with properties', () {
      DVCUser user = DVCUserBuilder().userId('user1').build();
      DVCClient devcycleFlutterClientSdkPlugin =
          DVCClientBuilder().environmentKey('SDK_KEY').user(user).build();
      DVCEvent event = DVCEventBuilder()
          .type('my event type')
          .target('my target')
          .value(1)
          .metaData({"hello": "world"}).build();

      devcycleFlutterClientSdkPlugin.track(event);
      expect(methodCall?.method, 'track');
      expect(methodCall?.arguments, event.toCodec());
    });
  });
}
