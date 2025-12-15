import 'package:flutter/material.dart';
import 'package:in_app_navigator/generate.dart';

import '../../routes/paths.dart';
import 'views/pages/main.dart';

Map<String, RouteBuilder> get mMainRoutes {
  return {Routes.main: _main};
}

Widget _main(BuildContext context, Object? args) {
  return const MainPage();
}
