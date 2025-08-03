import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_andomie/enums/data_type.dart';
import 'package:flutter_andomie/utils/hit_logger.dart';
import 'package:flutter_andomie/utils/settings.dart';

import '../../data/constants/paths.dart';
import '../../roots/helpers/connectivity.dart';
import '../../roots/preferences/preferences.dart';
import '../helpers/user.dart';

Future<SettingsBackupResponse> readBackupData() async {
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

Future<void> writeBackupData(SettingsWriteRequest request) async {
  final uid = UserHelper.uid;
  if (uid.isEmpty) return;
  final ref = FirebaseDatabase.instance.ref(Paths.settings).child(uid);
  return ref
      .update({request.path: request.value})
      .hitLogger("update", ref.path);
}

Future<void> cleanBackupData() async {
  final uid = UserHelper.uid;
  if (uid.isEmpty) return;
  final ref = FirebaseDatabase.instance.ref(Paths.settings).child(uid);
  await ref.remove().hitLogger("delete", ref.path);
}

Object? readCachedData(SettingsReadRequest request) {
  final key = request.path;
  switch (request.type) {
    case DataType.INT:
    case DataType.INT_OR_NULL:
      return Preferences.getIntOrNull(key);
    case DataType.DOUBLE:
    case DataType.DOUBLE_OR_NULL:
      return Preferences.getDoubleOrNull(key);
    case DataType.STRING:
    case DataType.STRING_OR_NULL:
      return Preferences.getStringOrNull(key);
    case DataType.BOOL:
    case DataType.BOOL_OR_NULL:
      return Preferences.getBoolOrNull(key);
    case DataType.JSON:
    case DataType.JSON_OR_NULL:
      final json = Preferences.getStringOrNull(key);
      if (json == null || json.isEmpty) return null;
      final parsed = jsonDecode(json);
      return parsed;
    case DataType.STRINGS:
    case DataType.STRINGS_OR_NULL:
      return Preferences.getStringsOrNull(key);
    case DataType.OBJECT:
    case DataType.OBJECT_OR_NULL:
    case DataType.INTS:
    case DataType.INTS_OR_NULL:
    case DataType.DOUBLES:
    case DataType.DOUBLES_OR_NULL:
    case DataType.BOOLS:
    case DataType.BOOLS_OR_NULL:
    case DataType.JSONS:
    case DataType.JSONS_OR_NULL:
    case DataType.OBJECTS:
    case DataType.OBJECTS_OR_NULL:
    case DataType.NULL:
    case DataType.OTHER:
      return null;
  }
}

bool writeCachedData(SettingsWriteRequest request) {
  final key = request.path;
  final value = request.value;
  switch (request.type) {
    case DataType.INT:
    case DataType.INT_OR_NULL:
      Preferences.setInt(key, value as int?);
      return true;
    case DataType.DOUBLE:
    case DataType.DOUBLE_OR_NULL:
      Preferences.setDouble(key, value as double?);
      return true;
    case DataType.STRING:
    case DataType.STRING_OR_NULL:
      Preferences.setString(key, value as String?);
      return true;
    case DataType.BOOL:
    case DataType.BOOL_OR_NULL:
      Preferences.setBool(key, value as bool?);
      return true;
    case DataType.JSON:
    case DataType.JSON_OR_NULL:
      final json = value != null ? jsonEncode(value) : null;
      Preferences.setString(key, json);
      return true;
    case DataType.STRINGS:
    case DataType.STRINGS_OR_NULL:
      Preferences.setStrings(
        key,
        value != null ? [...value as Iterable<String>] : null,
      );
      return true;
    case DataType.OBJECT:
    case DataType.OBJECT_OR_NULL:
    case DataType.INTS:
    case DataType.INTS_OR_NULL:
    case DataType.DOUBLES:
    case DataType.DOUBLES_OR_NULL:
    case DataType.BOOLS:
    case DataType.BOOLS_OR_NULL:
    case DataType.JSONS:
    case DataType.JSONS_OR_NULL:
    case DataType.OBJECTS:
    case DataType.OBJECTS_OR_NULL:
    case DataType.NULL:
    case DataType.OTHER:
      return false;
  }
}
