import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:in_app_analytics/analytics.dart';

import '../data/delegates/cache.dart' show CacheDelegate;
import '../data/delegates/connectivity.dart' show ConnectivityDelegate;
import '../firebase_options.dart';
import '../packages/data_management.dart' show DM;
import 'utils/secret_code.dart';

Future<void> _initFirebase() async {
  await Analytics.callAsync(name: "firebase", reason: "init", () {
    return Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  });
  // await Analytics.callAsync(name: "firebase_parent", reason: "init", () {
  //   return Firebase.initializeApp(
  //     name: "parent",
  //     options: ParentFirebaseOptions.currentPlatform,
  //   );
  // });
}

void _initConnectivity() {
  DM.i.configure(cache: CacheDelegate(), connectivity: ConnectivityDelegate());
}

void _initSecretCode() {
  Analytics.call(name: "secret_code", reason: "init", () {
    SecretCode.init("techpek");
  });
}

Future<void> onInit() async {
  await _initFirebase();
  _initConnectivity();
  _initSecretCode();
}

Future<void> onReady(BuildContext context) async {}

Future<void> onDispose() async {}
