import 'package:flutter/material.dart';

import '../../../../roots/widgets/screen.dart';
import '../../../../roots/widgets/will_pop_scope.dart';

class OnboardScreen extends StatelessWidget {
  final InAppWillPopCallback? onWillPop;
  final Widget child;

  const OnboardScreen({super.key, this.onWillPop, required this.child});

  @override
  Widget build(BuildContext context) {
    return InAppScreen(onWillPop: onWillPop, child: child);
  }
}
