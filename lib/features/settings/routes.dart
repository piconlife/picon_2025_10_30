import 'package:flutter/material.dart';
import 'package:in_app_navigator/generate.dart';

import '../../routes/paths.dart';
import 'view/pages/settings.dart';

Map<String, RouteBuilder> get mSettingsRoutes {
  return {Routes.settings: _settings};
}

Widget _settings(BuildContext context, Object? args) {
  return const SettingsPage();
}
