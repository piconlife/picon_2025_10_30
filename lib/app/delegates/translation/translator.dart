import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_andomie/utils/internet.dart';
import 'package:flutter_andomie/utils/translation.dart';
import 'package:flutter_andomie/utils/translator.dart';
import 'package:translator/translator.dart' hide Translation;

import '../../../roots/preferences/preferences.dart';

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
  void translated(TranslationCache value) {
    Preferences.setString(kTranslatorCache, jsonEncode(value));
  }

  @override
  void save(String value) => Preferences.setString(kTranslatorCache, value);
}
