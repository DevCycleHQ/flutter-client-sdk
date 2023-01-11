enum VariableType {
  string,
  boolean,
  number,
  json
}

class DVCVariable<T> {
  /// unique database id
  String? id;

  /// Unique key by Project, can be used in the SDK / API to reference by &#x27;key&#x27; rather than _id.
  String? key;

  /// Variable type
  VariableType? type;

  /// Variable value can be a string, number, boolean, or JSON
  T? value;

  void Function(T value)? callback;

  static DVCVariable fromCodec(Map<String, dynamic> map) {
    DVCVariable variable = DVCVariable();
    String mapType = map['type'].toString().toLowerCase();

    variable.id = map['id'];
    variable.key = map['key'];
    variable.type = VariableType.values.firstWhere((e) => e.toString() == "VariableType.$mapType");
    variable.value = map['value'];

    return variable;
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
