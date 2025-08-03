import 'package:app_color/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_andomie/utils/settings.dart';
import 'package:flutter_androssy_kits/widgets/splash.dart';
import 'package:in_app_navigator/in_app_navigator.dart';

import '../../../../app/constants/app.dart';
import '../../../../app/constants/configs.dart';
import '../../../../app/helpers/user.dart';
import '../../../../roots/widgets/logo.dart';
import '../../../../roots/widgets/screen.dart';
import '../../../../roots/widgets/system_overlay.dart';
import '../../../../roots/widgets/text.dart';
import '../../../../routes/paths.dart';
import '../widgets/startup_screen.dart';

const kOnboardingComplete = "onboarding_complete";

bool get isOnboardingComplete => Settings.get(kOnboardingComplete, false);

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  void _next(BuildContext context) async {
    final isLoggedIn = await UserHelper.isLoggedIn(context);
    if (!context.mounted) return;
    if (isLoggedIn) {
      context.home();
    } else {
      context.clear(Routes.intro);
    }
  }

  @override
  Widget build(BuildContext context) {
    return InAppSystemOverlay(
      child: OnboardScreen(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.transparent,
          body: InAppScreen(
            child: AndrossySplash(
              onRoute: _next,
              duration: ConfigsConstants.splashTime,
              axisY: 5,
              content: const InAppLogo(),
              footer: Padding(
                padding: const EdgeInsets.only(bottom: 50),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    InAppText(
                      AppConstants.name,
                      style: TextStyle(
                        color: context.primary,
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const InAppText(
                      AppConstants.description,
                      style: TextStyle(color: Color(0xff647f88)),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
