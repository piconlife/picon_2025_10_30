import 'dart:io';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_andomie/extensions.dart';
import 'package:in_app_translation/in_app_translation.dart';
import 'package:object_finder/object_finder.dart';

import '../services/notification.dart';

NotificationImportance? _tryParseNotificationImportance(Object? value) {
  if (value == null) return null;
  return NotificationImportance.values.where((e) {
    if (e.toString() == value.toString()) return true;
    if (e.name == value) return true;
    if (e.index == value) return true;
    return false;
  }).firstOrNull;
}

DefaultRingtoneType? _tryParseDefaultRingtoneType(Object? value) {
  if (value == null) return null;
  return DefaultRingtoneType.values.where((e) {
    if (e.toString() == value.toString()) return true;
    if (e.name == value) return true;
    if (e.index == value) return true;
    return false;
  }).firstOrNull;
}

GroupAlertBehavior? _tryParseGroupAlertBehavior(Object? value) {
  if (value == null) return null;
  return GroupAlertBehavior.values.where((e) {
    if (e.toString() == value.toString()) return true;
    if (e.name == value) return true;
    if (e.index == value) return true;
    return false;
  }).firstOrNull;
}

NotificationPrivacy? _tryParseNotificationPrivacy(Object? value) {
  if (value == null) return null;
  return NotificationPrivacy.values.where((e) {
    if (e.toString() == value.toString()) return true;
    if (e.name == value) return true;
    if (e.index == value) return true;
    return false;
  }).firstOrNull;
}

GroupSort? _tryParseGroupSort(Object? value) {
  if (value == null) return null;
  return GroupSort.values.where((e) {
    if (e.toString() == value.toString()) return true;
    if (e.name == value) return true;
    if (e.index == value) return true;
    return false;
  }).firstOrNull;
}

class InAppNotificationChannel {
  final String channelKey;
  final String channelName;
  final String channelDescription;
  final String? channelGroupKey;
  final bool? channelShowBadge;
  final NotificationImportance? importance;
  final bool? playSound;
  final String? soundSource;
  final DefaultRingtoneType? defaultRingtoneType;
  final bool? enableVibration;
  final Int64List? vibrationPattern;
  final bool? enableLights;
  final Color? ledColor;
  final int? ledOnMs;
  final int? ledOffMs;
  final String? groupKey;
  final GroupSort? groupSort;
  final GroupAlertBehavior? groupAlertBehavior;
  final String? icon;
  final Color? defaultColor;
  final bool? locked;
  final bool? onlyAlertOnce;
  final NotificationPrivacy? defaultPrivacy;
  final bool? criticalAlerts;

  NotificationChannel get channel {
    return NotificationChannel(
      channelKey: channelKey,
      channelName: channelName,
      channelDescription: channelDescription,
      channelGroupKey: channelGroupKey,
      channelShowBadge: channelShowBadge,
      criticalAlerts: criticalAlerts,
      defaultColor: defaultColor,
      defaultPrivacy: defaultPrivacy,
      defaultRingtoneType: defaultRingtoneType,
      enableLights: enableLights,
      enableVibration: enableVibration,
      groupAlertBehavior: groupAlertBehavior,
      groupKey: groupKey,
      groupSort: groupSort,
      icon: icon,
      importance: importance,
      ledColor: ledColor,
      ledOffMs: ledOffMs,
      ledOnMs: ledOnMs,
      locked: locked,
      onlyAlertOnce: onlyAlertOnce,
      playSound: playSound,
      soundSource: soundSource,
      vibrationPattern: vibrationPattern,
    );
  }

  const InAppNotificationChannel({
    required this.channelKey,
    required this.channelName,
    required this.channelDescription,
    this.channelGroupKey,
    this.channelShowBadge,
    this.importance,
    this.playSound,
    this.soundSource,
    this.defaultRingtoneType,
    this.enableVibration,
    this.vibrationPattern,
    this.enableLights,
    this.ledColor,
    this.ledOnMs,
    this.ledOffMs,
    this.groupKey,
    this.groupSort,
    this.groupAlertBehavior,
    this.icon,
    this.defaultColor,
    this.locked,
    this.onlyAlertOnce,
    this.defaultPrivacy,
    this.criticalAlerts,
  });

  InAppNotificationChannel copyWith({
    String? channelKey,
    String? channelName,
    String? channelDescription,
    String? channelGroupKey,
    bool? channelShowBadge,
    NotificationImportance? importance,
    bool? playSound,
    String? soundSource,
    DefaultRingtoneType? defaultRingtoneType,
    bool? enableVibration,
    Int64List? vibrationPattern,
    bool? enableLights,
    Color? ledColor,
    int? ledOnMs,
    int? ledOffMs,
    String? groupKey,
    GroupSort? groupSort,
    GroupAlertBehavior? groupAlertBehavior,
    String? icon,
    Color? defaultColor,
    bool? locked,
    bool? onlyAlertOnce,
    NotificationPrivacy? defaultPrivacy,
    bool? criticalAlerts,
  }) {
    return InAppNotificationChannel(
      channelKey: channelKey ?? this.channelKey,
      channelName: channelName ?? this.channelName,
      channelDescription: channelDescription ?? this.channelDescription,
      channelGroupKey: channelGroupKey ?? this.channelGroupKey,
      channelShowBadge: channelShowBadge ?? this.channelShowBadge,
      importance: importance ?? this.importance,
      playSound: playSound ?? this.playSound,
      soundSource: soundSource ?? this.soundSource,
      defaultRingtoneType: defaultRingtoneType ?? this.defaultRingtoneType,
      enableVibration: enableVibration ?? this.enableVibration,
      vibrationPattern: vibrationPattern ?? this.vibrationPattern,
      enableLights: enableLights ?? this.enableLights,
      ledColor: ledColor ?? this.ledColor,
      ledOnMs: ledOnMs ?? this.ledOnMs,
      ledOffMs: ledOffMs ?? this.ledOffMs,
      groupKey: groupKey ?? this.groupKey,
      groupSort: groupSort ?? this.groupSort,
      groupAlertBehavior: groupAlertBehavior ?? this.groupAlertBehavior,
      icon: icon ?? this.icon,
      defaultColor: defaultColor ?? this.defaultColor,
      locked: locked ?? this.locked,
      onlyAlertOnce: onlyAlertOnce ?? this.onlyAlertOnce,
      defaultPrivacy: defaultPrivacy ?? this.defaultPrivacy,
      criticalAlerts: criticalAlerts ?? this.criticalAlerts,
    );
  }

  InAppNotificationChannel localize(Object? source) {
    if (source is! Map) return this;

    String? name = source.getOrNull("name");
    name ??= source.getOrNull("channel_ame");
    name ??= source.getOrNull("channelName");
    name = name.verified;

    String? description = source.getOrNull("description");
    description ??= source.getOrNull("channel_description");
    description ??= source.getOrNull("channelDescription");
    description = description.verified;

    return copyWith(channelName: name, channelDescription: description);
  }

  static NotificationChannel? tryParseChannel(Object? source) {
    if (source is NotificationChannel) return source;
    if (source is! Map) return null;
    String? key = source.getOrNull("key");
    key ??= source.getOrNull("channel_key");
    key ??= source.getOrNull("channelKey");
    key = key.verified;

    String? name = source.getOrNull("name");
    name ??= source.getOrNull("channel_ame");
    name ??= source.getOrNull("channelName");
    name = name.verified;

    if (key.isNotValid || name.isNotValid) return null;

    String? description = source.getOrNull("description");
    description ??= source.getOrNull("channel_description");
    description ??= source.getOrNull("channelDescription");
    description = description.verified;

    String? importance = source.getOrNull("importance");
    importance = importance.verified;

    bool? enableVibration = source.getOrNull("vibration");
    enableVibration ??= source.getOrNull("enable_vibration");
    enableVibration ??= source.getOrNull("enableVibration");
    enableVibration = enableVibration.verified;

    bool? playSound = source.getOrNull("sound");
    playSound ??= source.getOrNull("play_sound");
    playSound ??= source.getOrNull("playSound");
    playSound = playSound.verified;

    bool? criticalAlerts = source.getOrNull("critical_alerts");
    criticalAlerts ??= source.getOrNull("criticalAlerts");
    criticalAlerts = criticalAlerts.verified;

    String? defaultRingtoneType = source.getOrNull("ringtone");
    defaultRingtoneType ??= source.getOrNull("ringtone_type");
    defaultRingtoneType ??= source.getOrNull("ringtoneType");
    defaultRingtoneType ??= source.getOrNull("default_ringtone_type");
    defaultRingtoneType ??= source.getOrNull("defaultRingtoneType");
    defaultRingtoneType = defaultRingtoneType.verified;

    String? vibrationPattern = source.getOrNull("vibration_pattern");
    vibrationPattern ??= source.getOrNull("vibrationPattern");
    vibrationPattern = vibrationPattern.verified;

    final channel = NotificationChannel(
      channelKey: key,
      channelName: name,
      channelDescription: description,
      defaultColor: Colors.transparent,
      importance: NotificationImportance.values.current(importance, null),
      channelShowBadge: Platform.isAndroid,
      enableVibration: enableVibration ?? true,
      playSound: playSound ?? true,
      criticalAlerts: criticalAlerts ?? true,
      ledColor: Colors.white,
      defaultRingtoneType: DefaultRingtoneType.values.current(
        defaultRingtoneType,
        null,
      ),
      vibrationPattern:
          vibrationPattern == "low"
              ? lowVibrationPattern
              : vibrationPattern == "medium"
              ? mediumVibrationPattern
              : highVibrationPattern,
    );
    return channel;
  }

  static InAppNotificationChannel? tryParse(Object? source) {
    if (source is! Map) return null;

    final channelKey = source["channelKey"];
    if (channelKey.toString().isEmpty) return null;

    final channelName = source["channelName"];
    if (channelName.toString().isEmpty) return null;

    final channelDescription = source["channelDescription"];
    if (channelDescription.toString().isEmpty) return null;

    final channelGroupKey = source["channelGroupKey"];
    final channelShowBadge = source["channelShowBadge"];
    final importance = source["importance"];
    final playSound = source["playSound"];
    final soundSource = source["soundSource"];
    final defaultRingtoneType = source["defaultRingtoneType"];
    final enableVibration = source["enableVibration"];
    final vibrationPattern = source["vibrationPattern"];
    final enableLights = source["enableLights"];
    final ledColor = source["ledColor"];
    final ledOnMs = source["ledOnMs"];
    final ledOffMs = source["ledOffMs"];
    final groupKey = source["groupKey"];
    final groupSort = source["groupSort"];
    final groupAlertBehavior = source["groupAlertBehavior"];
    final icon = source["icon"];
    final defaultColor = source["defaultColor"];
    final locked = source["locked"];
    final onlyAlertOnce = source["onlyAlertOnce"];
    final defaultPrivacy = source["defaultPrivacy"];
    final criticalAlerts = source["criticalAlerts"];

    return InAppNotificationChannel(
      channelKey: channelKey.toString(),
      channelName: channelName.toString(),
      channelDescription: channelDescription.toString(),
      channelGroupKey: channelGroupKey is String ? channelGroupKey : null,
      channelShowBadge:
          channelShowBadge is bool
              ? channelShowBadge
              : channelShowBadge is String
              ? bool.tryParse(
                channelShowBadge.replace({
                  "IS_ANDROID": !kIsWeb && Platform.isAndroid,
                }),
              )
              : null,
      importance: _tryParseNotificationImportance(importance),
      playSound: playSound is bool ? playSound : null,
      soundSource: soundSource is String ? soundSource : null,
      defaultRingtoneType: _tryParseDefaultRingtoneType(defaultRingtoneType),
      enableVibration: enableVibration is bool ? enableVibration : null,
      vibrationPattern:
          vibrationPattern is List
              ? Int64List.fromList(
                vibrationPattern.map((e) => e as int).toList(),
              )
              : null,
      enableLights: enableLights is bool ? enableLights : null,
      ledColor: ledColor is String ? ledColor.color : null,
      ledOnMs: ledOnMs is num ? ledOnMs.toInt() : null,
      ledOffMs: ledOffMs is num ? ledOffMs.toInt() : null,
      groupKey: groupKey is String ? groupKey : null,
      groupSort: _tryParseGroupSort(groupSort),
      groupAlertBehavior: _tryParseGroupAlertBehavior(groupAlertBehavior),
      icon: icon is String ? icon : null,
      defaultColor: defaultColor is String ? defaultColor.color : null,
      locked: locked is bool ? locked : null,
      onlyAlertOnce: onlyAlertOnce is bool ? onlyAlertOnce : null,
      defaultPrivacy: _tryParseNotificationPrivacy(defaultPrivacy),
      criticalAlerts: criticalAlerts is bool ? criticalAlerts : null,
    );
  }

  static List<InAppNotificationChannel> tryParses(Iterable? source) {
    if (source == null) return [];
    final a =
        source.map(tryParse).whereType<InAppNotificationChannel>().toList();
    return a;
  }

  Map<String, dynamic> toMap() {
    return {
      'channelKey': channelKey,
      'channelName': channelName,
      'channelDescription': channelDescription,
      'channelGroupKey': channelGroupKey,
      'channelShowBadge': channelShowBadge,
      'importance': importance?.index,
      'playSound': playSound,
      'soundSource': soundSource,
      'defaultRingtoneType': defaultRingtoneType?.index,
      'enableVibration': enableVibration,
      'vibrationPattern': vibrationPattern,
      'enableLights': enableLights,
      'ledColor': ledColor?.toString(),
      'ledOnMs': ledOnMs,
      'ledOffMs': ledOffMs,
      'groupKey': groupKey,
      'groupSort': groupSort?.index,
      'groupAlertBehavior': groupAlertBehavior?.index,
      'icon': icon,
      'defaultColor': defaultColor?.toString(),
      'locked': locked,
      'onlyAlertOnce': onlyAlertOnce,
      'defaultPrivacy': defaultPrivacy?.index,
      'criticalAlerts': criticalAlerts,
    };
  }

  @override
  String toString() => "$InAppNotificationChannel($channelKey)";
}
