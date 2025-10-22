import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SystemUi {
  const SystemUi._();

  static bool isLandscape(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.landscape;
  }

  static Future<void> toggleOrientation(BuildContext context) {
    if (isLandscape(context)) {
      return setOrientation(Orientation.portrait);
    } else {
      return setOrientation(Orientation.landscape);
    }
  }

  static Future<void> setOrientation(Orientation orientation) async {
    try {
      await SystemChrome.setEnabledSystemUIMode(
        orientation == Orientation.landscape
            ? SystemUiMode.immersiveSticky
            : SystemUiMode.edgeToEdge,
      );
      await SystemChrome.setPreferredOrientations(
        orientation == Orientation.landscape
            ? [
              DeviceOrientation.landscapeLeft,
              DeviceOrientation.landscapeRight,
            ]
            : [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown],
      );
    } catch (_) {}
  }

  static Future<void> resetOrientation() async {
    await SystemChrome.setPreferredOrientations(DeviceOrientation.values);
    await SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: SystemUiOverlay.values,
    );
  }

  static void hideStatusBar() {
    try {
      hideSystemOverlays(SystemUiOverlay.values..remove(SystemUiOverlay.top));
    } catch (_) {}
  }

  static void showStatusBar() {
    try {
      hideSystemOverlays(SystemUiOverlay.values..add(SystemUiOverlay.top));
    } catch (_) {}
  }

  static void hideNavigationBar() {
    try {
      hideSystemOverlays(
        SystemUiOverlay.values..remove(SystemUiOverlay.bottom),
      );
    } catch (_) {}
  }

  static void showNavigationBar() {
    try {
      hideSystemOverlays(SystemUiOverlay.values..add(SystemUiOverlay.bottom));
    } catch (_) {}
  }

  static void hideSystemOverlays([List<SystemUiOverlay> overlays = const []]) {
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: overlays,
    );
  }
}
