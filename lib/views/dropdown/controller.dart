part of 'view.dart';

class DropdownViewController<T extends Object> extends TextViewController {
  int _selectedIndex = 0;
  List<DropdownItem<T>> items = const [];

  set selectedIndex(int value) => _selectedIndex = value;

  int get selectedIndex => items.length > _selectedIndex ? _selectedIndex : 0;

  T? get selectedItem => items.isNotEmpty ? items[selectedIndex].value : null;

  DropdownViewController<T> fromDropdownView(DropdownView<T> view) {
    super.fromTextView(view);
    selectedIndex = view.selectedIndex;
    items = view.items;

    /// DRAWABLE PROPERTIES
    leadingIcon = view.leadingIcon;
    leadingIconState = view.leadingIconState;
    leadingIconSize = view.leadingIconSize;
    leadingIconSizeState = view.leadingIconSizeState;
    leadingIconTint = view.leadingIconTint;
    leadingIconTintState = view.leadingIconTintState;
    leadingIconVisible = view.leadingIconVisible;

    trailingIcon = view.trailingIcon;
    trailingIconState = view.trailingIconState;
    trailingIconSize = view.trailingIconSize;
    trailingIconSizeState = view.trailingIconSizeState;
    trailingIconTint = view.trailingIconTint;
    trailingIconTintState = view.trailingIconTintState;
    trailingIconVisible = view.trailingIconVisible;

    trailingSelectedIcon = view.trailingSelectedIcon;
    trailingSelectedIconState = view.trailingSelectedIconState;
    trailingSelectedIconSize = view.trailingSelectedIconSize;
    trailingSelectedIconSizeState = view.trailingSelectedIconSizeState;
    trailingSelectedIconTint = view.trailingSelectedIconTint;
    trailingSelectedIconTintState = view.trailingSelectedIconTintState;
    trailingSelectedIconVisible = view.trailingSelectedIconVisible;

    return this;
  }

  /// DRAWABLE PROPERTIES
  dynamic _leadingIcon;
  ValueState<dynamic>? leadingIconState;
  double? _leadingIconSize;
  ValueState<double>? leadingIconSizeState;
  Color? _leadingIconTint;
  ValueState<Color>? leadingIconTintState;
  bool leadingIconVisible = true;

  dynamic _trailingIcon;
  ValueState<dynamic>? trailingIconState;
  double? _trailingIconSize;
  ValueState<double>? trailingIconSizeState;
  Color? _trailingIconTint;
  ValueState<Color>? trailingIconTintState;
  bool trailingIconVisible = true;

  dynamic _trailingSelectedIcon;
  ValueState<dynamic>? trailingSelectedIconState;
  double? _trailingSelectedIconSize;
  ValueState<double>? trailingSelectedIconSizeState;
  Color? _trailingSelectedIconTint;
  ValueState<Color>? trailingSelectedIconTintState;
  bool trailingSelectedIconVisible = true;

  set leadingIcon(dynamic value) => _leadingIcon = value;

  set leadingIconSize(double? value) => _leadingIconSize = value;

  set leadingIconTint(Color? value) => _leadingIconTint = value;

  set trailingIcon(dynamic value) => _trailingIcon = value;

  set trailingIconSize(double? value) => _trailingIconSize = value;

  set trailingIconTint(Color? value) => _trailingIconTint = value;

  set trailingSelectedIcon(dynamic value) => _trailingSelectedIcon = value;

  set trailingSelectedIconSize(double? value) =>
      _trailingSelectedIconSize = value;

  set trailingSelectedIconTint(Color? value) =>
      _trailingSelectedIconTint = value;

  dynamic get leadingIcon {
    var value = leadingIconState?.fromController(this);
    return value ?? _leadingIcon;
  }

  double? get leadingIconSize {
    var value = leadingIconSizeState?.fromController(this);
    return value ?? _leadingIconSize;
  }

  Color? get leadingIconTint {
    var value = leadingIconTintState?.fromController(this);
    return value ?? _leadingIconTint;
  }

  dynamic get trailingIcon {
    var value = trailingIconState?.fromController(this);
    return value ?? _trailingIcon;
  }

  double? get trailingIconSize {
    var value = trailingIconSizeState?.fromController(this);
    return value ?? _trailingIconSize;
  }

  Color? get trailingIconTint {
    var value = trailingIconTintState?.fromController(this);
    return value ?? _trailingIconTint;
  }

  dynamic get trailingSelectedIcon {
    var value = trailingSelectedIconState?.fromController(this);
    return value ?? _trailingSelectedIcon;
  }

  double? get trailingSelectedIconSize {
    var value = trailingSelectedIconSizeState?.fromController(this);
    return value ?? _trailingSelectedIconSize;
  }

  Color? get trailingSelectedIconTint {
    var value = trailingSelectedIconTintState?.fromController(this);
    return value ?? _trailingSelectedIconTint;
  }

  void setLeadingIcon(dynamic icon) {
    onNotifyWithCallback(() => leadingIcon = icon);
  }

  void setLeadingIconState(ValueState<dynamic> iconState) {
    onNotifyWithCallback(() => leadingIconState = iconState);
  }

  void setLeadingIconSize(double? size) {
    onNotifyWithCallback(() => leadingIconSize = size);
  }

  void setLeadingIconSizeState(ValueState<double>? sizeState) {
    onNotifyWithCallback(() => leadingIconSizeState = sizeState);
  }

  void setLeadingIconTint(Color? tint) {
    onNotifyWithCallback(() => leadingIconTint = tint);
  }

  void setLeadingIconTintState(ValueState<Color>? tintState) {
    onNotifyWithCallback(() => leadingIconTintState = tintState);
  }

  void setTrailingIcon(dynamic icon) {
    onNotifyWithCallback(() => trailingIcon = icon);
  }

  void setTrailingIconState(ValueState<dynamic> iconState) {
    onNotifyWithCallback(() => trailingIconState = iconState);
  }

  void setTrailingIconSize(double? size) {
    onNotifyWithCallback(() => trailingIconSize = size);
  }

  void setTrailingIconSizeState(ValueState<double>? sizeState) {
    onNotifyWithCallback(() => trailingIconSizeState = sizeState);
  }

  void setTrailingIconTint(Color? tint) {
    onNotifyWithCallback(() => trailingIconTint = tint);
  }

  void setTrailingIconTintState(ValueState<Color>? tintState) {
    onNotifyWithCallback(() => trailingIconTintState = tintState);
  }

  void setTrailingSelectedIcon(dynamic icon) {
    onNotifyWithCallback(() => trailingSelectedIcon = icon);
  }

  void setTrailingSelectedIconState(ValueState<dynamic> iconState) {
    onNotifyWithCallback(() => trailingSelectedIconState = iconState);
  }

  void setTrailingSelectedIconSize(double? size) {
    onNotifyWithCallback(() => trailingSelectedIconSize = size);
  }

  void setTrailingSelectedIconSizeState(ValueState<double>? sizeState) {
    onNotifyWithCallback(() => trailingSelectedIconSizeState = sizeState);
  }

  void setTrailingSelectedIconTint(Color? tint) {
    onNotifyWithCallback(() => trailingSelectedIconTint = tint);
  }

  void setTrailingSelectedIconTintState(ValueState<Color>? tintState) {
    onNotifyWithCallback(() => trailingSelectedIconTintState = tintState);
  }
}
