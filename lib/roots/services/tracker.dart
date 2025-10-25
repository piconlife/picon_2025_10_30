import 'package:characters/characters.dart';
import 'package:flutter/foundation.dart';

import '../../app/configs/remote.dart';

class ReferralDetails {
  final String id;
  final int time;
  final String referrer;
  final String code;
  final String? status;
  final int? expiredDuration;

  bool get isPurchased => status == "purchased";

  bool get isRedeemed => status == "redeemed" || isPurchased;

  bool get isInstalled => status == "installed" || isRedeemed;

  bool get isExpired {
    final expiredAt = DateTime.fromMillisecondsSinceEpoch(
      time,
      isUtc: true,
    ).add(Duration(days: expiredDuration ?? 3));
    return expiredAt.isBefore(DateTime.now().toUtc());
  }

  String? get campaign {
    if (code.length < 8) return null;
    return code.characters.takeLast(2).join();
  }

  const ReferralDetails({
    required this.id,
    required this.time,
    required this.referrer,
    required this.code,
    this.status,
    this.expiredDuration,
  });

  static ReferralDetails? parse(Object? source) {
    if (source is! Map) return null;
    final id = source['id'];
    if (id is! String || id.isEmpty) return null;
    final time = source['time'];
    if (time is! num || time <= 0) return null;
    final referrer = source['referrer'];
    if (referrer is! String || referrer.isEmpty) return null;
    final code = source['code'];
    if (code is! String || code.isEmpty) return null;
    final status = source['status'];
    final expiredDuration = source['expiredDuration'];
    return ReferralDetails(
      id: id,
      time: time.toInt(),
      referrer: referrer,
      code: code,
      status: status is String ? status : null,
      expiredDuration: expiredDuration is num ? expiredDuration.toInt() : null,
    );
  }

  ReferralDetails copyWith({
    String? id,
    int? time,
    String? referrer,
    String? code,
    String? status,
    int? expiredDuration,
  }) {
    return ReferralDetails(
      id: id ?? this.id,
      time: time ?? this.time,
      referrer: referrer ?? this.referrer,
      code: code ?? this.code,
      status: status ?? this.status,
      expiredDuration: expiredDuration ?? this.expiredDuration,
    );
  }

  Map<String, dynamic> get source {
    return {
      "id": id,
      "time": time,
      "referrer": referrer,
      "code": code,
      if (status != null) "status": status,
      if (expiredDuration != null) "expiredDuration": expiredDuration,
    };
  }

  @override
  String toString() {
    return "$ReferralDetails(id: $id, referrer: $referrer, code: $code)";
  }
}

abstract class UserTrackerDelegate {
  Future<void> markClickEventAsStatus(String id, String status);

  Future<void> keepReferralDetails(ReferralDetails details);

  ReferralDetails? getReferralDetailsFromCache();

  Future<ReferralDetails?> getReferralDetailsByIp(String ip);

  Future<Map<String, dynamic>?> getReferrerDetailsByCode(String code);

  Future<String?>? getIp();

  Future<void> install(ReferralDetails details, {Map<String, dynamic>? args});

  Future<bool> redeem(
    String uid,
    ReferralDetails details, {
    Map<String, dynamic>? args,
  });

  Future<void> purchase(
    String id,
    String package,
    double usdPrice, {
    String? uid,
    String? referrerId,
    bool admin,
    bool isTrial,
  });
}

class UserTracker {
  final bool logThrowEnabled;
  final UserTrackerDelegate delegate;

  const UserTracker._({required this.delegate, this.logThrowEnabled = false});

  static UserTracker? _i;

  static UserTracker get i => _i!;

  static Future<void> init({
    required UserTrackerDelegate delegate,
    bool logThrowEnabled = kDebugMode,
  }) async {
    _i = UserTracker._(delegate: delegate, logThrowEnabled: logThrowEnabled);
  }

  static Future<ReferralDetails?> info({
    String? code,
    bool fromRemote = false,
  }) async {
    try {
      if (!fromRemote || code == null || code.isEmpty) {
        return i.delegate.getReferralDetailsFromCache();
      }
      return i.delegate.getReferrerDetailsByCode(code).then((value) {
        final id = value?['id'];
        if (id is! String || id.isEmpty) return null;
        return ReferralDetails(
          id: '',
          time: DateTime.now().millisecondsSinceEpoch,
          referrer: id,
          code: code,
          expiredDuration: 0,
          status: "find",
        );
      });
    } catch (e) {
      if (i.logThrowEnabled) throw "info[error]: $e";
      return null;
    }
  }

  static Future<void> install({Map<String, dynamic>? args}) async {
    try {
      final ip = await i.delegate.getIp();
      if (ip == null || ip.isEmpty) return;
      final old = i.delegate.getReferralDetailsFromCache();
      if (old != null && (old.isInstalled || old.isExpired)) return;
      final details = await i.delegate.getReferralDetailsByIp(ip);
      if (details == null || details.isInstalled) return;
      await i.delegate.keepReferralDetails(
        details.copyWith(status: "installed"),
      );
      await i.delegate.install(details, args: args);
      await i.delegate.markClickEventAsStatus(details.id, "installed");
    } catch (e) {
      if (i.logThrowEnabled) throw "install[error]: $e";
    }
  }

  static Future<bool> redeem(
    String uid,
    ReferralDetails details, {
    Map<String, dynamic>? args,
  }) async {
    bool status = false;
    try {
      if (details.referrer.isEmpty || uid.isEmpty) return false;
      final old = i.delegate.getReferralDetailsFromCache();
      if (old != null && (old.isRedeemed || old.isExpired)) return false;
      await i.delegate.keepReferralDetails(
        details.copyWith(status: 'redeemed'),
      );
      status = await i.delegate.redeem(uid, details, args: args);
      await i.delegate.markClickEventAsStatus(details.id, "redeemed");
      return status;
    } catch (e) {
      if (i.logThrowEnabled) throw "install[error]: $e";
      return status;
    }
  }

  static Future<void> purchase({
    required String id,
    required double usdPrice,
    required String package,
    required String? uid,
    required bool adminOnly,
    required bool isTrial,
  }) async {
    try {
      final info = i.delegate.getReferralDetailsFromCache();
      if (info != null && (!info.isPurchased || !info.isExpired)) {
        await i.delegate.keepReferralDetails(
          info.copyWith(
            time:
                DateTime.now()
                    .subtract(Duration(days: 10))
                    .millisecondsSinceEpoch,
            status: "purchased",
          ),
        );
        await i.delegate.markClickEventAsStatus(info.id, "purchased");
      }
      await i.delegate.purchase(
        id,
        package,
        usdPrice,
        uid: uid,
        referrerId: info?.referrer,
        admin:
            adminOnly ||
            info == null ||
            info.isExpired ||
            info.isPurchased ||
            !RemoteConfigs.subscriptionReferralPackageIds.contains(package),
        isTrial: isTrial,
      );
    } catch (e) {
      if (i.logThrowEnabled) throw "purchase[error]: $e";
    }
  }
}
