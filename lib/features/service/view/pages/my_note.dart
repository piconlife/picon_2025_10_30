import 'package:flutter/material.dart';

import '../../../../roots/widgets/appbar.dart';

class MyNotesPage extends StatelessWidget {
  const MyNotesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(appBar: InAppAppbar(titleText: "My notes"));
  }
}
