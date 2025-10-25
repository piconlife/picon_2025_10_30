import 'package:in_app_configs/configs.dart';
import 'package:in_app_purchaser/in_app_purchaser.dart';

import '../../roots/utils/platform.dart';
import '../constants/app.dart';

const kIsOnboardSelectToNext = "is_onboard_select_to_next";
const kTranslationSupportedLocales = "translation_supported_locales";

const kIsFirebaseApp = "is_firebase_app";
const kIsUserBackupEnabled = "is_user_backup_enabled";
const kIsUserOnboardBackupEnabled = "is_user_onboard_backup_enabled";
const kIsAuthPaywallEnabled = "is_auth_paywall_enabled";
const kIsAppleAuthEnabled = "is_apple_auth_enabled";
const kIsGoogleAuthEnabled = "is_google_auth_enabled";
const kIsPurchasePaywallEnabled = "is_purchase_paywall_enabled";
const kIsPurchasePaywallRtlEnabled = "is_purchase_paywall_rtl_enabled";
const kIsPurchasePaywallDefaultDarkTheme =
    "is_purchase_paywall_default_dark_theme";
const kIsPurchaseOtoPaywallEnabled = "is_purchase_oto_paywall_enabled";
const kIsPurchaseStartupPaywallEnabled = "is_purchase_startup_paywall_enabled";
const kIsPremiumFeatureIgnoreForFast = "is_premium_feature_ignore_for_fast";
const kIsReferralEnabled = "is_referral_mode";
const kIsUpgraderEnabled = "is_upgrader_enabled";
const kIsUpgraderForceEnabled = "is_upgrader_force_enabled";
const kIsUpgraderReleaseNoteEnabled = "is_upgrader_release_note_enabled";
const kAppLink = "app_link";
const kAppPrivacyPolicy = "privacy_policy";
const kAppTerms = "terms_and_conditions";
const kPremiumFeatures = "premium_features";
const kSubscriptionApiKey = "subscription_api_key";
const kSubscriptionApiType = "subscription_api_type";
const kSubscriptionPlacements = "subscription_placements";
const kSubscriptionSettingsEnabled = "subscription_settings_enabled";
const kSubscriptionOtoCompletedModeEnabled =
    "subscription_oto_completed_mode_enabled";
const kSubscriptionDefaultOtoPlacementId =
    "subscription_default_oto_placement_id";
const kSubscriptionDefaultPlacementId = "subscription_default_placement_id";
const kSubscriptionDefaultReferralPlacementId =
    "subscription_default_referral_placement_id";
const kSubscriptionIgnorableUids = "subscription_ignorable_uids";
const kSubscriptionRtlLanguages = "subscription_rtl_languages";
const kSubscriptionIgnorableMappedFeatureIndexes =
    "subscription_ignorable_mapped_feature_indexes";
const kTranslatorInstantCacheMode = "translator_instant_cache_mode";
const kTranslationAutoMode = "translation_auto_mode";
const kTranslationLazyMode = "translation_lazy_mode";
const kZotloAppId = "zotlo_app_id";
const kZotloAccessKey = "zotlo_access_key";
const kZotloSecretKey = "zotlo_secret_key";
const kZotloPackages = "zotlo_packages";

abstract final class RemoteConfigs {
  static bool get isPurchasePaywallEnabled {
    return Configs.get(kIsPurchasePaywallEnabled, defaultValue: false);
  }

  static bool get isPurchasePaywallRtlEnabled {
    return Configs.get(kIsPurchasePaywallRtlEnabled, defaultValue: false);
  }

  static bool get isPurchasePaywallDefaultDarkTheme {
    return Configs.get(kIsPurchasePaywallDefaultDarkTheme, defaultValue: false);
  }

  static bool get isUpgraderEnabled {
    return Configs.get(kIsUpgraderEnabled, defaultValue: true);
  }

  static bool get isUpgraderForceEnabled {
    return Configs.get(kIsUpgraderForceEnabled, defaultValue: true);
  }

  static bool get isUpgraderReleaseNoteEnabled {
    return Configs.get(kIsUpgraderReleaseNoteEnabled, defaultValue: false);
  }

  static String get appLink => Configs.get(
    kAppLink,
    defaultValue:
        isIosDevice ? AppConstants.appStoreLink : AppConstants.playStoreLink,
  );

  static String get appPrivacyLink =>
      Configs.get(kAppPrivacyPolicy, defaultValue: AppConstants.privacyLink);

  static String get appTermsLink =>
      Configs.get(kAppTerms, defaultValue: AppConstants.termsLink);

  static String get subscriptionApiKey {
    return Configs.get(
      kSubscriptionApiKey,
      defaultValue:
          isIosDevice
              ? "appl_VAZyIZfhlGIpcnQgNWdtlJRaAlK"
              : "goog_ujvVCUgdPIrkSfXBVtojzTdGQnM",
    );
  }

  static int get subscriptionApiType {
    return Configs.get(kSubscriptionApiType, defaultValue: 0);
  }

  static double get buttonClickLowerFade {
    return Configs.get("button_click_lower_fade", defaultValue: 0.75);
  }

  static double get buttonClickUpperFade {
    return Configs.get("button_click_upper_fade", defaultValue: 1);
  }

  static double get buttonClickLowerScale {
    return Configs.get("button_click_lower_scale", defaultValue: 1);
  }

  static double get buttonClickUpperScale {
    return Configs.get("button_click_upper_scale", defaultValue: 1);
  }

  static bool get subscriptionSettingsEnabled {
    return Configs.get(kSubscriptionSettingsEnabled, defaultValue: true);
  }

  static List<String> get subscriptionIgnorableUids {
    return Configs.gets(kSubscriptionIgnorableUids, defaultValue: []);
  }

  static List<String> get subscriptionRtlLanguages {
    return Configs.gets(
      kSubscriptionRtlLanguages,
      defaultValue: kPurchaserRtlLocales,
    );
  }

  static Map<String, List<int>> get subscriptionIgnorableMappedFeatureIndexes {
    final x = Configs.get<Map>(
      kSubscriptionIgnorableMappedFeatureIndexes,
      defaultValue: {},
    );
    final entries =
        x.entries
            .map((e) {
              final v = e.value;
              if (v is! List) return null;
              final x = MapEntry(
                e.key.toString(),
                v
                    .map((e) => e is num ? e.toInt() : null)
                    .whereType<int>()
                    .toList(),
              );
              return x;
            })
            .whereType<MapEntry<String, List<int>>>()
            .toList();
    return Map.fromEntries(entries);
  }

  static List<String> get subscriptionFeatures {
    return Configs.gets(kPremiumFeatures, defaultValue: []);
  }

  static Map<String, String> get subscriptionPlacements {
    final x = Configs.get<Map>(
      kSubscriptionPlacements,
      defaultValue: {
        "": "default",
        "V1": "v1",
        "V2": "v2",
        "R1": "referral_v1",
        "O1": "oto_v1",
        "O2": "oto_v2",
      },
    );
    return x.map((k, v) => MapEntry(k.toString(), v.toString()));
  }

  static List<String> get subscriptionReferralPackageIds {
    return Configs.gets(
      "subscription_referral_package_ids",
      defaultValue:
          isIOS
              ? ["yearly.v1.d50", "monthly.v1.d50"]
              : ['default:yearly-v1-d50', 'default:monthly-v1-d50'],
    );
  }

  static Set<String> get subscriptionPlacementIds {
    return subscriptionPlacements.values.toSet();
  }

  static String get subscriptionDefaultPlacementId {
    return Configs.get(kSubscriptionDefaultPlacementId, defaultValue: 'v1');
  }

  static String get subscriptionDefaultReferralPlacementId {
    return Configs.get(
      kSubscriptionDefaultReferralPlacementId,
      defaultValue: "referral_v1",
    );
  }

  static bool get subscriptionOtoCompleteModeEnabled {
    return Configs.get(
      kSubscriptionOtoCompletedModeEnabled,
      defaultValue: true,
    );
  }

  static bool get translationAutoMode =>
      Configs.get(kTranslationAutoMode, defaultValue: false);

  static bool get translationLazyMode =>
      Configs.get(kTranslationLazyMode, defaultValue: true);

  static Iterable<String> get translationSupportedLocales {
    return Configs.gets("application/supported_locales", defaultValue: []);
  }

  static String? get zotloAppId => Configs.getOrNull(kZotloAppId);

  static String get zotloAccessKey =>
      Configs.get(kZotloAccessKey, defaultValue: "");

  static String get zotloSecretKey =>
      Configs.get(kZotloSecretKey, defaultValue: "");

  static Iterable<String> get zotloPackages {
    return Configs.get(kZotloPackages, defaultValue: []);
  }

  static bool isPremiumFeature(String feature, [int? ignoreIndex]) {
    if (!isPurchasePaywallEnabled) return false;
    return InAppPurchaser.isPremiumFeature(feature, ignoreIndex);
  }

  static Object? themeConfigs = Configs.getByName('themes');
}
