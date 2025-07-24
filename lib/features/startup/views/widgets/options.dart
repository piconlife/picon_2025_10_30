import 'package:app_color/app_color.dart';
import 'package:app_dimen/app_dimen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_andomie/utils/translation.dart';
import 'package:flutter_androssy_kits/widgets/fade.dart';

import '../../../../roots/widgets/fade.dart';
import '../../../../roots/widgets/gesture.dart';
import '../../../../roots/widgets/layout.dart';
import '../../../../roots/widgets/text.dart';

class OnboardingOption extends StatelessWidget {
  final DimenData? dimen;
  final String? data;
  final bool selected;

  const OnboardingOption(
    this.data, {
    super.key,
    this.dimen,
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = context.color;
    final dimen = this.dimen ?? context.dimens;
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: Color(0xFFDDDDDD)),
        borderRadius: BorderRadius.circular(dimen.mediumCorner),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: dimen.padding.medium,
        vertical: dimen.padding.large,
      ),
      child: InAppLayout(
        layout: LayoutType.row,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AnimatedContainer(
            duration: Duration(milliseconds: 250),
            padding: EdgeInsets.all(4).apply(dimen),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: selected
                    ? color.base.secondary ?? Theme.of(context).primaryColor
                    : color.base.primary ?? Colors.grey,
                width: dimen.stroke.large,
              ),
            ),
            child: AnimatedContainer(
              width: dimen.dp(12),
              height: dimen.dp(12),
              duration: Duration(milliseconds: 250),
              decoration: BoxDecoration(
                color: selected ? color.base.secondary : Colors.transparent,
                shape: BoxShape.circle,
              ),
            ),
          ),
          SizedBox(width: 18).apply(dimen),
          Expanded(
            child: InAppText(
              Translation.trNum(data?.tr ?? ''),
              style: TextStyle(
                fontSize: dimen.fontSize.medium,
                color: color.text.primary,
                fontWeight: dimen.fontWeight.medium.fontWeight,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class OnboardingOptions extends StatelessWidget {
  final DimenData? dimen;
  final int index;
  final List<String> options;
  final ValueChanged<int> onChanged;

  const OnboardingOptions({
    super.key,
    this.dimen,
    required this.index,
    required this.onChanged,
    required this.options,
  });

  @override
  Widget build(BuildContext context) {
    final dimen = this.dimen ?? context.dimens;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: dimen.padding.large),
      constraints: BoxConstraints(maxHeight: dimen.height * 0.7),
      child: InAppFade(
        side: FadeSide.vertical,
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(vertical: 24).apply(dimen),
          child: InAppLayout(
            children: List.generate(options.length, (index) {
              final item = options.elementAt(index);
              Widget child = InAppGesture(
                onTap: () => onChanged(index),
                child: OnboardingOption(
                  item,
                  dimen: dimen,
                  selected: index == this.index,
                ),
              );
              if (index != options.length - 1) {
                return Padding(
                  padding: EdgeInsets.only(bottom: dimen.mediumSpace),
                  child: child,
                );
              }
              return child;
            }),
          ),
        ),
      ),
    );
  }
}
