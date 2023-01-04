class DVCEvent {
  final String? type;
  final String? target;
  final double? value;
  final Map<String, dynamic>? metaData;

  DVCEvent._builder(DVCEventBuilder builder) :
    type = builder._type,
    target = builder._target,
    value = builder._value,
    metaData = builder._metaData;

<<<<<<< HEAD
  Map<String, dynamic> toMap() {
=======
  Map<String, dynamic> toCodec() {
>>>>>>> 999b3d2 (Rename toMap methods to toCodec to align with Flutter terminology)
    final Map<String, dynamic> result = <String, dynamic>{};
    result['type'] = type;
    result['target'] = target;
    result['value'] = value;
    result['metaData'] = metaData;
    return result;
  }
}

/// A builder for constructing [DVCEvent] objects.
class DVCEventBuilder {
  String? _type;
  String? _target;
  double? _value;
  Map<String, dynamic>? _metaData;

  /// Custom event type
  DVCEventBuilder type(String type) {
    this._type = type;
    return this;
  }

  /// Custom event target / subject of event. Contextual to event type
  DVCEventBuilder target(String target) {
    this._target = target;
    return this;
  }

  /// Sets the user's email attribute.
  DVCEventBuilder value(double value) {
    this._value = value;
    return this;
  }

  DVCEventBuilder metaData(Map<String, dynamic> metaData) {
    this._metaData = metaData;
    return this;
  }

  /// Constructs a [DVCEvent] instance from the values currently in the builder.
  DVCEvent build() {
    return DVCEvent._builder(this);
  }
}
