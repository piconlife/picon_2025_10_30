import 'package:auth_management/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_andomie/extensions/string.dart';
import 'package:flutter_andomie/utils/validator.dart';

import '../../data/models/user.dart';
import '../data/use_cases/user/get.dart';
import '../notifiers/paywall.dart';
import '../preferences/preferences.dart';
import '../res/listeners.dart';

class UserHelper {
  const UserHelper._();

  static String key = "__local_user__";

  static User get user => User.from(Preferences.getOrNull(key));

  static String get uid => user.id;

  static String get email => emailOrNull.use;

  static String? get emailOrNull => user.email;

  static String get language => 'bn';

  static String get phone => user.phone.use;

  static String get photo => user.photo.use;

  static String get name => nameOrNull.use;

  static String? get nameOrNull => user.name;

  static String get username => user.username.use;

  static bool get isActiveUser => user.isLoggedIn;

  static bool get isPremium => PaywallNotifier.i.status.isPremium;

  static bool get isValidUser {
    final a = Validator.isValidString(user.id);
    final b = Validator.isValidString(user.name);
    final c = Validator.isValidString(user.email);
    return a && b && c;
  }

  static bool isCurrentUser(String? id) => id == uid;

  static Future<String?> read(String key) async {
    return Preferences.getString(key);
  }

  static Future<bool> write(String key, String? value) async {
    if (value == null || value.isEmpty) {
      return Preferences.remove(key);
    }
    return Preferences.setString(key, value);
  }

  static Future<User> get([BuildContext? context]) {
    if (context == null) {
      return GetUserUseCase.i(uid).then((value) {
        return value.data ?? user;
      });
    }
    return context.auth<User>().then((value) {
      return value ?? user;
    });
  }

  static Future<bool> update(
    BuildContext context,
    Map<String, dynamic> data,
  ) async {
    try {
      await context.updateAccount<User>(data);
      return true;
    } catch (error) {
      return false;
    }
  }

  static Future<bool> isLoggedIn(BuildContext context) {
    return context.isLoggedIn<User>();
  }

  static Future<void> signOut(BuildContext context, [String? id]) {
    return RootListeners.logout(context, id);
  }

  static Future<bool> deleteAccount(BuildContext context, [String? id]) {
    return RootListeners.deleteAccount(context, id);
  }
}
