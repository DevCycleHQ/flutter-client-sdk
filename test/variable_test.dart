import 'package:flutter_test/flutter_test.dart';
import 'package:devcycle_flutter_client_sdk/variable.dart';

void main() {
  test('builds string variable object from a map', () {
    Map<String, dynamic> variableMap = {
      "id": "variable1",
      "key": "variable-one",
      "type": "String",
      "value": "hello world",
      "isDefaulted": false
    };
    Variable variable = Variable.fromMap(variableMap);
    expect(variable.id, equals('variable1'));
    expect(variable.key, equals('variable-one'));
    expect(variable.type.toString(), equals('VariableType.string'));
    expect(variable.value, equals('hello world'));
    expect(variable.isDefaulted, equals(isFalse));
  });

  test('builds boolean variable object from a map', () {
    Map<String, dynamic> variableMap = {
      "id": "variable1",
      "key": "variable-one",
      "type": "Boolean",
      "value": true
    };
    Variable variable = Variable.fromMap(variableMap);
    expect(variable.id, equals('variable1'));
    expect(variable.key, equals('variable-one'));
    expect(variable.type.toString(), equals('VariableType.boolean'));
    expect(variable.value, equals(isTrue));
  });

  test('builds number variable object from a map', () {
    Map<String, dynamic> variableMap = {
      "id": "variable1",
      "key": "variable-one",
      "type": "Number",
      "value": 100
    };
    Variable variable = Variable.fromMap(variableMap);
    expect(variable.id, equals('variable1'));
    expect(variable.key, equals('variable-one'));
    expect(variable.type.toString(), equals('VariableType.number'));
    expect(variable.value, equals(100));
  });

  test('builds json variable object from a map', () {
    Map<String, dynamic> variableMap = {
      "id": "variable1",
      "key": "variable-one",
      "type": "JSON",
      "value": { "hello": "world" }
    };
    Variable variable = Variable.fromMap(variableMap);
    expect(variable.id, equals('variable1'));
    expect(variable.key, equals('variable-one'));
    expect(variable.type.toString(), equals('VariableType.json'));
    expect(variable.value, equals({ "hello": "world" }));
  });
}
