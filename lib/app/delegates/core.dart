import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:in_app_analytics/analytics.dart';

import '../../app/utils/secret_code.dart';
import '../../roots/services/tracker.dart';

abstract final class Company {
  static FirebaseFirestore get firestore {
    return FirebaseFirestore.instanceFor(app: Firebase.app('parent'));
  }

  static DocumentReference get app => firestore
      .collection("apps")
      .doc("pelvix")
      .collection("versions")
      .doc('v1');

  static DocumentReference marketerRef(String id) => firestore
      .collection("marketers")
      .doc(id)
      .collection("apps")
      .doc("pelvix")
      .collection("versions")
      .doc('v1');

  static Future<Map<String, dynamic>?> getInfluencerById(String? id) async {
    if (id == null || id.isEmpty) return null;
    return Analytics.future(name: id, reason: 'get_influencer_by_id', () {
      return firestore.collection("marketers").doc(id).get().then((value) {
        final data = value.data();
        if (data == null) return null;
        final id = data['id'];
        if (id is! String || id.isEmpty) return null;
        return data;
      });
    });
  }

  static Future<Map<String, dynamic>?> getInfluencerByCode(String? code) async {
    if (code == null || code.isEmpty) return null;
    final chars = code.characters;
    final id =
        chars.length >= 8
            ? chars.take(6).join()
            : chars.length == 6
            ? chars.join()
            : null;
    if (id == null) return null;
    return Analytics.future(name: id, reason: 'get_influencer_by_code', () {
      return firestore
          .collection("marketers")
          .where("code", isEqualTo: id)
          .limit(1)
          .get()
          .then((value) {
            final data = value.docs.firstOrNull?.data();
            if (data == null) return null;
            final id = data['id'];
            if (id is! String || id.isEmpty) return null;
            return data;
          });
    });
  }

  static Future<Map<String, dynamic>?> getCommissionRateById(
    String? marketerId,
    String? id, {
    bool verify = true,
  }) async {
    if (marketerId == null || marketerId.isEmpty) return null;
    if (id == null || id.isEmpty) return null;
    return Analytics.future(name: id, reason: 'get_commission_rate_by_id', () {
      return app.collection('commission_rates').doc(id).get().then((v) {
        final data = v.data();
        if (data == null) return null;
        final status = data["status"];
        if (verify && status != 'active') return null;
        return data;
      });
    });
  }

  static Future<void> markClickEventAsStatus(String id, String status) async {
    if (id.isEmpty) return;
    return Analytics.callAsync(
      name: status,
      reason: 'mark_click_event_as_status',
      () {
        return app.collection('clicks').doc(id).update({"status": status});
      },
    );
  }

  static Future<ReferralDetails?> getClickDetails(String ip) async {
    if (ip.isEmpty) return null;
    final mIp = ip.encode();
    return Analytics.future(name: mIp, reason: 'get_click_details', () {
      final ref = app.collection('clicks').doc(mIp);
      return ref.get().then((value) async {
        final data = value.data();
        if (data == null || data.isEmpty) return null;
        return ReferralDetails.parse(data);
      });
    });
  }

  static Future<void> install(
    ReferralDetails details, {
    Map<String, dynamic>? args,
  }) async {
    if (details.id.isEmpty) return;
    return Analytics.callAsync(name: details.id, reason: 'install', () async {
      final time = DateTime.now().millisecondsSinceEpoch;
      final campaign = details.campaign;
      await app.collection("installs").doc(details.id).set({
        "id": details.id,
        "time": time,
        "referrer": details.referrer,
        if (campaign != null) "campaign": campaign,
        if (args != null) "meta": args,
      });
      await marketerRef(
        details.referrer,
      ).collection("installs").doc(details.id).set({
        "id": details.id,
        "time": time,
        if (campaign != null) "campaign": campaign,
      });
    });
  }

  static Future<void> purchase(
    String id,
    String package,
    double usdPrice, {
    String? uid,
    String? referrerId,
    bool admin = true,
    bool isFreeTrial = true,
  }) {
    return Analytics.callAsync(name: id, reason: 'purchase', () async {
      if (id.isEmpty || usdPrice <= 0 || package.isEmpty) return;
      final time = DateTime.now().millisecondsSinceEpoch;
      final secret = usdPrice.toString().encode(public: time.toString());
      final mUid = uid.encode();
      final refOfCore = app.collection('purchases').doc(id);
      if (referrerId == null || referrerId.isEmpty || admin || isFreeTrial) {
        await refOfCore.set({
          "id": id,
          "time": time,
          "uid": mUid,
          "package": package,
          "amount": usdPrice,
          "secret": secret,
          "trial": isFreeTrial,
        });
        return;
      }

      final commissionRateId = await getInfluencerById(referrerId).then((
        value,
      ) {
        final ids = value?["commissionRateIds"];
        if (ids is! Map || ids.isEmpty) return null;
        final id = ids['pelvix'];
        return id is! String || id.isEmpty ? null : id;
      });
      double commissionRate = 0.0;
      if (commissionRateId != null && commissionRateId.isNotEmpty) {
        commissionRate = await getCommissionRateById(
          referrerId,
          commissionRateId,
        ).then((value) {
          final rate = value?["rate"];
          return rate is num ? rate.toDouble() : 0.0;
        });
      }

      final refOfMarketer = marketerRef(
        referrerId,
      ).collection('purchases').doc(id);

      if (commissionRate <= 0) {
        await refOfMarketer.set({
          "id": id,
          "time": time,
          "uid": mUid,
          "package": package,
          "amount": usdPrice,
          "secret": secret,
        });
        return;
      }
      final commission = usdPrice * commissionRate;
      final commissionSecret = commission.toString().encode(
        public: time.toString(),
      );
      final mCommissionRateId = commissionRateId.encode();
      await refOfCore.set({
        "id": id,
        "time": time,
        "uid": mUid,
        "package": package,
        "amount": usdPrice,
        "secret": secret,
        "commission": commission,
        "commissionSecret": commissionSecret,
        "commissionRateId": mCommissionRateId,
        "referrer": referrerId.encode(),
      });
      await refOfMarketer.set({
        "id": id,
        "time": time,
        "uid": mUid,
        "package": package,
        "amount": usdPrice,
        "secret": secret,
        "commission": commission,
        "commissionSecret": commissionSecret,
        "commissionRateId": mCommissionRateId,
      });
    });
  }

  static Future<bool> redeem(
    String uid,
    ReferralDetails details, {
    Map<String, dynamic>? args,
  }) {
    return Analytics.future(name: uid, reason: 'redeem', () async {
      final mUid = uid.encode();
      final time = DateTime.now().millisecondsSinceEpoch;
      await app.collection("redeems").doc(mUid).set({
        "id": mUid,
        "time": time,
        "referrer": details.referrer,
        if (args != null) "meta": args,
      });
      await marketerRef(
        details.referrer,
      ).collection("redeems").doc(mUid).set({"id": mUid, "time": time});
      return true;
    }).then((v) => v ?? false);
  }
}
