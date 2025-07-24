import 'dart:async';

import 'package:in_app_purchaser/in_app_purchaser.dart';

import '../../roots/helpers/user.dart';

Map<String, IPackage> _purchased = {};
StreamController<String> controller = StreamController();

class IPackage {
  final String? id;
  final String? testingId;
  final String? title;
  final String? subtitle;
  final String? prettyPrice;
  final String? currency;
  final String? currencySign;
  final double? price;
  final double? discount;

  const IPackage({
    this.id,
    this.testingId,
    this.title,
    this.subtitle,
    this.price,
    this.currency,
    this.currencySign,
    this.discount,
    this.prettyPrice,
  });
}

class InAppPurchaseDelegate extends PurchaseDelegate<IPackage> {
  @override
  String get apiKey => '';

  @override
  String get uid => UserHelper.uid;

  @override
  Stream<Object?> get stream => controller.stream;

  @override
  Future<bool> checkStatus(Object data) async {
    await Future.delayed(Duration(seconds: 5));
    if (data is! String) return false;
    return _purchased.containsKey(data);
  }

  @override
  Future<InAppOffering<IPackage>> fetchOtoPackages() async {
    await Future.delayed(Duration(seconds: 5));
    final packages = <IPackage>[
      IPackage(
        id: 'yearly',
        title: 'Yearly',
        subtitle: '\$90.00',
        price: 9.99,
        prettyPrice: '\$9.99',
        currency: '\$',
      ),
    ];
    return InAppOffering(id: "oto", products: packages);
  }

  @override
  Future<InAppOffering<IPackage>> fetchPackages() async {
    await Future.delayed(Duration(seconds: 5));
    final packages = <IPackage>[
      IPackage(
        id: 'monthly',
        title: 'Monthly',
        subtitle: 'with 7 days free trial',
        price: 3.99,
        prettyPrice: '\$3.99',
        currency: '\$',
      ),
      IPackage(
        id: 'yearly',
        title: 'Yearly',
        subtitle: '\$90.00',
        price: 9.99,
        discount: 90,
        prettyPrice: '\$9.99',
        currency: '\$',
      ),
    ];
    return InAppOffering(id: "default", products: packages);
  }

  @override
  Iterable<String> filterAbTestingIds(InAppOffering<IPackage> offering) {
    return offering.products.map((e) => e.testingId).whereType();
  }

  @override
  Future<Object?> identify(String uid) async {
    return UserHelper.uid;
  }

  @override
  Future<void> init() async {}

  @override
  Future<void> initAdjustSdk() async {}

  @override
  Future<void> initFacebookSdk() async {}

  @override
  Future<void> logShow(String id) async {}

  @override
  Future<void> logout() async {}

  @override
  Iterable<InAppPackage> parsePackages(Iterable<IPackage> packages) {
    return packages.map((e) {
      return InAppPackage(
        id: e.id,
        plan: e.title,
        body: e.subtitle,
        details: null,
        price: e.price,
        priceString: e.prettyPrice,
        discount: e.discount,
        currency: e.currency,
        raw: e,
      );
    });
  }

  @override
  Future<Object?> purchase(IPackage raw) async {
    await Future.delayed(Duration(seconds: 3));
    _purchased[uid] = raw;
    return _purchased[uid];
  }

  @override
  Future<Object?> restore() async {
    await Future.delayed(Duration(seconds: 3));
    return _purchased[uid];
  }

  @override
  Future<void> update() async {}
}
