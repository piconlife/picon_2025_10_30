import 'package:flutter/material.dart';

import '../../routes/builder.dart';
import '../../routes/paths.dart';
import '../abouts/views/pages/privacy.dart';
import '../abouts/views/pages/terms.dart';
import 'views/pages/info.dart';

Map<String, RouteBuilder> get kAboutsRoutes {
  return {Routes.info: _info, Routes.privacy: _privacy, Routes.terms: _terms};
}

Widget _info(BuildContext context, Object? args) {
  return InfoPage(args: args);
}

Widget _privacy(BuildContext context, Object? args) {
  return PrivacyPage(args: args);
}

Widget _terms(BuildContext context, Object? args) {
  return TermsPage(args: args);
}
