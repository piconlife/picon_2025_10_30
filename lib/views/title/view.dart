import 'package:flutter/material.dart';

import '../text/view.dart';
import '../view/view.dart';

class TitledView extends YMRView<TitledViewController> {
  /// TITLE CONTENTS
  final String? title;
  final Color? titleColor;
  final double? titleSize;
  final String? titleFontFamily;
  final FontWeight? titleFontWeight;
  final double titleSpaceFromDescription;
  final double titleSpacingExtra;

  /// BODY CONTENTS
  final String? subtitle;
  final Color? subtitleColor;
  final double? subtitleSize;
  final String? subtitleFontFamily;
  final FontWeight? subtitleFontWeight;
  final double subtitleSpacingExtra;

  const TitledView({
    /// ROOT PROPERTIES
    super.key,
    super.controller,

    /// CALLBACK PROPERTIES
    super.onActivator,
    super.onChange,
    super.onError,
    super.onHover,
    super.onValid,
    super.onValidator,

    /// CLICK PROPERTIES
    super.clickEffect,
    super.onClick,
    super.onDoubleClick,
    super.onLongClick,
    super.onToggleClick,
    super.onClickHandler,
    super.onDoubleClickHandler,
    super.onLongClickHandler,

    ///BASE PROPERTIES
    super.absorbMode,
    super.activated,
    super.background,
    super.backgroundState,
    super.backgroundBlendMode,
    super.backgroundGradient,
    super.backgroundGradientState,
    super.backgroundImage,
    super.backgroundImageState,
    super.child,
    super.clipBehavior,
    super.dimensionRatio,
    super.elevation,
    super.enabled,
    super.expandable,
    super.foreground,
    super.foregroundBlendMode,
    super.foregroundGradient,
    super.foregroundImage,
    super.flex,
    super.gravity,
    super.height,
    super.heightState,
    super.heightMax,
    super.heightMin,
    super.hoverColor,
    super.orientation,
    super.position,
    super.positionType,
    super.pressedColor,
    super.rippleColor,
    super.scrollable,
    super.scrollController,
    super.scrollingType,
    super.shape,
    super.transform,
    super.transformGravity,
    super.visibility,
    super.width,
    super.widthState,
    super.widthMax,
    super.widthMin,

    /// ANIMATION PROPERTIES
    super.animation,
    super.animationType,

    /// BACKDROP PROPERTIES
    super.backdropFilter,
    super.backdropMode,

    /// BORDER PROPERTIES
    super.borderColor,
    super.borderColorState,
    super.borderSize,
    super.borderSizeState,
    super.borderHorizontal,
    super.borderHorizontalState,
    super.borderVertical,
    super.borderVerticalState,
    super.borderTop,
    super.borderTopState,
    super.borderBottom,
    super.borderBottomState,
    super.borderStart,
    super.borderStartState,
    super.borderEnd,
    super.borderEndState,
    super.borderStrokeAlign,

    /// BORDER RADIUS PROPERTIES
    super.borderRadius,
    super.borderRadiusState,
    super.borderRadiusBL,
    super.borderRadiusBLState,
    super.borderRadiusBR,
    super.borderRadiusBRState,
    super.borderRadiusTL,
    super.borderRadiusTLState,
    super.borderRadiusTR,
    super.borderRadiusTRState,

    /// INDICATOR PROPERTIES
    super.indicatorVisible,

    /// MARGIN PROPERTIES
    super.margin,
    super.marginHorizontal,
    super.marginVertical,
    super.marginTop,
    super.marginBottom,
    super.marginStart,
    super.marginEnd,
    super.marginCustom,

    /// OPACITY PROPERTIES
    super.opacity,
    super.opacityState,
    super.opacityAlwaysIncludeSemantics,

    /// PADDING PROPERTIES
    super.padding,
    super.paddingHorizontal,
    super.paddingVertical,
    super.paddingTop,
    super.paddingBottom,
    super.paddingStart,
    super.paddingEnd,
    super.paddingCustom,

    /// SHADOW PROPERTIES
    super.shadow,
    super.shadowBlurRadius,
    super.shadowBlurStyle,
    super.shadowColor,
    super.shadowType,
    super.shadowSpreadRadius,
    super.shadowHorizontal,
    super.shadowVertical,
    super.shadowStart,
    super.shadowEnd,
    super.shadowTop,
    super.shadowBottom,

    /// TITLE CONTENTS
    this.title,
    this.titleColor,
    this.titleSize,
    this.titleFontFamily,
    this.titleFontWeight,
    this.titleSpaceFromDescription = 0,
    this.titleSpacingExtra = 0,

    /// BODY CONTENTS
    this.subtitle,
    this.subtitleColor,
    this.subtitleSize,
    this.subtitleFontFamily,
    this.subtitleFontWeight,
    this.subtitleSpacingExtra = 0,
  });

  @override
  TitledViewController initController() => TitledViewController();

  @override
  TitledViewController attachController(
    TitledViewController controller,
  ) {
    return controller.fromDescriptionView(this);
  }

  @override
  Widget? attach(BuildContext context, TitledViewController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        TextView(
          visibility: (title ?? "").isNotEmpty,
          text: title,
          textColor: titleColor,
          textSize: titleSize,
          textFontFamily: titleFontFamily,
          textFontWeight: titleFontWeight,
          lineSpacingExtra: titleSpacingExtra,
          marginBottom: titleSpaceFromDescription,
        ),
        if ((subtitle ?? "").isNotEmpty)
          TextView(
            text: subtitle,
            textColor: subtitleColor,
            textSize: subtitleSize,
            textFontFamily: subtitleFontFamily,
            textFontWeight: subtitleFontWeight,
            lineSpacingExtra: subtitleSpacingExtra,
          ),
        if (child != null) child!,
      ],
    );
  }
}

class TitledViewController extends ViewController {
  /// TITLE CONTENTS
  String? title;
  Color? titleColor;
  double? titleSize;
  String? titleFontFamily;
  FontWeight? titleFontWeight;

  /// BODY CONTENTS
  String? subtitle;
  Color? subtitleColor;
  double? subtitleSize;
  String? subtitleFontFamily;
  FontWeight? subtitleFontWeight;

  TitledViewController fromDescriptionView(TitledView view) {
    super.fromView(view);

    /// TITLE CONTENTS
    title = view.title;
    titleColor = view.titleColor;
    titleSize = view.titleSize;
    titleFontFamily = view.titleFontFamily;
    titleFontWeight = view.titleFontWeight;

    /// BODY CONTENTS
    subtitle = view.subtitle;
    subtitleColor = view.subtitleColor;
    subtitleSize = view.subtitleSize;
    subtitleFontFamily = view.subtitleFontFamily;
    subtitleFontWeight = view.subtitleFontWeight;
    return this;
  }
}
