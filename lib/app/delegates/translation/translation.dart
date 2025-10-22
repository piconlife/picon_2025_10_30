import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:in_app_settings/settings.dart';
import 'package:in_app_translation/core.dart';

import '../../../roots/preferences/preferences.dart';
import '../../dialogs/bsd_locale.dart';
import '../../res/listeners.dart';
import '../../settings/remote.dart';

class InAppTranslationDelegate extends TranslationDelegate {
  @override
  Future<Object?> get defaultLocale async {
    return RemoteSettings.translationSavedLocale;
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
  Future<void> ready(String name, String path) async {
    Translation.i.separator = "/";
    InAppListeners.translationsLocaleChanged(Translation.i.locale);
  }

  @override
  Future<void> changes(String name, String path) async {}

  @override
  Future<void> changed(Locale locale) async {
    Settings.set(kTranslationSavedLocale, locale.toString());
    InAppListeners.translationsLocaleChanged(locale);
  }

  @override
  Future<Locale?> select(BuildContext context, String? reason) {
    return LocaleBsd.show(context);
  }
}
