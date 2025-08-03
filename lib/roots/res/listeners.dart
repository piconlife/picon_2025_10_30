import 'package:auth_management/auth_management.dart' hide AuthStatus;
import 'package:flutter/cupertino.dart';
import 'package:flutter_andomie/utils/configs.dart';
import 'package:flutter_andomie/utils/settings.dart';
import 'package:flutter_andomie/utils/translation.dart';
import 'package:flutter_androssy_dialogs/dialogs.dart';

import '../../app/res/listeners.dart';
import '../../data/models/user.dart';
import '../../roots/services/zotlo_subscription.dart';
import '../helpers/connectivity.dart';
import '../notifiers/auth.dart';

class RootListeners {
  const RootListeners._();

  static void connectivityChanged(bool connected) {
    Configs.i.changeConnection(connected);
    Translation.i.changeConnection(connected);
    ZotloService.i.changeConnection(connected);
    if (connected) {
      Settings.load();
    }
    InAppListeners.connectivityChanged(connected);
  }

  static Future<void> login(
    BuildContext context,
    OauthButtonType type,
    VoidCallback? onLoggedIn,
  ) async {
    try {
      context.showLoader();
      if (!(await ConnectivityHelper.isInternetActive)) {
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
        AuthManager.changeStatus(AuthStatus.authorized);
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
      if (!(await ConnectivityHelper.isInternetActive)) {
        if (!context.mounted) return;
        context.hideLoader();
        context.showErrorSnackBar(Status.networkError.error);
        return;
      }
      if (!context.mounted) return;
      AuthResponse<User> response = await context.signOut<User>(id: id);
      if (!context.mounted) return;
      if (!response.status.isAuthenticated) {
        AuthManager.changeStatus(AuthStatus.none);
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
      if (!(await ConnectivityHelper.isInternetActive)) {
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
        AuthManager.changeStatus(AuthStatus.none);
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

  static void translationsLocaleChanged(Locale locale) {
    Settings.set("locale", locale.toString());
    InAppListeners.translationsLocaleChanged(locale);
  }
}
