import 'package:flutter/services.dart';

class HapticService {
  static const MethodChannel _channel = MethodChannel('haptic');

  // Impact feedback with style and intensity (0.0 to 1.0)
  static Future<void> impactFeedback(String style, double intensity) async {
    await _channel.invokeMethod('impactFeedback', {
      'style': style, // light, medium, heavy
      'intensity': intensity, // 0.0 to 1.0
    });
  }

  // Notification feedback (success, warning, error)
  static Future<void> notificationFeedback(String type) async {
    await _channel.invokeMethod('notificationFeedback', {'type': type});
  }

  // Selection feedback for UI interactions
  static Future<void> selectionFeedback() async {
    await _channel.invokeMethod('selectionFeedback');
  }
}
