import 'package:flutter/material.dart';

import '../../routes/builder.dart';
import '../../routes/paths.dart';
import '../abouts/views/pages/privacy.dart';
import '../abouts/views/pages/terms.dart';
import 'views/pages/info.dart';
import 'views/pages/terms_reader.dart';

Map<String, RouteBuilder> get kAboutsRoutes {
  return {
    Routes.info: _info,
    Routes.privacy: _privacy,
    Routes.termsAndConditions: _terms,
    Routes.terms: _termsReader,
  };
}

Widget _info(BuildContext context, Object? args) {
  return InfoPage(args: args);
}

Widget _privacy(BuildContext context, Object? args) {
  return PrivacyPage(args: args, isStartupMode: args == true);
}

Widget _terms(BuildContext context, Object? args) {
  return TermsPage(args: args, isStartupMode: args == true);
}

Widget _termsReader(BuildContext context, Object? args) {
  return TermsReaderPage(args: args);
}
