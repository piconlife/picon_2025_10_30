import 'package:flutter/material.dart';

import '../../routes/builder.dart';
import '../../routes/paths.dart';
import 'views/pages/paywall.dart';

Map<String, RouteBuilder> get kPaywallRoutes {
  return {Routes.paywall: _paywall};
}

Widget _paywall(BuildContext context, Object? args) {
  return PaywallPage(args: args);
}
