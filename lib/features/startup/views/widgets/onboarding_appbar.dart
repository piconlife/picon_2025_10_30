import 'package:flutter/material.dart';
import 'package:flutter_andomie/extensions/enum.dart';
import 'package:flutter_andomie/utils/configs.dart';
import 'package:flutter_andomie/utils/translation.dart';

import '../../../../roots/widgets/layout.dart';
import '../../../../roots/widgets/padding.dart';
import '../../../../roots/widgets/position.dart';
import '../../../../roots/widgets/text.dart';
import 'onboarding_arrow_back.dart';
import 'onboarding_skip.dart';
import 'progress_bar.dart';
import 'startup_steps_bar.dart';

enum StartupAppbarType {
  steps,
  progress;

  bool get isSteps => this == steps;

  bool get isProgress => this == progress;

  factory StartupAppbarType.parse(Object? source) => values.find(source);

  factory StartupAppbarType.detect() {
    return Configs.get(
      "onboard_appbar_type",
      defaultValue: StartupAppbarType.steps,
      parser: StartupAppbarType.parse,
    );
  }
}

class OnboardingAppbar extends StatefulWidget {
  final bool hero;
  final StartupAppbarType? type;

  final int step;
  final int total;
  final String title;
  final String? Function(String key)? text;
  final bool showLeading;
  final bool showLocalization;
  final List<Widget> actions;
  final TextDirection? textDirection;
  final VoidCallback? onSkip;

  const OnboardingAppbar({
    super.key,
    this.hero = false,
    this.type,
    this.step = 0,
    this.total = 0,
    this.text,
    this.title = '',
    this.showLeading = true,
    this.showLocalization = true,
    this.actions = const [],
    this.textDirection,
    this.onSkip,
  });

  @override
  State<OnboardingAppbar> createState() => _OnboardingAppbarState();
}

class _OnboardingAppbarState extends State<OnboardingAppbar> {
  late StartupAppbarType type = widget.type ?? StartupAppbarType.detect();

  int get step => widget.step;

  int get total => widget.total;

  @override
  Widget build(BuildContext context) {
    Widget child;
    if (step <= 0) {
      child = SizedBox(
        height: kToolbarHeight,
        child: InAppLayout(
          layout: LayoutType.stack,
          alignment: Alignment.center,
          children: [
            if (widget.showLeading)
              InAppPositioned(left: 0, child: _buildLeading()),
            Center(child: _buildTitle()),
            InAppPositioned(right: 0, child: _buildActions(context)),
          ],
        ),
      );
    } else if (type.isSteps && widget.title.isEmpty) {
      child = InAppLayout(
        layout: LayoutType.stack,
        alignment: Alignment.center,
        children: [
          Center(child: _buildProgress(context, type)),
          if (widget.showLeading)
            InAppPositioned(left: 0, child: _buildLeading()),
          InAppPositioned(right: 0, child: _buildActions(context)),
        ],
      );
    } else if (type.isSteps) {
      child = InAppLayout(
        layout: LayoutType.row,
        children: [
          if (widget.showLeading) _buildLeading(),
          SizedBox(width: 16 + (widget.showLeading ? 0 : 12)),
          Expanded(child: _buildTitle()),
          _buildProgress(context, type),
          SizedBox(width: 16),
          _buildActions(context),
        ],
      );
    } else if (type.isProgress && widget.title.isEmpty) {
      child = InAppLayout(
        layout: LayoutType.row,
        children: [
          if (widget.showLeading) _buildLeading(),
          SizedBox(width: 16),
          Expanded(child: _buildProgress(context, type)),
          SizedBox(width: 16),
          _buildActions(context),
        ],
      );
    } else {
      child = InAppLayout(
        children: [
          InAppLayout(
            layout: LayoutType.stack,
            alignment: Alignment.center,
            children: [
              if (widget.showLeading)
                InAppPositioned(left: 0, child: _buildLeading()),
              Center(child: _buildTitle()),
              InAppPositioned(right: 0, child: _buildActions(context)),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(left: 24, right: 24, top: 12),
            child: _buildProgress(context, type),
          ),
        ],
      );
    }
    if (widget.hero) {
      child = Hero(
        tag: "onboarding_app_bar",
        child: Material(
          color: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          child: child,
        ),
      );
    }
    return child;
  }

  Widget _buildLeading() {
    return InAppPadding(
      padding: EdgeInsets.only(left: 12),
      child: OnboardingArrowBack(hero: widget.hero),
    );
  }

  Widget _buildTitle() {
    return InAppText(
      widget.title,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
    );
  }

  Widget _buildProgress(BuildContext context, StartupAppbarType type) {
    if (step < 1) return SizedBox();
    if (type.isSteps) {
      return StartupStepsBar(
        titled: widget.title.isNotEmpty,
        text:
            widget.text?.call(
              widget.title.isNotEmpty ? "step_counter_titled" : "step_counter",
            ) ??
            (widget.title.isNotEmpty
                ? '{STEP}<span>/{TOTAL_STEPS}</span>'
                : "Step {STEP} <span> of {TOTAL_STEPS}</span>"),
        step: step.trNumber,
        total: total.trNumber,
      );
    }
    if (type.isProgress) {
      return StartupProgressBar(step: step, total: total, text: "Basics");
    }
    return SizedBox();
  }

  Widget _buildActions(BuildContext context) {
    if (widget.onSkip != null) {
      return OnboardingSkip(onTap: widget.onSkip);
    }
    return InAppLayout(
      layout: LayoutType.row,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.actions.isEmpty && widget.showLocalization)
          TranslationButton(
            type: TranslationButtonType.flagAndCode,
            padding: EdgeInsets.only(right: 16, left: 16, top: 4, bottom: 4),
          )
        else
          ...widget.actions,
      ],
    );
  }
}
