import 'package:flutter_test/flutter_test.dart';
import 'package:devcycle_flutter_client_sdk/devcycle_flutter_client_sdk.dart';

void main() {
  test('builds correct user object', () {
    DevCycleUser user = DevCycleUserBuilder()
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

  test('deprecated DVCUserBuilder', () {
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
    DevCycleUser user = DevCycleUserBuilder()
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
}
