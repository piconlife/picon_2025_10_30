import 'package:app_color/app_color.dart';
import 'package:app_dimen/app_dimen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_andomie/extensions/object.dart';
import 'package:flutter_andomie/utils/settings.dart';
import 'package:flutter_andomie/utils/translation.dart';
import 'package:in_app_navigator/in_app_navigator.dart';

import '../../../../app/constants/app.dart';
import '../../../../roots/widgets/align.dart';
import '../../../../roots/widgets/layout.dart';
import '../../../../roots/widgets/position.dart';
import '../../../../roots/widgets/screen.dart';
import '../../configs/onboard.dart';
import '../utils/parser.dart';
import '../widgets/generating.dart';
import '../widgets/onboarding_appbar.dart';
import '../widgets/onboarding_titled_body.dart';
import 'splash.dart';

class FinalPage extends StatefulWidget {
  final Object? args;

  const FinalPage({super.key, this.args});

  @override
  State<FinalPage> createState() => _FinalPageState();
}

class _FinalPageState extends State<FinalPage>
    with TranslationMixin, ColorMixin {
  late int step = widget.args.findByKey("step", defaultValue: 21);
  late int total = widget.args.findByKey("total", defaultValue: 21);

  @override
  Widget build(BuildContext context) {
    final configs = OnboardConfigs.i;
    final dimen = context.dimens;

    String steps(String key) => stepsParser(key, total, step);

    return InAppScreen(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: InAppLayout(
            layout: LayoutType.stack,
            children: [
              InAppPositioned(
                left: 0,
                right: 0,
                top: 8,
                child: OnboardingAppbar(
                  title: localize("title", defaultValue: ''),
                  step: step,
                  total: total,
                  text: steps,
                ),
              ),
              InAppAlign(
                alignment: Alignment(0, -0.7),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                  ).apply(dimen),
                  child: OnboardingTitledBody(
                    configs: configs,
                    body: localize(
                      "description",
                      defaultValue:
                          "According to our data, {APP_NAME} users who receive notification are more likely achieve their goals",
                      replace: (value) =>
                          value.replaceAll("{APP_NAME}", AppConstants.name),
                    ),
                    title: localize(
                      "title",
                      defaultValue:
                          "{PROGRESS}% more successful with notifications",
                      applyNumber: true,
                      replace: (value) => value.replaceAll("{PROGRESS}", "87"),
                    ),
                  ),
                ),
              ),
              InAppAlign(
                alignment: Alignment.center,
                child: OnboardingGenerating(
                  label: localize("progress_text"),
                  onStatus: (status) {
                    if (status == AnimationStatus.completed) {
                      Settings.set(kOnboardingComplete, true);
                      context.home();
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  String get name => "startup:final";
}
