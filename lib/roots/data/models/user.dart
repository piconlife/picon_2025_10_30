import 'dart:convert';

import 'package:auth_management/auth_management.dart';

import '../keys/user.dart';

class User extends Auth<UserKeys> {
  User({
    super.id = "",
    super.timeMills,
    super.accessToken,
    super.biometric,
    super.email,
    super.extra,
    super.idToken,
    super.loggedIn,
    super.loggedInTime,
    super.loggedOutTime,
    super.name,
    super.password,
    super.phone,
    super.photo,
    super.provider,
    super.username,
    super.verified,
  });

  @override
  User copy({
    String? id,
    int? timeMills,
    String? accessToken,
    BiometricStatus? biometric,
    String? email,
    Map<String, dynamic>? extra,
    String? idToken,
    bool? loggedIn,
    int? loggedInTime,
    int? loggedOutTime,
    String? name,
    String? password,
    String? phone,
    String? photo,
    Provider? provider,
    String? username,
    bool? verified,
  }) {
    return User(
      id: id ?? this.id,
      timeMills: timeMills ?? this.timeMills,
      accessToken: accessToken ?? this.accessToken,
      biometric: biometric ?? this.biometric,
      email: email ?? this.email,
      extra: extra ?? this.extra,
      idToken: idToken ?? this.idToken,
      loggedIn: loggedIn ?? this.loggedIn,
      loggedInTime: loggedInTime ?? this.loggedInTime,
      loggedOutTime: loggedOutTime ?? this.loggedOutTime,
      name: name ?? this.name,
      password: password ?? this.password,
      phone: phone ?? this.phone,
      photo: photo ?? this.photo,
      provider: provider ?? this.provider,
      username: username ?? this.username,
      verified: verified ?? this.verified,
    );
  }

  factory User.from(Object? source) {
    final auth = Auth.from(source);
    return User(
      id: auth.id,
      timeMills: auth.timeMills,
      accessToken: auth.accessToken,
      biometric: auth.biometric,
      loggedIn: auth.loggedIn,
      loggedInTime: auth.loggedInTime,
      loggedOutTime: auth.loggedOutTime,
      idToken: auth.idToken,
      email: auth.email,
      name: auth.name,
      password: auth.password,
      phone: auth.phone,
      photo: auth.photo,
      provider: auth.provider,
      username: auth.username,
      verified: auth.verified,
      extra: auth.extra,
    );
  }

  @override
  UserKeys makeKey() => UserKeys.i;

  @override
  bool isInsertable(String key, value) {
    super.isInsertable(key, value);
    return this.key.keys.contains(key) && value != null;
  }

  @override
  Map<String, dynamic> get source {
    return {...super.source};
  }

  @override
  String get json => jsonEncode(source);

  @override
  int get hashCode => json.hashCode;

  @override
  bool operator ==(Object other) {
    return other is User && other.id == id && other.json == json;
  }

  @override
  String toString() => "$User#$hashCode($json)";
}
