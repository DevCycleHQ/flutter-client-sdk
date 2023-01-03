import 'package:flutter_test/flutter_test.dart';
import 'package:devcycle_flutter_client_sdk/devcycle_flutter_client_sdk.dart';

void main() {
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
    Map<String, dynamic> userMap = user.toMap();
    expect(userMap['userId'], equals('user1'));
    expect(userMap['isAnonymous'], isFalse);
    expect(userMap['email'], equals('test@example.com'));
    expect(userMap['name'], equals('a b'));
    expect(userMap['country'], equals('de'));
  });
}
