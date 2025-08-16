import 'package:app_color/app_color.dart';
import 'package:app_color/extension.dart';
import 'package:app_dimen/app_dimen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_andomie/core.dart';
import 'package:flutter_androssy_dialogs/dialogs.dart';
import 'package:flutter_androssy_kits/widgets.dart';
import 'package:flutter_entity/entity.dart';
import 'package:in_app_navigator/in_app_navigator.dart';

import '../../../../app/constants/app.dart';
import '../../../../app/constants/limitations.dart';
import '../../../../data/parsers/errors.dart';
import '../../../../data/parsers/user_parser.dart';
import '../../../../data/parsers/validations.dart';
import '../../../../data/use_cases/unifier/check_email.dart';
import '../../../../data/use_cases/unifier/create_user_prefix.dart';
import '../../../../roots/widgets/appbar.dart';
import '../../../../roots/widgets/filled_button.dart';
import '../../../../roots/widgets/logo_trailing.dart';
import '../../../../roots/widgets/text.dart';
import '../../../../routes/paths.dart';
import '../../preferences/startup.dart';
import '../widgets/screen.dart';
import '../widgets/title_with_subtitle.dart';

class EmailPage extends StatefulWidget {
  const EmailPage({super.key});

  @override
  State<EmailPage> createState() => _EmailPageState();
}

class _EmailPageState extends State<EmailPage> {
  final etPrefixKey = GlobalKey<AndrossyFieldState>();
  final btnSubmit = GlobalKey<InAppFilledButtonState>();

  final etPrefix = TextEditingController();

  String? get _prefix {
    return UserParser.asPrefix(Startup.i.email) ?? Startup.i.shortname;
  }

  Future<AndrossyFieldError> _check(String value) async {
    btnSubmit.currentState?.setEnabled(false);
    final response = await CheckUserPrefixUseCase.i(value);
    if (response.status.isNetworkError) return AndrossyFieldError.networkError;
    final remote = response.result.firstOrNull;
    if (remote?.value == null || remote?.value == _prefix) {
      if (!(remote?.verified ?? false)) return AndrossyFieldError.none;
    }
    return AndrossyFieldError.alreadyFound;
  }

  void _continue(String? prefix) {
    final email = UserParser.asEmail(prefix);
    if (Startup.puts({StartupKeys.email: email})) {
      context.open(Routes.password);
    }
  }

  void _next(BuildContext context) async {
    final prefix = etPrefix.text.trim();
    if (!isValidPrefix(prefix)) {
      context.showWarningSnackBar("Prefix hasn't valid!");
      return;
    }

    if (!etPrefixKey.currentState!.isChecked) {
      context.showWarningSnackBar("Prefix is unavailable!");
      return;
    }

    btnSubmit.currentState?.showLoading();
    final value = await CreateUserPrefixUseCase.i(prefix);
    btnSubmit.currentState?.hideLoading();
    if (!value.status.isSuccessful) {
      if (context.mounted) context.showErrorSnackBar(value.error);
      return;
    }
    _continue(prefix);
  }

  void _buildEmail(String value) {
    etPrefixKey.currentState!.setHelperText(UserParser.asEmail(etPrefix.text));
  }

  @override
  Widget build(BuildContext context) {
    final primary = context.primary;
    final dimen = context.dimens;
    return StartupScreen(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: const InAppAppbar(
          titleText: "Email",
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
                title: "Make your email?",
                subtitle:
                    "Please make a ${AppConstants.name.toLowerCase()} mail to access a personalized experience.",
              ),
              dimen.dp(24).h,
              AndrossyField(
                primaryColor: primary,
                secondaryColor: context.dark.t30,
                errorColor: context.error,
                animationDuration: const Duration(milliseconds: 300),
                borderColor: const AndrossyFieldProperty.auto(),
                borderRadius: AndrossyFieldProperty.all(
                  BorderRadius.circular(dimen.dp(16)),
                ),
                contentPadding: EdgeInsets.all(dimen.dp(16)),
                counterVisibility: FloatingVisibility.always,
                drawableEndTint: AndrossyFieldProperty(
                  enabled: context.mid,
                  validFocused: primary,
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
                key: etPrefixKey,
                onValid: (v) => btnSubmit.currentState?.setEnabled(v),
                controller: etPrefix,
                hintText: "username",
                floatingText: "Prefix",
                text: _prefix,
                helperText:
                    Startup.i.email ?? UserParser.asEmail(Startup.i.shortname),
                inputAction: TextInputAction.done,
                inputType: TextInputType.name,
                characters: "1234567890_.abcdefghijklmnopqrstuvwxyz",
                onCheck: _check,
                drawableEndBuilder: (context, controller) {
                  return InAppText(
                    AppConstants.domain,
                    style: TextStyle(
                      color: context.mid,
                      fontSize: dimen.dp(18),
                    ),
                  );
                },
                maxCharacters: Limitations.maxEmail,
                minCharacters: Limitations.minEmail,
                onChanged: _buildEmail,
                onError: AuthErrors.prefix,
                onValidator: isValidPrefix,
                onSubmitted: (value) => _next(context),
              ),
              dimen.dp(32).h,
              InAppFilledButton(
                key: btnSubmit,
                enabled: false,
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
