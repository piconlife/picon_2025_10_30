import 'package:flutter/foundation.dart';

import '../../app/res/settings.dart';

enum AuthStatus {
  authorized,
  guest,
  none;

  bool get isGuest => this == guest;

  bool get isAuthorized => this == authorized;

  bool get isNone => this == none;
}

class AuthManager extends ChangeNotifier {
  bool initializing = true;
  AuthStatus status;

  AuthManager._(this.status);

  final Map<String, bool> _skippedPages = {};

  static bool get isAuthorized => i.status.isAuthorized;

  static bool get isGuest => i.status.isGuest;

  static bool get isNone => i.status.isNone;

  static bool get isInitialized => !i.initializing;

  static final AuthManager i = AuthManager._(
    RemoteSettings.authorized ? AuthStatus.authorized : AuthStatus.none,
  );

  static void setInitialized(bool value) {
    i.status = value ? AuthStatus.authorized : AuthStatus.none;
    i.initializing = false;
    i.notifyListeners();
  }

  static void changeStatus(AuthStatus value) {
    i.status = value;
    i.notifyListeners();
  }

  static void setSkipped(String name) {
    i._skippedPages[name] = true;
    i.notifyListeners();
  }

  static bool isSkipped(String name) => i._skippedPages[name] ?? false;
}
