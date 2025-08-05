import 'package:flutter/material.dart';
import 'package:flutter_app_navigator/app_navigator.dart';

import '../../routes/paths.dart';
import 'views/pages/info.dart';
import 'views/pages/privacy.dart';
import 'views/pages/terms.dart';
import 'views/pages/terms_reader.dart';

Map<String, RouteBuilder> get mAboutsRoutes {
  return {
    Routes.aboutUs: _aboutUs,
    Routes.privacyPolicy: _privacyPolicy,
    Routes.terms: _terms,
    Routes.termsAndConditions: _termsAndConditions,
  };
}

Widget _aboutUs(BuildContext context, Object? args) {
  return InfoPage(args: args);
}

Widget _privacyPolicy(BuildContext context, Object? data) {
  return PrivacyPage(args: data);
}

Widget _terms(BuildContext context, Object? data) {
  return TermsReaderPage(args: data);
}

Widget _termsAndConditions(BuildContext context, Object? data) {
  return TermsPage(args: data);
}
