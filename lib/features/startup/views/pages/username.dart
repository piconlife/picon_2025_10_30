import 'package:app_color/app_color.dart';
import 'package:app_color/extension.dart';
import 'package:app_dimen/app_dimen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_andomie/extensions/spacing.dart';
import 'package:flutter_andomie/extensions/string.dart';
import 'package:flutter_androssy_dialogs/dialogs.dart';
import 'package:flutter_androssy_kits/widgets.dart';
import 'package:flutter_entity/entity.dart';
import 'package:in_app_navigator/in_app_navigator.dart';

import '../../../../app/constants/limitations.dart';
import '../../../../app/res/icons.dart';
import '../../../../data/parsers/errors.dart';
import '../../../../data/parsers/validations.dart';
import '../../../../data/use_cases/unifier/check_username.dart';
import '../../../../data/use_cases/unifier/create_user_name.dart';
import '../../../../roots/widgets/appbar.dart';
import '../../../../roots/widgets/filled_button.dart';
import '../../../../roots/widgets/logo_trailing.dart';
import '../../../../roots/widgets/screen.dart';
import '../../../../routes/paths.dart';
import '../../preferences/startup.dart';
import '../widgets/title_with_subtitle.dart';

class UsernamePage extends StatefulWidget {
  final Object? args;

  const UsernamePage({super.key, this.args});

  @override
  State<UsernamePage> createState() => _UsernamePageState();
}

class _UsernamePageState extends State<UsernamePage> with ColorMixin {
  final etFullnameKey = GlobalKey<AndrossyFieldState>();
  final etShortnameKey = GlobalKey<AndrossyFieldState>();
  final btnSubmit = GlobalKey<InAppFilledButtonState>();
  final etFullname = TextEditingController();
  final etShortname = TextEditingController();

  String? get _username => Startup.i.shortname;

  @override
  void initState() {
    super.initState();
    etFullname.text = Startup.i.fullname.use;
    etShortname.text = _username.use;
  }

  Future<AndrossyFieldError> _check(String value) async {
    btnSubmit.currentState?.setEnabled(false);
    final response = await CheckUsernameUseCase.i(value);
    if (response.status.isNetworkError) return AndrossyFieldError.networkError;
    final remote = response.result.firstOrNull;
    if (remote?.value == null || remote?.value == _username) {
      if (!(remote?.verified ?? false)) return AndrossyFieldError.none;
    }
    return AndrossyFieldError.alreadyFound;
  }

  void _next(BuildContext context) async {
    final fullname = etFullname.text.trim();
    if (!isValidFullname(fullname)) {
      context.showWarningSnackBar("Fullname hasn't valid!");
      return;
    }

    final shortname = etShortname.text.trim();
    if (!isValidUsername(shortname)) {
      context.showWarningSnackBar("Shortname hasn't valid!");
      return;
    }

    if (!etShortnameKey.currentState!.isChecked) {
      context.showWarningSnackBar("Shortname is unavailable!");
      return;
    }

    if (shortname == _username) {
      return _continue(fullname, shortname);
    }

    btnSubmit.currentState?.showLoading();
    final value = await CreateUserNameUseCase.i(shortname);
    btnSubmit.currentState?.hideLoading();
    if (!value.status.isSuccessful) {
      if (context.mounted) context.showErrorSnackBar(value.error);
      return;
    }
    _continue(fullname, shortname);
  }

  void _continue(String fullname, String shortname) {
    if (Startup.puts({
      StartupKeys.fullname: fullname,
      StartupKeys.shortname: shortname,
    })) {
      context.open(Routes.birthday);
    }
  }

  @override
  Widget build(BuildContext context) {
    final dimen = context.dimens;
    return InAppScreen(
      child: Scaffold(
        appBar: const InAppAppbar(
          titleText: "Create username",
          actions: [InAppLogoTrailing()],
        ),
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: ListView(
            padding: EdgeInsets.symmetric(
              horizontal: dimen.dp(24),
              vertical: dimen.dp(16),
            ),
            children: [
              AuthTitleWithSubtitle(
                title: "What's your name?",
                subtitle:
                    "Please enter your details to receive a personalized experience.",
                dimen: dimen,
              ),
              dimen.dp(24).h,
              AndrossyForm(
                primaryColor: primary,
                secondaryColor: dark.t30,
                errorColor: error,
                animationDuration: const Duration(milliseconds: 300),
                borderColor: const AndrossyFieldProperty.auto(),
                borderRadius: AndrossyFieldProperty.all(
                  BorderRadius.circular(dimen.dp(16)),
                ),
                contentPadding: EdgeInsets.all(dimen.dp(16)),
                counterVisibility: FloatingVisibility.always,
                drawableEndTint: AndrossyFieldProperty(
                  enabled: primary,
                  disabled: iconColor.disable,
                  error: iconColor.error,
                  focused: primary,
                ),
                drawableStartTint: AndrossyFieldProperty(
                  enabled: primary,
                  focused: primary,
                  error: iconColor.error,
                  disabled: iconColor.disable,
                ),
                drawableStartPadding: AndrossyFieldProperty(
                  enabled: dimen.dp(12),
                ),
                drawableEndPadding: AndrossyFieldProperty(enabled: dimen.dp(4)),
                floatingPadding: EdgeInsets.symmetric(
                  horizontal: dimen.dp(12),
                  vertical: dimen.dp(4),
                ),
                floatingVisibility: FloatingVisibility.always,
                style: TextStyle(color: dark),
                onValid: (v) => btnSubmit.currentState?.setEnabled(v),
                children: [
                  AndrossyField(
                    key: etFullnameKey,
                    controller: etFullname,
                    hintText: "Fullname",
                    inputAction: TextInputAction.next,
                    inputType: TextInputType.name,
                    drawableStart: AndrossyFieldProperty(
                      enabled: InAppIcons.user.regular,
                      focused: InAppIcons.user.solid,
                    ),
                    drawableEnd: AndrossyFieldProperty(
                      valid: InAppIcons.nativeCheckMark.regular,
                    ),
                    maxCharacters: Limitations.maxFullname,
                    minCharacters: Limitations.minFullname,
                    onError: AuthErrors.fullname,
                    onValidator: isValidFullname,
                  ),
                  dimen.dp(24).h,
                  AndrossyField(
                    key: etShortnameKey,
                    controller: etShortname,
                    hintText: "Shortname",
                    inputAction: TextInputAction.done,
                    inputType: TextInputType.name,
                    characters: "1234567890_.abcdefghijklmnopqrstuvwxyz",
                    drawableStart: AndrossyFieldProperty(
                      enabled: InAppIcons.user.regular,
                      focused: InAppIcons.user.solid,
                    ),
                    drawableEnd: AndrossyFieldProperty(
                      valid: InAppIcons.nativeCheckMark.regular,
                    ),
                    maxCharacters: Limitations.maxUsername,
                    minCharacters: Limitations.minUsername,
                    onCheck: _check,
                    onError: AuthErrors.shortname,
                    onValidator: isValidUsername,
                    onSubmitted: (value) => _next(context),
                  ),
                ],
              ),
              dimen.dp(32).h,
              InAppFilledButton(
                enabled: false,
                key: btnSubmit,
                text: "Next",
                onTap: () => _next(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
