import 'package:flutter/material.dart';
import 'package:flutter_androssy_dialogs/dialogs.dart';
import 'package:in_app_configs/configs.dart';
import 'package:in_app_database/in_app_database.dart';
import 'package:object_finder/object_finder.dart';

import '../../app/interfaces/bsd_audience.dart';
import '../../app/interfaces/bsd_privacy.dart';
import '../../app/interfaces/dialog_big_photo.dart';
import '../../data/enums/audience.dart';
import '../../data/enums/privacy.dart';
import '../../features/channel/view/dialogs/bsd_metube_format.dart';
import '../../features/shop/view/dialogs/bsd_market_format.dart';
import '../../features/shore/view/dialogs/bsd_grocery_format.dart';
import '../../features/social/view/dialogs/bsd_feed_format.dart';
import '../../features/startup/views/dialogs/auth_biometric_permission.dart';
import '../delegates/in_app_purchase_test.dart';

/// Default configuration constants
const kDailyNotificationsConfigPath = "daily_notifications";
const kWeeklyNotificationsConfigPath = "weekly_notifications";
const kThemesConfigPath = "themes";
const kSecretsConfigPath = "secrets";

/// Default configuration paths used in initialization
const _kDefaultConfigPaths = {
  kDailyNotificationsConfigPath,
  kWeeklyNotificationsConfigPath,
  kSecretsConfigPath,
  kThemesConfigPath,
};

abstract final class LocalConfigs {
  static int splashTime = 3000;
  static int splashTimeForNative = 0;

  static ThemeMode theme = ThemeMode.light;

  static bool authInitialCheck = true;
  static bool hitLogger = false;

  static List<String> assetsPreloads = ["assets/contents/application.json"];

  // SETTINGS
  static Map<String, dynamic>? settings;
  static bool settingsLogs = false;

  static String configName = "configs";
  static String configDefault = "application";
  static PlatformType configPlatform = PlatformType.system;
  static EnvironmentType configEnvironment = EnvironmentType.system;
  static Set<String> configPaths = {
    ..._kDefaultConfigPaths,
    "countries",
    "hobbies",
    'languages',
    'legals',
    'onboards',
    'professions',
    'religions',
    'reports',
    'secrets',
  };
  static Set<String> configSymmetricPaths = _kDefaultConfigPaths;
  static bool configLogs = false;
  static bool configLazyMode = false;

  // IN_APP_DATABASE
  static bool inAppDatabaseLogs = false;
  static String? inAppDatabaseName;
  static InAppDatabaseType? inAppDatabaseType;
  static InAppDatabaseVersion? inAppDatabaseVersion;

  // TOAST AND DIALOGS
  static Alignment toastDisplayAlignment = Alignment(0, 0.9);
  static Duration toastDisplayDuration = const Duration(seconds: 3);
  static ToastBuilder? toastBuilder;

  // TRANSLATION
  static bool translationShowLogs = false;
  static Locale translationFallback = Locale("en", "US");
  static Set<String> translationPaths = {
    "notification_channels",
    "hourly_notifications",
    "time_of_day_notifications",
    "weekly_notifications",
  };
  static Set<String> translationSymmetricPaths = {};

  static bool inAppPurchaseLogs = true;
  static bool inAppPurchaseThrowLogs = true;
  static final inAppPurchaseDelegate = TestInAppPurchaseDelegate();

  static Map<String, DialogConfigBuilder<DialogConfig>> dialogConfigs = {
    kBigPhotoDialogKey: (context) {
      return DialogConfig(
        builder: (context, content) {
          return InAppBigPhotoDialog(content.args);
        },
      );
    },
    kBiometricPermissionDialogKey: (context) {
      return DialogConfig(
        position: AndrossyDialogPosition.center,
        builder: (context, content) {
          return const InAppBiometricPermissionDialog();
        },
      );
    },
    kFeedFormatBSD: (context) {
      return DialogConfig(
        position: AndrossyDialogPosition.bottom,
        builder: (context, content) {
          return const InAppFeedFormatBSD();
        },
      );
    },
    kGroceryFormatBSD: (context) {
      return DialogConfig(
        position: AndrossyDialogPosition.bottom,
        builder: (context, content) {
          return const GroceryFormatBSD();
        },
      );
    },
    kMarketFormatBSD: (context) {
      return DialogConfig(
        position: AndrossyDialogPosition.bottom,
        builder: (context, content) {
          return const MarketFormatBSD();
        },
      );
    },
    kMetubeFormatBSD: (context) {
      return DialogConfig(
        position: AndrossyDialogPosition.bottom,
        builder: (context, content) {
          return const MetubeFormatBSD();
        },
      );
    },
    kAudienceBSD: (context) {
      return DialogConfig(
        position: AndrossyDialogPosition.bottom,
        builder: (context, content) {
          return AudienceBSD(
            audience: content.args.find(defaultValue: Audience.everyone),
          );
        },
      );
    },
    kPrivacyBSD: (context) {
      return DialogConfig(
        position: AndrossyDialogPosition.bottom,
        builder: (context, content) {
          return PrivacyBSD(
            privacy: content.args.find(defaultValue: Privacy.everyone),
          );
        },
      );
    },
  };
}
