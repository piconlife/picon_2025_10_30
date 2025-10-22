import 'package:object_finder/object_finder.dart';

import '../../../roots/preferences/preferences.dart';

const _key = "__startup_info__";

class StartupKeys {
  const StartupKeys._();

  static const fullname = "fullname";
  static const shortname = "shortname";
  static const birthday = "birthday";
  static const gender = "gender";
  static const email = "email";
  static const isoCode = "isoCode";
  static const languageCode = "languageCode";
  static const phone = "phone";
  static const password = "password";
  static const latitude = "latitude";
  static const longitude = "longitude";
  static const idToken = "idToken";
  static const provider = "provider";
}

class Startup {
  final String? fullname;
  final String? shortname;
  final int? birthday;
  final int? gender;
  final String? email;
  final String? isoCode;
  final String? languageCode;
  final double? latitude;
  final double? longitude;
  final String? phone;
  final String? password;
  final String? idToken;
  final String? provider;

  const Startup({
    this.fullname,
    this.shortname,
    this.birthday,
    this.gender,
    this.email,
    this.isoCode,
    this.languageCode,
    this.latitude,
    this.longitude,
    this.phone,
    this.password,
    this.idToken,
    this.provider,
  });

  factory Startup.from(Object? source) {
    return Startup(
      fullname: source.findOrNull(key: StartupKeys.fullname),
      shortname: source.findOrNull(key: StartupKeys.shortname),
      birthday: source.findOrNull(key: StartupKeys.birthday),
      gender: source.findOrNull(key: StartupKeys.gender),
      email: source.findOrNull(key: StartupKeys.email),
      isoCode: source.findOrNull(key: StartupKeys.isoCode),
      languageCode: source.findOrNull(key: StartupKeys.languageCode),
      latitude: source.findOrNull(key: StartupKeys.latitude),
      longitude: source.findOrNull(key: StartupKeys.longitude),
      phone: source.findOrNull(key: StartupKeys.phone),
      password: source.findOrNull(key: StartupKeys.password),
      idToken: source.findOrNull(key: StartupKeys.idToken),
      provider: source.findOrNull(key: StartupKeys.provider),
    );
  }

  Map<String, dynamic> get source {
    return {
      if (fullname != null) StartupKeys.fullname: fullname,
      if (shortname != null) StartupKeys.shortname: shortname,
      if (birthday != null) StartupKeys.birthday: birthday,
      if (gender != null) StartupKeys.gender: gender,
      if (email != null) StartupKeys.email: email,
      if (isoCode != null) StartupKeys.isoCode: isoCode,
      if (languageCode != null) StartupKeys.languageCode: languageCode,
      if (latitude != null) StartupKeys.latitude: latitude,
      if (longitude != null) StartupKeys.longitude: longitude,
      if (phone != null) StartupKeys.phone: phone,
      if (password != null) StartupKeys.password: password,
      if (idToken != null) StartupKeys.idToken: idToken,
      if (provider != null) StartupKeys.provider: provider,
    };
  }

  static Startup get i => Startup.from(Preferences.getOrNull(_key));

  static bool put(String key, dynamic value) => puts({key: value});

  static bool puts(Map<String, dynamic> data) {
    final current = i.source;
    current.addAll(data);
    return Preferences.set(_key, current);
  }

  static void clear() => Preferences.remove(_key);
}
