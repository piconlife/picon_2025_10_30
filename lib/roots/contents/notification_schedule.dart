import 'dart:io';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_andomie/extensions.dart';
import 'package:object_finder/object_finder.dart';

class InAppNotificationSchedule {
  static NotificationSchedule? tryParseSchedule(Object? source) {
    if (source == null) return null;
    if (source is NotificationSchedule) return source;
    if (source is! Map) return null;
    String? type = source.getOrNull("type");
    if (type == null || type.isEmpty) return null;
    String? timeZone = source.getOrNull("timezone");
    timeZone ??= source.getOrNull("timeZone");
    timeZone = timeZone.verified;

    bool? allowWhileIdle = source.getOrNull("allow_while_idle");
    allowWhileIdle ??= source.getOrNull("allowWhileIdle");
    allowWhileIdle = allowWhileIdle.verified;

    bool? repeats = source.getOrNull("repeats");
    repeats = repeats.verified;

    bool? preciseAlarm = source.getOrNull("preciseAlarm");
    preciseAlarm ??= source.getOrNull("precise_alarm");
    preciseAlarm = preciseAlarm.verified;

    if (type == "calender") {
      int? era = source.getOrNull("era");
      era = era.verified;

      String? rawDate = source.getOrNull("date");
      rawDate = rawDate.verified;

      DateTime? date = rawDate == null ? null : DateTime.tryParse(rawDate);
      return NotificationCalendar(
        timeZone: timeZone,
        repeats: repeats ?? false,
        allowWhileIdle: allowWhileIdle ?? false,
        preciseAlarm: preciseAlarm ?? true,
        era: era,
        year: date?.year,
        month: date?.month,
        day: date?.day,
        hour: date?.hour,
        minute: date?.minute,
        second: date?.second,
      );
    } else if (type == 'interval') {
      int? interval = source.getOrNull("interval");
      interval = interval.verified;

      return NotificationInterval(
        timeZone: timeZone,
        repeats: repeats ?? false,
        allowWhileIdle: allowWhileIdle ?? false,
        preciseAlarm: preciseAlarm ?? true,
        interval:
            interval.verified != null
                ? Duration(milliseconds: interval!)
                : null,
      );
    } else if (type == "crontab" && !kIsWeb && Platform.isAndroid) {
      String? crontabExpression = source.getOrNull("crontab_expression");
      crontabExpression ??= source.getOrNull("crontabExpression");
      crontabExpression = crontabExpression.verified;

      String? expirationDateTime = source.getOrNull("expiration_date");
      expirationDateTime ??= source.getOrNull("expiration_time");
      expirationDateTime ??= source.getOrNull("expiration_date_time");
      expirationDateTime ??= source.getOrNull("expirationDateTime");
      expirationDateTime = expirationDateTime.verified;

      String? initialDateTime = source.getOrNull("initial_date");
      initialDateTime ??= source.getOrNull("initial_time");
      initialDateTime ??= source.getOrNull("initial_date_time");
      initialDateTime ??= source.getOrNull("initialDateTime");
      initialDateTime = initialDateTime.verified;

      Iterable<DateTime>? preciseSchedules =
          source
              .findsByKey(
                "precise_schedules",
                builder: (value) {
                  if (value is! String) return null;
                  return DateTime.tryParse(value);
                },
              )
              .whereType<DateTime>();
      preciseSchedules =
          preciseSchedules.isEmpty
              ? source
                  .findsByKey(
                    "preciseSchedules",
                    builder: (value) {
                      if (value is! String) return null;
                      return DateTime.tryParse(value);
                    },
                  )
                  .whereType<DateTime>()
              : preciseSchedules;
      preciseSchedules = preciseSchedules.verified;

      return NotificationAndroidCrontab(
        timeZone: timeZone,
        repeats: repeats ?? false,
        allowWhileIdle: allowWhileIdle ?? false,
        preciseAlarm: preciseAlarm ?? true,
        preciseSchedules: preciseSchedules?.toList(),
        crontabExpression: crontabExpression,
        expirationDateTime:
            expirationDateTime == null
                ? null
                : DateTime.tryParse(expirationDateTime),
        initialDateTime:
            initialDateTime == null ? null : DateTime.tryParse(initialDateTime),
      );
    }
    return null;
  }
}
