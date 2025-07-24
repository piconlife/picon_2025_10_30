import 'package:app_color/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_andomie/utils/settings.dart';
import 'package:in_app_navigator/in_app_navigator.dart';

import '../../../../app/constants/configs.dart';
import '../../../../roots/widgets/system_overlay.dart';
import '../../../../routes/paths.dart';
import '../../configs/onboard.dart';
import '../widgets/logo.dart';
import '../widgets/startup_screen.dart';

const kOnboardingComplete = "onboarding_complete";

bool get isOnboardingComplete => Settings.get(kOnboardingComplete, false);

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with ColorMixin {
  void _next() async {
    if (!mounted) return;
    if (isOnboardingComplete) {
      context.home();
    } else {
      context.next(Routes.splash, clearMode: true);
    }
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(
      Duration(milliseconds: ConfigsConstants.splashTime),
      (_next),
    );
  }

  @override
  Widget build(BuildContext context) {
    final configs = OnboardConfigs.i;
    return InAppSystemOverlay(
      child: OnboardScreen(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Center(child: OnboardingLogo(hero: configs.hero.logo)),
        ),
      ),
    );
  }
}
