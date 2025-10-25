import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:in_app_analytics/in_app_analytics.dart';
import 'package:in_app_configs/configs.dart';

class InAppAnalyticsDelegate extends AnalyticsDelegate {
  final version = Configs.get("analytics_version", defaultValue: 'v1');
  final isFirestore = Configs.getOrNull<String?>("analytics_db") == 'firestore';
  final isErrorEnabled = Configs.get(
    "analytics_error_enabled",
    defaultValue: true,
  );
  final isEventEnabled = Configs.get(
    "analytics_event_enabled",
    defaultValue: false,
  );
  final isFailureEnabled = Configs.get(
    "analytics_failure_enabled",
    defaultValue: true,
  );
  final isLogEnabled = Configs.get(
    "analytics_log_enabled",
    defaultValue: false,
  );
  final isFirebaseCrashlyticsEnabled = Configs.get(
    "analytics_firebase_crashlytics_enabled",
    defaultValue: true,
  );
  final isFirebaseAnalyticsEnabled = Configs.get(
    "analytics_firebase_analytics_enabled",
    defaultValue: false,
  );

  late final firebase = FirebaseDatabase.instance
      .ref()
      .child("analytics")
      .child(version);

  late final firestore = FirebaseFirestore.instance
      .collection("analytics")
      .doc(version);

  @override
  Future<void> error(AnalyticsError error) async {
    if (!isErrorEnabled) return;
    final value = error.json;
    if (value == null || value.isEmpty) return;
    final date = DateTime.now();
    final id = "${date.year}-${date.month}${date.day}";
    if (isFirestore) {
      await firestore
          .collection("errors")
          .doc(id)
          .set(value, SetOptions(merge: true));
      return;
    }
    await firebase.child("errors").child(id).set(value);
  }

  @override
  Future<void> event(AnalyticsEvent event) async {
    final name = event.name;
    if (name.isEmpty) return;
    firebaseAnalytics(event);
    if (!isEventEnabled) return;
    final reason = event.reason ?? "event";
    final value = event.json;
    if (value == null || value.isEmpty) return;
    if (isFirestore) {
      await firestore
          .collection("events")
          .doc(name)
          .collection("reasons")
          .doc(reason)
          .set(value, SetOptions(merge: true));
      return;
    }
    await firebase.child("events").child(name).child(reason).set(value);
  }

  @override
  Future<void> failure(AnalyticsEvent event) async {
    if (!isFailureEnabled) return;
    final name = event.name;
    final reason = event.reason ?? "failure";
    final value = event.json;
    if (name.isEmpty || value == null || value.isEmpty) return;
    if (isFirestore) {
      await firestore
          .collection("failures")
          .doc(name)
          .collection("reasons")
          .doc(reason)
          .set(value, SetOptions(merge: true));
      return;
    }
    await firebase.child("failures").child(name).child(reason).set(value);
  }

  @override
  Future<void> log(AnalyticsEvent event) async {
    if (!isLogEnabled) return;
    final name = event.name;
    final reason = event.reason ?? "log";
    final value = event.json;
    if (name.isEmpty || value == null || value.isEmpty) return;
    if (isFirestore) {
      await firestore
          .collection("logs")
          .doc(name)
          .collection("reasons")
          .doc(reason)
          .set(value, SetOptions(merge: true));
      return;
    }
    await firebase.child("logs").child(name).child(reason).set(value);
  }

  @override
  void platform(Object error, StackTrace stackTrace) {
    if (!isFirebaseCrashlyticsEnabled) return;
    FirebaseCrashlytics.instance.recordError(error, stackTrace, fatal: false);
  }

  @override
  void widget(FlutterErrorDetails details) {
    if (!isFirebaseCrashlyticsEnabled) return;
    FirebaseCrashlytics.instance.recordFlutterFatalError(details);
  }

  Future<void> firebaseAnalytics(AnalyticsEvent event) async {
    if (!isFirebaseAnalyticsEnabled) return;
    final analytics = FirebaseAnalytics.instance;
    final x = event.extra ?? event.props ?? {};
    final extra = x[EventFields.parameters];
    final parameters = extra is Map<String, Object> ? extra : null;

    List<AnalyticsEventItem>? parseItems(Object? source) {
      if (source is! List) return null;
      return source
          .map((e) {
            if (e is AnalyticsEventItem) return e;
            if (e is! EventItem) return null;
            return AnalyticsEventItem(
              affiliation: e.affiliation,
              coupon: e.coupon,
              creativeName: e.creativeName,
              creativeSlot: e.creativeSlot,
              currency: e.currency,
              discount: e.discount,
              index: e.index,
              itemBrand: e.itemBrand,
              itemCategory: e.itemCategory,
              itemCategory2: e.itemCategory2,
              itemCategory3: e.itemCategory3,
              itemCategory4: e.itemCategory4,
              itemCategory5: e.itemCategory5,
              itemId: e.itemId,
              itemListId: e.itemListId,
              itemListName: e.itemListName,
              itemName: e.itemName,
              itemVariant: e.itemVariant,
              locationId: e.locationId,
              parameters: e.parameters,
              price: e.price,
              promotionId: e.promotionId,
              promotionName: e.promotionName,
              quantity: e.quantity,
            );
          })
          .whereType<AnalyticsEventItem>()
          .toList();
    }

    switch (event.name) {
      case Events.logAddPaymentInfo:
        final coupon = x[EventFields.coupon];
        final currency = x[EventFields.currency];
        final paymentType = x[EventFields.paymentType];
        final value = x[EventFields.value];
        final items = x[EventFields.items];
        return analytics.logAddPaymentInfo(
          coupon: coupon is String ? coupon : null,
          currency: currency is String ? currency : null,
          paymentType: paymentType is String ? paymentType : null,
          value: value is num ? value.toDouble() : null,
          items: parseItems(items),
          parameters: parameters,
        );

      case Events.logAddShippingInfo:
        final coupon = x[EventFields.coupon];
        final currency = x[EventFields.currency];
        final shippingTier = x[EventFields.shippingTier];
        final value = x[EventFields.value];
        final items = x[EventFields.items];
        return analytics.logAddShippingInfo(
          coupon: coupon is String ? coupon : null,
          currency: currency is String ? currency : null,
          shippingTier: shippingTier is String ? shippingTier : null,
          value: value is num ? value.toDouble() : null,
          items: parseItems(items),
          parameters: parameters,
        );

      case Events.logAddToCart:
        final currency = x[EventFields.currency];
        final value = x[EventFields.value];
        final items = x[EventFields.items];
        return analytics.logAddToCart(
          currency: currency is String ? currency : null,
          value: value is num ? value.toDouble() : null,
          items: parseItems(items),
          parameters: parameters,
        );

      case Events.logAddToWishlist:
        final currency = x[EventFields.currency];
        final value = x[EventFields.value];
        final items = x[EventFields.items];
        return analytics.logAddToWishlist(
          currency: currency is String ? currency : null,
          value: value is num ? value.toDouble() : null,
          items: parseItems(items),
          parameters: parameters,
        );

      case Events.logAppOpen:
        return analytics.logAppOpen(parameters: parameters);

      case Events.logBeginCheckout:
        final coupon = x[EventFields.coupon];
        final currency = x[EventFields.currency];
        final value = x[EventFields.value];
        final items = x[EventFields.items];
        return analytics.logBeginCheckout(
          coupon: coupon is String ? coupon : null,
          currency: currency is String ? currency : null,
          value: value is num ? value.toDouble() : null,
          items: parseItems(items),
          parameters: parameters,
        );

      case Events.logCampaignDetails:
        final source = x[EventFields.source];
        final medium = x[EventFields.medium];
        final campaign = x[EventFields.campaign];
        if (source is! String || medium is! String || campaign is! String) {
          return;
        }
        return analytics.logCampaignDetails(
          source: source,
          medium: medium,
          campaign: campaign,
          parameters: parameters,
        );

      case Events.logEarnVirtualCurrency:
        final virtualCurrencyName = x[EventFields.virtualCurrencyName];
        final value = x[EventFields.value];
        if (virtualCurrencyName is! String || value is! num) return;
        return analytics.logEarnVirtualCurrency(
          virtualCurrencyName: virtualCurrencyName,
          value: value,
          parameters: parameters,
        );

      case Events.logGenerateLead:
        final currency = x[EventFields.currency];
        final value = x[EventFields.value];
        return analytics.logGenerateLead(
          currency: currency is String ? currency : null,
          value: value is num ? value.toDouble() : null,
          parameters: parameters,
        );

      case Events.logJoinGroup:
        final groupId = x[EventFields.groupId];
        if (groupId is! String) return;
        return analytics.logJoinGroup(groupId: groupId, parameters: parameters);

      case Events.logLogin:
        final loginMethod = x[EventFields.loginMethod];
        return analytics.logLogin(
          loginMethod: loginMethod is String ? loginMethod : null,
          parameters: parameters,
        );

      case Events.logLevelEnd:
        final levelName = x[EventFields.levelName];
        final success = x[EventFields.success];
        if (levelName is! String || success is! num) return;
        return analytics.logLevelEnd(
          levelName: levelName,
          success: success.toInt(),
          parameters: parameters,
        );

      case Events.logLevelStart:
        final levelName = x[EventFields.levelName];
        if (levelName is! String) return;
        return analytics.logLevelStart(
          levelName: levelName,
          parameters: parameters,
        );

      case Events.logLevelUp:
        final level = x[EventFields.level];
        if (level is! num) return;
        final character = x[EventFields.character];
        return analytics.logLevelUp(
          level: level.toInt(),
          character: character is String ? character : null,
          parameters: parameters,
        );

      case Events.logPostScore:
        final score = x[EventFields.score];
        final level = x[EventFields.level];
        if (score is! num || level is! num) return;
        final character = x[EventFields.character];
        return analytics.logPostScore(
          score: score.toInt(),
          level: level.toInt(),
          character: character is String ? character : null,
          parameters: parameters,
        );

      case Events.logPurchase:
        final transactionId = x[EventFields.transactionId];
        final affiliation = x[EventFields.affiliation];
        final currency = x[EventFields.currency];
        final coupon = x[EventFields.coupon];
        final value = x[EventFields.value];
        final tax = x[EventFields.tax];
        final shipping = x[EventFields.shipping];
        final items = x[EventFields.items];
        return analytics.logPurchase(
          transactionId: transactionId is String ? transactionId : null,
          affiliation: affiliation is String ? affiliation : null,
          currency: currency is String ? currency : null,
          coupon: coupon is String ? coupon : null,
          value: value is num ? value.toDouble() : null,
          tax: tax is num ? tax.toDouble() : null,
          shipping: shipping is num ? shipping.toDouble() : null,
          items: parseItems(items),
          parameters: parameters,
        );

      case Events.logRefund:
        final transactionId = x[EventFields.transactionId];
        final currency = x[EventFields.currency];
        final value = x[EventFields.value];
        final items = x[EventFields.items];
        return analytics.logRefund(
          transactionId: transactionId is String ? transactionId : null,
          currency: currency is String ? currency : null,
          value: value is num ? value.toDouble() : null,
          items: parseItems(items),
          parameters: parameters,
        );

      case Events.logRemoveFromCart:
        final currency = x[EventFields.currency];
        final value = x[EventFields.value];
        final items = x[EventFields.items];
        return analytics.logRemoveFromCart(
          currency: currency is String ? currency : null,
          value: value is num ? value.toDouble() : null,
          items: parseItems(items),
          parameters: parameters,
        );

      case Events.logScreenView:
        final screenName = x[EventFields.screenName];
        final screenClass = x[EventFields.screenClass];
        return analytics.logScreenView(
          screenName: screenName is String ? screenName : null,
          screenClass: screenClass is String ? screenClass : null,
          parameters: parameters,
        );

      case Events.logSearch:
        final searchTerm = x[EventFields.searchTerm];
        if (searchTerm is! String) return;
        return analytics.logSearch(
          searchTerm: searchTerm,
          parameters: parameters,
        );

      case Events.logSelectContent:
        final contentType = x[EventFields.contentType];
        final itemId = x[EventFields.itemId];
        if (contentType is! String || itemId is! String) return;
        return analytics.logSelectContent(
          contentType: contentType,
          itemId: itemId,
          parameters: parameters,
        );

      case Events.logSelectItem:
        final itemListId = x[EventFields.itemListId];
        final itemListName = x[EventFields.itemListName];
        final items = x[EventFields.items];
        return analytics.logSelectItem(
          itemListId: itemListId is String ? itemListId : null,
          itemListName: itemListName is String ? itemListName : null,
          items: parseItems(items),
          parameters: parameters,
        );

      case Events.logSelectPromotion:
        final promotionId = x[EventFields.promotionId];
        final promotionName = x[EventFields.promotionName];
        final items = x[EventFields.items];
        return analytics.logSelectPromotion(
          promotionId: promotionId is String ? promotionId : null,
          promotionName: promotionName is String ? promotionName : null,
          items: parseItems(items),
          parameters: parameters,
        );

      case Events.logShare:
        final contentType = x[EventFields.contentType];
        final itemId = x[EventFields.itemId];
        final method = x[EventFields.method];
        if (contentType is! String || itemId is! String || method is! String) {
          return;
        }
        return analytics.logShare(
          contentType: contentType,
          itemId: itemId,
          method: method,
          parameters: parameters,
        );

      case Events.logSignUp:
        final signUpMethod = x[EventFields.signUpMethod];
        if (signUpMethod is! String) return;
        return analytics.logSignUp(
          signUpMethod: signUpMethod,
          parameters: parameters,
        );

      case Events.logSpendVirtualCurrency:
        final itemName = x[EventFields.itemName];
        final virtualCurrencyName = x[EventFields.virtualCurrencyName];
        final value = x[EventFields.value];
        if (itemName is! String ||
            virtualCurrencyName is! String ||
            value is! num) {
          return;
        }
        return analytics.logSpendVirtualCurrency(
          itemName: itemName,
          virtualCurrencyName: virtualCurrencyName,
          value: value,
          parameters: parameters,
        );

      case Events.logTutorialBegin:
        return analytics.logTutorialBegin(parameters: parameters);

      case Events.logTutorialComplete:
        return analytics.logTutorialComplete(parameters: parameters);

      case Events.logUnlockAchievement:
        final id = x[EventFields.id];
        if (id is! String) return;
        return analytics.logUnlockAchievement(id: id, parameters: parameters);

      case Events.logViewCart:
        final currency = x[EventFields.currency];
        final value = x[EventFields.value];
        final items = x[EventFields.items];
        return analytics.logViewCart(
          currency: currency is String ? currency : null,
          value: value is num ? value.toDouble() : null,
          items: parseItems(items),
          parameters: parameters,
        );

      case Events.logViewItem:
        final currency = x[EventFields.currency];
        final value = x[EventFields.value];
        final items = x[EventFields.items];
        return analytics.logViewItem(
          currency: currency is String ? currency : null,
          value: value is num ? value.toDouble() : null,
          items: parseItems(items),
          parameters: parameters,
        );

      case Events.logViewItemList:
        final itemListId = x[EventFields.itemListId];
        final itemListName = x[EventFields.itemListName];
        final items = x[EventFields.items];
        return analytics.logViewItemList(
          itemListId: itemListId is String ? itemListId : null,
          itemListName: itemListName is String ? itemListName : null,
          items: parseItems(items),
          parameters: parameters,
        );

      case Events.logViewPromotion:
        final promotionId = x[EventFields.promotionId];
        final promotionName = x[EventFields.promotionName];
        final items = x[EventFields.items];
        return analytics.logViewPromotion(
          promotionId: promotionId is String ? promotionId : null,
          promotionName: promotionName is String ? promotionName : null,
          items: parseItems(items),
          parameters: parameters,
        );

      case Events.logViewSearchResults:
        final searchTerm = x[EventFields.searchTerm];
        if (searchTerm is! String) return;
        return analytics.logViewSearchResults(
          searchTerm: searchTerm,
          parameters: parameters,
        );
      default:
        return analytics.logEvent(
          name: event.name,
          parameters: parameters ?? event.props,
        );
    }
  }
}
