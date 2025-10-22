import 'dart:ui';

import 'package:in_app_purchaser/in_app_purchaser.dart';
import 'package:in_app_translation/core.dart';

import '../../roots/services/notification.dart';
import '../../roots/utils/speech.dart';

abstract final class InAppListeners {
  static Future<void> purchased(InAppPurchaseResultSuccess result) async {}

  static void home() {}

  static Future<void> authorizationChanged(bool authorized) async {}

  static void connectivityChanged(bool connected) {}

  static void translationsLocaleChanged(Locale locale) async {
    await Speech.language(Translation.languageCode);
    await InAppNotifications.init(
      onReady: () async {
        await InAppNotifications.initWeeklyNotifications();
      },
    );
  }
}
