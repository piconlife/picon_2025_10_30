import 'package:get_ip_address/get_ip_address.dart' hide Core;

import '../../roots/preferences/preferences.dart';
import '../../roots/services/tracker.dart';
import 'core.dart';

const _kReferralDetails = "referral_details";

class InAppUserTrackerDelegate extends UserTrackerDelegate {
  @override
  Future<ReferralDetails?> getReferralDetailsByIp(String ip) {
    return Company.getClickDetails(ip);
  }

  @override
  Future<Map<String, dynamic>?> getReferrerDetailsByCode(String code) {
    return Company.getInfluencerByCode(code);
  }

  @override
  ReferralDetails? getReferralDetailsFromCache() {
    return ReferralDetails.parse(Preferences.getOrNull(_kReferralDetails));
  }

  @override
  Future<void> markClickEventAsStatus(String id, String status) {
    return Company.markClickEventAsStatus(id, status);
  }

  @override
  Future<void> keepReferralDetails(ReferralDetails details) async {
    Preferences.set(_kReferralDetails, details.source);
  }

  @override
  Future<String?> getIp() async {
    return IpAddress().getIp().then((v) => v is String ? v : null);
  }

  @override
  Future<void> install(ReferralDetails details, {Map<String, dynamic>? args}) {
    return Company.install(details, args: args);
  }

  @override
  Future<bool> redeem(
    String uid,
    ReferralDetails details, {
    Map<String, dynamic>? args,
  }) {
    return Company.redeem(uid, details, args: args);
  }

  @override
  Future<void> purchase(
    String id,
    String package,
    double usdPrice, {
    String? uid,
    String? referrerId,
    bool admin = true,
    bool isTrial = true,
  }) {
    return Company.purchase(
      id,
      package,
      usdPrice,
      uid: uid,
      referrerId: referrerId,
      admin: admin,
      isFreeTrial: isTrial,
    );
  }
}
