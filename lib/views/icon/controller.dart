part of 'view.dart';

class IconViewController extends ViewController {
  bool iconSizeAsFixed = false;

  void setIconSizeAsFixed(bool value) {
    onNotifyWithCallback(() => iconSizeAsFixed = value);
  }

  BoxFit fit = BoxFit.contain;

  void setIconFit(BoxFit value) {
    onNotifyWithCallback(() => fit = value);
  }

  dynamic _icon;

  set icon(dynamic value) => _icon = value;

  void setIcon(dynamic value) {
    onNotifyWithCallback(() => icon = value);
  }

  ValueState<dynamic>? iconState;

  void setIconState(ValueState<dynamic>? value) {
    onNotifyWithCallback(() => iconState = value);
  }

  double? _size;

  set size(double? value) => _size = value;

  void setIconSize(double? value) {
    onNotifyWithCallback(() => size = value);
  }

  ValueState<double>? iconSizeState;

  void setIconSizeState(ValueState<double>? value) {
    onNotifyWithCallback(() => iconSizeState = value);
  }

  Color? _tint;

  set tint(Color? value) => _tint = value;

  void setIconTint(Color value) {
    onNotifyWithCallback(() => tint = value);
  }

  ValueState<Color>? tintState;

  void setIconTintState(ValueState<Color>? value) {
    onNotifyWithCallback(() => tintState = value);
  }

  BlendMode tintMode = BlendMode.srcIn;

  void setIconTintMode(BlendMode value) {
    onNotifyWithCallback(() => tintMode = value);
  }

  IconThemeData? _iconTheme;

  set iconTheme(IconThemeData? value) => _iconTheme = value;

  void setIconTheme(IconThemeData? value) {
    onNotifyWithCallback(() => iconTheme = value);
  }

  ValueState<IconThemeData>? iconThemeState;

  void setIconThemeState(ValueState<IconThemeData>? value) {
    onNotifyWithCallback(() => iconThemeState = value);
  }

  IconViewController fromIconView(IconView view) {
    super.fromView(view);
    fit = view.fit;
    icon = view.icon;
    iconState = view.iconState;
    size = view.size;
    tint = view.tint;
    tintState = view.tintState;
    tintMode = view.tintMode;
    iconSizeAsFixed = view.iconSizeAsFixed;
    iconTheme = view.iconTheme;
    iconThemeState = view.iconThemeState;
    return this;
  }

  dynamic get icon => iconState?.fromController(this) ?? _icon;

  IconThemeData? get iconTheme {
    return iconThemeState?.fromController(this) ?? _iconTheme;
  }

  double get size {
    return iconSizeState?.fromController(this) ??
        _size ??
        iconTheme?.size ??
        24;
  }

  double get iconSize {
    if (iconSizeAsFixed) {
      return size;
    } else {
      return size - (paddingAll / 2);
    }
  }

  Color? get tint {
    return tintState?.fromController(this) ?? _tint ?? iconTheme?.color;
  }
}
