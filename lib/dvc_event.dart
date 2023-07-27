class DevCycleEvent {
  final String? type;
  final String? target;
  final double? value;
  final DateTime? date;
  final Map<String, dynamic>? metaData;

  DevCycleEvent._builder(DevCycleEventBuilder builder)
      : type = builder._type,
        target = builder._target,
        value = builder._value,
        date = builder._date,
        metaData = builder._metaData;

  Map<String, dynamic> toCodec() {
    final Map<String, dynamic> result = <String, dynamic>{};
    result['type'] = type;
    result['target'] = target;
    result['value'] = value.toString();
    result['date'] = date?.toIso8601String();
    result['metaData'] = metaData;
    return result;
  }

  @override
  String toString() {
    return 'DVCEvent{type: $type, target: $target, value: $value, date: $date, metaData: $metaData}';
  }
}

@Deprecated('Use DevCycleEvent instead')
typedef DVCEvent = DevCycleEvent;

/// A builder for constructing [DevCycleEvent] objects.
class DevCycleEventBuilder {
  String? _type;
  String? _target;
  double? _value;
  DateTime? _date;
  Map<String, dynamic>? _metaData;

  /// Custom event type
  DevCycleEventBuilder type(String type) {
    _type = type;
    return this;
  }

  /// Custom event target / subject of event. Contextual to event type
  DevCycleEventBuilder target(String target) {
    _target = target;
    return this;
  }

  /// Sets the user's email attribute.
  DevCycleEventBuilder value(double value) {
    _value = value;
    return this;
  }

  DevCycleEventBuilder date(DateTime date) {
    _date = date;
    return this;
  }

  DevCycleEventBuilder metaData(Map<String, dynamic> metaData) {
    _metaData = metaData;
    return this;
  }

  /// Constructs a [DevCycleEvent] instance from the values currently in the builder.
  DevCycleEvent build() {
    return DevCycleEvent._builder(this);
  }
}

@Deprecated('Use DevCycleEventBuilder instead')
typedef DVCEventBuilder = DevCycleEventBuilder;