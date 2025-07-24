import 'dart:developer';

import 'package:app_color/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_andomie/utils/date_helper.dart';
import 'package:flutter_andomie/utils/translation.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../../configs/extensions/text_direction.dart';
import '../../../../roots/widgets/icon.dart';
import '../../../../roots/widgets/layout.dart';
import '../../../../roots/widgets/text.dart';

enum ItemStatus { completed, missed, uncompleted }

enum RangeStatus {
  completed,
  missed,
  uncompleted,
  completedRangeStart,
  completedRangeEnd,
  completedMiddleRange,
  uncompletedRangeStart,
  uncompletedRangeEnd,
  uncompletedMiddleRange,
  missedRangeStart,
  missedRangeEnd,
  missedMiddleRange;

  bool get isStart {
    return this == RangeStatus.completedRangeStart ||
        this == RangeStatus.uncompletedRangeStart ||
        this == RangeStatus.missedRangeStart;
  }

  bool get isMiddle {
    return this == RangeStatus.completedMiddleRange ||
        this == RangeStatus.uncompletedMiddleRange ||
        this == RangeStatus.missedMiddleRange;
  }

  bool get isEnd {
    return this == RangeStatus.completedRangeEnd ||
        this == RangeStatus.uncompletedRangeEnd ||
        this == RangeStatus.missedRangeEnd;
  }

  bool get isCompleted =>
      this == RangeStatus.completed ||
      this == RangeStatus.completedRangeStart ||
      this == RangeStatus.completedRangeEnd;

  bool get isUncompleted =>
      this == RangeStatus.uncompleted ||
      this == RangeStatus.uncompletedRangeStart ||
      this == RangeStatus.uncompletedRangeEnd;

  bool get isMissed =>
      this == RangeStatus.missed ||
      this == RangeStatus.missedRangeStart ||
      this == RangeStatus.missedRangeEnd;

  bool get isRange => isStart || isMiddle || isEnd;

  bool get isCompletedRange {
    return this == RangeStatus.completedRangeStart ||
        this == RangeStatus.completedMiddleRange ||
        this == RangeStatus.completedRangeEnd;
  }

  bool get isUncompletedRange {
    return this == RangeStatus.uncompletedRangeStart ||
        this == RangeStatus.uncompletedMiddleRange ||
        this == RangeStatus.uncompletedRangeEnd;
  }

  bool get isMissedRange {
    return this == RangeStatus.missedRangeStart ||
        this == RangeStatus.missedMiddleRange ||
        this == RangeStatus.missedRangeEnd;
  }

  factory RangeStatus.parse({
    required ItemStatus? previous,
    required ItemStatus current,
    required ItemStatus? next,
  }) {
    bool isSame(ItemStatus? a, ItemStatus b) => a != null && a == b;
    switch (current) {
      case ItemStatus.completed:
        if (!isSame(previous, current) && isSame(next, current)) {
          return RangeStatus.completedRangeStart;
        } else if (isSame(previous, current) && !isSame(next, current)) {
          return RangeStatus.completedRangeEnd;
        } else if (isSame(previous, current) && isSame(next, current)) {
          return RangeStatus.completedMiddleRange;
        } else {
          return RangeStatus.completed;
        }

      case ItemStatus.uncompleted:
        if (!isSame(previous, current) && isSame(next, current)) {
          return RangeStatus.uncompletedRangeStart;
        } else if (isSame(previous, current) && !isSame(next, current)) {
          return RangeStatus.uncompletedRangeEnd;
        } else if (isSame(previous, current) && isSame(next, current)) {
          return RangeStatus.uncompletedMiddleRange;
        } else {
          return RangeStatus.uncompleted;
        }

      case ItemStatus.missed:
        if (!isSame(previous, current) && isSame(next, current)) {
          return RangeStatus.missedRangeStart;
        } else if (isSame(previous, current) && !isSame(next, current)) {
          return RangeStatus.missedRangeEnd;
        } else if (isSame(previous, current) && isSame(next, current)) {
          return RangeStatus.missedMiddleRange;
        } else {
          return RangeStatus.missed;
        }
    }
  }
}

class _Data {
  final DateTime date;
  final double value;
  final RangeStatus status;

  bool get isPrevious => status.isStart;

  bool get isNext => status.isEnd;

  const _Data({required this.date, required this.status, this.value = 0});

  _Data copyWith({DateTime? date, RangeStatus? status, double? value}) {
    return _Data(
      date: date ?? this.date,
      status: status ?? this.status,
      value: value ?? this.value,
    );
  }
}

class TimelineData {
  final DateTime date;
  final double progress;
  final bool completed;

  const TimelineData({
    required this.date,
    required this.progress,
    required this.completed,
  });
}

class TimelineChart extends StatefulWidget {
  final Map<DateTime, TimelineData> data;

  const TimelineChart({super.key, required this.data});

  @override
  State<TimelineChart> createState() => _TimelineChartState();
}

class _TimelineChartState extends State<TimelineChart>
    with ColorMixin, TranslationMixin {
  Map<DateTime, _Data> _data = {};

  DateTime focusedDay = DateTime.now();

  // DateTime get firstDay => widget.data.keys.firstOrNull ?? DateTime.now();

  bool isToday(DateTime date) {
    final now = DateTime.now();
    return date.day == now.day &&
        date.month == now.month &&
        date.year == now.year;
  }

  bool isMonth(DateTime date) {
    final now = DateTime.now();
    return date.month == now.month && date.year == now.year;
  }

  _Data _parse(DateTime date) {
    final p = date.subtract(Duration(days: 1));
    final n = date.add(Duration(days: 1));
    final current = widget.data[date];
    final previous = widget.data[p];
    final next = widget.data[n];
    final status = RangeStatus.parse(
      previous: isToday(p)
          ? ItemStatus.uncompleted
          : previous == null || previous.progress == 0
          ? ItemStatus.missed
          : previous.progress >= 1
          ? ItemStatus.completed
          : ItemStatus.uncompleted,
      current: isToday(date)
          ? ItemStatus.uncompleted
          : current == null || current.progress == 0
          ? ItemStatus.missed
          : current.progress >= 1
          ? ItemStatus.completed
          : ItemStatus.uncompleted,
      next: isToday(n)
          ? ItemStatus.uncompleted
          : next == null || next.progress == 0
          ? ItemStatus.missed
          : next.progress >= 1
          ? ItemStatus.completed
          : ItemStatus.uncompleted,
    );
    log("$date: $status");
    return _Data(date: date, status: status, value: current?.progress ?? 0);
  }

  MapEntry<DateTime, _Data>? _entry(DateTime date) {
    final current = _parse(date);
    return MapEntry(date, current);
  }

  void _loadData() {
    if (widget.data.isEmpty) return;
    final startDate = widget.data.keys.first;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final daysDifference = today.difference(startDate).inDays;
    final dates = List.generate(daysDifference + 1, (i) {
      return startDate.add(Duration(days: i));
    }).map(_entry).toList();
    _data = Map.fromEntries(dates.whereType<MapEntry<DateTime, _Data>>());
  }

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void didUpdateWidget(covariant TimelineChart oldWidget) {
    if (oldWidget.data != widget.data) {
      _loadData();
    }
    super.didUpdateWidget(oldWidget);
  }

  void _onChanged(DateTime date) {
    setState(() {
      focusedDay = date;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: textDirection,
      child: TableCalendar(
        firstDay: _data.keys.firstOrNull ?? DateTime.now(),
        lastDay: DateTime.now(),
        focusedDay: focusedDay,
        locale: locale.toString(),
        onPageChanged: _onChanged,
        headerStyle: HeaderStyle(
          titleCentered: true,
          formatButtonVisible: false,
          rightChevronMargin: EdgeInsets.zero,
          leftChevronMargin: EdgeInsets.zero,
          leftChevronPadding: EdgeInsets.all(8),
          rightChevronPadding: EdgeInsets.all(8),
          titleTextFormatter: (date, locale) {
            return date
                .toDate(local: locale, format: "MMMM y")
                .trWithOption(applyRtl: true, applyNumber: true);
          },
          leftChevronIcon: InAppIcon(
            Icons.arrow_left,
            size: 28,
            color: dark.tx(64),
          ),
          rightChevronIcon: InAppIcon(
            Icons.arrow_right,
            size: 28,
            color: dark.tx(64),
          ),
          titleTextStyle: const TextStyle(
            fontSize: 15.5,
            fontWeight: FontWeight.w600,
          ),
          headerMargin: EdgeInsets.zero,
          headerPadding: EdgeInsets.only(bottom: 4, top: 8),
        ),
        daysOfWeekStyle: DaysOfWeekStyle(
          dowTextFormatter: (date, locale) {
            return localizes(
              'dow_characters',
              defaultValue: ["M", "T", "W", "T", "F", "S", "S"],
            )[date.weekday - 1];
          },
          weekdayStyle: TextStyle(
            color: dark.tx(64),
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
          weekendStyle: TextStyle(
            color: dark.tx(64),
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        calendarStyle: CalendarStyle(outsideDaysVisible: true),
        daysOfWeekHeight: 24,
        rowHeight: 40,
        startingDayOfWeek: StartingDayOfWeek.sunday,
        calendarBuilders: CalendarBuilders(
          markerBuilder: (context, day, focusedDay) {
            if (isToday(day)) return SizedBox();
            final data = _data[DateTime(day.year, day.month, day.day)];
            if (data == null) return SizedBox();
            if (data.status.isRange) {
              return _buildMarker(day);
            }
            return SizedBox();
          },
          defaultBuilder: (context, day, focusedDay) {
            return _buildDefault(day);
          },
          outsideBuilder: (context, day, focusedDay) {
            return Opacity(opacity: 0.5, child: _buildDefault(day));
          },
          disabledBuilder: (context, day, _) {
            return _buildDisable(day);
          },
          todayBuilder: (context, day, _) {
            return _buildToday(day);
          },
        ),
      ),
    );
  }

  Widget _buildDefault(DateTime day) {
    final data = _data[DateTime(day.year, day.month, day.day)];
    if (data == null) return SizedBox();
    if (data.status.isCompleted) {
      return _buildCompleted(day);
    }
    if (data.status.isUncompleted) {
      return _buildUncompleted(day, data.value);
    }
    if (data.status.isMissed) {
      return _buildMissed(day);
    }
    if (data.status.isMiddle) {
      return _buildMiddleRange(
        day,
        isCompleted: data.status.isCompletedRange,
        isUncompleted: data.status.isUncompletedRange,
      );
    }
    return SizedBox();
  }

  Widget _buildCompleted(DateTime day) {
    return Container(
      margin: const EdgeInsets.all(4),
      decoration: BoxDecoration(shape: BoxShape.circle, color: secondary),
      child: Center(
        child: InAppText(
          day.day.trNumWithOption(applyRtl: true),
          style: TextStyle(color: light, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildUncompleted(DateTime day, double progress) {
    return Container(
      margin: const EdgeInsets.all(4),
      child: InAppLayout(
        layout: LayoutType.stack,
        alignment: Alignment.center,
        children: [
          Center(
            child: SizedBox(
              width: 30,
              height: 30,
              child: CircularProgressIndicator(
                value: progress,
                strokeWidth: 4,
                color: secondary,
                backgroundColor: grey.withValues(alpha: 0.35),
                strokeCap: StrokeCap.round,
              ),
            ),
          ),
          InAppText(
            day.day.trNumWithOption(applyRtl: true),
            style: TextStyle(color: secondary, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildMissed(DateTime day) {
    return Container(
      margin: const EdgeInsets.all(4),
      decoration: BoxDecoration(shape: BoxShape.circle, color: grey),
      child: Center(
        child: InAppText(
          day.day.trNumWithOption(applyRtl: true),
          style: TextStyle(color: light, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildMiddleRange(
    DateTime day, {
    bool isCompleted = false,
    bool isUncompleted = false,
  }) {
    return Center(
      child: InAppText(
        day.day.trNumWithOption(applyRtl: true),
        style: TextStyle(
          color: isCompleted
              ? dark
              : isUncompleted
              ? secondary
              : dark.t25,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildDisable(DateTime day) {
    return Center(
      child: InAppText(
        day.day.trNumWithOption(applyRtl: true),
        style: TextStyle(color: dark.t25, fontWeight: FontWeight.w400),
      ),
    );
  }

  Widget _buildToday(DateTime day) {
    return Container(
      margin: const EdgeInsets.all(4),
      decoration: BoxDecoration(shape: BoxShape.circle, color: primary),
      child: Center(
        child: InAppText(
          day.day.trNumWithOption(applyRtl: true),
          style: TextStyle(color: light, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildMarker(DateTime day) {
    final data = _data[DateTime(day.year, day.month, day.day)];
    if (data == null) return SizedBox();
    return Container(
      margin: EdgeInsets.only(
        top: 6,
        bottom: 6,
        left: data.status.isStart ? 30 : 0,
        right: data.status.isEnd ? 30 : 0,
      ).directional,
      decoration: BoxDecoration(
        color:
            (data.status.isCompletedRange || data.status.isUncompletedRange
                    ? secondary
                    : grey)
                .t10,
      ),
    );
  }

  @override
  String get name => "calender";
}
