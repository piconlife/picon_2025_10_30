import 'package:flutter/material.dart';

import '../../../../roots/widgets/screen.dart';

class StartupScreen extends StatelessWidget {
  final Widget child;

  const StartupScreen({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return InAppScreen(
      theme: ThemeType.secondary,
      unfocusMode: true,
      child: child,
    );
  }
}
