part of 'view.dart';

class ValueState<T> {
  final T? primary;
  final T? secondary;
  final T? ternary;
  final T? disable;
  final T? error;
  final T? hover;
  final T? valid;

  const ValueState({
    this.primary,
    this.secondary,
    this.ternary,
    this.disable,
    this.error,
    this.hover,
    this.valid,
  });

  T? detect(
    bool activated, {
    bool enabled = true,
    bool error = false,
    bool focused = false,
    bool hover = false,
    bool valid = false,
  }) {
    if (enabled) {
      if (hover) {
        return this.hover ?? secondary ?? primary;
      } else if (error) {
        if (focused) {
          return this.error ?? secondary ?? primary;
        } else {
          return primary ?? this.error;
        }
      } else if (valid) {
        if (focused) {
          return this.valid ?? secondary ?? primary;
        } else {
          return primary ?? this.valid;
        }
      } else if (activated) {
        return secondary ?? primary;
      } else {
        return primary;
      }
    } else {
      return disable ?? ternary ?? primary;
    }
  }

  factory ValueState.activation({
    T? activated,
    T? unactivated,
    T? disabled,
  }) {
    return ValueState<T>(
      primary: unactivated,
      secondary: activated,
      disable: disabled,
    );
  }

  T? activator(bool activated, [bool enabled = true]) {
    if (enabled) {
      return activated ? secondary : primary;
    } else {
      return disable ?? primary;
    }
  }

  factory ValueState.selection({
    T? selected,
    T? unselected,
    T? disabled,
  }) {
    return ValueState<T>(
      primary: unselected,
      secondary: selected,
      disable: disabled,
    );
  }

  T? selector(bool selected, [bool enabled = true]) {
    if (enabled) {
      return selected ? secondary : primary;
    } else {
      return disable ?? primary;
    }
  }

  T? fromController(ViewController controller) {
    return detect(
      controller.activated,
      enabled: controller.enabled,
      error: controller.error,
      focused: controller.focused,
      hover: controller.hover,
      valid: controller.valid,
    );
  }

  T? fromType(ValueStateType state) {
    switch (state) {
      case ValueStateType.secondary:
        return secondary ?? primary;
      case ValueStateType.ternary:
        return ternary ?? primary;
      case ValueStateType.disabled:
        return disable ?? primary;
      case ValueStateType.error:
        return error ?? primary;
      case ValueStateType.hover:
        return hover ?? primary;
      default:
        return primary;
    }
  }
}
