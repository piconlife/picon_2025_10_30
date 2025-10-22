import 'package:flutter/material.dart';
import 'package:in_app_settings/in_app_settings.dart';

import '../../roots/services/zotlo_subscription.dart';
import '../helpers/user.dart';

const kHourlyNotificationsEnabled = "hourly_notifications_enabled";
const kHourlyNotificationsTime = "hourly_notifications_time";
const kTranslationSavedLocale = "translation_saved_locale";
const kZotloExpireDate = "zotlo_expire_date";

class RemoteSettings {
  const RemoteSettings._();

  static bool get authorized => UserHelper.user.isLoggedIn;

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
