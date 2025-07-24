import 'package:flutter/material.dart';

import '../../../../roots/widgets/layout.dart';
import '../../configs/onboard.dart';
import 'onboarding_body.dart';
import 'onboarding_image.dart';
import 'onboarding_title.dart';

class OnboardingTitledBody extends StatelessWidget {
  final OnboardConfigs? configs;
  final String? body;
  final String? title;
  final dynamic image;
  final double? imageWidth;
  final TextAlign? textAlign;
  final Widget? child;

  const OnboardingTitledBody({
    super.key,
    this.title,
    this.body,
    this.image,
    this.imageWidth,
    this.configs,
    this.textAlign,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    final configs = this.configs ?? OnboardConfigs.i;
    return InAppLayout(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (image != null) ...[
          Center(
            child: OnboardingImage(
              image,
              hero: configs.hero.image,
              width: imageWidth,
            ),
          ),
          const SizedBox(height: 45),
        ],
        if (title != null && title!.isNotEmpty)
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: OnboardingTitle(
              title!,
              hero: configs.hero.title,
              textAlign: textAlign,
            ),
          ),
        if (body != null && body!.isNotEmpty)
          Padding(
            padding: EdgeInsets.only(left: 16, right: 16, top: 12),
            child: OnboardingBody(
              body!,
              hero: configs.hero.body,
              textAlign: textAlign,
            ),
          ),
        if (child != null) child!,
      ],
    );
  }
}
