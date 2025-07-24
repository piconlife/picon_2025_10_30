import 'package:app_color/app_color.dart';
import 'package:auth_management/auth_management.dart';
import 'package:flutter/material.dart';
import 'package:flutter_andomie/extensions/object.dart';
import 'package:flutter_andomie/utils/translation.dart';
import 'package:in_app_navigator/in_app_navigator.dart';

import '../../../../roots/data/models/user.dart';
import '../../../../roots/widgets/align.dart';
import '../../../../roots/widgets/layout.dart';
import '../../../../roots/widgets/system_overlay.dart';
import '../../../../routes/paths.dart';
import '../../configs/onboard.dart';
import '../widgets/logo.dart';
import '../widgets/onboarding_appbar.dart';
import '../widgets/onboarding_body.dart';
import '../widgets/onboarding_filled_button.dart';
import '../widgets/onboarding_title.dart';
import '../widgets/startup_screen.dart';

class IntroPage extends StatefulWidget {
  final Object? args;

  const IntroPage({super.key, this.args});

  @override
  State<IntroPage> createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage>
    with TranslationMixin, ColorMixin {
  void _next() async {
    final alreadyLoggedIn = await context.isLoggedIn<User>();
    if (!mounted) return;
    context.next(Routes.intro, arguments: alreadyLoggedIn);
  }

  @override
  Widget build(BuildContext context) {
    final configs = OnboardConfigs.i;
    return InAppSystemOverlay(
      child: OnboardScreen(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: SafeArea(
            child: InAppLayout(
              layout: LayoutType.stack,
              children: [
                Positioned(
                  left: 0,
                  right: 0,
                  top: 8,
                  child: OnboardingAppbar(
                    title: localize("title", defaultValue: ''),
                    showLeading: widget.args.find(defaultValue: false),
                  ),
                ),
                InAppAlign(
                  alignment: const Alignment(0, -0.15),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: InAppLayout(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        OnboardingLogo(hero: configs.hero.logo),
                        SizedBox(height: 40),
                        OnboardingTitle(
                          localize(
                            "header",
                            defaultValue: "Confidence Starts Inside",
                          ),
                        ),
                        SizedBox(height: 6),
                        OnboardingBody(
                          localize(
                            "description",
                            applyNumber: true,
                            defaultValue:
                                "Take just 5 minutes a day to see results.",
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                InAppAlign(
                  alignment: Alignment.bottomCenter,
                  child: OnboardingFilledButton(
                    text: localize("button", defaultValue: "Get Started"),
                    onTap: _next,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  String get name => "onboard:intro";
}
