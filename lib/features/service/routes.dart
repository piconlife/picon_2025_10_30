import 'package:flutter/material.dart';
import 'package:in_app_navigator/generate.dart';

import '../../routes/paths.dart';
import 'view/pages/guide_for_student.dart';
import 'view/pages/guide_for_traveller.dart';
import 'view/pages/marketplace.dart';
import 'view/pages/my_note.dart';
import 'view/pages/relationship.dart';
import 'view/pages/wallet.dart';

Map<String, RouteBuilder> get mServiceRoutes {
  return {
    Routes.guideForStudent: _guideForStudent,
    Routes.guideForTraveller: _guideForTraveller,
    Routes.marketplace: _marketplace,
    Routes.myNotes: _myNotes,
    Routes.relationship: _relationship,
    Routes.wallet: _wallet,
  };
}

Widget _guideForStudent(BuildContext context, Object? args) {
  return const GuideForStudentPage();
}

Widget _guideForTraveller(BuildContext context, Object? args) {
  return const GuideForTravellerPage();
}

Widget _marketplace(BuildContext context, Object? args) {
  return const MarketplacePage();
}

Widget _myNotes(BuildContext context, Object? args) {
  return const MyNotesPage();
}

Widget _relationship(BuildContext context, Object? args) {
  return const RelationshipPage();
}

Widget _wallet(BuildContext context, Object? args) {
  return const WalletPage();
}
