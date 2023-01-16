enum LogLevel { debug, info, warn, error }

class DVCOptions {
  final int? flushEventsIntervalMs;
  final bool? disableEventLogging;
  final bool? enableEdgeDB;
  final int? configCacheTTL;
  final bool? disableConfigCache;
  final LogLevel? logLevel;

  DVCOptions._builder(DVCOptionsBuilder builder)
      : flushEventsIntervalMs = builder._flushEventsIntervalMs,
        disableEventLogging = builder._disableEventLogging,
        enableEdgeDB = builder._enableEdgeDB,
        configCacheTTL = builder._configCacheTTL,
        disableConfigCache = builder._disableConfigCache,
        logLevel = builder._logLevel;

  Map<String, dynamic> toCodec() {
    final Map<String, dynamic> result = <String, dynamic>{};
    if (flushEventsIntervalMs != null) {
      result['flushEventsIntervalMs'] = flushEventsIntervalMs;
    }
    if (disableEventLogging != null) {
      result['disableEventLogging'] = disableEventLogging;
    }
    if (enableEdgeDB != null) result['enableEdgeDB'] = enableEdgeDB;
    if (configCacheTTL != null) result['configCacheTTL'] = configCacheTTL;
    if (disableConfigCache != null) {
      result['disableConfigCache'] = disableConfigCache;
    }
    if (logLevel != null) result['logLevel'] = logLevel?.name;
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
  LogLevel? _logLevel;

  DVCOptionsBuilder flushEventsIntervalMs(int flushEventsIntervalMs) {
    _flushEventsIntervalMs = flushEventsIntervalMs;
    return this;
  }

  DVCOptionsBuilder disableEventLogging(bool disableEventLogging) {
    _disableEventLogging = disableEventLogging;
    return this;
  }

  DVCOptionsBuilder enableEdgeDB(bool enableEdgeDB) {
    _enableEdgeDB = enableEdgeDB;
    return this;
  }

  DVCOptionsBuilder configCacheTTL(int configCacheTTL) {
    _configCacheTTL = configCacheTTL;
    return this;
  }

  DVCOptionsBuilder disableConfigCache(bool disableConfigCache) {
    _disableConfigCache = disableConfigCache;
    return this;
  }

  DVCOptionsBuilder logLevel(LogLevel logLevel) {
    _logLevel = logLevel;
    return this;
  }

  /// Constructs a [DVCOptions] instance from the values currently in the builder.
  DVCOptions build() {
    return DVCOptions._builder(this);
  }
}
