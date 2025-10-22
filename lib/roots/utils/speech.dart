import 'dart:developer';

import 'package:flutter_tts/flutter_tts.dart';
import 'package:in_app_configs/configs.dart';
import 'package:in_app_settings/settings.dart';

const kSpeechOn = "speech_mode";

bool get isSpeechOn {
  return Settings.get(kSpeechOn, Configs.get(kSpeechOn, defaultValue: true));
}

class Speech {
  Speech._();

  static Speech? _i;

  static Speech get i => _i ??= Speech._();

  final FlutterTts _tts = FlutterTts();

  static Future<void> init() async {
    await i._tts.setSpeechRate(0.5);
    await i._tts.setPitch(1.0);
    await i._tts.setVolume(1.0);
  }

  static Future<void> stop() async {
    await i._tts.stop();
  }

  static Future<void> volume(double value) async {
    await i._tts.setVolume(value);
  }

  static Future<void> language(String language) async {
    await i._tts.setLanguage(language);
  }

  static Future<void> speak(String input) async {
    if (!isSpeechOn || input.isEmpty) return;
    try {
      i._tts.stop();
      await i._tts.speak(input);
    } catch (msg) {
      log("SPEECH: $msg");
    }
  }
}
