import 'package:app_color/app_color.dart';
import 'package:app_color/extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_andomie/extensions/int.dart';
import 'package:flutter_andomie/utils/configs.dart';
import 'package:flutter_andomie/utils/settings.dart';
import 'package:flutter_andomie/utils/text_parser.dart';
import 'package:flutter_andomie/utils/translation.dart';
import 'package:flutter_androssy_dialogs/dialogs.dart';

import '../../../../roots/services/notification.dart';
import '../../../../roots/widgets/gesture.dart';
import '../../../../roots/widgets/icon.dart';
import '../../../../roots/widgets/layout.dart';
import '../../../../roots/widgets/text.dart';

const kReminderTimes = "remainder_times";

List<TimeOfDay> get mTimeOfDays {
  final defaultTimes = Configs.get(
    kReminderTimes,
    defaultValue: ["08:00", "12:00", "16:00"],
  );
  return Settings.get(kReminderTimes, defaultTimes).map((e) {
    final parts = e.split(':');
    final h = parts.firstOrNull ?? "0";
    final m = parts.lastOrNull ?? "0";
    final hour = int.tryParse(h) ?? 0;
    final minute = int.tryParse(m) ?? 0;
    return TimeOfDay(hour: hour, minute: minute);
  }).toList();
}

class SettingsRemainder extends StatefulWidget {
  const SettingsRemainder({super.key});

  @override
  State<SettingsRemainder> createState() => _SettingsRemainderState();
}

class _SettingsRemainderState extends State<SettingsRemainder>
    with ColorMixin, TranslationMixin {
  late final List<TimeOfDay> _times = mTimeOfDays;

  bool get isDisabled => _times.length >= 3;

  void _showTimePicker() async {
    showTimePicker(context: context, initialTime: TimeOfDay.now()).then((
      value,
    ) {
      if (value == null) return;
      if (_times.any((e) => e.hour == value.hour)) {
        if (!mounted) return;
        context.showSnackBar(
          localize(
            "remainder_times_similar_time_error",
            defaultValue: "At least 1 hour is required",
          ),
        );
        return;
      }
      _add(value);
    });
  }

  void _add(TimeOfDay time) {
    _times.add(time);
    setState(() {});
    Settings.set(
      kReminderTimes,
      _times.map((e) {
        return "${e.hour}:${e.minute}";
      }).toList(),
    );
    _resetNotifications();
  }

  void _remove(TimeOfDay time) {
    _times.remove(time);
    setState(() {});
    Settings.set(
      kReminderTimes,
      _times.map((e) {
        return "${e.hour}:${e.minute}";
      }).toList(),
    );
    _resetNotifications();
  }

  Future<void> _resetNotifications() async {
    if (_times.isEmpty) {
      await InAppNotifications.cancelTimeOfDayNotifications();
    } else {
      await InAppNotifications.initTimeOfDayNotifications(timeOfDays: _times);
    }
  }

  @override
  Widget build(BuildContext context) {
    final x = TextParser.parse(
      localize(
        "remainder_times_description",
        defaultValue:
            "Doing Kegel exercises <span>{TIMES} times</span> a day leads to the best results! Set a reminder now to stay on track.",
        applyRtl: true,
        applyNumber: true,
        replace: (value) {
          return value.replaceAll(
            "{TIMES}",
            _times.length.trNumWithOption(applyRtl: true),
          );
        },
      ),
    );
    final a = x.elementAtOrNull(0)?.text;
    final b = x.elementAtOrNull(1)?.text;
    final c = x.elementAtOrNull(2)?.text;
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: secondary, width: 1.5),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(16),
      child: InAppLayout(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InAppText(
            localize("remainder_times", defaultValue: '🔔 Set Reminders'),
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          RichText(
            textDirection: Translation.textDirection,
            text: TextSpan(
              style: TextStyle(color: dark.t75, fontSize: 14, height: 1.3),
              children: [
                TextSpan(text: a),
                TextSpan(
                  text: b,
                  style: TextStyle(color: secondary),
                ),
                TextSpan(text: c),
              ],
            ),
          ),
          if (_times.isNotEmpty) ...[
            const SizedBox(height: 16),
            ...List.generate(_times.length, (index) {
              return _buildReminderTime(_times[index]);
            }),
          ],
          if (!isDisabled) ...[
            const SizedBox(height: 16),
            InAppGesture(
              onTap: _showTimePicker,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: secondary,
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                child: InAppLayout(
                  layout: LayoutType.row,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InAppIcon(Icons.add, color: light, size: 28),
                    SizedBox(width: 8),
                    InAppText(
                      localize(
                        "remainder_times_button",
                        defaultValue: 'Set Reminder Now',
                      ),
                      style: TextStyle(
                        color: light,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildReminderTime(TimeOfDay time) {
    final format = localize(
      "remainder_times_format",
      defaultValue: "{HOUR}:{MINUTE} {PERIOD}",
      replace: (value) {
        return value
            .replaceAll(
              "{HOUR}",
              time.hour.x2D.trWithOption(applyRtl: true, applyNumber: true),
            )
            .replaceAll(
              "{MINUTE}",
              time.minute.x2D.trWithOption(applyRtl: true, applyNumber: true),
            )
            .replaceAll(
              "{PERIOD}",
              {
                    "am": localize(
                      "remainder_times_format_period_am",
                      defaultValue: 'AM',
                    ),
                    "pm": localize(
                      "remainder_times_format_period_pm",
                      defaultValue: 'PM',
                    ),
                  }[time.period.name] ??
                  '',
            );
      },
    );
    return Container(
      margin: EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: dark.t05,
        borderRadius: BorderRadius.circular(12),
      ),
      child: InAppLayout(
        layout: LayoutType.row,
        children: [
          InAppIcon(Icons.alarm, color: dark),
          const SizedBox(width: 12),
          InAppText(
            format,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
          ),
          const Spacer(),
          InAppGesture(
            onTap: () => _remove(time),
            child: Container(
              padding: EdgeInsets.all(6),
              decoration: BoxDecoration(color: light, shape: BoxShape.circle),
              child: InAppIcon(Icons.remove, color: dark.t40),
            ),
          ),
        ],
      ),
    );
  }

  @override
  String get name => "settings:main";
}
