import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';

import '../hive/model.dart';
import '../hive/paths.dart';
import '../hive/preferences.dart';

typedef PreferencesObject = Map;
typedef PreferencesObjectBuilder<T> = T Function(PreferencesObject source);

class Preferences {
  const Preferences._();

  static Box<HivePreferencesModel> get preferences {
    return HivePreferences.preferences;
  }

  static Box<List<String>> get strings {
    return Hive.box<List<String>>(HivePaths.strings);
  }

  static bool? getBoolOrNull(String key) => HivePreferences.getBool(key);

  static bool getBool(String key, [bool defaultValue = false]) {
    return getBoolOrNull(key) ?? defaultValue;
  }

  static bool setBool(String key, bool? value) {
    return HivePreferences.setBool(key, value);
  }

  static double? getDoubleOrNull(String key) => HivePreferences.getDouble(key);

  static double getDouble(String key, [double defaultValue = 0]) {
    return getDoubleOrNull(key) ?? defaultValue;
  }

  static bool setDouble(String key, double? value) {
    return HivePreferences.setDouble(key, value);
  }

  static int? getIntOrNull(String key) => HivePreferences.getInt(key);

  static int getInt(String key, [int defaultValue = 0]) {
    return getIntOrNull(key) ?? defaultValue;
  }

  static List<int>? getIntsOrNull(String key) => HivePreferences.getInts(key);

  static List<int> getInts(String key, [List<int> defaultValue = const []]) {
    return getIntsOrNull(key) ?? defaultValue;
  }

  static bool setInt(String key, int? value) {
    return HivePreferences.setInt(key, value);
  }

  static bool setInts(String key, Iterable<int>? value) {
    return HivePreferences.setInts(
      key,
      value != null ? List.from(value) : null,
    );
  }

  static bool setString(String key, String? value) {
    return HivePreferences.setString(key, value);
  }

  static String getString(String key, [String defaultValue = '']) {
    return getStringOrNull(key) ?? defaultValue;
  }

  static String? getStringOrNull(String key) => HivePreferences.getString(key);

  static bool setStrings(String key, Iterable<String>? value) {
    return HivePreferences.setStrings(
      key,
      value != null ? List.from(value) : null,
    );
  }

  static List<String> getStrings(
    String key, [
    List<String> defaultValue = const [],
  ]) {
    return getStringsOrNull(key) ?? defaultValue;
  }

  static List<String>? getStringsOrNull(String key) {
    return HivePreferences.getStrings(key);
  }

  static PreferencesObject get(
    String key, [
    PreferencesObject defaultValue = const {},
  ]) {
    return getOrNull(key) ?? defaultValue;
  }

  static PreferencesObject? getOrNull(String key) {
    try {
      final root = getStringOrNull(key);
      final data = jsonDecode(root ?? "{}");
      if (data is PreferencesObject && data.isNotEmpty) {
        return data;
      } else {
        return null;
      }
    } catch (error) {
      return null;
    }
  }

  static bool set(String key, PreferencesObject? object) {
    try {
      if (object == null) return remove(key);
      final root = jsonEncode(object);
      return setString(key, root);
    } catch (error) {
      return false;
    }
  }

  static bool sets(String key, List<PreferencesObject>? objects) {
    if (objects == null || objects.isEmpty) return remove(key);
    final root = jsonEncode(objects);
    return setString(key, root);
  }

  static List<T> gets<T extends Object?>(
    String key,
    T? Function(Object?) parse, {
    List<T> defaultValue = const [],
  }) {
    return getsOrNull(key, parse) ?? defaultValue;
  }

  static List<T>? getsOrNull<T extends Object?>(
    String key,
    T? Function(Object?) parse,
  ) {
    try {
      final root = getStringOrNull(key);
      final data = jsonDecode(root ?? "[]");
      if (data is List && data.isNotEmpty) {
        final parsed = data.map(parse).whereType<T>().toList();
        if (parsed.isEmpty) return null;
        return parsed;
      } else {
        return null;
      }
    } catch (error) {
      return null;
    }
  }

  static T getObject<T>(String key, PreferencesObjectBuilder<T> builder) {
    return builder(get(key));
  }

  static T? getObjectOrNull<T>(
    String key,
    PreferencesObjectBuilder<T> builder,
  ) {
    try {
      final root = getOrNull(key);
      if (root != null) {
        return builder(root);
      } else {
        return null;
      }
    } catch (error) {
      return null;
    }
  }

  static bool isValidInt(String key) => getIntOrNull(key) != null;

  static bool isValidString(String key) {
    final x = getStringOrNull(key);
    return x != null && x.isNotEmpty;
  }

  static bool isValidInts(String key) => getInts(key).isNotEmpty;

  static bool isValidStrings(String key) => getStrings(key).isNotEmpty;

  static bool remove(String key) => HivePreferences.remove(key);

  static bool clear() => HivePreferences.reset();
}
