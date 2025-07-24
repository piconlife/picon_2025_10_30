import 'package:flutter/material.dart';

import '../../routes/builder.dart';
import '../../routes/paths.dart';
import 'views/pages/final.dart';
import 'views/pages/intro.dart';
import 'views/pages/login.dart';
import 'views/pages/permission.dart';
import 'views/pages/quiz.dart';
import 'views/pages/splash.dart';

Map<String, RouteBuilder> get kStartupRoutes {
  return {
    Routes.splash: _splash,
    Routes.intro: _intro,
    Routes.login: _login,
    Routes.quiz: _quiz,
    Routes.permission: _permission,
    Routes.final_: _final,
  };
}

RouteBuilder kSplashRoute = _splash;

Widget _splash(BuildContext context, Object? args) {
  return SplashPage();
}

Widget _intro(BuildContext context, Object? args) {
  return IntroPage(args: args);
}

Widget _login(BuildContext context, Object? args) {
  return LoginPage(args: args);
}

Widget _quiz(BuildContext context, Object? args) {
  return QuizPage(args: args);
}

Widget _permission(BuildContext context, Object? args) {
  return PermissionPage(args: args);
}

Widget _final(BuildContext context, Object? args) {
  return FinalPage(args: args);
}
