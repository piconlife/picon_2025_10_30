import 'dart:developer' as dev;
import 'dart:ui';

import 'package:flutter/foundation.dart';

class Analytics {
  const Analytics._();

  static void _log(msg, {String? name, bool show = true}) {
    if (!show) return;
    dev.log("$name:$msg", name: "ANALYTICS");
  }

  static void init({
    bool enabled = kReleaseMode,
    FlutterExceptionHandler? widgetError,
    ErrorCallback? platformError,
  }) {
    if (!enabled) return;
    if (widgetError != null) {
      FlutterError.onError = widgetError;
    }
    if (platformError != null) {
      PlatformDispatcher.instance.onError = platformError;
    }
  }

  static Future<void> call(
    String name,
    AsyncCallback callback, {
    bool show = true,
    String? msg,
  }) async {
    try {
      await callback();
      if (msg != null && msg.isNotEmpty) _log(msg, show: show, name: name);
    } catch (msg) {
      _log(msg, show: show, name: name);
    }
  }

  static void log(
    String name, {
    String? msg,
    Map<String, dynamic>? args,
    bool show = true,
  }) async {
    try {
      if (msg != null && msg.isNotEmpty) _log(msg, show: show, name: name);
    } catch (msg) {
      _log(msg, show: show, name: name);
    }
  }
}
