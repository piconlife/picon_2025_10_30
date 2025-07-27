import 'package:flutter/material.dart';

import '../../views/button/view.dart';
import '../../views/view/view.dart';
import '../styles/fonts.dart';

class SecondaryButton extends StatelessWidget {
  final ButtonController? controller;
  final bool? enabled;
  final double? width;
  final double? marginTop;
  final String text;
  final double? borderRadius;
  final ValueState<String>? textState;
  final ValueState<Color>? textColorState;
  final ValueState<Color>? backgroundState;
  final OnViewClickListener? onClick;

  const SecondaryButton({
    super.key,
    this.controller,
    this.enabled,
    this.borderRadius,
    this.text = "",
    this.textState,
    this.textColorState,
    this.backgroundState,
    this.onClick,
    this.width,
    this.marginTop,
  });

  @override
  Widget build(BuildContext context) {
    return Button(
      controller: controller,
      borderColorState: backgroundState,
      width: width ?? double.infinity,
      height: 50,
      marginTop: marginTop,
      borderRadius: borderRadius ?? 12,
      borderSize: 1.5,
      borderStrokeAlign: BorderSide.strokeAlignInside,
      background: Colors.transparent,
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
