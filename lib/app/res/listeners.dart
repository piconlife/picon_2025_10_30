import 'dart:ui';

import 'package:flutter_andomie/utils/translation.dart';

import '../../roots/services/notification.dart';
import '../../roots/utils/speech.dart';

class InAppListeners {
  const InAppListeners._();

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
