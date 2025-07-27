part of 'view.dart';

class CheckmarkViewController extends TextViewController {
  CheckmarkViewController fromCheckmarkView(CheckmarkView view) {
    super.fromTextView(view);

    /// BASE PROPERTIES
    checkboxAlignment = view.checkboxAlignment;
    spaceBetween = view.spaceBetween;

    /// CHECK BOX PROPERTIES
    primary = view.primary;
    activeColor = view.activeColor;
    checkColor = view.checkColor;
    fillColor = view.fillColor;
    fillColorState = view.fillColorState;
    checkFocusColor = view.checkFocusColor;
    checkFocusNode = view.checkFocusNode;
    checkHoverColor = view.checkHoverColor;
    checkAutofocus = view.checkAutofocus;
    isError = view.isError;
    materialTapTargetSize = view.materialTapTargetSize;
    mouseCursor = view.mouseCursor;
    splashRadius = view.splashRadius;
    tristate = view.tristate;
    visualDensity = view.visualDensity;
    checkboxRadius = view.checkboxRadius;
    checkboxStrokeColor = view.checkboxStrokeColor;
    checkboxStrokeSize = view.checkboxStrokeSize;
    overlayOpacity = view.overlayOpacity;
    return this;
  }

  /// BASE PROPERTIES
  CheckboxAlignment checkboxAlignment = CheckboxAlignment.rightCenter;
  double spaceBetween = 8;

  bool get _isStart => checkboxAlignment.isLeftMode;

  /// CHECK BOX PROPERTIES
  Color? primary;
  Color? activeColor;
  Color? checkColor;
  Color? _fillColor;
  ValueState<Color>? fillColorState;
  Color? checkFocusColor;
  FocusNode? checkFocusNode;
  Color? checkHoverColor;
  bool checkAutofocus = false;
  bool isError = false;
  MaterialTapTargetSize materialTapTargetSize =
      MaterialTapTargetSize.shrinkWrap;
  MouseCursor? mouseCursor;
  double? splashRadius;
  bool tristate = false;
  VisualDensity? visualDensity;

  double checkboxRadius = 4;
  Color? checkboxStrokeColor;
  double checkboxStrokeSize = 2;
  int overlayOpacity = 20;

  Color get fillColor {
    var v = fillColorState?.fromController(this) ?? _fillColor;
    return v ??
        (context != null ? Theme.of(context!).primaryColor : Colors.blue);
  }

  MaterialStateProperty<Color> get fillColorProperty {
    return MaterialStateProperty.resolveWith((states) {
      return fillColor;
    });
  }

  MaterialStateProperty<Color> get overlayColor {
    return MaterialStateProperty.resolveWith((states) {
      return fillColor.withAlpha(overlayOpacity);
    });
  }

  BorderSide? get borderSide {
    return BorderSide(
      color: checkboxStrokeColor ?? fillColor,
      width: checkboxStrokeSize,
      style: checkboxStrokeSize > 0 ? BorderStyle.solid : BorderStyle.none,
      strokeAlign: BorderSide.strokeAlignInside,
    );
  }

  OutlinedBorder? get checkboxShape {
    return RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(checkboxRadius),
      side: borderSide ?? BorderSide.none,
    );
  }

  set fillColor(Color? value) => _fillColor = value;
}
