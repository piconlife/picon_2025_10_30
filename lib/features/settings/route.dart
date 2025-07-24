import 'package:flutter/material.dart';

import '../../routes/builder.dart';
import '../../routes/paths.dart';
import 'views/pages/profile.dart';
import 'views/pages/settings.dart';

Map<String, RouteBuilder> get kSettingsRoutes {
  return {Routes.settings: _settings, Routes.profile: _profile};
}

Widget _settings(BuildContext context, Object? args) {
  return SettingsPage(args: args);
}

Widget _profile(BuildContext context, Object? args) {
  return ProfilePage(args: args);
}
