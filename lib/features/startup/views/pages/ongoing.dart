import 'package:app_color/app_color.dart';
import 'package:app_dimen/app_dimen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_andomie/core.dart';
import 'package:in_app_navigator/in_app_navigator.dart';

import '../../../../app/constants/app.dart';
import '../../../../roots/widgets/appbar.dart';
import '../../../../roots/widgets/filled_button.dart';
import '../../../../roots/widgets/gesture.dart';
import '../../../../roots/widgets/logo.dart';
import '../../../../roots/widgets/screen.dart';
import '../../../../roots/widgets/text.dart';
import '../../../../routes/paths.dart';
import '../widgets/title_with_body.dart';

class OngoingPage extends StatelessWidget {
  const OngoingPage({super.key});

  void _next(BuildContext context) {
    context.next(Routes.ongoing, arguments: true);
  }

  void _signIn(BuildContext context) {
    context.open(Routes.login, arguments: true);
  }

  @override
  Widget build(BuildContext context) {
    final dimen = context.dimens;
    return InAppScreen(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        resizeToAvoidBottomInset: false,
        appBar: const InAppAppbar(
          titleText: "Create account",
          elevation: 0,
          actions: [],
        ),
        body: InAppScreen(
          child: Padding(
            padding: EdgeInsets.all(dimen.dp(24)),
            child: Stack(
              children: [
                const Align(alignment: Alignment(0, -0.35), child: InAppLogo()),
                const Align(
                  alignment: Alignment(0, 0),
                  child: AuthTitleAndBody(
                    title: "Join with ${AppConstants.name}",
                    subtitle:
                        "We'll help you create a new account \nin a few easy steps.",
                    strongTitle: true,
                  ),
                ),
                Align(
                  alignment: const Alignment(0, 0.25),
                  child: InAppFilledButton(
                    text: "Next",
                    onTap: () => _next(context),
                  ),
                ),
                Align(
                  alignment: const Alignment(0, 1),
                  child: InAppGesture(
                    onTap: () => _signIn(context),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        InAppText(
                          "Already have an account?",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: context.textColor.mid),
                        ),
                        context.smallMargin.h,
                        InAppText(
                          "Continue with Email",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: context.primary),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
