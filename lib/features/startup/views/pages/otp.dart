import 'dart:developer';

import 'package:app_color/app_color.dart';
import 'package:app_dimen/app_dimen.dart';
import 'package:auth_management/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_andomie/core.dart';
import 'package:flutter_androssy_dialogs/dialogs.dart';
import 'package:flutter_androssy_kits/widgets.dart';
import 'package:in_app_navigator/route.dart';

import '../../../../app/constants/limitations.dart';
import '../../../../data/models/user.dart';
import '../../../../data/parsers/validations.dart';
import '../../../../roots/widgets/appbar.dart';
import '../../../../roots/widgets/filled_button.dart';
import '../../../../roots/widgets/logo_trailing.dart';
import '../../../../roots/widgets/text.dart';
import '../../preferences/startup.dart';
import '../widgets/screen.dart';

const _kOtpTimeout = Duration(minutes: 2);

class OtpPage extends StatefulWidget {
  final Object? args;

  const OtpPage({super.key, this.args});

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  final countdown = GlobalKey<AndrossyCountdownState>();
  final btnContinue = GlobalKey<InAppFilledButtonState>();
  final etOtp = TextEditingController();

  String? get providerText {
    final provider = Provider.from(Startup.i.provider);
    if (provider.isPhone) {
      return Startup.i.phone;
    } else if (provider.isEmail) {
      return Startup.i.email;
    } else {
      return null;
    }
  }

  void _onResendCode(BuildContext context) {
    final phone = Startup.i.phone;
    if (phone == null || phone.isEmpty || !isValidNumber(phone)) {
      context.showErrorSnackBar("Phone number isn't valid!");
      return;
    }

    countdown.currentState?.restart();
    final auth = PhoneAuthenticator(phone: phone);
    context.signInByPhone<UserModel>(
      auth,
      onCodeSent: (token, _) {
        Startup.puts({StartupKeys.idToken: token});
        context.showSnackBar("Verification code sent");
      },
      onCodeAutoRetrievalTimeout: (token) {
        Startup.puts({StartupKeys.idToken: token});
      },
      timeout: _kOtpTimeout,
    );
  }

  void _submit(BuildContext context) async {
    final token = Startup.i.idToken;
    if (token == null || token.isEmpty) {
      context.showWarningSnackBar("Verification code not valid!");
      return;
    }

    final code = etOtp.text;
    if (code.isEmpty || !isValidOtp(code)) {
      context.showWarningSnackBar("Otp code not valid!");
      return;
    }

    _verify(context, token, code);
  }

  Future<void> _verify(
    BuildContext context,
    String token,
    String smsCode,
  ) async {
    btnContinue.currentState?.showLoading();
    final response = await context.verifyPhoneByOtp<UserModel>(
      OtpAuthenticator(token: token, smsCode: smsCode),
    );
    btnContinue.currentState?.hideLoading();
    if (!context.mounted) return;
    if (!response.status.isAuthenticated || response.isError) {
      context.showErrorSnackBar(response.error);
      return;
    }
    context.close(result: true);
    log("_verify_done");
  }

  @override
  Widget build(BuildContext context) {
    final primary = context.primary;
    final dimen = context.dimens;
    return StartupScreen(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: const InAppAppbar(
          titleText: "Verification",
          elevation: 0,
          actions: [InAppLogoTrailing()],
        ),
        body: SafeArea(
          child: ListView(
            padding: EdgeInsets.symmetric(
              horizontal: dimen.dp(32),
              vertical: dimen.dp(24),
            ),
            children: [
              dimen.dp(56).h,
              InAppText(
                "Verification",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: dimen.dp(24),
                  fontWeight: context.boldFontWeight,
                ),
              ),
              dimen.dp(8).h,
              InAppText(
                "Enter the code from the sms we sent \nto ",
                textAlign: TextAlign.center,
                style: TextStyle(color: context.dark.withValues(alpha: .54)),
                suffix: providerText,
                suffixStyle: TextStyle(fontWeight: context.boldFontWeight),
              ),
              dimen.dp(32).h,
              Row(
                children: [
                  const Spacer(),
                  Expanded(
                    flex: 3,
                    child: AndrossyField(
                      controller: etOtp,
                      hintText: "CODE",
                      inputType: TextInputType.number,
                      textAlign: TextAlign.center,
                      minCharacters: Limitations.minOtp,
                      maxCharacters: Limitations.maxOtp,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 8,
                      ),
                      characters: "1234567890",
                      onValidator: isValidOtp,
                      onValid: (v) {
                        btnContinue.currentState?.setEnabled(v);
                      },
                      onSubmitted: (_) => _submit(context),
                    ),
                  ),
                  const Spacer(),
                ],
              ),
              dimen.dp(24).h,
              AndrossyCountdown(
                key: countdown,
                target: _kOtpTimeout,
                builder: (context, value) {
                  var min = value.minutes.x2D;
                  var sec = value.seconds.x2D;
                  final isCompleted = value == Duration.zero;
                  return InAppText(
                    "I didn't receive any code. ",
                    textAlign: TextAlign.center,
                    suffix: isCompleted ? "RESEND" : "$min:$sec",
                    style: TextStyle(fontSize: dimen.dp(16)),
                    suffixStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isCompleted ? primary : Colors.grey,
                    ),
                    onSuffixClick: isCompleted ? _onResendCode : null,
                  );
                },
              ),
              dimen.dp(32).h,
              InAppFilledButton(
                enabled: false,
                key: btnContinue,
                text: "Continue",
                onTap: () => _submit(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
