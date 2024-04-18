enum LogLevel { debug, info, warn, error }

class DevCycleOptions {
  final int? flushEventsIntervalMs;
  final bool? disableEventLogging;
  final bool? disableCustomEventLogging;
  final bool? disableAutomaticEventLogging;
  final bool? enableEdgeDB;
  final int? configCacheTTL;
  final bool? disableConfigCache;
  final bool? disableRealtimeUpdates;
  final LogLevel? logLevel;
  final String? apiProxyUrl;
  final String? eventsApiProxyUrl;

  DevCycleOptions._builder(DevCycleOptionsBuilder builder)
      : flushEventsIntervalMs = builder._flushEventsIntervalMs,
        disableEventLogging = builder._disableEventLogging,
        disableCustomEventLogging = builder._disableCustomEventLogging,
        disableAutomaticEventLogging = builder._disableAutomaticEventLogging,
        enableEdgeDB = builder._enableEdgeDB,
        configCacheTTL = builder._configCacheTTL,
        disableConfigCache = builder._disableConfigCache,
        disableRealtimeUpdates = builder._disableRealtimeUpdates,
        logLevel = builder._logLevel,
        apiProxyUrl = builder._apiProxyUrl,
        eventsApiProxyUrl = builder._eventsApiProxyUrl;

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
    if (apiProxyUrl != null) {
      result['apiProxyUrl'] = apiProxyUrl;
    }
    if (eventsApiProxyUrl != null) {
      result['eventsApiProxyUrl'] = eventsApiProxyUrl;
    }
    return result;
  }
}

@Deprecated('Use DevCycleOptions instead')
typedef DVCOptions = DevCycleOptions;

/// A builder for constructing [DevCycleOptions] objects.
class DevCycleOptionsBuilder {
  int? _flushEventsIntervalMs;
  bool? _disableEventLogging;
  bool? _disableCustomEventLogging;
  bool? _disableAutomaticEventLogging;
  bool? _enableEdgeDB;
  int? _configCacheTTL;
  bool? _disableConfigCache;
  bool? _disableRealtimeUpdates;
  LogLevel? _logLevel;
  String? _apiProxyUrl;
  String? _eventsApiProxyUrl;

  DevCycleOptionsBuilder flushEventsIntervalMs(int flushEventsIntervalMs) {
    _flushEventsIntervalMs = flushEventsIntervalMs;
    return this;
  }

  @Deprecated(
      'Use disableCustomEventLogging and disableAutomaticEventLogging instead')
  DevCycleOptionsBuilder disableEventLogging(bool disableEventLogging) {
    _disableEventLogging = disableEventLogging;
    return this;
  }

  DevCycleOptionsBuilder disableCustomEventLogging(
      bool disableCustomEventLogging) {
    _disableCustomEventLogging = disableCustomEventLogging;
    return this;
  }

  DevCycleOptionsBuilder disableAutomaticEventLogging(
      bool disableAutomaticEventLogging) {
    _disableAutomaticEventLogging = disableAutomaticEventLogging;
    return this;
  }

  DevCycleOptionsBuilder enableEdgeDB(bool enableEdgeDB) {
    _enableEdgeDB = enableEdgeDB;
    return this;
  }

  DevCycleOptionsBuilder configCacheTTL(int configCacheTTL) {
    _configCacheTTL = configCacheTTL;
    return this;
  }

  DevCycleOptionsBuilder disableConfigCache(bool disableConfigCache) {
    _disableConfigCache = disableConfigCache;
    return this;
  }

  DevCycleOptionsBuilder disableRealtimeUpdates(bool disableRealtimeUpdates) {
    _disableRealtimeUpdates = disableRealtimeUpdates;
    return this;
  }

  DevCycleOptionsBuilder logLevel(LogLevel logLevel) {
    _logLevel = logLevel;
    return this;
  }

  DevCycleOptionsBuilder apiProxyUrl(String apiProxyUrl) {
    _apiProxyUrl = apiProxyUrl;
    return this;
  }

  DevCycleOptionsBuilder eventsApiProxyUrl(String eventsApiProxyUrl) {
    _eventsApiProxyUrl = eventsApiProxyUrl;
    return this;
  }

  /// Constructs a [DevCycleOptions] instance from the values currently in the builder.
  DevCycleOptions build() {
    return DevCycleOptions._builder(this);
  }
}

@Deprecated('Use DevCycleOptionsBuilder instead')
typedef DVCOptionsBuilder = DevCycleOptionsBuilder;
