import 'package:app_color/app_color.dart';
import 'package:app_color/extension.dart';
import 'package:app_dimen/app_dimen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_andomie/core.dart';
import 'package:flutter_cupertino_datetime_picker/flutter_cupertino_datetime_picker.dart'
    as p;

import '../../roots/widgets/filled_button.dart';
import '../../roots/widgets/text.dart';

typedef OnDatePickerBSDChangeListener = void Function(DateTime? value);

class DatePickerBSD extends StatefulWidget {
  final DateTime? start;
  final DateTime? end;
  final DateTime? initial;
  final String? title;
  final String? subtitle;
  final OnDatePickerBSDChangeListener? onChange;

  const DatePickerBSD({
    super.key,
    this.start,
    this.end,
    this.initial,
    this.title,
    this.subtitle,
    this.onChange,
  });

  @override
  State<DatePickerBSD> createState() => _DatePickerBSDState();

  static Future<DateTime?> show(
    BuildContext context, {
    OnDatePickerBSDChangeListener? onChange,
    String? title,
    String? subtitle,
    DateTime? initial,
    DateTime? start,
    DateTime? end,
  }) {
    return showModalBottomSheet<DateTime?>(
      context: context,
      backgroundColor: context.bottomColor.primary,
      builder: (_) {
        return DatePickerBSD(
          title: title,
          subtitle: subtitle,
          initial: initial,
          end: end,
          start: start,
          onChange: onChange,
        );
      },
    );
  }
}

class _DatePickerBSDState extends State<DatePickerBSD> {
  late DateTime? _selected = widget.initial;

  @override
  Widget build(BuildContext context) {
    final titleMode = (widget.title ?? "").isNotEmpty;
    final subtitleMode = (widget.subtitle ?? "").isNotEmpty;
    final headerMode = titleMode || subtitleMode;
    final color = context.isDarkMode ? Colors.white : context.primary;
    return DimenLayout(
      builder: (context, dimen) {
        return Container(
          width: double.infinity,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: context.dialogColor.primary,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(dimen.dp(25)),
              topRight: Radius.circular(dimen.dp(25)),
            ),
          ),
          constraints: BoxConstraints(minHeight: dimen.dp(350)),
          padding: EdgeInsets.only(top: dimen.dp(headerMode ? 16 : 32)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (headerMode)
                Padding(
                  padding: EdgeInsets.all(dimen.dp(16)),
                  child: Column(
                    children: [
                      if (titleMode) ...[
                        InAppText(
                          widget.title,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: context.dark,
                            fontSize: dimen.dp(20),
                          ),
                        ),
                        dimen.dp(4).h,
                      ],
                      if (subtitleMode)
                        InAppText(
                          widget.subtitle,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: context.dark.t50,
                            fontSize: dimen.dp(14),
                          ),
                        ),
                    ],
                  ),
                ),
              p.DateTimePickerWidget(
                initDateTime: widget.initial,
                minDateTime: widget.start,
                maxDateTime: widget.end,
                dateFormat: "dd-MMM-yyyy",
                onChange:
                    (date, _) => setState(() {
                      _selected = date;
                      if (widget.onChange != null) widget.onChange!(date);
                    }),
                pickerTheme: p.DateTimePickerTheme(
                  pickerHeight: dimen.dp(headerMode ? 120 : 180),
                  backgroundColor: Colors.transparent,
                  showTitle: false,
                  itemHeight: dimen.dp(50),
                  itemTextStyle: TextStyle(
                    color: color,
                    fontWeight: FontWeight.w500,
                  ),
                  selectionOverlay: Container(
                    margin: EdgeInsets.symmetric(horizontal: dimen.dp(12)),
                    decoration: BoxDecoration(
                      color: color.t10,
                      border: Border.all(color: color.t10, width: dimen.dp(2)),
                      borderRadius: BorderRadius.circular(dimen.dp(12)),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: dimen.dp(24),
                  right: dimen.dp(24),
                  top: dimen.dp(24),
                ),
                child: InAppFilledButton(
                  text: "OK",
                  background: context.primary.t10,
                  textStyle: TextStyle(color: context.primary),
                  borderRadius: BorderRadius.circular(dimen.dp(25)),
                  onTap: () => Navigator.pop(context, _selected),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
