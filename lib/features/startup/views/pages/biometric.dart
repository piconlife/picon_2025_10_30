import 'package:app_dimen/app_dimen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_andomie/extensions/spacing.dart';

import '../../../../roots/widgets/appbar.dart';
import '../../../../roots/widgets/filled_button.dart';
import '../../../../roots/widgets/logo_trailing.dart';
import '../widgets/screen.dart';
import '../widgets/title_with_subtitle.dart';

class BiometricPage extends StatelessWidget {
  const BiometricPage({super.key});

  @override
  Widget build(BuildContext context) {
    final dimen = context.dimens;
    return StartupScreen(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: const InAppAppbar(
          titleText: "Add Biometric",
          actions: [InAppLogoTrailing()],
        ),
        body: SafeArea(
          child: ListView(
            padding: EdgeInsets.all(dimen.dp(24)),
            children: [
              AuthTitleWithSubtitle(
                title: "Welcome Back",
                subtitle: "Fast and secure login",
                dimen: dimen,
              ),
              dimen.dp(32).h,
              const InAppFilledButton(text: "Login"),
            ],
          ),
        ),
      ),
    );
  }
}
