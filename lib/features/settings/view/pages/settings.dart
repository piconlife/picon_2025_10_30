import 'package:flutter/material.dart';

import '../../../../roots/widgets/appbar.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(appBar: InAppAppbar(titleText: "Settings"));
  }
}
