import 'package:flutter/material.dart';

import '../../../../roots/widgets/screen.dart';
import '../../../../roots/widgets/system_overlay.dart';
import 'default.dart';

class PaywallPage extends StatelessWidget {
  final Object? args;
  final bool isBackMode;
  final VoidCallback? onSkipped;

  const PaywallPage({
    super.key,
    this.args,
    this.isBackMode = true,
    this.onSkipped,
  });

  @override
  Widget build(BuildContext context) {
    return InAppSystemOverlay(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: InAppScreen(
          onWillPop: !isBackMode ? () async => false : null,
          child: DefaultPaywall(onSkipped: onSkipped, args: args),
        ),
      ),
    );
  }
}
