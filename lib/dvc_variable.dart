import 'package:collection/collection.dart';

enum VariableType { string, boolean, number, json }

class DVCVariable<T> {
  /// unique database id
  String? id;

  /// Unique key by Project, can be used in the SDK / API to reference by &#x27;key&#x27; rather than _id.
  String key;

  /// Variable type
  VariableType? type;

  /// Variable value can be a string, number, boolean, or JSON
  T value;

  void Function(T value)? callback;

  DVCVariable({this.id, required this.key, this.type, required this.value});

  static DVCVariable fromCodec(Map<String, dynamic> map) {
    String mapType = map['type'].toString().toLowerCase();

    return DVCVariable(
        key: map['key'],
        value: map['value'],
        id: map['id'],
        type: VariableType.values
            .firstWhereOrNull((e) => e.toString() == "VariableType.$mapType")
    );
  }

  static DVCVariable fromDefault(String key, dynamic defaultValue) {
    String mapType = defaultValue.runtimeType.toString().toLowerCase();

    return DVCVariable(
        key: key,
        value: defaultValue,
        type: VariableType.values
            .firstWhereOrNull((e) => e.toString() == "VariableType.$mapType")
    );
  }

  ///
  /// To be notified when Variable.value changes register a callback by calling this method. The
  /// callback will replace any previously registered callback.
  ///
  /// [callback] called with the updated variable
  ///
  onUpdate(void Function(T value) onUpdateCallback) {
    callback = onUpdateCallback;
  }
}
