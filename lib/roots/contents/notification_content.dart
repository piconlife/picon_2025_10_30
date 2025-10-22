import 'dart:ui';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter_andomie/extensions.dart';
import 'package:object_finder/object_finder.dart';

import '../services/notification.dart';

ActionType? _tryParseActionType(Object? value) {
  if (value == null) return null;
  return ActionType.values.where((e) {
    if (e.toString() == value.toString()) return true;
    if (e.name == value) return true;
    if (e.index == value) return true;
    return false;
  }).firstOrNull;
}

NotificationLayout? _tryParseNotificationLayout(Object? value) {
  if (value == null) return null;
  return NotificationLayout.values.where((e) {
    if (e.toString() == value.toString()) return true;
    if (e.name == value) return true;
    if (e.index == value) return true;
    return false;
  }).firstOrNull;
}

NotificationCategory? _tryParseNotificationCategory(Object? value) {
  if (value == null) return null;
  return NotificationCategory.values.where((e) {
    if (e.toString() == value.toString()) return true;
    if (e.name == value) return true;
    if (e.index == value) return true;
    return false;
  }).firstOrNull;
}

NotificationPlayState? _tryParseNotificationPlayState(Object? value) {
  if (value == null) return null;
  return NotificationPlayState.values.where((e) {
    if (e.toString() == value.toString()) return true;
    if (e.name == value) return true;
    if (e.index == value) return true;
    return false;
  }).firstOrNull;
}

class InAppNotificationContent {
  final int id;
  final String channelKey;
  final String? title;
  final String? body;
  final String? titleLocKey;
  final String? bodyLocKey;
  final List<String>? titleLocArgs;
  final List<String>? bodyLocArgs;
  final String? groupKey;
  final String? summary;
  final String? icon;
  final String? largeIcon;
  final String? bigPicture;
  final String? customSound;
  final bool showWhen;
  final bool wakeUpScreen;
  final bool fullScreenIntent;
  final bool criticalAlert;
  final bool roundedLargeIcon;
  final bool roundedBigPicture;
  final bool autoDismissible;
  final Color? color;
  final Duration? timeoutAfter;
  final Duration? chronometer;
  final Color? backgroundColor;
  final ActionType actionType;
  final NotificationLayout notificationLayout;
  final Map<String, String>? payload;
  final NotificationCategory? category;
  final bool hideLargeIconOnExpand;
  final bool locked;
  final double? progress;
  final int? badge;
  final String? ticker;
  final bool displayOnForeground;
  final bool displayOnBackground;
  final Duration? duration;
  final NotificationPlayState? playState;
  final double? playbackSpeed;

  NotificationContent get content {
    return NotificationContent(
      id: id,
      channelKey: channelKey,
      actionType: actionType,
      autoDismissible: autoDismissible,
      body: body,
      backgroundColor: backgroundColor,
      badge: badge,
      bigPicture: bigPicture,
      bodyLocArgs: bodyLocArgs,
      bodyLocKey: bodyLocKey,
      color: color,
      category: category,
      chronometer: chronometer,
      criticalAlert: criticalAlert,
      customSound: customSound,
      displayOnBackground: displayOnBackground,
      displayOnForeground: displayOnForeground,
      duration: duration,
      fullScreenIntent: fullScreenIntent,
      groupKey: groupKey,
      hideLargeIconOnExpand: hideLargeIconOnExpand,
      icon: icon,
      locked: locked,
      largeIcon: largeIcon,
      notificationLayout: notificationLayout,
      payload: payload,
      playbackSpeed: playbackSpeed,
      playState: playState,
      progress: progress,
      roundedBigPicture: roundedBigPicture,
      roundedLargeIcon: roundedLargeIcon,
      showWhen: showWhen,
      summary: summary,
      title: title,
      ticker: ticker,
      timeoutAfter: timeoutAfter,
      titleLocArgs: titleLocArgs,
      titleLocKey: titleLocKey,
      wakeUpScreen: wakeUpScreen,
    );
  }

  const InAppNotificationContent({
    required this.id,
    required this.channelKey,
    this.title,
    this.body,
    this.titleLocKey,
    this.bodyLocKey,
    this.titleLocArgs,
    this.bodyLocArgs,
    this.groupKey,
    this.summary,
    this.icon,
    this.largeIcon,
    this.bigPicture,
    this.customSound,
    this.showWhen = true,
    this.wakeUpScreen = false,
    this.fullScreenIntent = false,
    this.criticalAlert = false,
    this.roundedLargeIcon = false,
    this.roundedBigPicture = false,
    this.autoDismissible = true,
    this.color,
    this.timeoutAfter,
    this.chronometer,
    this.backgroundColor,
    this.actionType = ActionType.Default,
    this.notificationLayout = NotificationLayout.Default,
    this.payload,
    this.category,
    this.hideLargeIconOnExpand = false,
    this.locked = false,
    this.progress,
    this.badge,
    this.ticker,
    this.displayOnForeground = true,
    this.displayOnBackground = true,
    this.duration,
    this.playState,
    this.playbackSpeed,
  });

  InAppNotificationContent copyWith({
    int? id,
    String? channelKey,
    String? title,
    String? body,
    String? titleLocKey,
    String? bodyLocKey,
    List<String>? titleLocArgs,
    List<String>? bodyLocArgs,
    String? groupKey,
    String? summary,
    String? icon,
    String? largeIcon,
    String? bigPicture,
    String? customSound,
    bool? showWhen,
    bool? wakeUpScreen,
    bool? fullScreenIntent,
    bool? criticalAlert,
    bool? roundedLargeIcon,
    bool? roundedBigPicture,
    bool? autoDismissible,
    Color? color,
    Duration? timeoutAfter,
    Duration? chronometer,
    Color? backgroundColor,
    ActionType? actionType,
    NotificationLayout? notificationLayout,
    Map<String, String>? payload,
    NotificationCategory? category,
    bool? hideLargeIconOnExpand,
    bool? locked,
    double? progress,
    int? badge,
    String? ticker,
    bool? displayOnForeground,
    bool? displayOnBackground,
    Duration? duration,
    NotificationPlayState? playState,
    double? playbackSpeed,
  }) {
    return InAppNotificationContent(
      id: id ?? this.id,
      channelKey: channelKey ?? this.channelKey,
      title: title ?? this.title,
      body: body ?? this.body,
      titleLocKey: titleLocKey ?? this.titleLocKey,
      bodyLocKey: bodyLocKey ?? this.bodyLocKey,
      titleLocArgs: titleLocArgs ?? this.titleLocArgs,
      bodyLocArgs: bodyLocArgs ?? this.bodyLocArgs,
      groupKey: groupKey ?? this.groupKey,
      summary: summary ?? this.summary,
      icon: icon ?? this.icon,
      largeIcon: largeIcon ?? this.largeIcon,
      bigPicture: bigPicture ?? this.bigPicture,
      customSound: customSound ?? this.customSound,
      showWhen: showWhen ?? this.showWhen,
      wakeUpScreen: wakeUpScreen ?? this.wakeUpScreen,
      fullScreenIntent: fullScreenIntent ?? this.fullScreenIntent,
      criticalAlert: criticalAlert ?? this.criticalAlert,
      roundedLargeIcon: roundedLargeIcon ?? this.roundedLargeIcon,
      roundedBigPicture: roundedBigPicture ?? this.roundedBigPicture,
      autoDismissible: autoDismissible ?? this.autoDismissible,
      color: color ?? this.color,
      timeoutAfter: timeoutAfter ?? this.timeoutAfter,
      chronometer: chronometer ?? this.chronometer,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      actionType: actionType ?? this.actionType,
      notificationLayout: notificationLayout ?? this.notificationLayout,
      payload: payload ?? this.payload,
      category: category ?? this.category,
      hideLargeIconOnExpand:
          hideLargeIconOnExpand ?? this.hideLargeIconOnExpand,
      locked: locked ?? this.locked,
      progress: progress ?? this.progress,
      badge: badge ?? this.badge,
      ticker: ticker ?? this.ticker,
      displayOnForeground: displayOnForeground ?? this.displayOnForeground,
      displayOnBackground: displayOnBackground ?? this.displayOnBackground,
      duration: duration ?? this.duration,
      playState: playState ?? this.playState,
      playbackSpeed: playbackSpeed ?? this.playbackSpeed,
    );
  }

  static NotificationContent? tryParseContent(Object? source) {
    if (source is NotificationContent) return source;
    if (source is! Map) return null;
    int? id = source.getOrNull("id");
    id = id.verified;

    String? key = source.getOrNull("channel");
    key ??= source.getOrNull("channel_key");
    key ??= source.getOrNull("channelKey");
    key ??= InAppNotifications.idBasicChannel;
    key = key.verified;

    String? title = source.getOrNull("title");
    String? body = source.getOrNull("body");

    if (id.isNotValid ||
        key.isNotValid ||
        title.isNotValid ||
        body.isNotValid) {
      return null;
    }

    String? actionType = source.getOrNull("action_type");
    actionType ??= source.getOrNull("actionType");
    actionType = actionType.verified;

    bool? autoDismissible = source.getOrNull("dismissible");
    autoDismissible ??= source.getOrNull("auto_dismissible");
    autoDismissible ??= source.getOrNull("autoDismissible");
    autoDismissible = autoDismissible.verified;

    String? backgroundColor = source.getOrNull("background_color");
    backgroundColor ??= source.getOrNull("backgroundColor");
    backgroundColor = backgroundColor.verified;

    int? badge = source.getOrNull("badge");
    badge ??= source.getOrNull("badge");
    badge = badge.verified;

    String? bigPicture = source.getOrNull("picture");
    bigPicture ??= source.getOrNull("big_picture");
    bigPicture ??= source.getOrNull("bigPicture");
    bigPicture = bigPicture.verified;

    List<String>? bodyLocArgs = source.getOrNull("body_loc_args");
    bodyLocArgs ??= source.getOrNull("bodyLocArgs");
    bodyLocArgs = bodyLocArgs.verified;

    String? bodyLocKey = source.getOrNull("body_loc_key");
    bodyLocKey ??= source.getOrNull("bodyLocKey");
    bodyLocKey = bodyLocKey.verified;

    String? category = source.getOrNull("category");
    category = category.verified;

    String? color = source.getOrNull("color");
    color = color.verified;

    int? chronometer = source.getOrNull("chronometer");
    chronometer = chronometer.verified;

    bool? criticalAlert = source.getOrNull("critical_alert");
    criticalAlert ??= source.getOrNull("criticalAlert");
    criticalAlert = criticalAlert.verified;

    String? customSound = source.getOrNull("sound");
    customSound ??= source.getOrNull("custom_sound");
    customSound ??= source.getOrNull("customSound");
    customSound = customSound.verified;

    bool? displayOnBackground = source.getOrNull("display_on_background");
    displayOnBackground ??= source.getOrNull("displayOnBackground");
    displayOnBackground = displayOnBackground.verified;

    bool? displayOnForeground = source.getOrNull("display_on_foreground");
    displayOnForeground ??= source.getOrNull("displayOnForeground");
    displayOnForeground = displayOnForeground.verified;

    int? duration = source.getOrNull("duration");
    duration = duration.verified;

    bool? fullScreenIntent = source.getOrNull("full_screen_intent");
    fullScreenIntent ??= source.getOrNull("fullScreenIntent");
    fullScreenIntent = fullScreenIntent.verified;

    String? groupKey = source.getOrNull("group_id");
    groupKey ??= source.getOrNull("group_key");
    groupKey ??= source.getOrNull("groupKey");
    groupKey = groupKey.verified;

    bool? hideLargeIconOnExpand = source.getOrNull("hide_large_icon_on_expand");
    hideLargeIconOnExpand ??= source.getOrNull("hideLargeIconOnExpand");
    hideLargeIconOnExpand = hideLargeIconOnExpand.verified;

    String? icon = source.getOrNull("icon");
    icon = icon.verified;

    String? largeIcon = source.getOrNull("large_icon");
    largeIcon ??= source.getOrNull("largeIcon");
    largeIcon = largeIcon.verified;

    bool? locked = source.getOrNull("locked");
    locked = locked.verified;

    String? notificationLayout = source.getOrNull("layout");
    notificationLayout ??= source.getOrNull("notification_layout");
    notificationLayout ??= source.getOrNull("notificationLayout");
    notificationLayout = notificationLayout.verified;

    double? playbackSpeed = source.getOrNull("playback_speed");
    playbackSpeed ??= source.getOrNull("playbackSpeed");
    playbackSpeed = playbackSpeed.verified;

    Map<String, String?>? payload = source.getOrNull("payload");
    // payload = payload;

    String? playState = source.getOrNull("play_state");
    playState ??= source.getOrNull("playState");
    playState = playState.verified;

    double? progress = source.getOrNull("progress");
    progress = progress.verified;

    bool? roundedBigPicture = source.getOrNull("rounded_big_picture");
    roundedBigPicture ??= source.getOrNull("roundedBigPicture");
    roundedBigPicture = roundedBigPicture.verified;

    bool? roundedLargeIcon = source.getOrNull("rounded_large_icon");
    roundedLargeIcon ??= source.getOrNull("roundedLargeIcon");
    roundedLargeIcon = roundedLargeIcon.verified;

    bool? showWhen = source.getOrNull("show_when");
    showWhen ??= source.getOrNull("showWhen");
    showWhen = showWhen.verified;

    String? summary = source.getOrNull("summary");
    summary = summary.verified;

    String? ticker = source.getOrNull("ticker");
    ticker = ticker.verified;

    int? timeoutAfter = source.getOrNull("timeout_after");
    timeoutAfter ??= source.getOrNull("timeoutAfter");
    timeoutAfter = timeoutAfter.verified;

    List<String>? titleLocArgs = source.getOrNull("title_loc_args");
    titleLocArgs ??= source.getOrNull("titleLocArgs");
    titleLocArgs = titleLocArgs.verified;

    String? titleLocKey = source.getOrNull("title_loc_key");
    titleLocKey ??= source.getOrNull("titleLocKey");
    titleLocKey = titleLocKey.verified;

    bool? wakeUpScreen = source.getOrNull("wake_up_screen");
    wakeUpScreen ??= source.getOrNull("wakeUpScreen");
    wakeUpScreen = wakeUpScreen.verified;

    return NotificationContent(
      id: id.use,
      channelKey: key.use,
      title: title,
      body: body,
      actionType: ActionType.values.current(actionType, ActionType.Default),
      autoDismissible: autoDismissible ?? true,
      backgroundColor: backgroundColor.color,
      badge: badge,
      bigPicture: bigPicture,
      bodyLocArgs: bodyLocArgs,
      bodyLocKey: bodyLocKey,
      category: NotificationCategory.values.current(category, null),
      chronometer: chronometer.duration,
      color: color.color,
      criticalAlert: criticalAlert ?? false,
      customSound: customSound,
      duration: duration.duration,
      displayOnBackground: displayOnBackground ?? true,
      displayOnForeground: displayOnForeground ?? true,
      fullScreenIntent: fullScreenIntent ?? false,
      groupKey: groupKey,
      hideLargeIconOnExpand: hideLargeIconOnExpand ?? false,
      icon: icon,
      largeIcon: largeIcon,
      locked: locked ?? false,
      notificationLayout: NotificationLayout.values.current(
        notificationLayout,
        NotificationLayout.Default,
      ),
      playbackSpeed: playbackSpeed,
      payload: payload,
      playState: NotificationPlayState.values.current(playState, null),
      progress: progress,
      roundedBigPicture: roundedBigPicture ?? false,
      roundedLargeIcon: roundedLargeIcon ?? false,
      showWhen: showWhen ?? true,
      summary: summary,
      ticker: ticker,
      timeoutAfter: timeoutAfter.duration,
      titleLocArgs: titleLocArgs,
      titleLocKey: titleLocKey,
      wakeUpScreen: wakeUpScreen ?? false,
    );
  }

  static InAppNotificationContent? tryParse(Object? source) {
    if (source is! Map) return null;

    final id = source["id"];
    final channelKey = source["channelKey"];
    final title = source["title"];
    final body = source["body"];
    final titleLocKey = source["titleLocKey"];
    final bodyLocKey = source["bodyLocKey"];
    final titleLocArgs = source["titleLocArgs"];
    final bodyLocArgs = source["bodyLocArgs"];
    final groupKey = source["groupKey"];
    final summary = source["summary"];
    final icon = source["icon"];
    final largeIcon = source["largeIcon"];
    final bigPicture = source["bigPicture"];
    final customSound = source["customSound"];
    final showWhen = source["showWhen"];
    final wakeUpScreen = source["wakeUpScreen"];
    final fullScreenIntent = source["fullScreenIntent"];
    final criticalAlert = source["criticalAlert"];
    final roundedLargeIcon = source["roundedLargeIcon"];
    final roundedBigPicture = source["roundedBigPicture"];
    final autoDismissible = source["autoDismissible"];
    final color = source["color"];
    final timeoutAfter = source["timeoutAfter"];
    final chronometer = source["chronometer"];
    final backgroundColor = source["backgroundColor"];
    final actionType = source["actionType"];
    final notificationLayout = source["notificationLayout"];
    final payload = source["payload"];
    final category = source["category"];
    final hideLargeIconOnExpand = source["hideLargeIconOnExpand"];
    final locked = source["locked"];
    final progress = source["progress"];
    final badge = source["badge"];
    final ticker = source["ticker"];
    final displayOnForeground = source["displayOnForeground"];
    final displayOnBackground = source["displayOnBackground"];
    final duration = source["duration"];
    final playState = source["playState"];
    final playbackSpeed = source["playbackSpeed"];

    return InAppNotificationContent(
      id: id is num ? id.toInt() : -1,
      channelKey: channelKey.toString(),
      title: title is String ? title : null,
      body: body is String ? body : null,
      titleLocKey: titleLocKey is String ? titleLocKey : null,
      bodyLocKey: bodyLocKey is String ? bodyLocKey : null,
      titleLocArgs: titleLocArgs is List ? List.from(titleLocArgs) : null,
      bodyLocArgs: bodyLocArgs is List ? List.from(bodyLocArgs) : null,
      groupKey: groupKey is String ? groupKey : null,
      summary: summary is String ? summary : null,
      icon: icon is String ? icon : null,
      largeIcon: largeIcon is String ? largeIcon : null,
      bigPicture: bigPicture is String ? bigPicture : null,
      customSound: customSound is String ? customSound : null,
      showWhen: showWhen is bool ? showWhen : true,
      wakeUpScreen: wakeUpScreen is bool ? wakeUpScreen : false,
      fullScreenIntent: fullScreenIntent is bool ? fullScreenIntent : false,
      criticalAlert: criticalAlert is bool ? criticalAlert : false,
      roundedLargeIcon: roundedLargeIcon is bool ? roundedLargeIcon : false,
      roundedBigPicture: roundedBigPicture is bool ? roundedBigPicture : false,
      autoDismissible: autoDismissible is bool ? autoDismissible : true,
      color: color is String ? color.color : null,
      timeoutAfter: timeoutAfter is int ? timeoutAfter.duration : null,
      chronometer: chronometer is int ? chronometer.duration : null,
      backgroundColor: backgroundColor is String ? backgroundColor.color : null,
      actionType: _tryParseActionType(actionType) ?? ActionType.Default,
      notificationLayout:
          _tryParseNotificationLayout(notificationLayout) ??
          NotificationLayout.Default,
      payload:
          payload is Map
              ? payload.map((k, v) => MapEntry(k.toString(), v.toString()))
              : null,
      category: _tryParseNotificationCategory(category),
      hideLargeIconOnExpand:
          hideLargeIconOnExpand is bool ? hideLargeIconOnExpand : false,
      locked: locked is bool ? locked : false,
      progress: progress is num ? progress.toDouble() : null,
      badge: badge is num ? badge.toInt() : null,
      ticker: ticker is String ? ticker : null,
      displayOnForeground:
          displayOnForeground is bool ? displayOnForeground : true,
      displayOnBackground:
          displayOnBackground is bool ? displayOnBackground : true,
      duration: duration is int ? duration.duration : null,
      playState: _tryParseNotificationPlayState(playState),
      playbackSpeed: playbackSpeed is num ? playbackSpeed.toDouble() : null,
    );
  }

  static List<InAppNotificationContent> tryParses(Object? source) {
    if (source == null) return [];
    if (source is! Iterable) return [];
    final a =
        source.map(tryParse).whereType<InAppNotificationContent>().toList();
    return a;
  }

  static List<List<InAppNotificationContent>> parses(Iterable? source) {
    if (source == null) return [];
    final a = source.whereType<Iterable>();
    final b =
        a.map(tryParses).whereType<List<InAppNotificationContent>>().toList();
    return b;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'channelKey': channelKey,
      'title': title,
      'body': body,
      'titleLocKey': titleLocKey,
      'bodyLocKey': bodyLocKey,
      'titleLocArgs': titleLocArgs,
      'bodyLocArgs': bodyLocArgs,
      'groupKey': groupKey,
      'summary': summary,
      'icon': icon,
      'largeIcon': largeIcon,
      'bigPicture': bigPicture,
      'customSound': customSound,
      'showWhen': showWhen,
      'wakeUpScreen': wakeUpScreen,
      'fullScreenIntent': fullScreenIntent,
      'criticalAlert': criticalAlert,
      'roundedLargeIcon': roundedLargeIcon,
      'roundedBigPicture': roundedBigPicture,
      'autoDismissible': autoDismissible,
      'color': color?.toString(),
      'timeoutAfter': timeoutAfter,
      'chronometer': chronometer,
      'backgroundColor': backgroundColor?.toString(),
      'actionType': actionType.index,
      'notificationLayout': notificationLayout.index,
      'payload': payload,
      'category': category?.index,
      'hideLargeIconOnExpand': hideLargeIconOnExpand,
      'locked': locked,
      'progress': progress,
      'badge': badge,
      'ticker': ticker,
      'displayOnForeground': displayOnForeground,
      'displayOnBackground': displayOnBackground,
      'duration': duration?.inMilliseconds,
      'playState': playState?.index,
      'playbackSpeed': playbackSpeed,
    };
  }

  @override
  String toString() => "$InAppNotificationContent($id)";
}
