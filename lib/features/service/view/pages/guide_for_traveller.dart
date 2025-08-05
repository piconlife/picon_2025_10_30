import 'package:flutter/material.dart';

import '../../../../roots/widgets/appbar.dart';

class GuideForTravellerPage extends StatelessWidget {
  const GuideForTravellerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: InAppAppbar(titleText: "Guide for traveller"),
    );
  }
}
