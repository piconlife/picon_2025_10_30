import 'package:flutter/services.dart';

enum HapticStyle { light, medium, hard }

enum NotificationFeedbackType { success, warning, error }

class HapticService {
  static const MethodChannel _channel = MethodChannel('haptic');

  // Impact feedback with style and intensity (0.0 to 1.0)
  static Future<void> impactFeedback(
    HapticStyle style,
    double intensity,
  ) async {
    await _channel.invokeMethod('impactFeedback', {
      'style': style.name, // 'light', 'medium', 'heavy'
      'intensity': intensity, // 0.0 to 1.0
    });
  }

  // Notification feedback (success, warning, error)
  static Future<void> notificationFeedback(
    NotificationFeedbackType type,
  ) async {
    await _channel.invokeMethod('notificationFeedback', {'type': type.name});
  }

  // Selection feedback for UI interactions
  static Future<void> selectionFeedback() async {
    await _channel.invokeMethod('selectionFeedback');
  }
}
