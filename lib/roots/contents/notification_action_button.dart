import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter_andomie/extensions.dart';
import 'package:object_finder/object_finder.dart';

import '../services/notification.dart';

class InAppNotificationActionButton {
  static NotificationActionButton? tryParseActionButton(Object? source) {
    if (source == null) return null;
    if (source is NotificationActionButton) return source;
    if (source is! Map) return null;
    String? key = source.getOrNull("key");
    key ??= source.getOrNull("id");
    key = key.verified;

    String? label = source.getOrNull("label");
    label ??= source.getOrNull("text");
    label = label.verified;

    String? actionType = source.getOrNull("type");
    actionType ??= source.getOrNull("action_type");
    actionType ??= source.getOrNull("actionType");
    actionType = actionType.verified;

    bool? autoDismissible = source.getOrNull("dismissible");
    autoDismissible ??= source.getOrNull("auto_dismissible");
    autoDismissible ??= source.getOrNull("autoDismissible");
    autoDismissible = autoDismissible.verified;

    String? color = source.getOrNull("color");
    color = color.verified;

    bool? enabled = source.getOrNull("enabled");
    enabled = enabled.verified;

    String? icon = source.getOrNull("icon");
    icon = icon.verified;

    bool? isAuthenticationRequired = source.getOrNull(
      "is_authentication_required",
    );
    isAuthenticationRequired ??= source.getOrNull("isAuthenticationRequired");
    isAuthenticationRequired = isAuthenticationRequired.verified;

    bool? isDangerousOption = source.getOrNull("is_dangerous_option");
    isDangerousOption ??= source.getOrNull("isDangerousOption");
    isDangerousOption = isDangerousOption.verified;

    bool? requireInputText = source.getOrNull("require_input_text");
    requireInputText ??= source.getOrNull("requireInputText");
    requireInputText = requireInputText.verified;

    bool? showInCompactView = source.getOrNull("show_in_compact_view");
    showInCompactView ??= source.getOrNull("showInCompactView");
    showInCompactView = showInCompactView.verified;

    if (key == null || label == null) return null;
    return NotificationActionButton(
      key: key,
      label: label,
      actionType: ActionType.values.current(actionType, ActionType.Default),
      autoDismissible: autoDismissible ?? true,
      color: color.color,
      enabled: enabled ?? true,
      icon: icon,
      isAuthenticationRequired: isAuthenticationRequired ?? false,
      isDangerousOption: isDangerousOption ?? false,
      requireInputText: requireInputText ?? false,
      showInCompactView: showInCompactView ?? false,
    );
  }

  static List<NotificationActionButton>? tryParseActionButtons(Object? source) {
    if (source == null) return null;
    if (source is List<NotificationActionButton>) return source;
    if (source is NotificationActionButton) return [source];
    if (source is! Iterable) return null;
    return source
        .map(tryParseActionButton)
        .whereType<NotificationActionButton>()
        .toList();
  }
}
