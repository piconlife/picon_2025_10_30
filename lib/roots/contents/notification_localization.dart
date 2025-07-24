import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter_andomie/extensions.dart';

class InAppNotificationLocalization {
  static NotificationLocalization? tryParseLocalization(Object? source) {
    if (source == null) return null;
    if (source is NotificationLocalization) return source;
    if (source is! Map) return null;
    String? title = source.getOrNull("title");
    title = title.verified;

    String? body = source.getOrNull("body");
    body = body.verified;

    String? summary = source.getOrNull("summary");
    summary = summary.verified;

    String? largeIcon = source.getOrNull("large_icon");
    largeIcon ??= source.getOrNull("largeIcon");
    largeIcon = largeIcon.verified;

    String? bigPicture = source.getOrNull("big_picture");
    bigPicture ??= source.getOrNull("bigPicture");
    bigPicture = bigPicture.verified;

    Map<String, String>? buttonLabels = source.getOrNull("button_labels");
    buttonLabels ??= source.getOrNull("buttonLabels");
    buttonLabels = buttonLabels.verified as Map<String, String>;

    return NotificationLocalization(
      title: title,
      body: body,
      summary: summary,
      largeIcon: largeIcon,
      bigPicture: bigPicture,
      buttonLabels: buttonLabels,
    );
  }

  static Map<String, NotificationLocalization>? tryParseLocalizations(
    Object? source,
  ) {
    if (source == null) return null;
    if (source is Map<String, NotificationLocalization>) return source;
    if (source is! Map) return null;
    final entries = source.entries.map((e) {
      final value = tryParseLocalization(e.value);
      if (e.key is! String || value == null) return null;
      return value;
    }).whereType<MapEntry<String, NotificationLocalization>>();
    if (entries.isEmpty) return null;
    return Map.fromEntries(entries);
  }
}
