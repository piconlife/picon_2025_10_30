import 'package:flutter/foundation.dart';

import '../../app/settings/remote.dart';

enum PaywallStatus {
  premium,
  guest,
  none;

  bool get isGuest => this == guest;

  bool get isPremium => this == premium;

  bool get isNone => this == none;
}

class PaywallNotifier extends ChangeNotifier {
  PaywallStatus status;

  PaywallNotifier._(this.status);

  final Map<String, bool> _skippedPages = {};

  static bool get isPremium => i.status.isPremium;

  static bool get isGuest => i.status.isGuest;

  static bool get isNone => i.status.isNone;

  static final PaywallNotifier i = PaywallNotifier._(
    RemoteSettings.premium ? PaywallStatus.premium : PaywallStatus.none,
  );

  static void changeStatus(PaywallStatus value) {
    i.status = value;
    i.notifyListeners();
  }

  static void setSkipped(String name) {
    i._skippedPages[name] = true;
    i.notifyListeners();
  }

  static bool isSkipped(String name) => i._skippedPages[name] ?? false;
}
