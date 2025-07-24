import 'package:flutter/material.dart';

import '../../routes/builder.dart';
import '../../routes/paths.dart';
import 'views/pages/main.dart';

Map<String, RouteBuilder> get kMainRoutes {
  return {Routes.home: _main};
}

Widget _main(BuildContext context, Object? args) {
  return MainPage(args: args);
}
