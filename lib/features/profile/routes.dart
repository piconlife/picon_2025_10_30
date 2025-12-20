import 'package:flutter/material.dart';
import 'package:in_app_navigator/generate.dart';

import '../../routes/paths.dart';
import 'view/pages/profile.dart';

Map<String, RouteBuilder> get mProfileRoutes {
  return {Routes.profile: _profile};
}

Widget _profile(BuildContext context, Object? args) {
  return ProfilePage();
}
