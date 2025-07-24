import 'package:flutter_andomie/utils/settings.dart';

import '../../roots/helpers/user.dart';
import '../../roots/services/zotlo_subscription.dart';

const kHourlyNotificationsEnabled = "hourly_notifications_enabled";
const kHourlyNotificationsTime = "hourly_notifications_time";

class InAppSettings {
  const InAppSettings._();

  static bool get authorized => UserHelper.isActiveUser;

  static bool get premium => ZotloService.i.isPremium;

  static bool get isHourlyNotifications {
    return Settings.get(kHourlyNotificationsEnabled, false);
  }

  static int get hourlyNotificationsTime {
    return Settings.get(kHourlyNotificationsTime, 1);
  }
}
