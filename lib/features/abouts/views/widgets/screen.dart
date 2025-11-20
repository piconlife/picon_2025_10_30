import 'package:flutter/material.dart';

import '../../../../roots/widgets/body.dart';

class InfoScreen extends StatelessWidget {
  final Widget child;

  const InfoScreen({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return InAppBody(theme: ThemeType.secondary, child: child);
  }
}
