import 'package:flutter/material.dart';
import 'package:flutter_andomie/utils/internet.dart';
import 'package:in_app_translation/extensions.dart';
import 'package:in_app_translator/delegate.dart';
import 'package:translator/translator.dart' hide Translation;

import '../../roots/preferences/preferences.dart';

const kTranslatorCache = "__translator_cache__";

class InAppTranslatorDelegate extends TranslatorDelegate {
  @override
  Future<String?> cache() async {
    return Preferences.getStringOrNull(kTranslatorCache);
  }

  @override
  Future<String> translate(String source, Locale locale) async {
    try {
      if (!Internet.isConnected) return source;
      final x = await source.translate(
        to: locale.formatedLanguageCode.toLowerCase(),
      );
      return x.text;
    } catch (_) {
      return source;
    }
  }

  @override
  void save(String source) => Preferences.setString(kTranslatorCache, source);
}
