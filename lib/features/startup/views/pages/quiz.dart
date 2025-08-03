import 'package:app_color/app_color.dart';
import 'package:app_dimen/app_dimen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_andomie/extensions/object.dart';
import 'package:flutter_andomie/utils/configs.dart';
import 'package:flutter_andomie/utils/settings.dart';
import 'package:flutter_andomie/utils/translation.dart';
import 'package:in_app_navigator/in_app_navigator.dart';

import '../../../../app/constants/app.dart';
import '../../../../app/res/configs.dart';
import '../../../../roots/services/analytics.dart';
import '../../../../roots/widgets/align.dart';
import '../../../../roots/widgets/layout.dart';
import '../../../../roots/widgets/position.dart';
import '../../../../roots/widgets/system_overlay.dart';
import '../../../../routes/paths.dart';
import '../../configs/onboard.dart';
import '../../models/onboard_quiz.dart';
import '../utils/parser.dart';
import '../widgets/onboarding_appbar.dart';
import '../widgets/onboarding_filled_button.dart';
import '../widgets/onboarding_height.dart';
import '../widgets/onboarding_image.dart';
import '../widgets/onboarding_titled_body.dart';
import '../widgets/onboarding_weight.dart';
import '../widgets/options.dart';
import '../widgets/startup_screen.dart';
import '../widgets/tips.dart';

class QuizPage extends StatefulWidget {
  final Object? args;

  const QuizPage({super.key, this.args});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> with TranslationMixin, ColorMixin {
  late int step = widget.args.get("step", 1);
  late List<OnboardQuiz> contents;
  late OnboardQuiz content;

  late int index = Settings.get(content.name ?? '', -1);

  num height = Settings.get("height", Configs.get("height", defaultValue: 72));

  num weight = Settings.get("weight", Configs.get("weight", defaultValue: 60));

  bool get isSelectToNext {
    if (content.isEnabled) return false;
    return RemoteConfigs.isOnboardSelectToNext;
  }

  int get total => contents.length + (kIsWeb ? 1 : 2);

  void _changed(int value) {
    setState(() => index = value);
    _next(true);
  }

  void _saveInstance() {
    final name = content.name ?? '';
    if (name.isEmpty) return;
    switch (content.type) {
      case OnboardQuizType.option:
        Settings.set(name, index);
        break;
      case OnboardQuizType.height:
        Settings.set(name, height);
        break;
      case OnboardQuizType.weight:
        Settings.set(name, weight);
        break;
      case OnboardQuizType.preview:
      case OnboardQuizType.none:
      case null:
    }
  }

  void _next([bool selectToNext = false]) {
    Analytics.call(name, () async {
      if (selectToNext && !isSelectToNext) return;
      _saveInstance();
      _skip();
    });
  }

  void _skip() {
    if (step == contents.length) {
      context.next(Routes.quiz, arguments: {"step": step + 1, "total": total});
      return;
    }
    context.open(Routes.quiz, arguments: {"step": step + 1});
  }

  @override
  Widget build(BuildContext context) {
    contents = gets(path: "onboarding_quizzes", parser: OnboardQuiz.from);
    content = contents.elementAtOrNull(step - 1) ?? OnboardQuiz();
    return InAppSystemOverlay(
      child: OnboardScreen(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: SafeArea(child: _buildLayout()),
        ),
      ),
    );
  }

  Widget _buildLayout() {
    final configs = OnboardConfigs.i;
    final dimen = context.dimens;
    final center = Configs.get("onboard_quiz_center", defaultValue: false);
    final title = content.title
        ?.replaceAll("{APP_NAME}", AppConstants.name)
        .replaceAll("{App_NAME}", AppConstants.name)
        .replaceAll("{app_name}", AppConstants.name);

    String steps(String key) => stepsParser(key, total, step);

    if (!center && content.type == OnboardQuizType.option) {
      return InAppLayout(
        children: [
          SizedBox(height: 16),
          OnboardingAppbar(
            title: localize("title", defaultValue: ''),
            step: step,
            total: total,
            textDirection: textDirection,
            onSkip: _skip,
            text: steps,
          ),
          SizedBox(height: dimen.height * 0.053),
          Expanded(
            child: OnboardingTitledBody(
              configs: configs,
              body: content.body?.tr,
              title: title?.tr,
              child: Padding(
                padding: EdgeInsets.only(top: 16),
                child: _buildBody(dimen),
              ),
            ),
          ),
          if (!isSelectToNext)
            InAppLayout(
              mainAxisSize: MainAxisSize.min,
              children: [
                if ((content.tips?.isValid ?? false) &&
                    index == content.tips?.index)
                  OnboardingTips(tips: content.tips!),
                AnimatedOpacity(
                  opacity: index > -1 || content.isEnabled ? 1 : 0.25,
                  duration: Duration(milliseconds: 200),
                  child: OnboardingFilledButton(
                    text: localize("button_1"),
                    onTap: index > -1 || content.isEnabled ? _next : null,
                  ),
                ),
              ],
            ),
        ],
      );
    }

    return InAppLayout(
      layout: LayoutType.stack,
      children: [
        InAppPositioned(
          left: 0,
          right: 0,
          top: 16,
          child: OnboardingAppbar(
            title: localize("title", defaultValue: ''),
            step: step,
            total: total,
            textDirection: textDirection,
            onSkip: _skip,
            text: steps,
          ),
        ),
        InAppAlign(
          alignment: const Alignment(0, -0.78),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: dimen.largePadding),
            child: OnboardingTitledBody(
              configs: configs,
              body: content.body?.tr,
              title: title?.tr,
            ),
          ),
        ),
        InAppAlign(
          alignment: const Alignment(0, 0.1),
          child: _buildBody(dimen),
        ),
        if (!isSelectToNext)
          InAppAlign(
            alignment: Alignment.bottomCenter,
            child: InAppLayout(
              mainAxisSize: MainAxisSize.min,
              children: [
                if ((content.tips?.isValid ?? false) &&
                    index == content.tips?.index)
                  OnboardingTips(tips: content.tips!),
                AnimatedOpacity(
                  opacity: index > -1 || content.isEnabled ? 1 : 0.25,
                  duration: Duration(milliseconds: 200),
                  child: OnboardingFilledButton(
                    text: localize("button_1", defaultValue: "Next"),
                    onTap: index > -1 || content.isEnabled ? _next : null,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildBody(DimenData dimen) {
    return switch (content.type) {
      OnboardQuizType.option => _buildOptions(dimen),
      OnboardQuizType.preview => _buildPreview(dimen),
      OnboardQuizType.height => _buildHeight(dimen),
      OnboardQuizType.weight => _buildWeight(dimen),
      OnboardQuizType.none => SizedBox(),
      null => SizedBox(),
    };
  }

  Widget _buildOptions(DimenData dimen) {
    return OnboardingOptions(
      dimen: dimen,
      index: index,
      options: content.options,
      onChanged: _changed,
    );
  }

  Widget _buildPreview(DimenData dimen) {
    return Align(
      alignment: Alignment(0, 0.15),
      child: OnboardingImage(content.image, dimen: dimen),
    );
  }

  Widget _buildHeight(DimenData dimen) {
    return OnboardingHeight(
      value: height.toDouble(),
      units: content.tabs,
      onChanged: (value) => height = value,
    );
  }

  Widget _buildWeight(DimenData dimen) {
    return OnboardingWeight(
      value: weight.toDouble(),
      units: content.tabs,
      onChanged: (value) => weight = value,
    );
  }

  @override
  String get name => "startup:quiz";
}
