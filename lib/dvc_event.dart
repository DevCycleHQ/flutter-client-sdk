class DVCEvent {
  final String? type;
  final String? target;
  final double? value;
  final DateTime? date;
  final Map<String, dynamic>? metaData;

  DVCEvent._builder(DVCEventBuilder builder)
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

/// A builder for constructing [DVCEvent] objects.
class DVCEventBuilder {
  String? _type;
  String? _target;
  double? _value;
  DateTime? _date;
  Map<String, dynamic>? _metaData;

  /// Custom event type
  DVCEventBuilder type(String type) {
    _type = type;
    return this;
  }

  /// Custom event target / subject of event. Contextual to event type
  DVCEventBuilder target(String target) {
    _target = target;
    return this;
  }

  /// Sets the user's email attribute.
  DVCEventBuilder value(double value) {
    _value = value;
    return this;
  }

  DVCEventBuilder date(DateTime date) {
    _date = date;
    return this;
  }

  DVCEventBuilder metaData(Map<String, dynamic> metaData) {
    _metaData = metaData;
    return this;
  }

  /// Constructs a [DVCEvent] instance from the values currently in the builder.
  DVCEvent build() {
    return DVCEvent._builder(this);
  }
}
