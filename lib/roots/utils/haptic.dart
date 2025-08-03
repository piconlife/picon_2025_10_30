import 'package:flutter/services.dart';
import 'package:flutter_andomie/utils/configs.dart';
import 'package:flutter_andomie/utils/settings.dart';

import '../services/haptic.dart';
import 'platform.dart';

const kHapticOn = "haptic_mode";

bool get isHapticOn {
  return Settings.get(kHapticOn, Configs.get(kHapticOn, defaultValue: true));
}

class Haptics {
  const Haptics._();

  static void soft() {
    if (!isHapticOn) return;
    if (isAndroid) {
      HapticFeedback.lightImpact();
    } else {
      HapticService.impactFeedback(HapticStyle.light, 1.0);
    }
  }

  static void light() {
    if (isAndroid) {
      HapticFeedback.lightImpact();
    } else {
      HapticFeedback.selectionClick();
    }
  }

  static void medium() {
    if (isAndroid) {
      HapticFeedback.lightImpact();
    } else {
      HapticFeedback.mediumImpact();
    }
  }

  static void hard() {
    if (isAndroid) {
      HapticFeedback.lightImpact();
    } else {
      HapticService.impactFeedback(HapticStyle.hard, 1);
    }
  }
}
