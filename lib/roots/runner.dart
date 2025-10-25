import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:in_app_analytics/analytics.dart';

import '../app/delegates/in_app_analytics.dart';
import '../app/initializer.dart';
import '_imports.dart';

void _initAnalytics() {
  Analytics.init(delegate: InAppAnalyticsDelegate());
}

Future<void> run([Widget? app]) async {
  _initAnalytics();
  final binding = WidgetsFlutterBinding.ensureInitialized();
  Analytics.call(name: "native_splash", reason: "preserve", () {
    FlutterNativeSplash.preserve(widgetsBinding: binding);
  });
  runApp(
    Root(app: app, onInit: onInit, onReady: onReady, onDispose: onDispose),
  );
}
