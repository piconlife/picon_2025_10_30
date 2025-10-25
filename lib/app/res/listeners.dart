import 'package:auth_management/core/auth_response.dart';
import 'package:auth_management/core/helper.dart';
import 'package:auth_management/widgets/oauth_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_androssy_dialogs/dialogs.dart';
import 'package:flutter_entity/entity.dart';
import 'package:in_app_purchaser/in_app_purchaser.dart';
import 'package:in_app_settings/settings.dart';
import 'package:in_app_translation/core.dart';

import '../../data/models/user.dart';
import '../../roots/helpers/connectivity.dart';
import '../../roots/services/notification.dart';
import '../../roots/services/zotlo_subscription.dart';
import '../../roots/utils/speech.dart';
import '../settings/remote.dart';

abstract final class InAppListeners {
  static Future<void> purchased(InAppPurchaseResultSuccess result) async {}

  static void home() {}

  static Future<void> authorizationChanged(bool authorized) async {}

  static void connectivityChanged(bool connected) {}

  static void handleZotloReady(String? expireDate) {
    Settings.set(kZotloExpireDate, expireDate);
    if (ZotloService.i.isPremium) InAppPurchaser.setPremiumStatus(true);
  }

  static void translationsLocaleChanged(Locale locale) async {
    Settings.set("locale", locale.toString());
    await Speech.language(Translation.languageCode);
    await InAppNotifications.init(
      onReady: () async {
        await InAppNotifications.initWeeklyNotifications();
      },
    );
  }

  static Future<void> login(
    BuildContext context,
    OauthButtonType type,
    VoidCallback? onLoggedIn,
  ) async {
    try {
      context.showLoader();
      if (await ConnectivityHelper.isDisconnected) {
        if (!context.mounted) return;
        context.hideLoader();
        context.showErrorSnackBar(Status.networkError.error);
        return;
      }
      if (!context.mounted) return;
      AuthResponse<User> response;
      if (type == OauthButtonType.apple) {
        response = await context.signInWithApple<User>();
      } else if (type == OauthButtonType.google) {
        response = await context.signInWithGoogle<User>();
      } else {
        context.hideLoader();
        context.showErrorSnackBar("Authorization not supported!");
        return;
      }
      if (!context.mounted) return;
      if (response.status.isAuthenticated) {
        await Settings.load();
        await InAppListeners.authorizationChanged(true);
        if (!context.mounted) return;
        context.hideLoader();
        context.showToast("Logged in successful!");
        if (onLoggedIn != null) onLoggedIn();
      } else {
        context.hideLoader();
      }
    } catch (error) {
      if (!context.mounted) return;
      context.hideLoader();
      context.showErrorSnackBar(error.toString());
    }
  }

  static Future<void> logout(BuildContext context, [String? id]) async {
    try {
      context.showLoader();
      if (await ConnectivityHelper.isDisconnected) {
        if (!context.mounted) return;
        context.hideLoader();
        context.showErrorSnackBar(Status.networkError.error);
        return;
      }
      if (!context.mounted) return;
      AuthResponse<User> response = await context.signOut<User>(id: id);
      if (!context.mounted) return;
      if (!response.status.isAuthenticated) {
        context.hideLoader();
        context.showToast("Logged out!");
        return;
      } else {
        context.hideLoader();
        context.showErrorSnackBar(Status.error.error);
      }
    } catch (_) {
      return;
    }
  }

  static Future<bool> deleteAccount(BuildContext context, [String? id]) async {
    try {
      context.showLoader();
      if (await ConnectivityHelper.isDisconnected) {
        if (!context.mounted) return false;
        context.hideLoader();
        context.showErrorSnackBar(Status.networkError.error);
        return false;
      }
      if (!context.mounted) return false;
      AuthResponse<User> response = await context.signOut<User>(id: id);
      if (!context.mounted) return false;
      if (!response.status.isAuthenticated) {
        await context.deleteAccount<User>();
        await Settings.clear();
        await InAppListeners.authorizationChanged(false);
        if (!context.mounted) return true;
        context.hideLoader();
        context.showToast("Account has deleted!");
        return true;
      } else {
        context.hideLoader();
        return false;
      }
    } catch (_) {
      return false;
    }
  }
}
