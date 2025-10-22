import 'package:flutter/cupertino.dart';
import 'package:in_app_analytics/analytics.dart';
import 'package:in_app_purchaser/in_app_purchaser.dart';
import 'package:intl/intl.dart';
import 'package:object_finder/object_finder.dart';

import '../../roots/preferences/preferences.dart';
import '../res/listeners.dart';

const _chars = 'abcdefghijklmnopqrstuvwxyz_';
const _kCachedStatus = '__in_app_purchase_purchase_cached_status__';
const _kOfflineStatus = '__in_app_purchase_purchase_offline_status__';

class InAppPurchaseConfigDelegateImpl extends InAppPurchaseConfigDelegate {
  @override
  bool get cachedStatus => Preferences.getBool(_kCachedStatus);

  @override
  bool get offlineStatus {
    final createdAt = Preferences.getInt(_kOfflineStatus);
    if (createdAt <= 0) return false;
    final expiredAt = DateTime.fromMillisecondsSinceEpoch(
      createdAt,
    ).add(Duration(days: 7));
    return expiredAt.isAfter(DateTime.now());
  }

  @override
  String? formatPrice(Locale locale, String currencyCode, double price) {
    final formatter = NumberFormat.simpleCurrency(
      locale: locale.toString(),
      name: currencyCode,
    );
    final format = formatter.format(price);
    return format;
  }

  @override
  double prettyPrice(double value) {
    return value;
  }

  @override
  String formatFeature(String feature) {
    return feature.toLowerCase().characters.where(_chars.contains).join();
  }

  @override
  T parse<T extends Object?>(Object? value, T defaultValue) {
    return value.getOrNull<T>() ?? defaultValue;
  }

  @override
  void loggedIn() {
    Analytics.log("in_app_purchaser", 'logged_in');
  }

  @override
  void loggedOut() {
    Analytics.log("in_app_purchaser", 'logged_out');
  }

  @override
  void paywallsLoaded(List<String> ids) {
    Analytics.log("in_app_purchaser", 'paywalls_loaded', msg: ids.join(','));
  }

  @override
  void statusChanged(bool status) {
    Preferences.setBool(_kCachedStatus, status);
    if (status) {
      Preferences.setInt(
        _kOfflineStatus,
        DateTime.now().millisecondsSinceEpoch,
      );
    }
    Analytics.log("in_app_purchaser", 'status', msg: status.toString());
  }

  @override
  void purchased(InAppPurchaseResultSuccess result) {
    InAppListeners.purchased(result);
    Analytics.log(
      "in_app_purchaser",
      'purchased',
      msg: result.profile?.profileId,
    );
  }

  @override
  void restored(InAppPurchaseProfile profile) {
    Analytics.log("in_app_purchaser", 'restored', msg: profile.profileId);
  }
}
