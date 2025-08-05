import 'package:flutter/material.dart';

import '../../../../roots/widgets/appbar.dart';

class RelationshipPage extends StatelessWidget {
  const RelationshipPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(appBar: InAppAppbar(titleText: "Relationship"));
  }
}
