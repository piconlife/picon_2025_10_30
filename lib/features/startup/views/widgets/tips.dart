import 'package:app_color/app_color.dart';
import 'package:app_dimen/app_dimen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_andomie/utils/translation.dart';

import '../../../../roots/widgets/icon.dart';
import '../../../../roots/widgets/layout.dart';
import '../../../../roots/widgets/text.dart';
import '../../models/onboard_quiz.dart';

class OnboardingTips extends StatelessWidget {
  final OnboardTips tips;

  const OnboardingTips({super.key, required this.tips});

  @override
  Widget build(BuildContext context) {
    final color = context.color;
    final dimen = context.dimens;
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: dimen.padding.large,
        vertical: dimen.padding.large,
      ),
      decoration: BoxDecoration(
        border: Border.all(
          color: Color(0xFFDDDDDD),
          strokeAlign: BorderSide.strokeAlignInside,
        ),
        borderRadius: BorderRadius.circular(dimen.mediumCorner),
      ),
      clipBehavior: Clip.antiAlias,
      child: InAppLayout(
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: color.base.primary ?? context.primary,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(dimen.mediumCorner),
                topRight: Radius.circular(dimen.mediumCorner),
              ),
            ),
            padding: EdgeInsets.symmetric(
              horizontal: dimen.padding.normal,
              vertical: dimen.padding.small,
            ),
            child: InAppLayout(
              layout: LayoutType.row,
              children: [
                InAppIcon(
                  Icons.tips_and_updates,
                  color: color.base.lightAsFixed,
                  size: dimen.icon.small,
                ),
                SizedBox(width: dimen.mediumSpace),
                Expanded(
                  child: InAppText(
                    tips.title?.tr ?? '',
                    style: TextStyle(
                      color: color.base.lightAsFixed,
                      fontSize: dimen.fontSize.normal,
                      fontWeight: dimen.boldFontWeight,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: dimen.padding.medium,
              vertical: dimen.padding.normal,
            ),
            alignment: Alignment.centerLeft,
            child: InAppText(
              tips.body?.tr ?? '',
              style: TextStyle(
                fontSize: dimen.fontSize.normal,
                color: color.text.dark,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
