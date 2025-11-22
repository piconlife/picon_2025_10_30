import 'package:app_color/app_color.dart';
import 'package:app_color/extension.dart';
import 'package:app_dimen/app_dimen.dart';
import 'package:auth_management/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_andomie/extensions.dart';
import 'package:flutter_androssy_dialogs/dialogs.dart';
import 'package:flutter_androssy_kits/widgets.dart';
import 'package:flutter_entity/entity.dart';
import 'package:in_app_navigator/route.dart';

import '../../../../app/constants/app.dart';
import '../../../../app/res/icons.dart';
import '../../../../data/models/user.dart';
import '../../../../data/parsers/phone_parser.dart';
import '../../../../data/parsers/user_parser.dart';
import '../../../../data/parsers/validations.dart';
import '../../../../data/use_cases/user/find_user_by_email.dart';
import '../../../../data/use_cases/user/find_user_by_phone.dart';
import '../../../../roots/widgets/appbar.dart';
import '../../../../roots/widgets/filled_button.dart';
import '../../../../roots/widgets/image.dart';
import '../../../../roots/widgets/logo_trailing.dart';
import '../../../../roots/widgets/text.dart';
import '../../../../routes/paths.dart';
import '../../preferences/startup.dart';
import '../widgets/screen.dart';
import '../widgets/title_with_subtitle.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final etEmailKey = GlobalKey<AndrossyFieldState>();
  final etPhoneKey = GlobalKey<AndrossyFieldState>();
  final btnSubmitKey = GlobalKey<InAppFilledButtonState>();
  final etEmail = TextEditingController();
  final etPhone = TextEditingController();

  bool isPhoneMode = false;

  void _change(BuildContext context) {
    setState(() => isPhoneMode = !isPhoneMode);
  }

  void _next(BuildContext context) {
    if (isPhoneMode) {
      _continueWithPhone(context);
      return;
    }
    _continueWithEmail(context);
  }

  void _continueWithEmail(BuildContext context) async {
    String email = etEmail.text.toLowerCase().trim();
    if (!isValidPrefixOrEmail(email)) {
      if (email.contains("@")) {
        context.showWarningSnackBar("Email hasn't valid!");
        return;
      }
      context.showWarningSnackBar("Prefix hasn't valid!");
      return;
    }

    if (isValidPrefix(email)) {
      email = UserParser.asEmail(email) ?? email;
    }

    btnSubmitKey.currentState?.showLoading();
    final value = await FindUserByEmailUseCase.i(email);
    btnSubmitKey.currentState?.hideLoading();
    if (!context.mounted) return;
    if (value.status == Status.ok || value.result.isNotEmpty) {
      _verify(context, value.result.first);
    } else {
      context.showErrorSnackBar(value.error);
    }
  }

  void _continueWithPhone(BuildContext context) async {
    final number = parsePhoneNumber(null, etPhone.text.trim());
    if (number == null || !isValidPhoneNumber(number)) {
      context.showWarningSnackBar("Phone number hasn't valid!");
      return;
    }

    btnSubmitKey.currentState?.showLoading();
    final value = await FindUserByPhoneUseCase.i(number.international);
    btnSubmitKey.currentState?.hideLoading();
    if (!context.mounted) return;
    if (value.status.isSuccessful || value.result.isNotEmpty) {
      _verify(context, value.result.first);
    } else {
      context.showErrorSnackBar(value.error);
    }
  }

  void _verify(BuildContext context, UserModel user) {
    final phone = user.phone.use;
    if (phone.isEmpty) return;
    btnSubmitKey.currentState?.showLoading();
    context.signInByPhone<UserModel>(
      PhoneAuthenticator(phone: phone),
      onCodeSent: (token, _) async {
        btnSubmitKey.currentState?.hideLoading();
        if (Startup.puts({
          StartupKeys.idToken: token,
          StartupKeys.phone: phone,
          StartupKeys.provider: Provider.phone.name,
        })) {
          final value = await context.open(Routes.otp);
          if (!context.mounted) return;

          if (value is! bool || !value) {
            context.showErrorSnackBar("Verification failed!");
            return;
          }
          _login(context, user);
        }
      },
      onFailed: (error) {
        btnSubmitKey.currentState?.hideLoading();
        context.showErrorSnackBar(error.msg);
      },
    );
  }

  void _login(BuildContext context, UserModel user) async {
    final email = user.email.use;
    final password = UserParser.decryptPassword(user.password).use;
    if (email.isEmpty || password.isEmpty) return;
    btnSubmitKey.currentState?.showLoading();
    final loggedIn = await context.signInByEmail<UserModel>(
      EmailAuthenticator(email: email, password: password),
    );
    btnSubmitKey.currentState?.hideLoading();
    if (!context.mounted) return;
    if (!loggedIn.status.isAuthenticated) {
      context.showErrorSnackBar(loggedIn.error);
      return;
    }
    context.open(Routes.resetPassword, args: user);
  }

  @override
  Widget build(BuildContext context) {
    final primary = context.primary;
    final dimen = context.dimens;
    return StartupScreen(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: const InAppAppbar(
          titleText: "Forgot Password",
          actions: [InAppLogoTrailing()],
        ),
        body: SafeArea(
          child: ListView(
            padding: EdgeInsets.all(dimen.dp(24)),
            children: [
              dimen.dp(40).h,
              const InAppImage(
                "assets/images/doddle_forgot_password.svg",
                width: 232,
                height: 240,
              ),
              dimen.dp(24).h,
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(dimen.dp(4)),
                child: InAppText(
                  " or ",
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: dimen.dp(14),
                  ),
                  prefix: "Email",
                  suffix: "Phone Number",
                  prefixStyle: TextStyle(
                    fontWeight: context.mediumFontWeight,
                    color: !isPhoneMode ? primary : context.textColor.mid,
                  ),
                  suffixStyle: TextStyle(
                    fontWeight: context.mediumFontWeight,
                    color: !isPhoneMode ? context.textColor.mid : primary,
                  ),
                  onPrefixClick: (context) {
                    if (isPhoneMode) _change(context);
                  },
                  onSuffixClick: (context) {
                    if (!isPhoneMode) _change(context);
                  },
                ),
              ),
              dimen.dp(8).h,
              isPhoneMode
                  ? AndrossyField(
                    key: etPhoneKey,
                    controller: etPhone,
                    autoDisposeMode: false,
                    hintText: "Phone Number",
                    characters: "+1234567890",
                    inputType: TextInputType.phone,
                    inputAction: TextInputAction.done,
                    drawableStart: AndrossyFieldProperty(
                      focused: InAppIcons.phone.solid,
                      enabled: InAppIcons.phone.regular,
                    ),
                    onValidator: isValidNumber,
                    primaryColor: context.primary,
                    secondaryColor: context.dark.t30,
                    errorColor: ColorThemeHelper(context).error,
                    animationDuration: const Duration(milliseconds: 300),
                    borderColor: AndrossyFieldProperty(
                      enabled: context.isDarkMode ? primary.t25 : null,
                    ),
                    borderRadius: AndrossyFieldProperty.all(
                      BorderRadius.circular(dimen.dp(16)),
                    ),
                    contentPadding: EdgeInsets.all(dimen.dp(16)),
                    counterVisibility: FloatingVisibility.hide,
                    drawableStartTint: AndrossyFieldProperty(
                      enabled: context.iconColor.primary,
                      disabled: context.iconColor.disable,
                    ),
                    drawableStartPadding: AndrossyFieldProperty.all(
                      dimen.dp(12),
                    ),
                    floatingVisibility: FloatingVisibility.hide,
                    onValid: (v) => btnSubmitKey.currentState?.setEnabled(v),
                    onSubmitted: (_) => _next(context),
                  )
                  : AndrossyField(
                    key: etEmailKey,
                    controller: etEmail,
                    autoDisposeMode: false,
                    hintText: "Email or Prefix",
                    characters: "_.@1234567890abcdefghijklmnopqrstuvwxyz",
                    inputType: TextInputType.emailAddress,
                    inputAction: TextInputAction.done,
                    drawableStart: AndrossyFieldProperty(
                      focused: InAppIcons.email.solid,
                      enabled: InAppIcons.email.regular,
                    ),
                    drawableEndBuilder: (context, controller) {
                      if (etEmail.text.contains("@")) {
                        return const SizedBox();
                      }
                      return InAppText(
                        AppConstants.domain,
                        style: TextStyle(
                          color: context.mid,
                          fontSize: dimen.dp(18),
                        ),
                      );
                    },
                    onValidator: isValidPrefixOrEmail,
                    primaryColor: context.primary,
                    secondaryColor: context.dark.t30,
                    errorColor: ColorThemeHelper(context).error,
                    animationDuration: const Duration(milliseconds: 300),
                    borderColor: AndrossyFieldProperty(
                      enabled: context.isDarkMode ? primary.t25 : null,
                    ),
                    borderRadius: AndrossyFieldProperty.all(
                      BorderRadius.circular(dimen.dp(16)),
                    ),
                    contentPadding: EdgeInsets.all(dimen.dp(16)),
                    counterVisibility: FloatingVisibility.hide,
                    drawableStartTint: AndrossyFieldProperty(
                      enabled: context.iconColor.primary,
                      disabled: context.iconColor.disable,
                    ),
                    drawableStartPadding: AndrossyFieldProperty.all(
                      dimen.dp(12),
                    ),
                    floatingVisibility: FloatingVisibility.hide,
                    onValid: (v) => btnSubmitKey.currentState?.setEnabled(v),
                    onSubmitted: (_) => _next(context),
                  ),
              dimen.dp(32).h,
              AuthTitleWithSubtitle(
                title: "Forgot Password",
                subtitle:
                    "Enter your ${isPhoneMode ? "email" : "phone number"} for the verification process, we will send a 6-digit code to your ${AppConstants.name.toLowerCase()} account.",
                dimen: dimen,
                centerMode: true,
              ),
              dimen.dp(32).h,
              InAppFilledButton(
                key: btnSubmitKey,
                text: "Continue",
                enabled: false,
                onTap: () => _next(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
