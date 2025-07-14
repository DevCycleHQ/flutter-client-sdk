import 'package:collection/collection.dart';
import 'devcycle_eval_reason.dart';

enum FeatureType { release, experiment, permission, ops }

class DVCFeature {
  /// unique database id
  String? id;

  /// Unique key by Project, can be used in the SDK / API to reference by &#x27;key&#x27; rather than _id.
  String? key;

  /// Feature type
  FeatureType? type;

  /// Bucketed feature variation ID
  String? variation;

  /// Deprecated, remove in next major version, use [eval] instead
  @Deprecated('Use [eval] instead')
  String? evalReason;

  /// Variation name
  String? variationName;

  /// Variation key
  String? variationKey;

  /// Evaluation reasoning
  DevCycleEvalReason? eval;

  static DVCFeature fromCodec(Map<String, dynamic> map) {
    DVCFeature feature = DVCFeature();

    feature.id = map['id'];
    feature.key = map['key'];
    feature.type = FeatureType.values
        .firstWhereOrNull((e) => e.toString() == "FeatureType.${map['type']}");
    feature.variation = map['variation'];
    feature.variationName = map['variationName'];
    feature.variationKey = map['variationKey'];
    feature.eval =
        map['eval'] != null ? DevCycleEvalReason.fromCodec(map['eval']) : null;

    return feature;
  }
}
