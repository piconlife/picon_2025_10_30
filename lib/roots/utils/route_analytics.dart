import 'dart:math';

import 'package:flutter/material.dart';
import 'package:in_app_navigator/route.dart';

class RouteAnalytics extends ChangeNotifier {
  final String name;
  String currentRoute = '';
  String previousRoute = '';
  List<String> routes = [];

  int get currentRouteIndex => routes.indexOf(currentRoute);

  int get nextRouteIndex => max(currentRouteIndex + 1, 0);

  int get previousRouteIndex => routes.indexOf(previousRoute);

  RouteAnalytics._(this.name);

  static final Map<String, RouteAnalytics> _proxies = {};

  factory RouteAnalytics(String name) => RouteAnalytics.of(name);

  factory RouteAnalytics.of(String name) {
    return _proxies[name] ??= RouteAnalytics._(name);
  }

  void setCurrentRoute(String route) {
    previousRoute = currentRoute;
    currentRoute = route;
    notifyListeners();
  }

  void setPreviousRoute(String route) {
    previousRoute = route;
    notifyListeners();
  }

  void next(BuildContext context) {
    final route = routes.elementAtOrNull(nextRouteIndex);
    if (route == null) return;
    context.next(route);
  }

  void previous(BuildContext context) {
    final route = routes[routes.indexOf(currentRoute) - 1];
    context.next(route);
  }
}
