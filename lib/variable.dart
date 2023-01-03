part of devcycle_flutter_client_sdk;

enum TypeEnum {
  String,
  Boolean,
  Number,
  JSON
}

class Variable<T> {
  /// unique database id
  String? id;

  /// Unique key by Project, can be used in the SDK / API to reference by &#x27;key&#x27; rather than _id.
  String? key;

  /// Variable type
  TypeEnum? type;

  /// Variable value can be a string, number, boolean, or JSON
  T? value;
  
  bool? isDefaulted;

  static Variable fromMap(Map<String, dynamic> map) {
    Variable variable = Variable();

    variable.id = map['id'];
    variable.key = map['key'];
    variable.type = map['type'];
    variable.value = map['value'];
    variable.isDefaulted = map['isDefaulted'];

    return variable;
  }

  ///
  /// To be notified when Variable.value changes register a callback by calling this method. The
  /// callback will replace any previously registered callback.
  ///
  /// [callback] called with the updated variable
  ///
  onUpdate() {

  }
}
