part of 'view.dart';

class ButtonController extends TextViewController {
  dynamic _icon;

  set icon(dynamic value) => _icon = value;

  void setIcon(dynamic value) {
    onNotifyWithCallback(() => icon = value);
  }

  ValueState<dynamic>? iconState;

  void setIconState(ValueState<dynamic>? value) {
    onNotifyWithCallback(() => iconState = value);
  }

  IconAlignment iconAlignment = IconAlignment.end;

  void setIconAlignment(IconAlignment value) {
    onNotifyWithCallback(() => iconAlignment = value);
  }

  bool iconFlexible = false;

  void setIconFlexible(bool value) {
    onNotifyWithCallback(() => iconFlexible = value);
  }

  bool iconOnly = false;

  void setIconOnly(bool value) {
    onNotifyWithCallback(() => iconOnly = value);
  }

  double? _iconSize;

  set iconSize(double? value) => _iconSize = value;

  void setIconSize(double? value) {
    onNotifyWithCallback(() => iconSize = value);
  }

  ValueState<double>? iconSizeState;

  void setIconSizeState(ValueState<double>? value) {
    onNotifyWithCallback(() => iconSizeState = value);
  }

  double? _iconSpace;

  set iconSpace(double? value) => _iconSpace = value;

  void setIconSpace(double value) {
    onNotifyWithCallback(() => iconSpace = value);
  }

  Color? _iconTint;

  set iconTint(Color? value) => _iconTint = value;

  void setIconTint(Color? value) {
    onNotifyWithCallback(() => iconTint = value);
  }

  ValueState<Color>? iconTintState;

  void setIconTintState(ValueState<Color>? value) {
    onNotifyWithCallback(() => iconTintState = value);
  }

  bool iconTintEnabled = true;

  void setIconTintEnabled(bool value) {
    onNotifyWithCallback(() => iconTintEnabled = value);
  }

  bool textCenter = false;

  void setTextCenter(bool value) {
    onNotifyWithCallback(() => textCenter = value);
  }

  ButtonController fromButton(Button view) {
    super.fromTextView(view);
    icon = view.icon;
    iconState = view.iconState;
    iconAlignment = view.iconAlignment;
    iconFlexible = view.iconFlexible;
    iconOnly = view.iconOnly;
    iconSize = view.iconSize;
    iconSizeState = view.iconSizeState;
    iconSpace = view.iconSpace;
    iconTint = view.iconTint;
    iconTintState = view.iconTintState;
    iconTintEnabled = view.iconTintEnabled;
    textCenter = view.textCenter;
    return this;
  }

  dynamic get icon => iconState?.fromController(this) ?? _icon;

  double get iconSize {
    return iconSizeState?.fromController(this) ??
        _iconSize ??
        (textSize ?? 0) * 1.2;
  }

  double get iconSpace => _iconSpace ?? (iconOnly ? 0 : 16);

  Color? get iconTint => iconTintEnabled
      ? iconTintState?.fromController(this) ?? _iconTint ?? color
      : null;

  bool get isCenterText => textCenter;

  get isStartIconVisible => iconAlignment.isStart && icon != null;

  bool get isEndIconVisible => iconAlignment.isEnd && icon != null;

  bool get isStartIconFlex => isStartIconVisible && iconFlexible;

  bool get isEndIconFlex => isEndIconVisible && iconFlexible;

  Color? get color {
    var I = textColorState?.fromController(this) ?? textColor;
    if (I == null) {
      return enabled && isClickMode
          ? activated
              ? theme.primaryColor
              : isBorder
                  ? theme.primaryColor
                  : Colors.white
          : Colors.grey.withOpacity(0.75);
    }
    return I;
  }

  @override
  Color? get background {
    if (super.background == null) {
      return enabled && isClickMode
          ? activated
              ? theme.primaryColor.withOpacity(0.1)
              : theme.primaryColor
          : Colors.grey.withOpacity(0.1);
    }
    return super.background;
  }

  @override
  Color? get borderColor {
    if (super.borderColor == null) {
      return enabled && isClickMode
          ? activated
              ? theme.primaryColor.withOpacity(0.1)
              : theme.primaryColor
          : Colors.grey.withOpacity(0.1);
    }
    return super.background;
  }

  @override
  double? get paddingHorizontal {
    final x = width ?? 0;
    final y = x == double.infinity || x > 0;
    return y ? super.paddingHorizontal : super.paddingHorizontal ?? 24;
  }

  @override
  double? get paddingVertical {
    final x = height ?? 0;
    final y = x == double.infinity || x > 0;
    return y ? super.paddingVertical : super.paddingVertical ?? 12;
  }
}
