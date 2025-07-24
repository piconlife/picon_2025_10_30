import 'package:flutter_andomie/utils/configs.dart';

import '../../roots/utils/platform.dart';
import '../constants/app.dart';

const kIsAppleAuthEnabled = "is_apple_auth_enabled";
const kIsGoogleAuthEnabled = "is_google_auth_enabled";
const kAppPrivacyPolicy = "privacy_policy";
const kAppTerms = "terms_and_conditions";
const kTranslationAutoMode = "translation_auto_mode";
const kTranslationSupportedLocales = "translation_supported_locales";

const kZotloAppId = "zotlo_app_id";
const kZotloAccessKey = "zotlo_access_key";
const kZotloSecretKey = "zotlo_secret_key";
const kZotloPackages = "zotlo_packages";

class RemoteConfigs {
  const RemoteConfigs._();

  static bool get isAppleAuthEnabled {
    return Configs.get(kIsAppleAuthEnabled, defaultValue: isIos);
  }

  static bool get isGoogleAuthEnabled {
    return Configs.get(kIsGoogleAuthEnabled, defaultValue: isAndroid);
  }

  static String get privacyLink =>
      Configs.get(kAppPrivacyPolicy, defaultValue: AppConstants.privacyLink);

  static String get termsLink =>
      Configs.get(kAppTerms, defaultValue: AppConstants.termsLink);

  static bool get translationAutoMode {
    return Configs.get(kTranslationAutoMode, defaultValue: false);
  }

  static Iterable<String> get translationSupportedLocales {
    return Configs.gets(kTranslationSupportedLocales, defaultValue: []);
  }

  static String? get zotloAppId => Configs.getOrNull(kZotloAppId);

  static String get zotloAccessKey =>
      Configs.get(kZotloAccessKey, defaultValue: "");

  static String get zotloSecretKey =>
      Configs.get(kZotloSecretKey, defaultValue: "");

  static Iterable<String> get zotloPackages {
    return Configs.get(kZotloPackages, defaultValue: []);
  }
}
