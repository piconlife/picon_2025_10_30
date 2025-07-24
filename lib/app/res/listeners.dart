import 'dart:ui';

import 'package:flutter_andomie/utils/translation.dart';

import '../../data/services/manager.dart';
import '../../features/settings/views/pages/settings.dart';
import '../../features/settings/views/widgets/remainder.dart';
import '../../roots/services/notification.dart';
import '../../roots/utils/speech.dart';
import 'settings.dart';

class InAppListeners {
  const InAppListeners._();

  static void home() {}

  static Future<void> authorizationChanged(bool authorized) async {}

  static void connectivityChanged(bool connected) {}

  static void translationsLocaleChanged(Locale locale) async {
    await Speech.language(Translation.languageCode);
    await ExerciseManager.init();
    await InAppNotifications.init(
      onReady: () async {
        if (RemoteSettings.isHourlyNotifications) {
          await InAppNotifications.initHourlyNotifications(
            perHour: RemoteSettings.hourlyNotificationsTime,
            startHour: mHourlyNotificationStartTime,
            endHour: mHourlyNotificationEndTime,
          );
        }
        await InAppNotifications.initTimeOfDayNotifications(
          timeOfDays: mTimeOfDays,
        );
        await InAppNotifications.initWeeklyNotifications();
      },
    );
  }
}
