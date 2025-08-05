import 'dart:async';

import 'package:flutter_andomie/utils/cache_manager.dart';
import 'package:translator/translator.dart';

class TranslateProvider {
  TranslateProvider._();

  static Future<String> callback(String text, String to) async {
    if (text.isEmpty) return text;
    try {
      return GoogleTranslator().translate(text, to: to).then((value) {
        return value.text;
      });
    } catch (e) {
      return text;
    }
  }

  static Future<String> translate(String text, {String to = 'en'}) async {
    return CacheManager.cache(text, callback: () => callback(text, to));
  }

  static Future<List<String>> translates(
    List<String> texts, {
    String to = 'en',
  }) async {
    return Future.wait(texts.map((e) => translate(e, to: to)));
  }
}
