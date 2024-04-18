import 'package:flutter_test/flutter_test.dart';
import 'package:devcycle_flutter_client_sdk/devcycle_flutter_client_sdk.dart';

void main() {
  test('builds options object with all params', () {
    DevCycleOptions options = DevCycleOptionsBuilder()
        .flushEventsIntervalMs(100)
        .disableCustomEventLogging(true)
        .disableAutomaticEventLogging(false)
        .enableEdgeDB(false)
        .configCacheTTL(999)
        .disableConfigCache(false)
        .disableRealtimeUpdates(false)
        .logLevel(LogLevel.debug)
        .apiProxyUrl("http://api.test.com")
        .eventsApiProxyUrl("http://events.test.com")
        .build();
    expect(options.flushEventsIntervalMs, equals(100));
    expect(options.disableCustomEventLogging, isTrue);
    expect(options.disableAutomaticEventLogging, isFalse);
    expect(options.enableEdgeDB, isFalse);
    expect(options.configCacheTTL, equals(999));
    expect(options.disableConfigCache, isFalse);
    expect(options.disableRealtimeUpdates, isFalse);
    expect(options.logLevel, equals(LogLevel.debug));
    expect(options.apiProxyUrl, equals("http://api.test.com"));
    expect(options.eventsApiProxyUrl, equals("http://events.test.com"));
  });

  test('deprecated DVCOptionsBuilder', () {
    DVCOptions options = DVCOptionsBuilder()
        .flushEventsIntervalMs(100)
        .disableCustomEventLogging(true)
        .disableAutomaticEventLogging(false)
        .enableEdgeDB(false)
        .configCacheTTL(999)
        .disableConfigCache(false)
        .disableRealtimeUpdates(false)
        .logLevel(LogLevel.debug)
        .apiProxyUrl("http://api.test.com")
        .eventsApiProxyUrl("http://events.test.com")
        .build();
    expect(options.flushEventsIntervalMs, equals(100));
    expect(options.disableCustomEventLogging, isTrue);
    expect(options.disableAutomaticEventLogging, isFalse);
    expect(options.enableEdgeDB, isFalse);
    expect(options.configCacheTTL, equals(999));
    expect(options.disableConfigCache, isFalse);
    expect(options.disableRealtimeUpdates, isFalse);
    expect(options.logLevel, equals(LogLevel.debug));
    expect(options.apiProxyUrl, equals("http://api.test.com"));
    expect(options.eventsApiProxyUrl, equals("http://events.test.com"));
  });

  test('creates map from options object with all properties', () {
    DevCycleOptions options = DVCOptionsBuilder()
        .flushEventsIntervalMs(100)
        .disableAutomaticEventLogging(true)
        .disableCustomEventLogging(false)
        .enableEdgeDB(false)
        .configCacheTTL(999)
        .disableConfigCache(false)
        .logLevel(LogLevel.error)
        .apiProxyUrl("http://api.test.com")
        .eventsApiProxyUrl("http://events.test.com")
        .build();
    Map<String, dynamic> codecOptions = options.toCodec();
    expect(codecOptions['flushEventsIntervalMs'], equals(100));
    expect(codecOptions['disableAutomaticEventLogging'], isTrue);
    expect(codecOptions['disableCustomEventLogging'], isFalse);
    expect(codecOptions['enableEdgeDB'], isFalse);
    expect(codecOptions['configCacheTTL'], equals(999));
    expect(codecOptions['disableConfigCache'], isFalse);
    expect(codecOptions['logLevel'], equals('error'));
    expect(codecOptions['apiProxyUrl'], equals('http://api.test.com'));
    expect(codecOptions['eventsApiProxyUrl'], equals('http://events.test.com'));
  });

  test('creates map from options object with only one property', () {
    DevCycleOptions options =
        DVCOptionsBuilder().flushEventsIntervalMs(100).build();
    Map<String, dynamic> codecOptions = options.toCodec();
    expect(codecOptions, {"flushEventsIntervalMs": 100});
  });
}
