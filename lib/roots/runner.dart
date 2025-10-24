import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_andomie/utils/hit_logger.dart';
import 'package:flutter_androssy_dialogs/dialogs.dart';
import 'package:in_app_analytics/analytics.dart';
import 'package:in_app_configs/configs.dart';
import 'package:object_finder/object_finder.dart';

import '../app/configs/local.dart';
import '../app/interfaces/bsd_audience.dart';
import '../app/interfaces/bsd_privacy.dart';
import '../app/interfaces/dialog_big_photo.dart';
import '../data/enums/audience.dart';
import '../data/enums/privacy.dart';
import '../features/channel/view/dialogs/bsd_metube_format.dart';
import '../features/shop/view/dialogs/bsd_market_format.dart';
import '../features/shore/view/dialogs/bsd_grocery_format.dart';
import '../features/social/view/dialogs/bsd_feed_format.dart';
import '../features/startup/views/dialogs/auth_biometric_permission.dart';
import '../firebase_options.dart';
import '_imports.dart';
import 'services/unique_id.dart';

const kAssetsPreloads = <String>[];
final Map<String, DialogConfigBuilder<DialogConfig>> kDialogConfigs = {
  kBigPhotoDialogKey: (context) {
    return DialogConfig(
      builder: (context, content) {
        return InAppBigPhotoDialog(content.args);
      },
    );
  },
  kBiometricPermissionDialogKey: (context) {
    return DialogConfig(
      position: AndrossyDialogPosition.center,
      builder: (context, content) {
        return const InAppBiometricPermissionDialog();
      },
    );
  },
  "feed_format_bsd": (context) {
    return DialogConfig(
      position: AndrossyDialogPosition.bottom,
      builder: (context, content) {
        return const InAppFeedFormatBSD();
      },
    );
  },
  "grocery_format_bsd": (context) {
    return DialogConfig(
      position: AndrossyDialogPosition.bottom,
      builder: (context, content) {
        return const GroceryFormatBSD();
      },
    );
  },
  "market_format_bsd": (context) {
    return DialogConfig(
      position: AndrossyDialogPosition.bottom,
      builder: (context, content) {
        return const MarketFormatBSD();
      },
    );
  },
  "metube_format_bsd": (context) {
    return DialogConfig(
      position: AndrossyDialogPosition.bottom,
      builder: (context, content) {
        return const MetubeFormatBSD();
      },
    );
  },
  "audience_bsd": (context) {
    return DialogConfig(
      position: AndrossyDialogPosition.bottom,
      builder: (context, content) {
        return AudienceBSD(
          audience: content.args.find(defaultValue: Audience.everyone),
        );
      },
    );
  },
  "privacy_bsd": (context) {
    return DialogConfig(
      position: AndrossyDialogPosition.bottom,
      builder: (context, content) {
        return PrivacyBSD(
          privacy: content.args.find(defaultValue: Privacy.everyone),
        );
      },
    );
  },
};

Future<void> _initFirebase() {
  return Analytics.callAsync(
    name: "firebase_init",
    msg: "_initFirebase",
    () async {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    },
  );
}

Future<void> _initHitLogger() async {
  if (!LocalConfigs.hitLogger) return;
  HitLogger.init(
    onClientCheck: (value) {
      return true;
    },
    onClientListen: (value) {
      log(value.toString());
    },
  );
}

Future<void> _initUniqueId() {
  return Analytics.callAsync(name: "unique_id", msg: "_initUniqueId", () async {
    if (Configs.get("application/firebase_app", defaultValue: false)) return;
    await UniqueIdService.init();
  });
}

Future<void> runRoot(Widget app) async {
  runApp(
    Root(
      app: app,
      onInit: () async {
        await _initHitLogger();
        await _initUniqueId();
        await _initFirebase();
      },
    ),
  );
}
