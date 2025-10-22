import 'package:flutter/material.dart';
import 'package:flutter_androssy_dialogs/dialogs.dart';
import 'package:in_app_configs/configs.dart';
import 'package:in_app_database/in_app_database.dart';

import '../../features/chooser/data/models/country.dart';
import '../../features/chooser/data/models/hobby.dart';
import '../../features/chooser/data/models/language.dart';
import '../../features/chooser/data/models/profession.dart';
import '../../features/chooser/data/models/religion.dart';
import '../../features/chooser/data/models/report.dart';

class LocalConfigs {
  const LocalConfigs._();

  static const splashTime = 3000;
  static const splashTimeForNative = 0;

  static const theme = ThemeMode.light;

  static const authInitialCheck = true;
  static const purchaserLogEnabled = true;
  static const hitLogger = false;

  // TRANSLATION
  static const configName = "configs";
  static const configDefault = "application";
  static const configPlatform = PlatformType.system;
  static const configEnvironment = EnvironmentType.system;
  static const configPaths = <String>{
    "legals",
    kCountries,
    kLanguages,
    kHobbies,
    kProfessions,
    kReligions,
    kReports,
  };
  static const configLogs = true;

  // IN_APP_DATABASE
  static bool inAppDatabaseLogs = true;
  static String? inAppDatabaseName;
  static InAppDatabaseType? inAppDatabaseType;
  static InAppDatabaseVersion? inAppDatabaseVersion;

  // TOAST AND DIALOGS
  static Alignment toastDisplayAlignment = Alignment(0, 0.9);
  static Duration toastDisplayDuration = const Duration(seconds: 3);
  static ToastBuilder? toastBuilder;

  static const showConfigsLogs = true;
  static const settingsShowLogs = true;

  static const connectivityChecking = true;
  static const connectivityTimeout = 5;
  static const connectivityUrl = "https://www.cloudflare.com/cdn-cgi/trace";
  static const onboardSelectToNext = true;

  static bool translationShowLogs = true;
  static Locale translationFallbackLocale = Locale("en", "US");
}
