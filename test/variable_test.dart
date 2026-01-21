import 'package:flutter_test/flutter_test.dart';
import 'package:devcycle_flutter_client_sdk/dvc_variable.dart';

void main() {
  test('builds string variable object from a map', () {
    Map<String, dynamic> codecVariable = {
      "id": "variable1",
      "key": "variable-one",
      "type": "String",
      "value": "hello world",
      "isDefaulted": false
    };
    DVCVariable variable = DVCVariable.fromCodec(codecVariable);
    expect(variable.id, equals('variable1'));
    expect(variable.key, equals('variable-one'));
    expect(variable.type.toString(), equals('VariableType.string'));
    expect(variable.value, equals('hello world'));
    expect(variable.eval, equals(null));
  });

  test('builds boolean variable object from a map', () {
    Map<String, dynamic> codecVariable = {
      "id": "variable1",
      "key": "variable-one",
      "type": "Boolean",
      "value": true
    };
    DVCVariable variable = DVCVariable.fromCodec(codecVariable);
    expect(variable.id, equals('variable1'));
    expect(variable.key, equals('variable-one'));
    expect(variable.type.toString(), equals('VariableType.boolean'));
    expect(variable.value, equals(isTrue));
    expect(variable.eval, equals(null));
  });

  test('builds number variable object from a map', () {
    Map<String, dynamic> codecVariable = {
      "id": "variable1",
      "key": "variable-one",
      "type": "Number",
      "value": 100
    };
    DVCVariable variable = DVCVariable.fromCodec(codecVariable);
    expect(variable.id, equals('variable1'));
    expect(variable.key, equals('variable-one'));
    expect(variable.type.toString(), equals('VariableType.number'));
    expect(variable.value, equals(100));
    expect(variable.eval, equals(null));
  });

  test('builds json variable object from a map', () {
    Map<String, dynamic> codecVariable = {
      "id": "variable1",
      "key": "variable-one",
      "type": "JSON",
      "value": {"hello": "world"}
    };
    DVCVariable variable = DVCVariable.fromCodec(codecVariable);
    expect(variable.id, equals('variable1'));
    expect(variable.key, equals('variable-one'));
    expect(variable.type.toString(), equals('VariableType.json'));
    expect(variable.value, equals({"hello": "world"}));
    expect(variable.eval, equals(null));
  });

  test('builds variable object from a map with eval reason', () {
    Map<String, dynamic> codecVariable = {
      "id": "variable1",
      "key": "variable-one",
      "type": "Boolean",
      "value": true,
      "eval": {
        "reason": "TARGETING_MATCH",
        "details": "Email AND App Version",
        "target_id": "test_target_id"
      }
    };
    DVCVariable variable = DVCVariable.fromCodec(codecVariable);
    expect(variable.id, equals('variable1'));
    expect(variable.key, equals('variable-one'));
    expect(variable.type.toString(), equals('VariableType.boolean'));
    expect(variable.value, equals(isTrue));
    expect(variable.eval?.reason, equals('TARGETING_MATCH'));
    expect(variable.eval?.details, equals('Email AND App Version'));
    expect(variable.eval?.targetId, equals('test_target_id'));
  });

  test(
      'builds variable object from a map with eval reason and extra properties',
      () {
    Map<String, dynamic> codecVariable = {
      "id": "variable1",
      "key": "variable-one",
      "type": "Boolean",
      "value": true,
      "eval": {
        "reason": "TARGETING_MATCH",
        "details": "Email AND App Version",
        "target_id": "test_target_id",
        "some_random_key": "some_random_value"
      }
    };
    DVCVariable variable = DVCVariable.fromCodec(codecVariable);
    expect(variable.id, equals('variable1'));
    expect(variable.key, equals('variable-one'));
    expect(variable.type.toString(), equals('VariableType.boolean'));
    expect(variable.value, equals(isTrue));
    expect(variable.eval?.reason, equals('TARGETING_MATCH'));
    expect(variable.eval?.details, equals('Email AND App Version'));
    expect(variable.eval?.targetId, equals('test_target_id'));
  });

  test('builds string variable fromDefault from a key and default value', () {
    DVCVariable variable =
        DVCVariable.fromDefault('variable-one', 'hello world');
    expect(variable.key, equals('variable-one'));
    expect(variable.type.toString(), equals('VariableType.string'));
    expect(variable.value, equals('hello world'));
    expect(variable.eval?.reason, equals('DEFAULT'));
    expect(variable.eval?.details, equals('User Not Targeted'));
  });

  test('handles eval reason with null targetId', () {
    Map<String, dynamic> codecVariable = {
      "id": "variable1",
      "key": "variable-one",
      "type": "String",
      "value": "test",
      "eval": {
        "reason": "DEFAULT",
        "details": "User Not Targeted",
        "target_id": null
      }
    };
    DVCVariable variable = DVCVariable.fromCodec(codecVariable);
    expect(variable.eval?.reason, equals('DEFAULT'));
    expect(variable.eval?.details, equals('User Not Targeted'));
    expect(variable.eval?.targetId, equals(null));
  });

  test('handles eval reason with null details', () {
    Map<String, dynamic> codecVariable = {
      "id": "variable1",
      "key": "variable-one",
      "type": "String",
      "value": "test",
      "eval": {
        "reason": "TARGETING_MATCH",
        "details": null,
        "target_id": "target_123"
      }
    };
    DVCVariable variable = DVCVariable.fromCodec(codecVariable);
    expect(variable.eval?.reason, equals('TARGETING_MATCH'));
    expect(variable.eval?.details, equals(null));
    expect(variable.eval?.targetId, equals('target_123'));
  });

  test('handles eval reason as Map<Object?, Object?> from platform channel',
      () {
    // Simulate what the platform channel returns (Map<Object?, Object?>)
    Map<Object?, Object?> platformEval = {
      "reason": "DEFAULT",
      "details": "User Not Targeted",
      "target_id": null
    };

    Map<String, dynamic> codecVariable = {
      "id": "variable1",
      "key": "variable-one",
      "type": "String",
      "value": "test",
      "eval": platformEval
    };

    DVCVariable variable = DVCVariable.fromCodec(codecVariable);
    expect(variable.eval?.reason, equals('DEFAULT'));
    expect(variable.eval?.details, equals('User Not Targeted'));
    expect(variable.eval?.targetId, equals(null));
  });

  test('handles different eval reason types', () {
    final reasonTypes = [
      'DEFAULT',
      'TARGETING_MATCH',
      'CONFIG_NOT_READY',
      'VARIABLE_NOT_FOUND',
      'ERROR'
    ];

    for (var reasonType in reasonTypes) {
      Map<String, dynamic> codecVariable = {
        "id": "variable1",
        "key": "variable-one",
        "type": "String",
        "value": "test",
        "eval": {
          "reason": reasonType,
          "details": "Test details for $reasonType",
          "target_id": reasonType == 'TARGETING_MATCH' ? 'target_123' : null
        }
      };

      DVCVariable variable = DVCVariable.fromCodec(codecVariable);
      expect(variable.eval?.reason, equals(reasonType));
      expect(variable.eval?.details, equals('Test details for $reasonType'));
    }
  });

  test('handles eval reason with all fields null', () {
    Map<String, dynamic> codecVariable = {
      "id": "variable1",
      "key": "variable-one",
      "type": "String",
      "value": "test",
      "eval": {"reason": null, "details": null, "target_id": null}
    };
    DVCVariable variable = DVCVariable.fromCodec(codecVariable);
    expect(variable.eval, isNotNull);
    expect(variable.eval?.reason, equals(null));
    expect(variable.eval?.details, equals(null));
    expect(variable.eval?.targetId, equals(null));
  });
}
