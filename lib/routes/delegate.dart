import 'package:flutter/material.dart';
import 'package:in_app_navigator/in_app_navigator.dart';

import '../roots/preferences/preferences.dart';
import 'paths.dart';

class NavigatorDelegate extends InAppNavigatorDelegate {
  const NavigatorDelegate() : super(defaultRoute: Routes.main);

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
    return [
      Routes.splash,
      Routes.intro,
      Routes.ongoing,
      Routes.termsAndConditions,
      Routes.privacy,
      Routes.username,
      Routes.birthday,
      Routes.gender,
      Routes.email,
      Routes.password,
    ];
  }

  @override
  Future<T?>? clear<T extends Object?>(
    BuildContext context,
    String route, {
    RoutePredicate? predicate,
    Object? args,
  }) {
    return Navigator.pushNamedAndRemoveUntil(
      context,
      route,
      predicate ?? (_) => false,
      arguments: args,
    );
  }

  @override
  Future<T?>? close<T extends Object?>(
    BuildContext context, {
    T? result,
    Object? args,
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
    Object? args,
  }) {
    return Navigator.pushNamed(context, route, arguments: args);
  }

  @override
  Future<T?>? replace<T extends Object?, TO extends Object?>(
    BuildContext context,
    String route, {
    TO? result,
    Object? args,
  }) {
    return Navigator.pushReplacementNamed(
      context,
      route,
      result: result,
      arguments: args,
    );
  }
}
