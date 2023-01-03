part of devcycle_flutter_client_sdk;

enum TypeEnum {
  release,
  experiment,
  permission,
  ops
}

class Feature {
  /// unique database id
  String? id;

  /// Unique key by Project, can be used in the SDK / API to reference by &#x27;key&#x27; rather than _id.
  String? key;

  /// Feature type
  TypeEnum? type;

  /// Bucketed feature variation ID
  String? variation;

  /// Evaluation reasoning
  String? evalReason;

  /// Variation name
  String? variationName;

  /// Variation key
  String? variationKey;

  static Feature fromMap(Map<String, dynamic> map) {
    Feature feature = Feature();

    feature.id = map['id'];
    feature.key = map['key'];
    feature.type = map['type'];
    feature.variation = map['variation'];
    feature.evalReason = map['evalReason'];
    feature.variationName = map['variationName'];
    feature.variationKey = map['variationKey'];

    return feature;
  }
}
