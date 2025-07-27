import 'package:app_color/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_andomie/utils/translation.dart';
import 'package:in_app_navigator/in_app_navigator.dart';
import 'package:picon/app/constants/app.dart';

import '../../../../roots/widgets/column.dart';
import '../../../../roots/widgets/filled_button.dart';
import '../../../../roots/widgets/image.dart';
import '../../../../roots/widgets/outlined_button.dart';
import '../../../../roots/widgets/padding.dart';
import '../../../../roots/widgets/screen.dart';
import '../../../../roots/widgets/system_overlay.dart';
import '../../../../roots/widgets/text.dart';
import '../../../../routes/paths.dart';

class IntroPage extends StatefulWidget {
  final Object? args;

  const IntroPage({super.key, this.args});

  @override
  State<IntroPage> createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage>
    with TranslationMixin, ColorMixin {
  void _seePrivacy(BuildContext context) {
    context.open(Routes.privacy);
  }

  void _seeTerms(BuildContext context) {
    context.open(Routes.terms);
  }

  void _joining() {
    context.next(Routes.intro);
  }

  void _login() {
    context.open(Routes.login);
  }

  @override
  Widget build(BuildContext context) {
    return InAppSystemOverlay(
      child: InAppScreen(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: InAppColumn(
            children: [
              Expanded(
                child: InAppColumn(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [InAppImage("assets/app/logo.png", width: 120)],
                ),
              ),
              Expanded(
                child: InAppColumn(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 8,
                  children: [
                    InAppText(
                      "Welcome to ${AppConstants.name}",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 24),
                    ),
                    InAppText(
                      " and ",
                      prefix: "Privacy",
                      suffix: "Terms Services",
                      style: TextStyle(color: Colors.grey, fontSize: 14),
                      prefixStyle: TextStyle(
                        color: context.primary,
                        fontWeight: FontWeight.w600,
                      ),
                      suffixStyle: TextStyle(
                        color: context.primary,
                        fontWeight: FontWeight.w600,
                      ),
                      onPrefixClick: _seePrivacy,
                      onSuffixClick: _seeTerms,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: InAppPadding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: InAppColumn(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    spacing: 24,
                    children: [
                      InAppFilledButton(
                        text: "Join with ${AppConstants.name}",
                        borderRadius: BorderRadius.circular(50),
                        onTap: _joining,
                      ),
                      InAppOutlinedButton(
                        text: "Continue with Email",
                        borderRadius: BorderRadius.circular(50),
                        onTap: _login,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  String get name => "onboard:intro";
}
