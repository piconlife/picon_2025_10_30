import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class DeviceSettings {
  DeviceSettings._();

  static Future<bool> open({
    required Future<bool> Function() check,
    Future<void> Function()? open,
  }) async {
    final completer = Completer<bool>();
    late final _DeviceSettingsObserver observer;

    observer = _DeviceSettingsObserver(
      onResumed: () async {
        if (completer.isCompleted) return;
        try {
          if (!kIsWeb && Platform.isIOS) {
            await Future.delayed(const Duration(milliseconds: 600));
          }
          final result = await check();
          completer.complete(result);
        } catch (_) {
          completer.complete(false);
        } finally {
          observer.stop();
        }
      },
    );

    observer.start();

    if (open != null) {
      await open();
    } else {
      await openAppSettings();
    }

    return completer.future;
  }
}

// ---------------------------------------------------------------------------

class _DeviceSettingsObserver with WidgetsBindingObserver {
  _DeviceSettingsObserver({required this.onResumed});

  final Future<void> Function() onResumed;
  bool _wentToBackground = false;

  void start() => WidgetsBinding.instance.addObserver(this);

  void stop() => WidgetsBinding.instance.removeObserver(this);

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      _wentToBackground = true;
    }
    if (state == AppLifecycleState.resumed && _wentToBackground) {
      _wentToBackground = false;
      onResumed();
    }
  }
}
