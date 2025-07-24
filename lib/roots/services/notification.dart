import 'dart:developer';
import 'dart:math' as math;

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_andomie/extensions/object.dart';
import 'package:flutter_andomie/utils/configs.dart';
import 'package:flutter_andomie/utils/random_provider.dart';
import 'package:flutter_andomie/utils/translation.dart';

import '../../app/constants/app.dart';
import '../contents/notification_action_button.dart';
import '../contents/notification_channel.dart';
import '../contents/notification_content.dart';
import '../contents/notification_localization.dart';
import '../contents/notification_schedule.dart';

class InAppNotifications {
  InAppNotifications._();

  // ---------------------------------------------------------------------------
  // CORE START
  // ---------------------------------------------------------------------------

  static const idBasicChannel = "basic_channel";

  static bool initialized = false;

  static AwesomeNotifications get _n => AwesomeNotifications();

  static Future<bool> get isPermissionAllow {
    return _n.isNotificationAllowed();
  }

  static Future<bool> get isPermissionNotAllow async {
    return !(await isPermissionAllow);
  }

  static Future<bool> requestPermission() async {
    if (await isPermissionNotAllow) {
      return _n.requestPermissionToSendNotifications();
    }
    return true;
  }

  static Future<void> channel(NotificationChannel channel) async {
    if (!initialized) return;
    try {
      return await _n.setChannel(channel);
    } catch (_) {}
  }

  static Future<void> channels(Iterable<NotificationChannel> values) async {
    if (!initialized) return;
    try {
      await Future.wait(values.map(channel));
    } catch (_) {}
  }

  static Future<bool> create(
    InAppNotificationContent content, {
    List<NotificationActionButton>? actionButtons,
    Map<String, NotificationLocalization>? localizations,
    NotificationSchedule? schedule,
  }) async {
    if (!initialized) return false;
    return _n.createNotification(
      content: content.content,
      actionButtons: actionButtons,
      localizations: localizations,
      schedule: schedule,
    );
  }

  static Future<bool> creates(Iterable<InAppNotificationContent> values) async {
    if (!initialized) return false;
    if (values.isEmpty) return false;
    final mNotifications = values.map(create);
    final feedback = await Future.wait(mNotifications);
    if (feedback.isEmpty) return false;
    return feedback.reduce((a, b) => a = a && b);
  }

  static Future<void> cancelByIds(Iterable<int> ids) async {
    if (!initialized) return;
    if (ids.isEmpty) return;
    final mNotifications = ids.map((id) async {
      if (id.isNotValid) return Future.value();
      return _n.cancel(id);
    });
    final feedback = await Future.wait(mNotifications);
    if (feedback.isEmpty) return;
  }

  static Future<void> cancelNotificationsByChannelKey(String channelKey) async {
    if (!initialized) return;
    await _n.cancelNotificationsByChannelKey(channelKey);
  }

  static Future<void> cancelSchedulesByChannelKey(String channelKey) async {
    if (!initialized) return;
    await _n.cancelSchedulesByChannelKey(channelKey);
  }

  static Future<bool> createFromPayload(
    Object? content, {
    Object? actionButtons,
    Object? localizations,
    Object? schedule,
  }) async {
    if (!initialized) return false;
    final mContent = InAppNotificationContent.tryParse(content);
    final mActionButtons = InAppNotificationActionButton.tryParseActionButtons(
      actionButtons,
    );
    final mLocalizations = InAppNotificationLocalization.tryParseLocalizations(
      localizations,
    );
    final mSchedule = InAppNotificationSchedule.tryParseSchedule(schedule);
    if (mContent == null) return false;
    return create(
      mContent,
      actionButtons: mActionButtons,
      localizations: mLocalizations,
      schedule: mSchedule,
    );
  }

  static Future<bool> createFromJson(Object? value) async {
    if (!initialized) return false;
    if (value is! Map) return false;
    return createFromPayload(
      value["content"],
      actionButtons: value["action_buttons"] ?? value["actionButtons"],
      localizations: value["localizations"],
      schedule: value["schedule"],
    );
  }

  static Future<bool> createFromMap(Map<String, dynamic> value) async {
    if (!initialized) return false;
    return _n.createNotificationFromJsonData(value);
  }

  static void dispose() {}

  // ---------------------------------------------------------------------------
  // CORE END
  // ---------------------------------------------------------------------------

  // ---------------------------------------------------------------------------
  // INIT START
  // ---------------------------------------------------------------------------

  @pragma('vm:entry-point')
  static Future<void> _clicked(ReceivedAction receivedAction) async {
    final notificationId = receivedAction.id ?? 0;
    log("Notification clicked: $notificationId");
  }

  @pragma('vm:entry-point')
  static Future<void> _created(ReceivedNotification notification) async {
    log('Notification created: ${notification.title}');
  }

  @pragma('vm:entry-point')
  static Future<void> _displayed(
    ReceivedNotification receivedNotification,
  ) async {
    // Log or handle notification display
    log('Notification displayed: ${receivedNotification.title}');
  }

  @pragma('vm:entry-point')
  static Future<void> _received(ReceivedAction receivedAction) async {
    // Log or handle notification dismissal
    log('Notification dismissed: ${receivedAction.title}');
  }

  static Future<void> init({VoidCallback? onReady}) async {
    if (kIsWeb) return;

    if (await isPermissionNotAllow) return;

    final channels = Configs.getsOrNull(
      "application/notification_channels",
      parser: InAppNotificationChannel.tryParse,
    );

    if (channels == null || channels.isEmpty) return;

    Map? localizations = Translation.get(
      path: 'notification_channels',
      defaultValue: {},
    );

    final localizedChannels = channels
        .map((e) => e.localize(localizations?[e.channelKey]))
        .map((e) => e.channel)
        .toList();

    if (localizedChannels.isEmpty) return;
    await _n.cancelAll();
    initialized = await _n.initialize(
      AppConstants.logoNotification,
      localizedChannels,
      debug: true,
    );

    await _n.resetGlobalBadge();

    // Listen to notification events
    _n.setListeners(
      onActionReceivedMethod: _clicked,
      onNotificationCreatedMethod: _created,
      onNotificationDisplayedMethod: _displayed,
      onDismissActionReceivedMethod: _received,
    );

    if (onReady != null) onReady();
  }

  // ---------------------------------------------------------------------------
  // INIT END
  // ---------------------------------------------------------------------------

  // ---------------------------------------------------------------------------
  // HOURLY NOTIFICATION START
  // ---------------------------------------------------------------------------

  static const idHourlyChannel = 'hourly_channel';

  static Future<void> initHourlyNotifications({
    int perHour = 2,
    int startHour = 8,
    int endHour = 22,
  }) async {
    try {
      final values = Translation.gets(
        path: 'hourly_notifications',
        parser: (value) => value is Map ? value : null,
      );
      await hourlyNotifications(
        values: values,
        perHour: perHour,
        startHour: startHour,
        endHour: endHour,
      );
    } catch (_) {}
  }

  static Future<void> hourlyNotifications({
    required List<Map> values,
    required int perHour,
    required int startHour,
    required int endHour,
  }) async {
    await cancelHourlyNotifications();
    if (!initialized) return;
    final random = math.Random();
    final now = DateTime.now();
    final timezone = await _n.getLocalTimeZoneIdentifier();

    int id = 1000;

    for (int day = 0; day < 3; day++) {
      final date = now.add(Duration(days: day));
      int notificationsPerDay = 24 ~/ perHour;
      for (int i = 0; i < notificationsPerDay; i++) {
        final hour = startHour + (perHour * i);
        if (hour > endHour) continue;
        final scheduledTime = DateTime(
          date.year,
          date.month,
          date.day,
          hour,
          0,
        );

        if (scheduledTime.isBefore(DateTime.now())) continue;

        final message = values[random.nextInt(values.length)];

        await _n.createNotification(
          content: NotificationContent(
            id: id++,
            channelKey: idHourlyChannel,
            title: message['title'],
            body: message['body'],
            notificationLayout: NotificationLayout.Default,
          ),
          schedule: NotificationCalendar(
            year: scheduledTime.year,
            month: scheduledTime.month,
            day: scheduledTime.day,
            hour: scheduledTime.hour,
            minute: scheduledTime.minute,
            timeZone: timezone,
            second: 0,
            millisecond: 0,
            repeats: false,
          ),
        );
      }
    }
  }

  static Future<void> cancelHourlyNotifications() async {
    if (!initialized) return;
    await _n.cancelSchedulesByChannelKey(idHourlyChannel);
  }

  // ---------------------------------------------------------------------------
  // HOURLY NOTIFICATIONS END
  // ---------------------------------------------------------------------------

  // ---------------------------------------------------------------------------
  // TIME_OF_DAY NOTIFICATIONS (MORNING, NOON, NIGHT) START
  // ---------------------------------------------------------------------------

  static const idTimeOfDayChannel = 'time_of_day_channel';

  static Future<void> initTimeOfDayNotifications({
    List<TimeOfDay> timeOfDays = const [
      TimeOfDay(hour: 8, minute: 0),
      TimeOfDay(hour: 14, minute: 0),
      TimeOfDay(hour: 22, minute: 0),
    ],
  }) async {
    try {
      final values = Translation.gets(
        path: 'time_of_day_notifications',
        parser: (value) => value is Map ? value : null,
      );
      await timeOfDayNotifications(timeOfDays: timeOfDays, values: values);
    } catch (_) {}
  }

  static Future<void> timeOfDayNotifications({
    required List<TimeOfDay> timeOfDays,
    required List<Map> values,
  }) async {
    if (!initialized) return;
    if (values.isEmpty) return;
    if (await isPermissionNotAllow) return;
    await cancelTimeOfDayNotifications();
    final random = math.Random();
    final now = DateTime.now();
    final timezone = await _n.getLocalTimeZoneIdentifier();

    int id = 2000;

    final days = values.fold(0, (a, b) {
      final day = b['day'];
      final d = day is num ? day.toInt() : 0;
      return a > d ? a : d;
    });

    final morning = values.where((e) => e['time'] == 'morning').toList();
    final noon = values.where((e) => e['time'] == 'noon').toList();
    final night = values.where((e) => e['time'] == 'night').toList();
    final any = values.where((e) => [null, 'any'].contains(e['time'])).toList();

    final notifications = [
      [...morning, ...any],
      [...noon, ...any],
      [...night, ...any],
    ];

    for (int day = 0; day < days; day++) {
      final date = now.add(Duration(days: day));
      for (int shiftIndex = 0; shiftIndex < timeOfDays.length; shiftIndex++) {
        final shift = timeOfDays[shiftIndex];

        final scheduledTime = DateTime(
          date.year,
          date.month,
          date.day,
          shift.hour,
          shift.minute,
          0,
        );

        if (scheduledTime.isBefore(DateTime.now())) continue;

        List<Map> current = notifications[shiftIndex];
        if (current.isEmpty) continue;

        final temp = current.where((e) => [null, day + 1].contains(e['day']));

        if (temp.length >= 10) {
          current = temp.toList();
        }

        final message = current[random.nextInt(current.length)];

        await _n.createNotification(
          content: NotificationContent(
            id: id++,
            channelKey: idTimeOfDayChannel,
            title: message['title'],
            body: message['body'],
            notificationLayout: NotificationLayout.Default,
          ),
          schedule: NotificationCalendar(
            year: scheduledTime.year,
            month: scheduledTime.month,
            day: scheduledTime.day,
            hour: scheduledTime.hour,
            minute: scheduledTime.minute,
            timeZone: timezone,
            second: 0,
            millisecond: 0,
            repeats: false,
          ),
        );
      }
    }
  }

  static Future<void> cancelTimeOfDayNotifications() async {
    if (!initialized) return;
    await _n.cancelSchedulesByChannelKey(idTimeOfDayChannel);
  }

  // ---------------------------------------------------------------------------
  // TIME_OF_DAY NOTIFICATIONS (MORNING, NOON, NIGHT) END
  // ---------------------------------------------------------------------------

  // ---------------------------------------------------------------------------
  // WEEKLY NOTIFICATIONS START
  // ---------------------------------------------------------------------------

  static const idWeeklyChannel = 'weekly_channel';

  static const idWeeklyDuration = "notifications/weekly_duration";

  static const idWeeklyLength = "notifications/weekly_length";

  static Future<void> initWeeklyNotifications() async {
    try {
      int length = Configs.get(idWeeklyLength, defaultValue: 7);
      final irregular = Translation.gets(
        path: 'weekly_notifications',
        parser: InAppNotificationContent.tryParses,
      ).randomize(length: length);

      await InAppNotifications.weekly(irregular);
    } catch (_) {}
  }

  static Future<bool> weekly(List<InAppNotificationContent> values) async {
    if (!initialized) return false;
    if (values.isEmpty) return false;
    if (await isPermissionNotAllow) return false;
    await cancelWeekly();
    try {
      final timezone = await _n.getLocalTimeZoneIdentifier();
      Duration duration = Configs.get(
        idWeeklyDuration,
        defaultValue: "days: 1",
      ).duration;

      final converted = List.generate(values.length, (i) {
        duration = duration + (duration * i);
        final date = DateTime.now().add(duration);
        final item = values.elementAt(i);
        return (date, item.copyWith(id: i, channelKey: idWeeklyChannel));
      });
      final contents = converted.map((data) async {
        final date = data.$1;
        final item = data.$2;
        return create(
          item,
          schedule: NotificationCalendar(
            timeZone: timezone,
            repeats: false,
            allowWhileIdle: true,
            year: date.year,
            month: date.month,
            day: date.day,
            hour: date.hour,
            minute: date.minute,
            second: date.second,
            preciseAlarm: true,
          ),
        );
      });
      final feedback = await Future.wait(contents);
      if (feedback.isEmpty) return false;
      return feedback.reduce((a, b) => a = a && b);
    } catch (_) {
      return false;
    }
  }

  static Future<void> cancelWeekly() async {
    if (!initialized) return;
    await _n.cancelSchedulesByChannelKey(idWeeklyChannel);
  }

  // ---------------------------------------------------------------------------
  // WEEKLY NOTIFICATIONS END
  // ---------------------------------------------------------------------------
}

extension NotificationColor on String? {
  Color? get color {
    String? raw = this;
    if (raw == null) return null;
    if (raw.length == 6 && !raw.startsWith("0x")) {
      raw = "0xFF$raw";
    } else if (raw.length == 8 && !raw.startsWith("0x")) {
      raw = "0x$raw";
    }
    final code = int.tryParse(raw);
    if (code == null) return null;
    return Color(code);
  }

  TimeOfDay get timeOfDay {
    String? input = this;
    if (input == null || input.isEmpty) return TimeOfDay.now();

    int hour = 0;
    int minute = 0;

    input = input.replaceAll('TimeOfDay(', '').replaceAll(')', '');
    final parts = input.split(',');

    for (final part in parts) {
      final trimmed = part.trim();
      if (trimmed.isEmpty) continue;
      final m = trimmed.split(':');
      if (m.length != 2) continue;
      final k = m[0].trim();
      final v = int.tryParse(m[1].trim()) ?? 0;
      switch (k) {
        case 'hour':
          hour = v;
          break;
        case 'minute':
          minute = v;
          break;
      }
    }

    return TimeOfDay(hour: hour, minute: minute);
  }

  Duration get duration {
    String? input = this;
    if (input == null || input.isEmpty) return Duration.zero;

    int days = 0;
    int hours = 0;
    int minutes = 0;
    int seconds = 0;
    int milliseconds = 0;
    int microseconds = 0;

    input = input.replaceAll('Duration(', '').replaceAll(')', '');
    final parts = input.split(',');

    for (final part in parts) {
      final trimmed = part.trim();
      if (trimmed.isEmpty) continue;
      final m = trimmed.split(':');
      if (m.length != 2) continue;
      final k = m[0].trim();
      final v = int.tryParse(m[1].trim()) ?? 0;
      switch (k) {
        case 'days':
          days = v;
          break;
        case 'hours':
          hours = v;
          break;
        case 'minutes':
          minutes = v;
          break;
        case 'seconds':
          seconds = v;
          break;
        case 'milliseconds':
          milliseconds = v;
          break;
        case 'microseconds':
          microseconds = v;
          break;
      }
    }

    return Duration(
      days: days,
      hours: hours,
      minutes: minutes,
      seconds: seconds,
      milliseconds: milliseconds,
      microseconds: microseconds,
    );
  }
}

extension NotificationDuration on int? {
  Duration? get duration {
    int? raw = this;
    if (raw == null) return null;
    return Duration(seconds: raw);
  }
}

extension NotificationEnum on Iterable {
  T current<T extends Enum?>(String? source, T defaultValue) {
    final x = where((e) {
      if (e is! Enum) return false;
      if (e.name.toLowerCase() != source?.toLowerCase()) {
        return false;
      }
      return true;
    }).firstOrNull;
    return x ?? defaultValue;
  }
}
