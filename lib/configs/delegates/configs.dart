import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_andomie/utils/configs.dart';

import '../../roots/preferences/preferences.dart';

class InAppConfigDelegate extends ConfigsDelegate {
  @override
  Future<String> asset(String name, String path) async {
    // TODO: implement asset
    final a = await super.asset(name, path);
    return a;
  }

  @override
  Future<Map?> cache(String name, String path) async {
    path = "$name/$path";
    Map? data = Preferences.getOrNull(path);
    return data;
  }

  @override
  Future<bool> save(String name, String path, Map? data) async {
    path = "$name/$path";
    return Preferences.set(path, data);
  }

  @override
  Future<Map?> fetch(String name, String path) {
    path = "$name/$path";
    return FirebaseDatabase.instance.ref().child(path).get().then((value) {
      if (!value.exists) return null;
      final data = value.value;
      if (data is! Map) return null;
      return data;
    });
  }

  @override
  Stream<Map?> listen(String name, String path) {
    path = "$name/$path";
    return FirebaseDatabase.instance.ref().child(path).onValue.map((value) {
      if (!value.snapshot.exists) return null;
      final data = value.snapshot.value;
      if (data is! Map) return null;
      return data;
    });
  }

  @override
  Future<void> ready(String name, String path) async {}

  @override
  Future<void> changes(String name, String path) async {}
}
