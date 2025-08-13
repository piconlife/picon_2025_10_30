import 'package:app_color/app_color.dart';
import 'package:app_color/extension.dart';
import 'package:app_dimen/app_dimen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_andomie/core.dart';
import 'package:flutter_androssy_dialogs/dialogs.dart';
import 'package:flutter_androssy_kits/widgets.dart';
import 'package:in_app_navigator/in_app_navigator.dart';

import '../../../../app/constants/limitations.dart';
import '../../../../app/dialogs/dialog_date_picker.dart';
import '../../../../roots/widgets/appbar.dart';
import '../../../../roots/widgets/filled_button.dart';
import '../../../../roots/widgets/gesture.dart';
import '../../../../roots/widgets/logo_trailing.dart';
import '../../../../roots/widgets/screen.dart';
import '../../../../roots/widgets/text.dart';
import '../../../../routes/paths.dart';
import '../../preferences/startup.dart';
import '../widgets/title_with_subtitle.dart';

class BirthdayPage extends StatefulWidget {
  const BirthdayPage({super.key});

  @override
  State<BirthdayPage> createState() => _BirthdayPageState();
}

class _BirthdayPageState extends State<BirthdayPage> {
  final etDayFocus = FocusNode();
  final etMonthFocus = FocusNode();
  final etYearFocus = FocusNode();

  final etDayKey = GlobalKey<AndrossyFieldState>();
  final etMonthKey = GlobalKey<AndrossyFieldState>();
  final etYearKey = GlobalKey<AndrossyFieldState>();
  final btnSubmitKey = GlobalKey<InAppFilledButtonState>();

  late final etDay = TextEditingController();
  late final etMonth = TextEditingController();
  late final etYear = TextEditingController();

  int? get day => int.tryParse(etDay.text);

  int? get month => int.tryParse(etMonth.text);

  int? get year => int.tryParse(etYear.text);

  DateTime get currentDate => DateTime.utc(year ?? 0, month ?? 0, day ?? 0);

  bool get isValidBirthday {
    return isValidDay() && isValidMonth() && isValidYear();
  }

  bool isValidDay([String? value]) {
    return (value ?? etDay.text).isValidDay;
  }

  bool isValidMonth([String? value]) {
    return (value ?? etMonth.text).isValidMonth;
  }

  bool isValidYear([String? value]) {
    return (value ?? etYear.text).isValidYear(Limitations.ageMinimum);
  }

  void _changeDay(String value) {
    if (value.length == 2 && isValidDay(value)) {
      if (!isValidMonth()) {
        etMonthFocus.requestFocus();
      } else if (!isValidYear()) {
        etYearFocus.requestFocus();
      } else {
        _change();
      }
    } else {
      _change();
    }
  }

  void _changeMonth(String value) {
    if (value.length == 2 && isValidMonth(value)) {
      if (!isValidDay()) {
        etDayFocus.requestFocus();
      } else if (!isValidYear()) {
        etYearFocus.requestFocus();
      } else {
        _change();
      }
    } else {
      _change(value);
    }
  }

  void _changeYear(String value) {
    if (value.length == 4 && isValidYear(value)) {
      if (!isValidDay()) {
        etDayFocus.requestFocus();
      } else if (!isValidMonth()) {
        etMonthFocus.requestFocus();
      } else {
        _change();
      }
    } else {
      _change();
    }
  }

  void _change([dynamic value]) {
    final isValid = isValidBirthday;
    btnSubmitKey.currentState?.setEnabled(isValid);
    if (isValid) {
      final date = currentDate;
      final ms = date.millisecondsSinceEpoch;
      final mDay = DateHelper.toDate(ms, dateFormat: DateFormats.dayFullName);
      final mMonth = DateHelper.toDate(
        ms,
        dateFormat: DateFormats.monthFullName,
      );

      etDayKey.currentState?.setHelperText(mDay);
      etMonthKey.currentState?.setHelperText(mMonth);
      etYearKey.currentState?.setHelperText("${date.year}");
    } else {
      etDayKey.currentState?.setHelperText("");
      etMonthKey.currentState?.setHelperText("");
      etYearKey.currentState?.setHelperText("");
    }
  }

  void changeDate(DateTime? date) {
    if (date != null) {
      etDay.text = date.day.toString();
      etMonth.text = date.month.toString();
      etYear.text = date.year.toString();
    }
    _change(date);
  }

  void chooseDate(BuildContext context) {
    final now = DateTime.now();
    DatePickerBSD.show(
      context,
      title: "What's your birthday?",
      subtitle:
          "Please select your birthday to receive a personalized experience.",
      initial: DateTime.utc(
        year ?? now.year - 20,
        month ?? now.month,
        day ?? now.day,
      ),
      start: DateTime(now.year - Limitations.ageMaximum),
      end: DateTime(now.year - Limitations.ageMinimum, 12, 31),
      onChange: changeDate,
    ).then(changeDate);
  }

  void _next(BuildContext context) {
    if (!isValidDay()) {
      etDayFocus.requestFocus();
      context.showWarningSnackBar("Please select your day of birthday");
      return;
    }
    if (!isValidMonth()) {
      etMonthFocus.requestFocus();
      context.showWarningSnackBar("Please select your month of birthday");
      return;
    }
    if (!isValidYear()) {
      etYearFocus.requestFocus();
      context.showWarningSnackBar("Please select your year of birthday");
      return;
    }

    if (Startup.puts({
      StartupKeys.birthday: currentDate.millisecondsSinceEpoch,
    })) {
      context.open(Routes.gender);
    }
  }

  @override
  void initState() {
    super.initState();
    final birthday = Startup.i.birthday;
    if (birthday != null && birthday > 0) {
      final date = DateTime.fromMillisecondsSinceEpoch(birthday);
      etDay.text = "${date.day}";
      etMonth.text = "${date.month}";
      etYear.text = "${date.year}";
    }
  }

  @override
  Widget build(BuildContext context) {
    final primary = context.primary;
    final dimen = context.dimens;
    return InAppScreen(
      unfocusMode: true,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: const InAppAppbar(
          titleText: "Birthday",
          actions: [InAppLogoTrailing()],
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: dimen.dp(32),
            vertical: dimen.dp(24),
          ),
          child: Column(
            children: [
              AuthTitleWithSubtitle(
                dimen: dimen,
                title: "What's your birthday?",
                subtitle:
                    "Please enter your birthday to receive a personalized experience.",
              ),
              dimen.dp(24).h,
              Padding(
                padding: EdgeInsets.symmetric(horizontal: dimen.dp(12)),
                child: AndrossyForm(
                  onValid: btnSubmitKey.currentState?.setEnabled,
                  direction: Axis.horizontal,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  style: TextStyle(fontSize: dimen.dp(18)),
                  helperStyle: AndrossyFieldProperty(
                    enabled: TextStyle(
                      color: context.isDarkMode ? context.dark.t50 : null,
                    ),
                    focused: TextStyle(color: primary),
                  ),
                  floatingStyle: AndrossyFieldProperty(
                    enabled: TextStyle(
                      color: context.dark.t50,
                      fontWeight: FontWeight.w500,
                    ),
                    focused: TextStyle(
                      color: primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  floatingVisibility: FloatingVisibility.auto,
                  floatingAlignment: Alignment.center,
                  textAlign: TextAlign.center,
                  counterVisibility: FloatingVisibility.hide,
                  children: [
                    Expanded(
                      child: AndrossyField(
                        key: etDayKey,
                        controller: etDay,
                        focusNode: etDayFocus,
                        characters: "1234567890",
                        hintText: "Day",
                        textAlign: TextAlign.center,
                        inputType: TextInputType.number,
                        inputAction: TextInputAction.next,
                        maxCharacters: 2,
                        minCharacters: 1,
                        maxCharactersAsLimit: true,
                        counterVisibility: FloatingVisibility.hide,
                        onChanged: _changeDay,
                        onValidator: isValidDay,
                      ),
                    ),
                    dimen.dp(8).w,
                    Expanded(
                      child: AndrossyField(
                        key: etMonthKey,
                        focusNode: etMonthFocus,
                        controller: etMonth,
                        characters: "1234567890",
                        hintText: "Month",
                        inputType: TextInputType.number,
                        inputAction: TextInputAction.next,
                        maxCharacters: 2,
                        minCharacters: 1,
                        maxCharactersAsLimit: true,
                        onChanged: _changeMonth,
                        onValidator: isValidMonth,
                      ),
                    ),
                    dimen.dp(8).w,
                    Expanded(
                      child: AndrossyField(
                        key: etYearKey,
                        focusNode: etYearFocus,
                        controller: etYear,
                        characters: "1234567890",
                        inputAction: TextInputAction.done,
                        hintText: "Year",
                        inputType: TextInputType.number,
                        maxCharacters: 4,
                        minCharacters: 4,
                        maxCharactersAsLimit: true,
                        onChanged: _changeYear,
                        onValidator: isValidYear,
                      ),
                    ),
                  ],
                ),
              ),
              dimen.dp(32).h,
              InAppFilledButton(
                key: btnSubmitKey,
                enabled: false,
                text: "Next",
                onTap: () => _next(context),
              ),
              Container(
                alignment: Alignment.centerRight,
                width: double.infinity,
                padding: EdgeInsets.all(dimen.dp(8)),
                child: InAppGesture(
                  onTap: () => chooseDate(context),
                  child: InAppText(
                    "Select your birthday",
                    textAlign: TextAlign.end,
                    style: TextStyle(fontSize: dimen.dp(14), color: primary),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
