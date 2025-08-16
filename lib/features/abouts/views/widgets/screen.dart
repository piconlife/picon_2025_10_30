import 'package:flutter/material.dart';

import '../../../../roots/widgets/screen.dart';

class InfoScreen extends StatelessWidget {
  final Widget child;

  const InfoScreen({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return InAppScreen(theme: ThemeType.secondary, child: child);
  }
}
