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
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(platform.methodChannel, handler);

  DevCycleFlutterClientSdkPlatform.instance = platform;

  setUp(() {
    methodCall = null;
  });

  test('$MethodChannelDevCycleFlutterClientSdk is the default instance', () {
    expect(
        initialPlatform, isInstanceOf<MethodChannelDevCycleFlutterClientSdk>());
  });

  group('initializeDevCycle', () {
    test('initializes with only required params', () async {
      DevCycleUser user = DevCycleUserBuilder().userId('user1').build();
      DevCycleClientBuilder().user(user).sdkKey('123').build();
      expect(methodCall?.method, 'initializeDevCycle');
      expect(methodCall?.arguments, {
        "sdkKey": "123",
        "user": {"userId": "user1"},
        "options": null
      });
    });

    test('check deprecated Builder classes', () async {
      DVCUser user = DVCUserBuilder().userId('user1').build();
      DVCClientBuilder().user(user).sdkKey('123').build();
      expect(methodCall?.method, 'initializeDevCycle');
      expect(methodCall?.arguments, {
        "sdkKey": "123",
        "user": {"userId": "user1"},
        "options": null
      });
    });

    test('initializes with environmentKey', () async {
      DevCycleUser user = DevCycleUserBuilder().userId('user1').build();
      // ignore: deprecated_member_use_from_same_package
      DevCycleClientBuilder().user(user).environmentKey('123').build();
      expect(methodCall?.method, 'initializeDevCycle');
      expect(methodCall?.arguments, {
        "sdkKey": "123",
        "user": {"userId": "user1"},
        "options": null
      });
    });

    test('initializes with all available params', () async {
      DevCycleUser user = DevCycleUserBuilder().userId('user1').build();
      DevCycleOptions options =
          DVCOptionsBuilder().configCacheTTL(100).enableEdgeDB(true).build();
      DevCycleClientBuilder()
          .user(user)
          .sdkKey('123')
          .options(options)
          .build();
      expect(methodCall?.method, 'initializeDevCycle');
      expect(methodCall?.arguments, {
        "sdkKey": "123",
        "user": {"userId": "user1"},
        "options": {"configCacheTTL": 100, "enableEdgeDB": true}
      });
    });

    test('fails to initialize without an environment key', () async {
      DevCycleUser user = DevCycleUserBuilder().userId('123').build();
      DevCycleClientBuilder clientBuilder = DevCycleClientBuilder().user(user);

      expect(clientBuilder.build, throwsException);
    });

    test('fails to initialize without a user', () async {
      DevCycleClientBuilder clientBuilder = DevCycleClientBuilder().sdkKey('123');

      expect(clientBuilder.build, throwsException);
    });
  });

  group('identifyUser', () {
    test('identify user correctly', () async {
      DevCycleUser user1 = DevCycleUserBuilder()
          .userId('user1')
          .isAnonymous(false)
          .email('test@example.com')
          .name('a b')
          .country('de')
          .build();
      DevCycleUser user2 = DevCycleUserBuilder()
          .userId('user2')
          .isAnonymous(false)
          .email('test_2@example.com')
          .name('c d')
          .country('ca')
          .build();

      DevCycleClient devcycleFlutterClientSdkPlugin =
          DevCycleClientBuilder().sdkKey('SDK_KEY').user(user1).build();
      await devcycleFlutterClientSdkPlugin.identifyUser(user2);
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
    test('reset user from client', () async {
      DevCycleUser user = DevCycleUserBuilder()
          .userId('user1')
          .isAnonymous(false)
          .email('test@example.com')
          .name('a b')
          .country('de')
          .build();
      DevCycleClient devcycleFlutterClientSdkPlugin =
          DevCycleClientBuilder().sdkKey('SDK_KEY').user(user).build();
      await devcycleFlutterClientSdkPlugin.resetUser();
      expect(methodCall?.method, 'resetUser');
      expect(methodCall?.arguments, {'callbackId': null});
    });
  });

  group('variable', () {
    test('get variable', () async {
      DevCycleUser user = DevCycleUserBuilder().userId('user1').build();
      DevCycleClient devcycleFlutterClientSdkPlugin =
          DevCycleClientBuilder().sdkKey('SDK_KEY').user(user).build();
      await devcycleFlutterClientSdkPlugin.variable(
          'test-key', 'default-value');
      expect(methodCall?.method, 'variable');
      expect(methodCall?.arguments,
          {'key': 'test-key', 'defaultValue': 'default-value'});
    });

    test('get variable value', () async {
      DevCycleUser user = DevCycleUserBuilder().userId('user1').build();
      DevCycleClient devcycleFlutterClientSdkPlugin =
      DevCycleClientBuilder().sdkKey('SDK_KEY').user(user).build();
      await devcycleFlutterClientSdkPlugin.variableValue(
          'test-key', 'default-value');
      expect(methodCall?.method, 'variable');
      expect(methodCall?.arguments,
          {'key': 'test-key', 'defaultValue': 'default-value'});
    });
  });

  group('allFeatures', () {
    test('fetch all features', () async {
      DevCycleUser user = DevCycleUserBuilder().userId('user1').build();
      DevCycleClient devcycleFlutterClientSdkPlugin =
          DevCycleClientBuilder().user(user).sdkKey('123').build();
      await devcycleFlutterClientSdkPlugin.allFeatures();
      expect(methodCall?.method, 'allFeatures');
    });
  });

  group('allVariables', () {
    test('fetch all variables', () async {
      DevCycleUser user = DevCycleUserBuilder().userId('user1').build();
      DevCycleClient devcycleFlutterClientSdkPlugin =
          DevCycleClientBuilder().user(user).sdkKey('123').build();
      await devcycleFlutterClientSdkPlugin.allVariables();
      expect(methodCall?.method, 'allVariables');
    });
  });
  group('track', () {
    test('track event with no properties', () async {
      DevCycleUser user = DevCycleUserBuilder().userId('user1').build();
      DevCycleClient devcycleFlutterClientSdkPlugin =
          DevCycleClientBuilder().sdkKey('SDK_KEY').user(user).build();
      DevCycleEvent event =
          DevCycleEventBuilder().type('my event type').target('my target').build();

      await devcycleFlutterClientSdkPlugin.track(event);
      expect(methodCall?.method, 'track');
      expect(methodCall?.arguments, {'event': event.toCodec()});
    });

    test('track event with properties', () async {
      DevCycleUser user = DevCycleUserBuilder().userId('user1').build();
      DevCycleClient devcycleFlutterClientSdkPlugin =
          DevCycleClientBuilder().sdkKey('SDK_KEY').user(user).build();
      DevCycleEvent event = DevCycleEventBuilder()
          .type('my event type')
          .target('my target')
          .value(1)
          .metaData({"hello": "world"}).build();

      await devcycleFlutterClientSdkPlugin.track(event);
      expect(methodCall?.method, 'track');
      expect(methodCall?.arguments, {'event': event.toCodec()});
    });

    test('do not track event with disableCustomEventLogging', () async {
      DevCycleUser user = DevCycleUserBuilder().userId('user1').build();
      DevCycleClient devcycleFlutterClientSdkPlugin =
      DevCycleClientBuilder().sdkKey('SDK_KEY').user(user).build();
      DevCycleEvent event = DevCycleEventBuilder()
          .type('my event type')
          .target('my target')
          .value(1)
          .metaData({"hello": "world"}).build();

      await devcycleFlutterClientSdkPlugin.track(event);
      expect(methodCall?.method, 'track');
      expect(methodCall?.arguments, {'event': event.toCodec()});
    });
  });

  group('flushEvents', () {
    test('flush events', () async {
      DevCycleUser user = DevCycleUserBuilder().userId('user1').build();
      DevCycleClient devcycleFlutterClientSdkPlugin =
          DevCycleClientBuilder().sdkKey('SDK_KEY').user(user).build();
      await devcycleFlutterClientSdkPlugin.flushEvents();
      expect(methodCall?.method, 'flushEvents');
    });
  });
}
