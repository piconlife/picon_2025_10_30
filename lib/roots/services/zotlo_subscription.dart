import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class ZotloProfile {
  final String? status;
  final String? realStatus;
  final String? subscriberId;
  final int? subscriptionId;
  final String? subscriptionType;
  final DateTime? startDate;
  final DateTime? expireDate;
  final DateTime? renewalDate;
  final DateTime? freezeEndDate;
  final String? package;
  final String? country;
  final String? phoneNumber;
  final String? language;
  final String? originalTransactionId;
  final String? lastTransactionId;
  final String? subscriptionPackageType;
  final String? cancellation;
  final ZotloCustomParameters? customParameters;
  final int? quantity;
  final int? pendingQuantity;
  final int? renewalFetchCount;

  const ZotloProfile({
    this.status,
    this.realStatus,
    this.subscriberId,
    this.subscriptionId,
    this.subscriptionType,
    this.startDate,
    this.expireDate,
    this.renewalDate,
    this.package,
    this.country,
    this.phoneNumber,
    this.language,
    this.originalTransactionId,
    this.lastTransactionId,
    this.subscriptionPackageType,
    this.cancellation,
    this.customParameters,
    this.quantity,
    this.pendingQuantity,
    this.renewalFetchCount,
    this.freezeEndDate,
  });

  factory ZotloProfile.fromJson(Map<String, dynamic> json) {
    return ZotloProfile(
      status: json["status"],
      realStatus: json["realStatus"],
      subscriberId: json["subscriberId"],
      subscriptionId: json["subscriptionId"],
      subscriptionType: json["subscriptionType"],
      startDate:
          json["startDate"] == null ? null : DateTime.parse(json["startDate"]),
      expireDate:
          json["expireDate"] == null
              ? null
              : DateTime.parse(json["expireDate"]),
      renewalDate:
          json["renewalDate"] == null
              ? null
              : DateTime.parse(json["renewalDate"]),
      freezeEndDate:
          json["freezeEndDate"] == null
              ? null
              : DateTime.parse(json["freezeEndDate"]),
      package: json["package"],
      country: json["country"],
      phoneNumber: json["phoneNumber"],
      language: json["language"],
      originalTransactionId: json["originalTransactionId"],
      lastTransactionId: json["lastTransactionId"],
      subscriptionPackageType: json["subscriptionPackageType"],
      cancellation: json["cancellation"],
      customParameters:
          json["customParameters"] == null
              ? null
              : ZotloCustomParameters.fromJson(json["customParameters"]),
      quantity: json["quantity"],
      pendingQuantity: json["pendingQuantity"],
      renewalFetchCount: json["renewalFetchCount"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "status": status,
      "realStatus": realStatus,
      "subscriberId": subscriberId,
      "subscriptionId": subscriptionId,
      "subscriptionType": subscriptionType,
      "startDate": startDate?.toIso8601String(),
      "expireDate": expireDate?.toIso8601String(),
      "renewalDate": renewalDate?.toIso8601String(),
      "package": package,
      "country": country,
      "phoneNumber": phoneNumber,
      "language": language,
      "originalTransactionId": originalTransactionId,
      "lastTransactionId": lastTransactionId,
      "subscriptionPackageType": subscriptionPackageType,
      "cancellation": cancellation,
      "customParameters": customParameters?.toJson(),
      "quantity": quantity,
      "pendingQuantity": pendingQuantity,
      "renewalFetchCount": renewalFetchCount,
      "freezeEndDate": freezeEndDate,
    };
  }
}

class ZotloPackage {
  final String? packageId;
  final double? price;
  final String? currency;
  final String? packageType;
  final String? name;
  final String? subscriptionPackageType;
  final List<dynamic>? bundlePackages;

  const ZotloPackage({
    this.packageId,
    this.price,
    this.currency,
    this.packageType,
    this.name,
    this.subscriptionPackageType,
    this.bundlePackages,
  });

  factory ZotloPackage.fromJson(Map<String, dynamic> json) {
    return ZotloPackage(
      packageId: json["packageId"],
      price: json["price"]?.toDouble(),
      currency: json["currency"],
      packageType: json["packageType"],
      name: json["name"],
      subscriptionPackageType: json["subscriptionPackageType"],
      bundlePackages:
          json["bundlePackages"] == null
              ? []
              : List<dynamic>.from(json["bundlePackages"]!.map((x) => x)),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "packageId": packageId,
      "price": price,
      "currency": currency,
      "packageType": packageType,
      "name": name,
      "subscriptionPackageType": subscriptionPackageType,
      "bundlePackages":
          bundlePackages == null
              ? []
              : List<dynamic>.from(bundlePackages!.map((x) => x)),
    };
  }
}

class ZotloCard {
  final String? cardNumber;
  final String? expireDate;
  final int? tokenId;

  const ZotloCard({this.cardNumber, this.expireDate, this.tokenId});

  factory ZotloCard.fromJson(Map<String, dynamic> json) {
    return ZotloCard(
      cardNumber: json["cardNumber"],
      expireDate: json["expireDate"],
      tokenId: json["tokenId"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "cardNumber": cardNumber,
      "expireDate": expireDate,
      "tokenId": tokenId,
    };
  }
}

class ZotloCustomer {
  final String? fullName;
  final String? address;
  final String? subscriberId;

  const ZotloCustomer({this.fullName, this.address, this.subscriberId});

  factory ZotloCustomer.fromJson(Map<String, dynamic> json) {
    return ZotloCustomer(
      fullName: json["fullName"],
      address: json["address"],
      subscriberId: json["subscriberId"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "fullName": fullName,
      "address": address,
      "subscriberId": subscriberId,
    };
  }
}

class ZotloResult {
  final ZotloProfile? profile;
  final ZotloPackage? package;
  final ZotloPackage? newPackage;
  final ZotloCard? card;
  final ZotloCustomer? customer;

  const ZotloResult({
    this.profile,
    this.package,
    this.newPackage,
    this.card,
    this.customer,
  });

  factory ZotloResult.fromJson(Map<String, dynamic> json) {
    return ZotloResult(
      profile:
          json["profile"] == null
              ? null
              : ZotloProfile.fromJson(json["profile"]),
      package:
          json["package"] == null
              ? null
              : ZotloPackage.fromJson(json["package"]),
      newPackage:
          json["newPackage"] == null
              ? null
              : ZotloPackage.fromJson(json["newPackage"]),
      card: json["card"] == null ? null : ZotloCard.fromJson(json["card"]),
      customer:
          json["customer"] == null
              ? null
              : ZotloCustomer.fromJson(json["customer"]),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "profile": profile?.toJson(),
      "package": package?.toJson(),
      "newPackage": newPackage?.toJson(),
      "card": card?.toJson(),
      "customer": customer?.toJson(),
    };
  }
}

class ZotloInvoice {
  final String? invoiceName;
  final String? invoiceProductTitle;
  final int? invoiceStatus;
  final bool? receiptStatus;
  final String? documentType;

  const ZotloInvoice({
    this.invoiceName,
    this.invoiceProductTitle,
    this.invoiceStatus,
    this.receiptStatus,
    this.documentType,
  });

  factory ZotloInvoice.fromJson(Map<String, dynamic> json) {
    return ZotloInvoice(
      invoiceName: json["invoiceName"],
      invoiceProductTitle: json["invoiceProductTitle"],
      invoiceStatus: json["invoiceStatus"],
      receiptStatus: json["receiptStatus"],
      documentType: json["documentType"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "invoiceName": invoiceName,
      "invoiceProductTitle": invoiceProductTitle,
      "invoiceStatus": invoiceStatus,
      "receiptStatus": receiptStatus,
      "documentType": documentType,
    };
  }
}

class ZotloDataWarehouse {
  final String? paymentModule;
  final int? siteId;
  final int? flowId;
  final int? appId;
  final int? teamId;
  final bool? acceptPolicy;
  final String? fullName;

  const ZotloDataWarehouse({
    this.paymentModule,
    this.siteId,
    this.flowId,
    this.appId,
    this.teamId,
    this.acceptPolicy,
    this.fullName,
  });

  factory ZotloDataWarehouse.fromJson(Map<String, dynamic> json) {
    return ZotloDataWarehouse(
      paymentModule: json["paymentModule"],
      siteId: json["siteId"],
      flowId: json["flowId"],
      appId: json["appId"],
      teamId: json["teamId"],
      acceptPolicy: json["acceptPolicy"],
      fullName: json["fullName"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "paymentModule": paymentModule,
      "siteId": siteId,
      "flowId": flowId,
      "appId": appId,
      "teamId": teamId,
      "acceptPolicy": acceptPolicy,
      "fullName": fullName,
    };
  }
}

class ZotloUtm {
  final dynamic source;
  final dynamic medium;
  final dynamic campaign;
  final dynamic term;
  final dynamic content;

  const ZotloUtm({
    this.source,
    this.medium,
    this.campaign,
    this.term,
    this.content,
  });

  factory ZotloUtm.fromJson(Map<String, dynamic> json) {
    return ZotloUtm(
      source: json["source"],
      medium: json["medium"],
      campaign: json["campaign"],
      term: json["term"],
      content: json["content"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "source": source,
      "medium": medium,
      "campaign": campaign,
      "term": term,
      "content": content,
    };
  }
}

class ZotloCompany {
  final String? title;
  final String? address;
  final String? phone;
  final String? email;
  final String? taxNumber;
  final String? taxOffice;

  const ZotloCompany({
    this.title,
    this.address,
    this.phone,
    this.email,
    this.taxNumber,
    this.taxOffice,
  });

  factory ZotloCompany.fromJson(Map<String, dynamic> json) {
    return ZotloCompany(
      title: json["title"],
      address: json["address"],
      phone: json["phone"],
      email: json["email"],
      taxNumber: json["taxNumber"],
      taxOffice: json["taxOffice"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "title": title,
      "address": address,
      "phone": phone,
      "email": email,
      "taxNumber": taxNumber,
      "taxOffice": taxOffice,
    };
  }
}

class ZotloProduct {
  final String? name;
  final String? detail;
  final int? quantity;
  final dynamic trialPrice;
  final String? subTotal;
  final String? vatTotal;
  final double? includeVatTotal;
  final String? pricesCurrency;

  const ZotloProduct({
    this.name,
    this.detail,
    this.quantity,
    this.trialPrice,
    this.subTotal,
    this.vatTotal,
    this.includeVatTotal,
    this.pricesCurrency,
  });

  factory ZotloProduct.fromJson(Map<String, dynamic> json) {
    return ZotloProduct(
      name: json["name"],
      detail: json["detail"],
      quantity: json["quantity"],
      trialPrice: json["trialPrice"],
      subTotal: json["subTotal"],
      vatTotal: json["vatTotal"],
      includeVatTotal: json["includeVatTotal"]?.toDouble(),
      pricesCurrency: json["pricesCurrency"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "detail": detail,
      "quantity": quantity,
      "trialPrice": trialPrice,
      "subTotal": subTotal,
      "vatTotal": vatTotal,
      "includeVatTotal": includeVatTotal,
      "pricesCurrency": pricesCurrency,
    };
  }
}

class ZotloAgreement {
  final ZotloCompany? company;
  final ZotloCustomer? customer;
  final ZotloProduct? product;

  const ZotloAgreement({this.company, this.customer, this.product});

  factory ZotloAgreement.fromJson(Map<String, dynamic> json) {
    return ZotloAgreement(
      company:
          json["company"] == null
              ? null
              : ZotloCompany.fromJson(json["company"]),
      customer:
          json["customer"] == null
              ? null
              : ZotloCustomer.fromJson(json["customer"]),
      product:
          json["product"] == null
              ? null
              : ZotloProduct.fromJson(json["product"]),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "company": company?.toJson(),
      "customer": customer?.toJson(),
      "product": product?.toJson(),
    };
  }
}

class ZotloCustomParameters {
  final ZotloInvoice? invoice;
  final String? clientUuid;
  final ZotloDataWarehouse? dataWarehouse;
  final ZotloUtm? utm;
  final ZotloAgreement? agreement;
  final List<dynamic>? merchantParameters;
  final String? subscriberIpAddress;

  const ZotloCustomParameters({
    this.invoice,
    this.clientUuid,
    this.dataWarehouse,
    this.utm,
    this.agreement,
    this.merchantParameters,
    this.subscriberIpAddress,
  });

  factory ZotloCustomParameters.fromJson(Map<String, dynamic> json) {
    return ZotloCustomParameters(
      invoice:
          json["invoice"] == null
              ? null
              : ZotloInvoice.fromJson(json["invoice"]),
      clientUuid: json["clientUuid"],
      dataWarehouse:
          json["dataWarehouse"] == null
              ? null
              : ZotloDataWarehouse.fromJson(json["dataWarehouse"]),
      utm: json["utm"] == null ? null : ZotloUtm.fromJson(json["utm"]),
      agreement:
          json["agreement"] == null
              ? null
              : ZotloAgreement.fromJson(json["agreement"]),
      merchantParameters:
          json["merchantParameters"] == null
              ? []
              : List<dynamic>.from(json["merchantParameters"]!.map((x) => x)),
      subscriberIpAddress: json["subscriberIpAddress"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "invoice": invoice?.toJson(),
      "clientUuid": clientUuid,
      "dataWarehouse": dataWarehouse?.toJson(),
      "utm": utm?.toJson(),
      "agreement": agreement?.toJson(),
      "merchantParameters":
          merchantParameters == null
              ? []
              : List<dynamic>.from(merchantParameters!.map((x) => x)),
      "subscriberIpAddress": subscriberIpAddress,
    };
  }
}

class ZotloMeta {
  final String? requestId;
  final int? httpStatus;
  final String? errorMessage;
  final String? errorCode;

  const ZotloMeta({
    this.requestId,
    this.httpStatus,
    this.errorMessage,
    this.errorCode,
  });

  factory ZotloMeta.fromJson(Map<String, dynamic> json) {
    return ZotloMeta(
      requestId: json["requestId"],
      httpStatus: json["httpStatus"],
      errorMessage: json["errorMessage"],
      errorCode: json["errorCode"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "requestId": requestId,
      "httpStatus": httpStatus,
      "errorMessage": errorMessage,
      "errorCode": errorCode,
    };
  }
}

class ZotloDetails {
  final ZotloMeta? meta;
  final ZotloResult? result;

  const ZotloDetails({this.meta, this.result});

  factory ZotloDetails.fromJson(Map<String, dynamic> json) {
    final meta = json['meta'];
    final result = json['result'];
    return ZotloDetails(
      meta: meta is! Map<String, dynamic> ? null : ZotloMeta.fromJson(meta),
      result:
          result is! Map<String, dynamic> ? null : ZotloResult.fromJson(result),
    );
  }

  Map<String, dynamic> toJson() {
    return {"meta": meta?.toJson(), "result": result?.toJson()};
  }
}

class ZotloApi {
  final String key;
  final String secret;
  final String? appId;
  final String baseUrl = 'https://api.zotlo.com/v1';

  const ZotloApi({required this.key, required this.secret, this.appId});

  Map<String, String> get _headers {
    return {
      'Content-Type': 'application/json',
      'AccessKey': key,
      'AccessSecret': secret,
      if (appId != null) 'ApplicationId': appId!,
    };
  }

  Future<ZotloDetails?> check({
    required String subscriberId,
    required String packageId,
  }) async {
    try {
      final url = Uri.parse(
        '$baseUrl/subscription/profile?subscriberId=$subscriberId&packageId=$packageId',
      );
      final resp = await http.get(url, headers: _headers);
      return ZotloDetails.fromJson(jsonDecode(resp.body));
    } catch (_) {
      return null;
    }
  }

  bool isActive([DateTime? expireDate]) {
    if (expireDate == null) return false;
    return DateTime.now().isBefore(expireDate);
  }

  Future<bool> isPremium({
    required String subscriberId,
    required String packageId,
  }) async {
    final value = await profile(
      subscriberId: subscriberId,
      packageId: packageId,
    );
    if (value == null) return false;
    return (value.status == 'active' && value.realStatus == 'active');
  }

  Future<ZotloResult?> result({
    required String subscriberId,
    required String packageId,
  }) async {
    return check(subscriberId: subscriberId, packageId: packageId).then((
      value,
    ) {
      return isActive(value?.result?.profile?.expireDate)
          ? value?.result
          : null;
    });
  }

  Future<ZotloProfile?> profile({
    required String subscriberId,
    required String packageId,
  }) {
    return result(subscriberId: subscriberId, packageId: packageId).then((
      value,
    ) {
      return value?.profile;
    });
  }
}

class ZotloService extends ChangeNotifier {
  ZotloService._();

  ZotloApi? _api;
  String? subscriberId;
  Iterable<String> packageIds = [];
  String? _expireDate;

  String? get expireDate {
    return profile?.expireDate?.toIso8601String() ?? _expireDate;
  }

  ZotloApi get api => _api!;

  ZotloDetails? _details;

  ZotloDetails? get details => _details;

  ZotloResult? get result => details?.result;

  ZotloProfile? get profile => result?.profile;

  ZotloCard? get card => result?.card;

  ZotloCustomer? get customer => result?.customer;

  ZotloPackage? get package => result?.package;

  ZotloPackage? get newPackage => result?.newPackage;

  bool initialized = false;

  ValueChanged<String?>? _callback;

  bool get isPremium {
    final raw = expireDate;
    if (raw == null || raw.isEmpty) return false;
    final date = DateTime.tryParse(raw);
    if (date == null) return false;
    return isActive(expireDate: date);
  }

  static ZotloService? _i;

  static ZotloService get i => _i ??= ZotloService._();

  static ZotloService get instance => i;

  static Future<void> init({
    required String key,
    required String secret,
    required Iterable<String> packageIds,
    bool connected = false,
    String? expireDate,
    String? appId,
    String? subscriberId,
    ValueChanged<String?>? onReady,
  }) async {
    i.subscriberId = subscriberId;
    i.packageIds = packageIds;
    i._expireDate = expireDate;
    i._api = ZotloApi(key: key, secret: secret, appId: appId);
    i._callback = onReady;
    i.initialized = true;
    if (connected) await i.load();
  }

  bool isActive({DateTime? expireDate}) {
    expireDate ??= profile?.expireDate;
    if (expireDate == null) return false;
    return DateTime.now().isBefore(expireDate);
  }

  bool isExpiringSoon({
    DateTime? expireDate,
    Duration duration = const Duration(days: 3),
  }) {
    expireDate ??= profile?.expireDate;
    if (expireDate == null) return false;
    return isActive(expireDate: expireDate) &&
        expireDate.difference(DateTime.now()).inMinutes <= duration.inMinutes;
  }

  bool isExpired({DateTime? expireDate}) {
    expireDate ??= profile?.expireDate;
    if (expireDate == null) return false;
    return expireDate.isBefore(DateTime.now());
  }

  Future<void> changeConnection(bool value) async {
    if (!value) return;
    await load();
  }

  Future<void> load() async {
    if (!initialized) return;
    if (subscriberId == null || subscriberId!.isEmpty) return;
    for (String packageId in packageIds) {
      final value = await api.check(
        subscriberId: subscriberId!,
        packageId: packageId,
      );
      if (value == null) continue;
      if (!api.isActive(value.result?.profile?.expireDate)) continue;
      _details = value;
      if (_callback != null) _callback!(expireDate);
      notifyListeners();
      break;
    }
  }

  Future<void> login(String subscriberId) async {
    this.subscriberId = subscriberId;
    await load();
  }

  void logout() {
    _details = null;
    if (_callback != null) _callback!(expireDate);
    notifyListeners();
  }
}

// void main() async {
//   ZotloService.init(
//     key: '829b2e43d70ea0fd28dac625cce43845e8332551c0e5129240',
//     secret:
//         'dw3mdm82o-07a28uot!hy4i_rofcd3x3s-fbovrcgk2d0r890ty@yjombjmbcft-i_u5p0o%#88im74!',
//     appId: '501',
//     packageIds: [
//       'com.madduck.drcal.zotlo.1month1',
//       'com.madduck.drcal.zotlo.1month2',
//       'com.madduck.drcal.zotlo.1month3',
//       'com.madduck.drcal.zotlo.1month',
//     ],
//   );
//   ZotloService.instance.addListener(() {
//     print(ZotloService.i.details?.toJson());
//   });
//   ZotloService.i.login('mohiuddin655.developer@gmail.com');
// }
