import 'package:flutter_test/flutter_test.dart';
import 'package:devcycle_flutter_client_sdk/devcycle_flutter_client_sdk.dart';

void main() {
  test('builds options object with all params', () {
    DVCOptions options = DVCOptionsBuilder()
      .flushEventsIntervalMs(100)
      .disableEventLogging(true)
      .enableEdgeDB(false)
      .configCacheTTL(999)
      .disableConfigCache(false)
      .build();
    expect(options.flushEventsIntervalMs, equals(100));
    expect(options.disableEventLogging, isTrue);
    expect(options.enableEdgeDB, isFalse);
    expect(options.configCacheTTL, equals(999));
    expect(options.disableConfigCache, isFalse);
  });

  test('creates map from options object with all properties', () {
    DVCOptions options = DVCOptionsBuilder()
      .flushEventsIntervalMs(100)
      .disableEventLogging(true)
      .enableEdgeDB(false)
      .configCacheTTL(999)
      .disableConfigCache(false)
      .build();
    Map<String, dynamic> codecOptions = options.toCodec();
    expect(codecOptions['flushEventsIntervalMs'], equals(100));
    expect(codecOptions['disableEventLogging'], isTrue);
    expect(codecOptions['enableEdgeDB'], isFalse);
    expect(codecOptions['configCacheTTL'], equals(999));
    expect(codecOptions['disableConfigCache'], isFalse);
  });

  test('creates map from options object with only one property', () {
    DVCOptions options = DVCOptionsBuilder()
      .flushEventsIntervalMs(100)
      .build();
    Map<String, dynamic> codecOptions = options.toCodec();
    expect(codecOptions, { "flushEventsIntervalMs": 100 });
  });
}
