import 'package:flutter/material.dart';

import '../../../../roots/widgets/appbar.dart';

class GuideForStudentPage extends StatelessWidget {
  const GuideForStudentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(appBar: InAppAppbar(titleText: "Guide for student"));
  }
}
