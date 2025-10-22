import 'package:hive_flutter/hive_flutter.dart';

import 'model.dart';
import 'paths.dart';

abstract final class HivePreferences {
  static Box<HivePreferencesModel> get preferences {
    return Hive.box<HivePreferencesModel>(HivePaths.preferences);
  }

  static Box<List<bool>?> get booleans {
    return Hive.box<List<bool>?>(HivePaths.booleans);
  }

  static Box<List<double>?> get doubles {
    return Hive.box<List<double>?>(HivePaths.doubles);
  }

  static Box<List<int>?> get ints {
    return Hive.box<List<int>?>(HivePaths.ints);
  }

  static Box<List<String>?> get strings {
    return Hive.box<List<String>?>(HivePaths.strings);
  }

  static bool? getBool(String key) => preferences.get(key)?.anyBool;

  static List<bool>? getBooleans(String key) => booleans.get(key);

  static double? getDouble(String key) => preferences.get(key)?.anyDouble;

  static List<double>? getDoubles(String key) => doubles.get(key);

  static int? getInt(String key) => preferences.get(key)?.anyInt;

  static List<int>? getInts(String key) => ints.get(key);

  static String? getString(String key) => preferences.get(key)?.anyString;

  static List<String>? getStrings(String key) => strings.get(key);

  static bool _execute(void Function() executor) {
    try {
      executor();
      return true;
    } catch (_) {
      return false;
    }
  }

  static bool setBool(String key, bool? value) {
    return _execute(() {
      if (value == null) {
        preferences.delete(key);
        return;
      }
      preferences.put(key, HivePreferencesModel()..anyBool = value);
    });
  }

  static bool setBooleans(String key, List<bool>? value) {
    return _execute(() {
      if (value == null || value.isEmpty) {
        preferences.delete(key);
        return;
      }
      booleans.put(key, value);
    });
  }

  static bool setDouble(String key, double? value) {
    return _execute(() {
      if (value == null) {
        preferences.delete(key);
        return;
      }
      preferences.put(key, HivePreferencesModel()..anyDouble = value);
    });
  }

  static bool setDoubles(String key, List<double>? value) {
    return _execute(() {
      if (value == null || value.isEmpty) {
        preferences.delete(key);
        return;
      }
      doubles.put(key, value);
    });
  }

  static bool setInt(String key, int? value) {
    return _execute(() {
      if (value == null) {
        preferences.delete(key);
        return;
      }
      preferences.put(key, HivePreferencesModel()..anyInt = value);
    });
  }

  static bool setInts(String key, List<int>? value) {
    return _execute(() {
      if (value == null || value.isEmpty) {
        preferences.delete(key);
        return;
      }
      ints.put(key, value);
    });
  }

  static bool setString(String key, String? value) {
    return _execute(() {
      if (value == null || value.isEmpty) {
        preferences.delete(key);
        return;
      }
      preferences.put(key, HivePreferencesModel()..anyString = value);
    });
  }

  static bool setStrings(String key, List<String>? value) {
    return _execute(() {
      if (value == null || value.isEmpty) {
        preferences.delete(key);
        return;
      }
      strings.put(key, value);
    });
  }

  static bool remove(String key) {
    return _execute(() => preferences.delete(key));
  }

  static bool clear() => _execute(() => preferences.clear());
}
