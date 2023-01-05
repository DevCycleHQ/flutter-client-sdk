class DVCOptions {
  final int? flushEventsIntervalMs;
  final bool? disableEventLogging;
  final bool? enableEdgeDB;
  final int? configCacheTTL;
  final bool? disableConfigCache;

  DVCOptions._builder(DVCOptionsBuilder builder) :
    flushEventsIntervalMs = builder._flushEventsIntervalMs,
    disableEventLogging = builder._disableEventLogging,
    enableEdgeDB = builder._enableEdgeDB,
    configCacheTTL = builder._configCacheTTL,
    disableConfigCache = builder._disableConfigCache;

  Map<String, dynamic> toCodec() {
    final Map<String, dynamic> result = <String, dynamic>{};
    if (flushEventsIntervalMs != null) result['flushEventsIntervalMs'] = flushEventsIntervalMs;
    if (disableEventLogging != null) result['disableEventLogging'] = disableEventLogging;
    if (enableEdgeDB != null) result['enableEdgeDB'] = enableEdgeDB;
    if (configCacheTTL != null) result['configCacheTTL'] = configCacheTTL;
    if (disableConfigCache != null) result['disableConfigCache'] = disableConfigCache;
    return result;
  }
}

/// A builder for constructing [DVCOptions] objects.
class DVCOptionsBuilder {
  int? _flushEventsIntervalMs;
  bool? _disableEventLogging;
  bool? _enableEdgeDB;
  int? _configCacheTTL;
  bool? _disableConfigCache;

  DVCOptionsBuilder flushEventsIntervalMs(int flushEventsIntervalMs) {
      this._flushEventsIntervalMs = flushEventsIntervalMs;
      return this;
  }

  DVCOptionsBuilder disableEventLogging(bool disableEventLogging) {
      this._disableEventLogging = disableEventLogging;
      return this;
  }

  DVCOptionsBuilder enableEdgeDB(bool enableEdgeDB) {
      this._enableEdgeDB = enableEdgeDB;
      return this;
  }

  DVCOptionsBuilder configCacheTTL(int configCacheTTL) {
      this._configCacheTTL = configCacheTTL;
      return this;
  }

  DVCOptionsBuilder disableConfigCache(bool disableConfigCache) {
      this._disableConfigCache = disableConfigCache;
      return this;
  }

  /// Constructs a [DVCOptions] instance from the values currently in the builder.
  DVCOptions build() {
    return DVCOptions._builder(this);
  }
}
