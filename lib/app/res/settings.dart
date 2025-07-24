import 'package:flutter/material.dart';
import 'package:flutter_andomie/utils/settings.dart';

import '../../roots/helpers/user.dart';
import '../../roots/services/zotlo_subscription.dart';

const kHourlyNotificationsEnabled = "hourly_notifications_enabled";
const kHourlyNotificationsTime = "hourly_notifications_time";
const kTranslationSavedLocale = "translation_saved_locale";
const kZotloExpireDate = "zotlo_expire_date";

class RemoteSettings {
  const RemoteSettings._();

  static bool get authorized => UserHelper.isActiveUser;

  static bool get premium => ZotloService.i.isPremium;

  static bool get isHourlyNotifications {
    return Settings.get(kHourlyNotificationsEnabled, false);
  }

  static int get hourlyNotificationsTime {
    return Settings.get(kHourlyNotificationsTime, 1);
  }

  static Object? get translationSavedLocale {
    final savedLocale = Settings.get(kTranslationSavedLocale, '');
    Object? locale = savedLocale.isEmpty ? null : savedLocale;
    locale ??= WidgetsBinding.instance.platformDispatcher.locales.firstOrNull;
    return locale;
  }

  static String? get zotloExpireDate {
    return Settings.get(kZotloExpireDate, null);
  }
}
