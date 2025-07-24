import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_andomie/extensions/object.dart';
import 'package:flutter_andomie/utils/configs.dart';
import 'package:in_app_navigator/in_app_navigator.dart';

import '../features/startup/enums/authorization_mode.dart';
import '../roots/keys/configs.dart';
import '../roots/preferences/preferences.dart';
import 'paths.dart';

class NavigatorDelegate extends InAppNavigatorDelegate {
  const NavigatorDelegate() : super(defaultRoute: Routes.home);

  @override
  Object? get arguments => null;

  @override
  bool isVisited(String name) {
    return Preferences.getBoolOrNull(name) ?? false;
  }

  @override
  bool setVisitor(String name) {
    return Preferences.setBool(name, true);
  }

  @override
  Future<List<String>> routes({String? groupName, Object? args}) async {
    final route = args.getOrNull("route");
    final mode = Configs.get(
      ConfigKeys.authorizationMode,
      defaultValue: AuthorizationMode.normal,
      parser: AuthorizationMode.parse,
    );
    return [
      Routes.splash,
      Routes.intro,
      if (args != true && (!mode.isNone || route == Routes.login)) Routes.login,
      Routes.quiz,
      if (!kIsWeb) Routes.permission,
      Routes.final_,
    ];
  }

  @override
  Future<T?>? clear<T extends Object?>(
    BuildContext context,
    String route, {
    RoutePredicate? predicate,
    Object? arguments,
    Map<String, dynamic>? routeConfigs,
  }) {
    return Navigator.pushNamedAndRemoveUntil(
      context,
      route,
      predicate ?? (_) => false,
      arguments: arguments,
    );
  }

  @override
  Future<T?>? close<T extends Object?>(
    BuildContext context, {
    T? result,
    Map<String, dynamic>? routeConfigs,
  }) {
    if (Navigator.canPop(context)) {
      Navigator.pop(context, result);
    }
    return null;
  }

  @override
  Future<T?>? open<T extends Object?>(
    BuildContext context,
    String route, {
    Object? arguments,
    Map<String, dynamic>? routeConfigs,
  }) {
    return Navigator.pushNamed(context, route, arguments: arguments);
  }

  @override
  Future<T?>? replace<T extends Object?, TO extends Object?>(
    BuildContext context,
    String route, {
    TO? result,
    Object? arguments,
    Map<String, dynamic>? routeConfigs,
  }) {
    return Navigator.pushReplacementNamed(
      context,
      route,
      result: result,
      arguments: arguments,
    );
  }
}
