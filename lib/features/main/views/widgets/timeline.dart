import 'package:app_color/app_color.dart';
import 'package:app_dimen/app_dimen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_andomie/utils/date_helper.dart';
import 'package:flutter_andomie/utils/settings.dart';
import 'package:flutter_andomie/utils/translation.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../../roots/widgets/layout.dart';
import '../../../../roots/widgets/text.dart';

const _kTimelineStart = "timeline_start";

void initTimeline() {
  final timeline = Settings.get(_kTimelineStart, 0);
  if (timeline <= 0) {
    Settings.set(_kTimelineStart, DateTime.now().millisecondsSinceEpoch);
  }
}

class Timeline extends StatefulWidget implements PreferredSizeWidget {
  final double elevation;
  final Color? elevationColor;
  final double? height;
  final DateTime? selectedDate;
  final ValueChanged<DateTime>? onChanged;

  const Timeline({
    super.key,
    this.elevation = 0,
    this.height,
    this.elevationColor,
    this.selectedDate,
    this.onChanged,
  });

  @override
  State<Timeline> createState() => _TimelineState();

  @override
  Size get preferredSize => Size.fromHeight(height ?? 90);
}

class _TimelineState extends State<Timeline> with ColorMixin, TranslationMixin {
  DateTime firstDay = DateTime.fromMillisecondsSinceEpoch(
    Settings.get(_kTimelineStart, 0),
  );

  DateTime lastDay = DateTime.now();

  late DateTime selectedDate = widget.selectedDate ?? DateTime.now();

  void changeTimeline(DateTime a, DateTime b) {
    setState(() => selectedDate = a);
    if (widget.onChanged != null) widget.onChanged!(a);
  }

  @override
  void didUpdateWidget(covariant Timeline oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedDate != oldWidget.selectedDate) {
      selectedDate = widget.selectedDate ?? selectedDate;
    }
  }

  @override
  Widget build(BuildContext context) {
    final dimen = context.dimens;
    final weekdayStyle = TextStyle(
      color: mid,
      fontSize: 12,
      fontWeight: FontWeight.w600,
    );
    Widget child = Padding(
      padding: const EdgeInsets.only(bottom: 8).apply(dimen),
      child: Directionality(
        textDirection: Translation.textDirection,
        child: TableCalendar(
          daysOfWeekStyle: DaysOfWeekStyle(
            dowTextFormatter: (date, __) {
              if (date.isToday) {
                return localize("today", defaultValue: "Today");
              }
              return localizes(
                'dow_characters',
                defaultValue: ["M", "T", "W", "T", "F", "S", "S"],
              )[date.weekday - 1];
            },
            weekdayStyle: weekdayStyle,
            weekendStyle: weekdayStyle,
          ),
          daysOfWeekHeight: dimen.dy(20),
          headerVisible: false,
          rowHeight: dimen.dy(55),
          focusedDay: selectedDate,
          firstDay: firstDay,
          lastDay: lastDay,
          currentDay: selectedDate,
          calendarFormat: CalendarFormat.week,
          onDaySelected: changeTimeline,
          calendarBuilders: CalendarBuilders(
            todayBuilder: (context, date, _) {
              return Center(
                child: SizedBox.square(
                  dimension: dimen.dp(40),
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: secondary,
                      shape: BoxShape.circle,
                    ),
                    child: InAppText(
                      date.day.trNumWithOption(applyRtl: true),
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        color: lightAsFixed,
                      ),
                    ),
                  ),
                ),
              );
            },
            defaultBuilder: (context, date, _) {
              return Center(
                child: SizedBox.square(
                  dimension: dimen.dp(40),
                  child: Container(
                    alignment: Alignment.center,
                    child: InAppText(
                      date.day.trNumWithOption(applyRtl: true),
                      style: TextStyle(
                        color: dark,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              );
            },
            disabledBuilder: (context, date, _) {
              return Center(
                child: SizedBox.square(
                  dimension: dimen.dp(40),
                  child: Container(
                    alignment: Alignment.center,
                    child: InAppText(
                      date.day.trNumWithOption(applyRtl: true),
                      style: TextStyle(
                        color: primary.t40,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );

    if (widget.elevation > 0) {
      child = InAppLayout(
        children: [
          child,
          Divider(
            height: 0,
            thickness: widget.elevation,
            color: widget.elevationColor ?? context.dividerColor.soft,
          ),
        ],
      );
    }
    return child;
  }

  @override
  String get name => "calender";
}
