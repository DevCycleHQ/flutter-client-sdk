import 'package:flutter_test/flutter_test.dart';
import 'package:devcycle_flutter_client_sdk/devcycle_flutter_client_sdk.dart';

void main() {
  test('builds event object', () {
    DVCEvent event = DVCEventBuilder()
      .type('my event type')
      .target('my target')
      .value(1)
      .metaData({
        "hello": "world"
      })
      .build();
    expect(event.type, equals('my event type'));
    expect(event.target, equals('my target'));
    expect(event.value, equals(1));
    expect(event.metaData, equals({ "hello": "world" }));
  });

  test('creates map from event object', () {
    DVCEvent event = DVCEventBuilder()
      .type('my event type')
      .target('my target')
      .value(1)
      .metaData({
        "hello": "world"
      })
      .build();
    Map<String, dynamic> eventMap = event.toMap();
    expect(eventMap['type'], equals('my event type'));
    expect(eventMap['target'], equals('my target'));
    expect(eventMap['value'], equals(1));
    expect(eventMap['metaData'], equals({ "hello": "world" }));
  });
}
