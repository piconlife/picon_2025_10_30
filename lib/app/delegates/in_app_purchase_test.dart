import 'package:in_app_purchaser/in_app_purchaser.dart';

class TestInAppPurchaseDelegate extends InAppPurchaseDelegate {
  @override
  Future<void> init(String? uid) async {}

  @override
  Future<void> initAdjustSdk() async {}

  @override
  Future<void> initFacebookSdk() async {}

  @override
  Future<void> login(String uid) async {}

  @override
  Future<void> logout() async {}

  @override
  Future<InAppPurchaseOffering> offering(String placement) async {
    return InAppPurchaseOffering(
      id: '${placement}_test',
      products: [
        InAppPurchaseProduct(id: "yearly", price: 4200, currencyCode: "BDT"),
        InAppPurchaseProduct(id: "monthly", price: 1400, currencyCode: "BDT"),
      ],
    );
  }

  @override
  Future<InAppPurchaseProfile> profile(Object? raw) async {
    return InAppPurchaseProfile(
      profileId: '',
      customAttributes: {},
      accessLevels: {},
      subscriptions: {},
      nonSubscriptions: {},
      isTestUser: true,
    );
  }

  @override
  Future<InAppPurchaseResult> purchase(InAppPurchaseProduct product) async {
    return InAppPurchaseResultInvalid();
  }

  @override
  Future<InAppPurchaseProfile?> restore() async {
    return null;
  }

  @override
  Stream<InAppPurchaseProfile> get stream {
    return Stream.value(null).asyncMap(profile);
  }
}
