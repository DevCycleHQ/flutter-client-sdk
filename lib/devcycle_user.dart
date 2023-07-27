class DevCycleUser {
  final String? userId;
  final bool? isAnonymous;
  final String? email;
  final String? name;
  final String? country;
  final Map<String, dynamic>? customData;
  final Map<String, dynamic>? privateCustomData;

  DevCycleUser._builder(DevCycleUserBuilder builder)
      : userId = builder._userId,
        isAnonymous = builder._isAnonymous,
        email = builder._email,
        name = builder._name,
        country = builder._country,
        customData = builder._customData,
        privateCustomData = builder._privateCustomData;

  Map<String, dynamic> toCodec() {
    final Map<String, dynamic> result = {};
    if (userId != null) result['userId'] = userId;
    if (isAnonymous != null) result['isAnonymous'] = isAnonymous;
    if (email != null) result['email'] = email;
    if (name != null) result['name'] = name;
    if (country != null) result['country'] = country;
    if (customData != null) result['customData'] = customData;
    if (privateCustomData != null) {
      result['privateCustomData'] = privateCustomData;
    }
    return result;
  }

  @override
  String toString() {
    return 'DVCUser{userId: $userId, isAnonymous: $isAnonymous, email: $email, name: $name, country: $country, customData: $customData, privateCustomData: $privateCustomData}';
  }
}

@Deprecated('Use DevCycleUser instead')
typedef DVCUser = DevCycleUser;

/// A builder for constructing [DevCycleUser] objects.
class DevCycleUserBuilder {
  String? _userId;
  bool? _isAnonymous;
  String? _email;
  String? _name;
  String? _country;
  Map<String, dynamic>? _customData;
  Map<String, dynamic>? _privateCustomData;

  /// Sets whether the user is anonymous.
  DevCycleUserBuilder userId(String userId) {
    _userId = userId;
    return this;
  }

  /// Sets whether the user is anonymous.
  DevCycleUserBuilder isAnonymous(bool isAnonymous) {
    _isAnonymous = isAnonymous;
    return this;
  }

  /// Sets the user's email attribute.
  DevCycleUserBuilder email(String email) {
    _email = email;
    return this;
  }

  /// Sets the user's name attribute.
  DevCycleUserBuilder name(String name) {
    _name = name;
    return this;
  }

  /// Sets the user's country.
  DevCycleUserBuilder country(String country) {
    _country = country;
    return this;
  }

  DevCycleUserBuilder customData(Map<String, dynamic> customData) {
    _customData = customData;
    return this;
  }

  DevCycleUserBuilder privateCustomData(Map<String, dynamic> privateCustomData) {
    _privateCustomData = privateCustomData;
    return this;
  }

  /// Constructs a [DevCycleUser] instance from the values currently in the builder.
  DevCycleUser build() {
    return DevCycleUser._builder(this);
  }
}

@Deprecated('Use DevCycleUserBuilder instead')
typedef DVCUserBuilder = DevCycleUserBuilder;
