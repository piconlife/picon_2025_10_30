import 'package:flutter/material.dart';

import '../../routes/builder.dart';
import '../../routes/paths.dart';
import 'views/pages/info.dart';

Map<String, RouteBuilder> get mAboutsRoutes {
  return {Routes.info: _aboutUs};
}

Widget _aboutUs(BuildContext context, Object? args) {
  return InfoPage(args: args);
}
