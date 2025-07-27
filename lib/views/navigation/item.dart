part of 'view.dart';

class NavigationItem extends StatelessWidget {
  final bool isSelected;
  final bool isVisible;
  final dynamic icon;
  final ValueState<dynamic>? iconState;
  final double? iconSize;
  final ValueState<double>? iconSizeState;
  final Color? iconTint;
  final ValueState<Color>? iconTintState;
  final IconThemeData? iconTheme;
  final ValueState<IconThemeData>? iconThemeState;
  final String? title;
  final ValueState<String>? titleState;
  final Color? titleColor;
  final ValueState<Color>? titleColorState;
  final double? titleSize;
  final ValueState<double>? titleSizeState;
  final TextStyle? titleStyle;
  final ValueState<TextStyle>? titleStyleState;
  final double? spaceBetween;
  final ValueState<double>? spaceBetweenState;
  final Color? background;
  final ValueState<Color>? backgroundState;
  final double? maxWidth;
  final double? maxHeight;
  final double? minWidth;
  final double? minHeight;
  final double? margin;
  final double? marginX;
  final double? marginY;
  final double? padding;
  final double? paddingX;
  final double? paddingY;
  final OnViewClickListener? onClick;
  final LinearLayoutController? itemController;
  final IconViewController? iconController;
  final TextViewController? labelController;

  const NavigationItem({
    super.key,
    this.isSelected = false,
    this.isVisible = true,
    this.icon,
    this.iconState,
    this.iconSize,
    this.iconSizeState,
    this.iconTint,
    this.iconTintState,
    this.iconTheme,
    this.iconThemeState,
    this.title,
    this.titleState,
    this.titleColor,
    this.titleColorState,
    this.titleSize,
    this.titleSizeState,
    this.titleStyle,
    this.titleStyleState,
    this.spaceBetween,
    this.spaceBetweenState,
    this.maxWidth,
    this.maxHeight,
    this.minWidth,
    this.minHeight,
    this.margin,
    this.marginX,
    this.marginY,
    this.padding,
    this.paddingX,
    this.paddingY,
    this.background,
    this.backgroundState,
    this.onClick,
    this.itemController,
    this.iconController,
    this.labelController,
  });

  @override
  Widget build(BuildContext context) {
    var ic = iconState?.detect(isSelected) ?? icon;
    var text = titleState?.detect(isSelected) ?? title ?? "";
    var spacer = spaceBetweenState?.detect(isSelected) ?? spaceBetween;
    return LinearLayout(
      controller: itemController,
      widthMax: maxWidth,
      widthMin: minWidth,
      heightMax: maxHeight,
      heightMin: minHeight,
      margin: margin,
      marginHorizontal: marginX,
      marginVertical: marginY,
      padding: padding,
      paddingHorizontal: paddingX,
      paddingVertical: paddingY,
      background: background,
      backgroundState: backgroundState,
      visibility: isVisible,
      gravity: Alignment.center,
      layoutGravity: LayoutGravity.center,
      onClick: onClick,
      children: [
        IconView(
          controller: iconController,
          visibility: ic != null,
          activated: isSelected,
          icon: ic,
          iconState: iconState,
          size: iconSize,
          sizeState: iconSizeState,
          tint: iconTint,
          tintState: iconTintState,
          iconTheme: iconTheme,
          iconThemeState: iconThemeState,
        ),
        TextView(
          controller: labelController,
          paddingHorizontal: 8,
          marginTop: spacer,
          visibility: text.isNotEmpty,
          activated: isSelected,
          text: text,
          textState: titleState,
          textSize: titleSize,
          textColor: titleColor,
          textColorState: titleColorState,
          textStyle: titleStyle,
          textStyleState: titleStyleState,
        ),
      ],
    );
  }
}
