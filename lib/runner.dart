import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_andomie/utils/configs.dart';
import 'package:flutter_andomie/utils/hit_logger.dart';
import 'package:flutter_androssy_dialogs/dialogs.dart';

import 'app/constants/configs.dart';
import 'firebase_options.dart';
import 'roots/_imports.dart';
import 'roots/services/analytics.dart';
import 'roots/services/unique_id.dart';

const kAssetsPreloads = <String>[];
final Map<String, DialogConfigBuilder<DialogConfig>> kDialogConfigs = const {};

Future<void> _initFirebase() {
  return Analytics.call("firebase_init", msg: "_initFirebase", () async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  });
}

Future<void> _initHitLogger() async {
  if (!ConfigsConstants.hitLogger) return;
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
  return Analytics.call("unique_id", msg: "_initUniqueId", () async {
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
