import 'package:flutter_test/flutter_test.dart';
import 'package:devcycle_flutter_client_sdk/devcycle_eval_reason.dart';

void main() {
  group('DevCycleEvalReason.fromCodec', () {
    test('deserializes complete eval reason with all fields', () {
      Map<String, dynamic> evalMap = {
        "reason": "TARGETING_MATCH",
        "details": "Email AND App Version",
        "target_id": "test_target_123"
      };

      DevCycleEvalReason evalReason = DevCycleEvalReason.fromCodec(evalMap);

      expect(evalReason.reason, equals('TARGETING_MATCH'));
      expect(evalReason.details, equals('Email AND App Version'));
      expect(evalReason.targetId, equals('test_target_123'));
    });

    test('deserializes eval reason with null targetId', () {
      Map<String, dynamic> evalMap = {
        "reason": "DEFAULT",
        "details": "User Not Targeted",
        "target_id": null
      };

      DevCycleEvalReason evalReason = DevCycleEvalReason.fromCodec(evalMap);

      expect(evalReason.reason, equals('DEFAULT'));
      expect(evalReason.details, equals('User Not Targeted'));
      expect(evalReason.targetId, isNull);
    });

    test('deserializes eval reason with null details', () {
      Map<String, dynamic> evalMap = {
        "reason": "ERROR",
        "details": null,
        "target_id": "target_456"
      };

      DevCycleEvalReason evalReason = DevCycleEvalReason.fromCodec(evalMap);

      expect(evalReason.reason, equals('ERROR'));
      expect(evalReason.details, isNull);
      expect(evalReason.targetId, equals('target_456'));
    });

    test('deserializes eval reason with all null values', () {
      Map<String, dynamic> evalMap = {
        "reason": null,
        "details": null,
        "target_id": null
      };

      DevCycleEvalReason evalReason = DevCycleEvalReason.fromCodec(evalMap);

      expect(evalReason.reason, isNull);
      expect(evalReason.details, isNull);
      expect(evalReason.targetId, isNull);
    });

    test('handles Map<Object?, Object?> from platform channel', () {
      // Simulate the actual type returned from platform channel
      Map<Object?, Object?> platformMap = {
        "reason": "DEFAULT",
        "details": "User Not Targeted",
        "target_id": null
      };

      // Convert to Map<String, dynamic> as done in production code
      Map<String, dynamic> evalMap = Map<String, dynamic>.from(platformMap);
      DevCycleEvalReason evalReason = DevCycleEvalReason.fromCodec(evalMap);

      expect(evalReason.reason, equals('DEFAULT'));
      expect(evalReason.details, equals('User Not Targeted'));
      expect(evalReason.targetId, isNull);
    });

    test('handles missing fields gracefully', () {
      Map<String, dynamic> evalMap = {
        "reason": "TARGETING_MATCH",
        // Missing details and targetId
      };

      DevCycleEvalReason evalReason = DevCycleEvalReason.fromCodec(evalMap);

      expect(evalReason.reason, equals('TARGETING_MATCH'));
      expect(evalReason.details, isNull);
      expect(evalReason.targetId, isNull);
    });

    test('handles empty map', () {
      Map<String, dynamic> evalMap = {};

      DevCycleEvalReason evalReason = DevCycleEvalReason.fromCodec(evalMap);

      expect(evalReason.reason, isNull);
      expect(evalReason.details, isNull);
      expect(evalReason.targetId, isNull);
    });

    test('ignores extra fields in map', () {
      Map<String, dynamic> evalMap = {
        "reason": "DEFAULT",
        "details": "User Not Targeted",
        "target_id": null,
        "extraField": "should be ignored",
        "anotherField": 123
      };

      DevCycleEvalReason evalReason = DevCycleEvalReason.fromCodec(evalMap);

      expect(evalReason.reason, equals('DEFAULT'));
      expect(evalReason.details, equals('User Not Targeted'));
      expect(evalReason.targetId, isNull);
    });
  });

  group('DevCycleEvalReason.defaultReason', () {
    test('creates default eval reason with details', () {
      DevCycleEvalReason evalReason =
          DevCycleEvalReason.defaultReason('User Not Targeted');

      expect(evalReason.reason, equals('DEFAULT'));
      expect(evalReason.details, equals('User Not Targeted'));
      expect(evalReason.targetId, isNull);
    });

    test('creates default eval reason with custom details', () {
      DevCycleEvalReason evalReason =
          DevCycleEvalReason.defaultReason('Custom message');

      expect(evalReason.reason, equals('DEFAULT'));
      expect(evalReason.details, equals('Custom message'));
      expect(evalReason.targetId, isNull);
    });
  });

  group('DevCycleEvalReason types', () {
    test('handles all common reason types', () {
      final reasonTypes = [
        'DEFAULT',
        'TARGETING_MATCH',
        'CONFIG_NOT_READY',
        'VARIABLE_NOT_FOUND',
        'ERROR',
        'BOOTSTRAP',
        'STALE'
      ];

      for (var reasonType in reasonTypes) {
        Map<String, dynamic> evalMap = {
          "reason": reasonType,
          "details": "Test for $reasonType",
          "target_id": null
        };

        DevCycleEvalReason evalReason = DevCycleEvalReason.fromCodec(evalMap);
        expect(evalReason.reason, equals(reasonType));
        expect(evalReason.details, equals('Test for $reasonType'));
      }
    });
  });
}
