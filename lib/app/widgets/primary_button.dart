import 'package:flutter/material.dart';

import '../../views/button/view.dart';
import '../../views/view/view.dart';
import '../styles/fonts.dart';

class PrimaryButton extends StatelessWidget {
  final ButtonController? controller;
  final bool visibility;
  final ViewPositionType? positionType;
  final bool? enabled;
  final double? width;
  final double? marginTop;
  final EdgeInsets? margin;
  final String text;
  final double? borderRadius;
  final ValueState<String>? textState;
  final ValueState<Color>? textColorState;
  final ValueState<Color>? backgroundState;
  final OnViewClickListener? onClick;

  const PrimaryButton({
    super.key,
    this.controller,
    this.visibility = true,
    this.enabled,
    this.positionType,
    this.borderRadius,
    this.text = "",
    this.textState,
    this.textColorState,
    this.backgroundState,
    this.onClick,
    this.width,
    this.marginTop,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return Button(
      positionType: positionType,
      visibility: visibility,
      controller: controller,
      // rippleColor: context.primaryColor.darker(15),
      // pressedColor: context.primaryColor.darker(15),
      backgroundState: backgroundState,
      width: width ?? double.infinity,
      height: 50,
      marginTop: marginTop,
      marginCustom: margin,
      borderRadius: borderRadius ?? 50,
      text: text,
      textState: textState,
      textColorState: textColorState,
      textSize: 16,
      textFontWeight: FontWeight.w600,
      textStyle: const TextStyle(fontFamily: InAppFonts.secondary),
      onClick: onClick,
      clickEffect: const ViewClickEffect.bounce(),
    );
  }
}
