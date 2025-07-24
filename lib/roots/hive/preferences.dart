import 'package:hive_flutter/hive_flutter.dart';

import 'model.dart';
import 'paths.dart';

class HivePreferences {
  const HivePreferences._();

  static Box<HivePreferencesModel> get preferences {
    return Hive.box<HivePreferencesModel>(HivePaths.preferences);
  }

  static Box<List<String>?> get strings {
    return Hive.box<List<String>?>(HivePaths.strings);
  }

  static Box<List<int>?> get ints {
    return Hive.box<List<int>?>(HivePaths.ints);
  }

  static bool _execute(void Function() executor) {
    try {
      executor();
      return true;
    } catch (_) {
      return false;
    }
  }

  static bool? getBool(String key) => preferences.get(key)?.anyBool;

  static bool setBool(String key, bool? value) {
    return _execute(() {
      if (value == null) {
        preferences.delete(key);
        return;
      }
      preferences.put(key, HivePreferencesModel()..anyBool = value);
    });
  }

  static double? getDouble(String key) => preferences.get(key)?.anyDouble;

  static bool setDouble(String key, double? value) {
    return _execute(() {
      if (value == null) {
        preferences.delete(key);
        return;
      }
      preferences.put(key, HivePreferencesModel()..anyDouble = value);
    });
  }

  static int? getInt(String key) => preferences.get(key)?.anyInt;

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

  static List<int>? getInts(String key) => ints.get(key);

  static String? getString(String key) => preferences.get(key)?.anyString;

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

  static List<String>? getStrings(String key) => strings.get(key);

  static bool remove(String key) {
    return _execute(() => preferences.delete(key));
  }

  static bool reset() => _execute(() => preferences.clear());
}
