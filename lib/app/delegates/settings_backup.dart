import 'package:data_type_detector/detector.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_andomie/utils/hit_logger.dart';
import 'package:in_app_settings/delegate.dart';

import '../../data/constants/paths.dart';
import '../../roots/helpers/connectivity.dart';
import '../../roots/preferences/preferences.dart';
import '../helpers/user.dart';

class InAppSettingsDelegate extends SettingsDelegate {
  @override
  bool backup(SettingsWriteRequest request) {
    final key = request.path;
    final value = request.value;
    switch (request.type) {
      case DataType.NULL:
        return Preferences.remove(key);
      case DataType.BOOL:
        return Preferences.setBool(key, value as bool);
      case DataType.DOUBLE:
        return Preferences.setDouble(key, value as double);
      case DataType.INT:
        return Preferences.setInt(key, value as int);
      case DataType.STRING:
        return Preferences.setString(key, value as String);
      case DataType.BOOLS:
        return Preferences.setBooleans(key, value as Iterable<bool>);
      case DataType.DOUBLES:
        return Preferences.setDoubles(key, value as Iterable<double>);
      case DataType.INTS:
        return Preferences.setInts(key, value as Iterable<int>);
      case DataType.STRINGS:
        return Preferences.setStrings(key, value as Iterable<String>);
      case DataType.JSON:
      case DataType.MAP:
      case DataType.OBJECT:
        return Preferences.set(key, value as Map);
      case DataType.JSONS:
      case DataType.MAPS:
      case DataType.OBJECTS:
        return Preferences.sets(key, value as Iterable<Map>);
    }
  }

  @override
  Object? cache(SettingsReadRequest request) {
    final key = request.path;
    switch (request.type) {
      case DataType.NULL:
        return null;
      case DataType.BOOL:
        return Preferences.getBoolOrNull(key);
      case DataType.DOUBLE:
        return Preferences.getDoubleOrNull(key);
      case DataType.INT:
        return Preferences.getIntOrNull(key);
      case DataType.STRING:
        return Preferences.getStringOrNull(key);
      case DataType.BOOLS:
        return Preferences.getBooleansOrNull(key);
      case DataType.DOUBLES:
        return Preferences.getDoublesOrNull(key);
      case DataType.INTS:
        return Preferences.getIntsOrNull(key);
      case DataType.STRINGS:
        return Preferences.getStringsOrNull(key);
      case DataType.JSON:
      case DataType.MAP:
      case DataType.OBJECT:
        return Preferences.getOrNull(key);
      case DataType.JSONS:
      case DataType.MAPS:
      case DataType.OBJECTS:
        return Preferences.getsOrNull(key);
    }
  }

  @override
  Future<void> clean(Iterable<String> keys) async {
    Preferences.removes(keys);
    final uid = UserHelper.uid;
    if (uid.isEmpty) return;
    final ref = FirebaseDatabase.instance.ref(Paths.settings).child(uid);
    await ref.remove().hitLogger("delete", ref.path);
  }

  @override
  Future<SettingsBackupResponse> get() async {
    final uid = UserHelper.uid;
    if (uid.isEmpty) {
      return const SettingsBackupResponse.failure("User invalid!");
    }
    final connection = await ConnectivityHelper.isConnected;
    if (!connection) {
      return const SettingsBackupResponse.failure("Connection not available!");
    }
    final ref = FirebaseDatabase.instance.ref(Paths.settings).child(uid);
    return ref.get().hitLogger("get", ref.path).then((value) {
      if (!value.exists) {
        return const SettingsBackupResponse.failure("Data not existed!");
      }
      final data = value.value;
      if (data is! Map) {
        return const SettingsBackupResponse.failure("Data not found!");
      }
      return SettingsBackupResponse.ok(
        data.map((k, v) {
          return MapEntry(k.toString(), v);
        }),
      );
    });
  }

  @override
  Future<void> set(SettingsWriteRequest request) async {
    final uid = UserHelper.uid;
    if (uid.isEmpty) return;
    final ref = FirebaseDatabase.instance.ref(Paths.settings).child(uid);
    return ref
        .update({request.path: request.value})
        .hitLogger("update", ref.path);
  }
}
