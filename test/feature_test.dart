import 'package:flutter_test/flutter_test.dart';
import 'package:devcycle_flutter_client_sdk/feature.dart';

void main() {
  test('builds feature object from a map', () {
    Map<String, dynamic> codecFeature = {
      "id": "feature1",
      "key": "feature-one",
      "type": "release",
      "variation": "variation1",
      "variationName": "Variation One",
      "variationKey": "var-one"
    };
    Feature feature = Feature.fromCodec(codecFeature);
    expect(feature.id, equals('feature1'));
    expect(feature.key, equals('feature-one'));
    expect(feature.type.toString(), equals('FeatureType.release'));
    expect(feature.variation, equals('variation1'));
    expect(feature.variationName, equals('Variation One'));
    expect(feature.variationKey, equals('var-one'));
  });
}
