part of 'view.dart';

enum DrawableState {
  focused,
  unfocused,
  disabled,
  error;

  bool get isDisabled => this == DrawableState.disabled;

  bool get isError => this == DrawableState.error;

  bool get isFocused => this == DrawableState.focused;

  bool get isUnfocused => this == DrawableState.unfocused;
}
