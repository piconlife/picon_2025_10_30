import 'package:object_finder/object_finder.dart';

import '../../../roots/preferences/preferences.dart';

const _key = "__globals__";

class GlobalKeys {
  const GlobalKeys._();

  static const currencyCode = "currencyCode";
  static const currencyName = "currencyName";
  static const currencySymbol = "currencySymbol";
  static const countryIsoCode = "countryIsoCode";
  static const countryIso3Code = "countryIso3Code";
  static const countryLanguageCode = "countryLanguageCode";
  static const countryLocale = "countryLocale";
  static const countryLanguageName = "countryLanguageName";
  static const countryName = "countryName";
  static const countryPhoneCode = "countryPhoneCode";

  static const latitude = "latitude";
  static const longitude = "longitude";
}

class Global {
  final String? currencyCode;
  final String? currencyName;
  final String? currencySymbol;
  final String? countryIsoCode;
  final String? countryIso3Code;
  final String? countryLanguageCode;
  final String? countryLocale;
  final String? countryLanguageName;
  final String? countryName;
  final String? countryPhoneCode;

  final double? latitude;
  final double? longitude;

  const Global({
    this.currencyCode,
    this.currencyName,
    this.currencySymbol,
    this.countryIsoCode,
    this.countryIso3Code,
    this.countryLanguageCode,
    this.countryLanguageName,
    this.countryLocale,
    this.countryName,
    this.countryPhoneCode,
    this.latitude,
    this.longitude,
  });

  factory Global.from(Object? source) {
    return Global(
      currencyCode: source.findOrNull(key: GlobalKeys.currencyCode),
      currencyName: source.findOrNull(key: GlobalKeys.currencyName),
      currencySymbol: source.findOrNull(key: GlobalKeys.currencySymbol),
      countryIsoCode: source.findOrNull(key: GlobalKeys.countryIsoCode),
      countryIso3Code: source.findOrNull(key: GlobalKeys.countryIso3Code),
      countryLanguageCode: source.findOrNull(
        key: GlobalKeys.countryLanguageCode,
      ),
      countryLanguageName: source.findOrNull(
        key: GlobalKeys.countryLanguageName,
      ),
      countryLocale: source.findOrNull(key: GlobalKeys.countryLocale),
      countryName: source.findOrNull(key: GlobalKeys.countryName),
      countryPhoneCode: source.findOrNull(key: GlobalKeys.countryPhoneCode),
      latitude: source.findOrNull(key: GlobalKeys.latitude),
      longitude: source.findOrNull(key: GlobalKeys.longitude),
    );
  }

  Map<String, dynamic> get source {
    return {
      if (currencyCode != null) GlobalKeys.currencyCode: currencyCode,
      if (currencyName != null) GlobalKeys.currencyName: currencyName,
      if (currencySymbol != null) GlobalKeys.currencySymbol: currencySymbol,
      if (countryIsoCode != null) GlobalKeys.countryIsoCode: countryIsoCode,
      if (countryIso3Code != null) GlobalKeys.countryIso3Code: countryIso3Code,
      if (countryLanguageCode != null)
        GlobalKeys.countryLanguageCode: countryLanguageCode,
      if (countryLanguageName != null)
        GlobalKeys.countryLanguageName: countryLanguageName,
      if (countryLocale != null) GlobalKeys.countryLocale: countryLocale,
      if (countryName != null) GlobalKeys.countryName: countryName,
      if (countryPhoneCode != null)
        GlobalKeys.countryPhoneCode: countryPhoneCode,
      if (latitude != null) GlobalKeys.latitude: latitude,
      if (longitude != null) GlobalKeys.longitude: longitude,
    };
  }

  static Global get i => Global.from(Preferences.getOrNull(_key));

  static bool put(Map<String, dynamic> data) {
    final current = i.source;
    current.addAll(data);
    return Preferences.set(_key, current);
  }

  static void clear() => Preferences.remove(_key);
}
