import 'package:flutter/material.dart';
import 'package:in_app_navigator/generate.dart';

import '../../routes/paths.dart';
import 'views/pages/asq.dart';
import 'views/pages/biometric.dart';
import 'views/pages/birthday.dart';
import 'views/pages/email.dart';
import 'views/pages/forgot_password.dart';
import 'views/pages/gender.dart';
import 'views/pages/intro.dart';
import 'views/pages/login.dart';
import 'views/pages/ongoing.dart';
import 'views/pages/otp.dart';
import 'views/pages/password.dart';
import 'views/pages/privacy.dart';
import 'views/pages/reset_password.dart';
import 'views/pages/splash.dart';
import 'views/pages/terms.dart';
import 'views/pages/terms_reader.dart';
import 'views/pages/username.dart';

Map<String, RouteBuilder> get mStartupRoutes {
  return {
    Routes.splash: _splash,
    Routes.intro: _intro,
    Routes.asq: _asq,
    Routes.biometric: _biometric,
    Routes.birthday: _birthday,
    Routes.email: _email,
    Routes.forgotPassword: _forgotPassword,
    Routes.gender: _gender,
    Routes.login: _login,
    Routes.ongoing: _ongoing,
    Routes.otp: _otp,
    Routes.password: _password,
    Routes.resetPassword: _resetPassword,
    Routes.username: _username,
    Routes.privacy: _privacyPolicy,
    Routes.terms: _terms,
    Routes.termsAndConditions: _termsAndConditions,
  };
}

RouteBuilder kSplashRoute = _splash;

Widget _splash(BuildContext context, Object? args) {
  return SplashPage();
}

Widget _intro(BuildContext context, Object? args) {
  return IntroPage(args: args);
}

Widget _asq(BuildContext context, Object? data) {
  return const AsqPage();
}

Widget _biometric(BuildContext context, Object? data) {
  return const BiometricPage();
}

Widget _birthday(BuildContext context, Object? data) {
  return const BirthdayPage();
}

Widget _email(BuildContext context, Object? data) {
  return const EmailPage();
}

Widget _forgotPassword(BuildContext context, Object? data) {
  return const ForgotPasswordPage();
}

Widget _gender(BuildContext context, Object? data) {
  return const GenderPage();
}

Widget _login(BuildContext context, Object? data) {
  return const LoginPage();
}

Widget _ongoing(BuildContext context, Object? data) {
  return const OngoingPage();
}

Widget _otp(BuildContext context, Object? data) {
  return OtpPage(args: data);
}

Widget _password(BuildContext context, Object? data) {
  return const PasswordPage();
}

Widget _resetPassword(BuildContext context, Object? data) {
  return ResetPasswordPage(args: data);
}

Widget _username(BuildContext context, Object? data) {
  return const UsernamePage();
}

Widget _privacyPolicy(BuildContext context, Object? data) {
  return PrivacyPage(args: data, isStartupMode: data is bool && data);
}

Widget _terms(BuildContext context, Object? data) {
  return TermsReaderPage(args: data);
}

Widget _termsAndConditions(BuildContext context, Object? data) {
  return TermsPage(args: data, isStartupMode: data is bool && data);
}
