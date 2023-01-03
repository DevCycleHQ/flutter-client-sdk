part of devcycle_flutter_client_sdk;

class DVCUser {
  final String? userId;
  final bool isAnonymous;
  final String? email;
  final String? name;
  final String? country;
  final Map<String, dynamic>? customData;
  final Map<String, dynamic>? privateCustomData;

  DVCUser._builder(DVCUserBuilder builder) :
    userId = builder._userId,
    isAnonymous = builder._isAnonymous,
    email = builder._email,
    name = builder._name,
    country = builder._country,
    customData = builder._customData,
    privateCustomData = builder._privateCustomData;

  Map<String, dynamic> _toMap() {
    final Map<String, dynamic> result = <String, dynamic>{};
    result['userId'] = userId;
    result['isAnonymous'] = isAnonymous;
    result['email'] = email;
    result['name'] = name;
    result['country'] = country;
    result['customData'] = customData;
    result['privateCustomData'] = privateCustomData;
    return result;
  }
}

/// A builder for constructing [DVCUser] objects.
class DVCUserBuilder {
  String? _userId;
  bool _isAnonymous = true;
  String? _email;
  String? _name;
  String? _country;
  Map<String, dynamic>? _customData;
  Map<String, dynamic>? _privateCustomData;

  /// Sets whether the user is anonymous.
  DVCUserBuilder userId(String userId) {
    this._userId = userId;
    return this;
  }

  /// Sets whether the user is anonymous.
  DVCUserBuilder isAnonymous(bool isAnonymous) {
    this._isAnonymous = isAnonymous;
    return this;
  }

  /// Sets the user's email attribute.
  DVCUserBuilder email(String email) {
    this._email = email;
    return this;
  }

  /// Sets the user's name attribute.
  DVCUserBuilder name(String name) {
    this._name = name;
    return this;
  }

  /// Sets the user's country.
  DVCUserBuilder country(String country) {
    this._country = country;
    return this;
  }

  DVCUserBuilder customData( Map<String, dynamic> customData) {
    this._customData = customData;
    return this;
  }

  DVCUserBuilder privateCustomData( Map<String, dynamic> privateCustomData) {
    this._privateCustomData = privateCustomData;
    return this;
  }

  /// Constructs a [DVCUser] instance from the values currently in the builder.
  DVCUser build() {
    return DVCUser._builder(this);
  }
}