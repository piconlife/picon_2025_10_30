part of 'view.dart';

class CheckmarkConfig {
  final Widget? checkmark;

  final Color? activeColor;
  final Color? checkColor;
  final Color? focusColor;
  final Color? hoverColor;
  final ValueState<Color>? fillColorState;
  final ValueState<Color?>? overlayColorState;

  const CheckmarkConfig({
    this.checkmark,
    this.activeColor,
    this.checkColor,
    this.focusColor,
    this.hoverColor,
    this.fillColorState,
    this.overlayColorState,
  });

  CheckmarkConfig copy({
    Widget? checkmark,
    Color? activeColor,
    Color? checkColor,
    Color? focusColor,
    Color? hoverColor,
    ValueState<Color>? fillColorState,
    ValueState<Color?>? overlayColorState,
  }) {
    return CheckmarkConfig(
      checkmark: checkmark ?? this.checkmark,
      activeColor: activeColor ?? this.activeColor,
      checkColor: checkColor ?? this.checkColor,
      focusColor: focusColor ?? this.focusColor,
      hoverColor: hoverColor ?? this.hoverColor,
      fillColorState: fillColorState ?? this.fillColorState,
      overlayColorState: overlayColorState ?? this.overlayColorState,
    );
  }

  MaterialStateProperty<Color?>? fillColor(SettingsViewController controller) {
    if (fillColorState != null) {
      return MaterialStateProperty.all(
        fillColorState?.fromController(controller),
      );
    }
    return null;
  }

  MaterialStateProperty<Color?>? overlayColor(
    SettingsViewController controller,
  ) {
    if (overlayColorState != null) {
      return MaterialStateProperty.all(
        overlayColorState?.fromController(controller),
      );
    }
    return null;
  }
}
