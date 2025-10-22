import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';

import '../hive/model.dart';
import '../hive/paths.dart';
import '../hive/preferences.dart';

class Preferences {
  const Preferences._();

  static Box<HivePreferencesModel> get preferences {
    return HivePreferences.preferences;
  }

  static Box<List<bool>> get booleans {
    return Hive.box<List<bool>>(HivePaths.booleans);
  }

  static Box<List<double>> get doubles {
    return Hive.box<List<double>>(HivePaths.doubles);
  }

  static Box<List<int>> get ints {
    return Hive.box<List<int>>(HivePaths.ints);
  }

  static Box<List<String>> get strings {
    return Hive.box<List<String>>(HivePaths.strings);
  }

  static bool isValid(String key) => getOrNull(key) != null;

  static bool isValidList(String key) => getsOrNull(key) != null;

  static bool isValidBool(String key) => getBoolOrNull(key) != null;

  static bool isValidBooleans(String key) => getBooleans(key).isNotEmpty;

  static bool isValidDouble(String key) => getDoubleOrNull(key) != null;

  static bool isValidDoubles(String key) => getDoubles(key).isNotEmpty;

  static bool isValidInt(String key) => getIntOrNull(key) != null;

  static bool isValidInts(String key) => getInts(key).isNotEmpty;

  static bool isValidString(String key) => getString(key).isNotEmpty;

  static bool isValidStrings(String key) => getStrings(key).isNotEmpty;

  static Map get(String key, {Map defaultValue = const {}}) {
    return getOrNull(key) ?? defaultValue;
  }

  static Map? getOrNull(String key) {
    try {
      final root = getStringOrNull(key);
      final data = jsonDecode(root ?? "{}");
      if (data is Map && data.isNotEmpty) {
        return data;
      } else {
        return null;
      }
    } catch (error) {
      return null;
    }
  }

  static List gets(String key, {List defaultValue = const []}) {
    return getsOrNull(key) ?? defaultValue;
  }

  static List? getsOrNull(String key) {
    try {
      final root = getStringOrNull(key);
      final data = jsonDecode(root ?? "[]");
      if (data is List && data.isNotEmpty) {
        return data;
      } else {
        return null;
      }
    } catch (error) {
      return null;
    }
  }

  static T getObject<T extends Object?>(
    String key,
    T Function(Map) parse, {
    Map defaultValue = const {},
  }) {
    return getObjectOrNull(key, parse) ?? parse(defaultValue);
  }

  static T? getObjectOrNull<T extends Object?>(
    String key,
    T? Function(Map) parse,
  ) {
    final data = getOrNull(key);
    if (data == null) return null;
    return parse(data);
  }

  static List<T> getObjects<T extends Object?>(
    String key,
    T? Function(Map) parse, {
    List<T> defaultValue = const [],
  }) {
    return getObjectsOrNull(key, parse) ?? defaultValue;
  }

  static List<T>? getObjectsOrNull<T extends Object?>(
    String key,
    T? Function(Map) parse,
  ) {
    try {
      final data = getsOrNull(key);
      if (data == null) return null;
      return data.whereType<Map>().map(parse).whereType<T>().toList();
    } catch (_) {
      return null;
    }
  }

  static bool getBool(String key, [bool defaultValue = false]) {
    return getBoolOrNull(key) ?? defaultValue;
  }

  static bool? getBoolOrNull(String key) => HivePreferences.getBool(key);

  static List<bool> getBooleans(
    String key, [
    List<bool> defaultValue = const [],
  ]) {
    return getBooleansOrNull(key) ?? defaultValue;
  }

  static List<bool>? getBooleansOrNull(String key) {
    return HivePreferences.getBooleans(key);
  }

  static double getDouble(String key, [double defaultValue = 0]) {
    return getDoubleOrNull(key) ?? defaultValue;
  }

  static double? getDoubleOrNull(String key) => HivePreferences.getDouble(key);

  static List<double> getDoubles(
    String key, [
    List<double> defaultValue = const [],
  ]) {
    return getDoublesOrNull(key) ?? defaultValue;
  }

  static List<double>? getDoublesOrNull(String key) {
    return HivePreferences.getDoubles(key);
  }

  static int getInt(String key, [int defaultValue = 0]) {
    return getIntOrNull(key) ?? defaultValue;
  }

  static int? getIntOrNull(String key) => HivePreferences.getInt(key);

  static List<int> getInts(String key, [List<int> defaultValue = const []]) {
    return getIntsOrNull(key) ?? defaultValue;
  }

  static List<int>? getIntsOrNull(String key) => HivePreferences.getInts(key);

  static String getString(String key, [String defaultValue = '']) {
    return getStringOrNull(key) ?? defaultValue;
  }

  static String? getStringOrNull(String key) => HivePreferences.getString(key);

  static List<String> getStrings(
    String key, [
    List<String> defaultValue = const [],
  ]) {
    return getStringsOrNull(key) ?? defaultValue;
  }

  static List<String>? getStringsOrNull(String key) {
    return HivePreferences.getStrings(key);
  }

  static bool set(String key, Map? object) {
    try {
      if (object == null) return remove(key);
      final root = jsonEncode(object);
      return setString(key, root);
    } catch (error) {
      return false;
    }
  }

  static bool sets(String key, Iterable<Map>? objects) {
    if (objects == null || objects.isEmpty) return remove(key);
    final root = jsonEncode(objects);
    return setString(key, root);
  }

  static bool setBool(String key, bool? value) {
    return HivePreferences.setBool(key, value);
  }

  static bool setBooleans(String key, Iterable<bool>? value) {
    if (value == null) return HivePreferences.remove(key);
    return HivePreferences.setBooleans(key, List.from(value));
  }

  static bool setDouble(String key, double? value) {
    return HivePreferences.setDouble(key, value);
  }

  static bool setDoubles(String key, Iterable<double>? value) {
    if (value == null) return HivePreferences.remove(key);
    return HivePreferences.setDoubles(key, List.from(value));
  }

  static bool setInt(String key, int? value) {
    return HivePreferences.setInt(key, value);
  }

  static bool setInts(String key, Iterable<int>? value) {
    if (value == null) return HivePreferences.remove(key);
    return HivePreferences.setInts(key, List.from(value));
  }

  static bool setString(String key, String? value) {
    return HivePreferences.setString(key, value);
  }

  static bool setStrings(String key, Iterable<String>? value) {
    if (value == null) return HivePreferences.remove(key);
    return HivePreferences.setStrings(key, List.from(value));
  }

  static bool remove(String key) => HivePreferences.remove(key);

  static bool removes(Iterable<String> keys) {
    bool removed = true;
    for (var key in keys) {
      if (!HivePreferences.remove(key)) removed = false;
    }
    return removed;
  }

  static bool clear() => HivePreferences.clear();
}
