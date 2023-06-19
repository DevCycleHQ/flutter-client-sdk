enum LogLevel { debug, info, warn, error }

class DVCOptions {
  final int? flushEventsIntervalMs;
  final bool? disableEventLogging;
  final bool? disableCustomEventLogging;
  final bool? disableAutomaticEventLogging;
  final bool? enableEdgeDB;
  final int? configCacheTTL;
  final bool? disableConfigCache;
  final bool? disableRealtimeUpdates;
  final LogLevel? logLevel;

  DVCOptions._builder(DVCOptionsBuilder builder)
      : flushEventsIntervalMs = builder._flushEventsIntervalMs,
        disableEventLogging = builder._disableEventLogging,
        disableCustomEventLogging = builder._disableCustomEventLogging,
        disableAutomaticEventLogging = builder._disableAutomaticEventLogging,
        enableEdgeDB = builder._enableEdgeDB,
        configCacheTTL = builder._configCacheTTL,
        disableConfigCache = builder._disableConfigCache,
        disableRealtimeUpdates = builder._disableRealtimeUpdates,
        logLevel = builder._logLevel;

  Map<String, dynamic> toCodec() {
    final Map<String, dynamic> result = <String, dynamic>{};
    if (flushEventsIntervalMs != null) {
      result['flushEventsIntervalMs'] = flushEventsIntervalMs;
    }
    if (disableEventLogging != null) {
      result['disableEventLogging'] = disableEventLogging;
    }
    if (disableCustomEventLogging != null) {
      result['disableCustomEventLogging'] = disableCustomEventLogging;
    }
    if (disableAutomaticEventLogging != null) {
      result['disableAutomaticEventLogging'] = disableAutomaticEventLogging;
    }
    if (enableEdgeDB != null) result['enableEdgeDB'] = enableEdgeDB;
    if (configCacheTTL != null) result['configCacheTTL'] = configCacheTTL;
    if (disableConfigCache != null) {
      result['disableConfigCache'] = disableConfigCache;
    }
    if (disableRealtimeUpdates != null) {
      result['disableRealtimeUpdates'] = disableRealtimeUpdates;
    }
    if (logLevel != null) {
      result['logLevel'] = logLevel?.toString().split('.').last;
    }
    return result;
  }
}

/// A builder for constructing [DVCOptions] objects.
class DVCOptionsBuilder {
  int? _flushEventsIntervalMs;
  bool? _disableEventLogging;
  bool? _disableCustomEventLogging;
  bool? _disableAutomaticEventLogging;
  bool? _enableEdgeDB;
  int? _configCacheTTL;
  bool? _disableConfigCache;
  bool? _disableRealtimeUpdates;
  LogLevel? _logLevel;

  DVCOptionsBuilder flushEventsIntervalMs(int flushEventsIntervalMs) {
    _flushEventsIntervalMs = flushEventsIntervalMs;
    return this;
  }

  @Deprecated(
      'Use disableCustomEventLogging and disableAutomaticEventLogging instead')
  DVCOptionsBuilder disableEventLogging(bool disableEventLogging) {
    _disableEventLogging = disableEventLogging;
    return this;
  }

  DVCOptionsBuilder disableCustomEventLogging(bool disableCustomEventLogging) {
    _disableCustomEventLogging = disableCustomEventLogging;
    return this;
  }

  DVCOptionsBuilder disableAutomaticEventLogging(
      bool disableAutomaticEventLogging) {
    _disableAutomaticEventLogging = disableAutomaticEventLogging;
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

  DVCOptionsBuilder disableRealtimeUpdates(bool disableRealtimeUpdates) {
    _disableRealtimeUpdates = disableRealtimeUpdates;
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
