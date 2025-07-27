part of 'view.dart';

class EditTextController extends TextViewController {
  TextEditingController _editor = TextEditingController();

  FocusNode _node = FocusNode();

  EditTextController({
    TextEditingController? editor,
    FocusNode? focusNode,
  }) {
    _editor = editor ?? _editor;
    _node = focusNode ?? _node;
    addFocusListener();
  }

  void addFocusListener([VoidCallback? callback]) {
    _node.addListener(() {
      _handleFocusChange();
      if (callback != null) callback();
    });
  }

  void removeFocusListener([VoidCallback? callback]) {
    _node.removeListener(() {
      _handleFocusChange();
      if (callback != null) callback();
    });
  }

  /// SUPER PROPERTIES

  @override
  bool get activated => isFocused;

  @override
  int? get maxLines {
    switch (inputType) {
      case TextInputType.datetime:
      case TextInputType.emailAddress:
      case TextInputType.name:
      case TextInputType.number:
      case TextInputType.phone:
      case TextInputType.streetAddress:
      case TextInputType.text:
      case TextInputType.visiblePassword:
      case TextInputType.text:
        return 1;
      case TextInputType.multiline:
      case TextInputType.url:
      default:
        return null;
    }
  }

  @override
  double? get paddingVertical => super.paddingVertical ?? 8;

  @override
  String get text => _editor.text;

  @override
  set text(String? value) => _editor.text = value ?? "";

  @override
  void setText(String? value) {
    _editor.text = value ?? "";
  }

  bool get _isMargin => marginAll > 0;

  /// BASE PROPERTIES

  bool autoDisposeMode = true;

  void setAutoDisposeMode(bool value) {
    onNotifyWithCallback(() => autoDisposeMode = value);
  }

  String characters = "";

  void setCharacters(String value) {
    onNotifyWithCallback(() => characters = value);
  }

  String ignorableCharacters = "";

  void setIgnorableCharacters(String value) {
    onNotifyWithCallback(() => ignorableCharacters = value);
  }

  bool maxCharactersAsLimit = true;

  void setMaxCharactersAsLimit(bool value) {
    onNotifyWithCallback(() => maxCharactersAsLimit = value);
  }

  int? minCharacters;

  void setMinCharacters(int? value) {
    onNotifyWithCallback(() => minCharacters = value);
  }

  Color? _primary;

  Color get primary => _primary ?? theme.primaryColor;

  set primary(Color? value) => _primary = value;

  void setPrimary(Color? value) {
    onNotifyWithCallback(() => primary = value);
  }

  void _initBaseProperties(EditText view) {
    autoDisposeMode = view.autoDisposeMode;
    characters = view.characters;
    ignorableCharacters = view.ignorableCharacters;
    maxCharacters = view.maxCharacters;
    maxCharactersAsLimit = view.maxCharactersAsLimit;
    minCharacters = view.minCharacters;
    primary = view.primary;
    text = view.text;
  }

  /// DRAWABLE PROPERTIES
  dynamic _drawableEnd;

  set drawableEnd(dynamic value) => _drawableEnd = value;

  void setDrawableEnd(dynamic value) {
    onNotifyWithCallback(() => drawableEnd = value);
  }

  ValueState<dynamic>? drawableEndState;

  void setDrawableEndState(ValueState<dynamic>? value) {
    onNotifyWithCallback(() => drawableEndState = value);
  }

  bool drawableEndAsEye = false;

  void setDrawableEndAsEye(bool value) {
    onNotifyWithCallback(() => drawableEndAsEye = value);
  }

  double _drawableEndSize = 24;

  set drawableEndSize(double value) => _drawableEndSize = value;

  void setDrawableEndSize(double value) {
    onNotifyWithCallback(() => drawableEndSize = value);
  }

  ValueState<double>? drawableEndSizeState;

  void setDrawableEndSizeState(ValueState<double>? value) {
    onNotifyWithCallback(() => drawableEndSizeState = value);
  }

  double? _drawableEndPadding;

  set drawableEndPadding(double? value) => _drawableEndPadding = value;

  void setDrawableEndPadding(double? value) {
    onNotifyWithCallback(() => drawableEndPadding = value);
  }

  ValueState<double>? drawableEndPaddingState;

  void setDrawableEndPaddingState(ValueState<double>? value) {
    onNotifyWithCallback(() => drawableEndPaddingState = value);
  }

  Color? _drawableEndTint;

  set drawableEndTint(Color? value) => _drawableEndTint = value;

  void setDrawableEndTint(Color? value) {
    onNotifyWithCallback(() => drawableEndTint = value);
  }

  ValueState<Color>? drawableEndTintState;

  void setDrawableEndTintState(ValueState<Color>? value) {
    onNotifyWithCallback(() => drawableEndTintState = value);
  }

  bool drawableEndVisible = true;

  void setDrawableEndVisible(bool value) {
    onNotifyWithCallback(() => drawableEndVisible = value);
  }

  void _initDrawableEndProperties(EditText view) {
    drawableEnd = view.drawableEnd;
    drawableEndState = view.drawableEndState;
    drawableEndAsEye = view.drawableEndAsEye;
    drawableEndSize = view.drawableEndSize;
    drawableEndSizeState = view.drawableEndSizeState;
    drawableEndPadding = view.drawableEndPadding;
    drawableEndPaddingState = view.drawableEndPaddingState;
    drawableEndTint = view.drawableEndTint;
    drawableEndTintState = view.drawableEndTintState;
    drawableEndVisible = view.drawableEndVisible;
  }

  /// DRAWABLE START PROPERTIES
  dynamic _drawableStart;

  set drawableStart(dynamic value) => _drawableStart = value;

  void setDrawableStart(dynamic value) {
    onNotifyWithCallback(() => drawableStart = value);
  }

  ValueState<dynamic>? drawableStartState;

  void setDrawableStartState(ValueState<dynamic>? value) {
    onNotifyWithCallback(() => drawableStartState = value);
  }

  double _drawableStartSize = 18;

  set drawableStartSize(double value) => _drawableStartSize = value;

  void setDrawableStartSize(double value) {
    onNotifyWithCallback(() => drawableStartSize = value);
  }

  ValueState<double>? drawableStartSizeState;

  void setDrawableStartSizeState(dynamic value) {
    onNotifyWithCallback(() => drawableStartSizeState = value);
  }

  double? _drawableStartPadding;

  set drawableStartPadding(double? value) => _drawableStartPadding = value;

  void setDrawableStartPadding(double? value) {
    onNotifyWithCallback(() => drawableStartPadding = value);
  }

  ValueState<double>? drawableStartPaddingState;

  void setDrawableStartPaddingState(ValueState<double>? value) {
    onNotifyWithCallback(() => drawableStartPaddingState = value);
  }

  Color? _drawableStartTint;

  set drawableStartTint(Color? value) => _drawableStartTint = value;

  void setDrawableStartTint(Color? value) {
    onNotifyWithCallback(() => drawableStartTint = value);
  }

  ValueState<Color>? drawableStartTintState;

  void setDrawableStartTintState(ValueState<Color>? value) {
    onNotifyWithCallback(() => drawableStartTintState = value);
  }

  bool drawableStartVisible = true;

  void setDrawableStartVisible(bool value) {
    onNotifyWithCallback(() => drawableStartVisible = value);
  }

  void _initDrawableStartProperties(EditText view) {
    drawableStart = view.drawableStart;
    drawableStartState = view.drawableStartState;
    drawableStartSize = view.drawableStartSize;
    drawableStartSizeState = view.drawableStartSizeState;
    drawableStartPadding = view.drawableStartPadding;
    drawableStartPaddingState = view.drawableStartPaddingState;
    drawableStartTint = view.drawableStartTint;
    drawableStartTintState = view.drawableStartTintState;
    drawableStartVisible = view.drawableStartVisible;
  }

  /// COUNTER TEXT PROPERTIES

  Color? _counterTextColor;

  Color? get counterTextColor {
    return counterTextColorState?.fromController(this) ??
        _counterTextColor ??
        secondaryColor;
  }

  set counterTextColor(Color? value) => _counterTextColor = value;

  ValueState<Color>? counterTextColorState;

  void setCounterTextColor(Color? value) {
    onNotifyWithCallback(() => counterTextColor = value);
  }

  TextStyle? _counterTextStyle;

  TextStyle? get counterTextStyle {
    return counterTextStyleState?.fromController(this) ??
        _counterTextStyle ??
        helperTextStyle?.copyWith(
          color: hasError ? errorTextColor : counterTextColor,
        );
  }

  set counterTextStyle(TextStyle? value) => _counterTextStyle = value;

  ValueState<TextStyle>? counterTextStyleState;

  void setCounterTextStyleState(ValueState<TextStyle>? value) {
    onNotifyWithCallback(() => counterTextStyleState = value);
  }

  FloatingVisibility counterVisibility = FloatingVisibility.hide;

  bool get counterVisible {
    return !counterVisibility.isInvisible && textAlign != TextAlign.center;
  }

  void setCounterVisibility(FloatingVisibility value) {
    onNotifyWithCallback(() => counterVisibility = value);
  }

  void _initCounterProperties(EditText view) {
    counterTextColor = view.counterTextColor;
    counterTextColorState = view.counterTextColorState;
    counterTextStyle = view.counterTextStyle;
    counterTextStyleState = view.counterTextStyleState;
    counterVisibility = view.counterVisibility;
  }

  /// ERROR TEXT PROPERTIES
  String? _errorText;

  set errorText(String? value) => _errorText = value;

  void setErrorText(String? value) {
    onNotifyWithCallback(() => errorText = value);
  }

  ValueState<String>? errorTextState;

  void setErrorTextState(ValueState<String>? value) {
    onNotifyWithCallback(() => errorTextState = value);
  }

  Color? _errorTextColor;

  Color? get errorTextColor {
    return errorTextColorState?.fromController(this) ?? _errorTextColor;
  }

  set errorTextColor(Color? value) => _errorTextColor = value;

  ValueState<Color>? errorTextColorState;

  void setErrorTextColor(Color? value) {
    onNotifyWithCallback(() => errorTextColor = value);
  }

  TextStyle? _errorTextStyle;

  TextStyle? get errorTextStyle {
    return errorTextStyleState?.fromController(this) ??
        _errorTextStyle ??
        helperTextStyle?.copyWith(color: errorTextColor);
  }

  set errorTextStyle(TextStyle? value) => _errorTextStyle = value;

  ValueState<TextStyle>? errorTextStyleState;

  void setErrorTextStyleState(ValueState<TextStyle>? value) {
    onNotifyWithCallback(() => errorTextStyleState = value);
  }

  FloatingVisibility errorVisibility = FloatingVisibility.hide;

  void setErrorVisibility(FloatingVisibility value) {
    onNotifyWithCallback(() => errorVisibility = value);
  }

  void _initErrorTextProperties(EditText view) {
    errorTextColor = view.errorTextColor;
    errorTextColorState = view.errorTextColorState;
    errorTextStyle = view.errorTextStyle;
    errorTextStyleState = view.errorTextStyleState;
    errorVisibility = view.errorVisibility;
  }

  /// FLOATING TEXT PROPERTIES

  Alignment? _floatingAlignment;

  Alignment get floatingAlignment {
    if (textAlign == TextAlign.center) {
      return Alignment.center;
    } else {
      if (_floatingAlignment != null) {
        return _floatingAlignment!;
      }
      final isRTL = textDirection == TextDirection.rtl;
      return isRTL ? Alignment.centerRight : Alignment.centerLeft;
    }
  }

  set floatingAlignment(Alignment? value) => _floatingAlignment = value;

  void setFloatingAlignment(String? value) {
    onNotifyWithCallback(() => floatingText = value);
  }

  String? _floatingText;

  String get floatingText => _floatingText ?? hintText;

  set floatingText(String? value) => _floatingText = value;

  void setFloatingText(String? value) {
    onNotifyWithCallback(() => floatingText = value);
  }

  Color? get floatingTextColor {
    return isFocused ? primary : secondaryColor;
  }

  TextStyle? _floatingTextStyle;

  TextStyle get floatingTextStyle {
    final x = floatingTextStyleState?.fromController(this) ??
        _floatingTextStyle ??
        const TextStyle(fontSize: 12, fontWeight: FontWeight.w500);
    if (floatingVisibility.isVisible || text.isNotEmpty) {
      return x;
    } else {
      return x.copyWith(color: Colors.transparent);
    }
  }

  set floatingTextStyle(TextStyle? value) => _floatingTextStyle = value;

  void setFloatingTextStyle(TextStyle value) {
    onNotifyWithCallback(() => floatingTextStyle = value);
  }

  ValueState<TextStyle>? floatingTextStyleState;

  void setFloatingTextStyleState(ValueState<TextStyle>? value) {
    onNotifyWithCallback(() => floatingTextStyleState = value);
  }

  EdgeInsets floatingTextSpace = EdgeInsets.zero;

  void setFloatingTextSpace(EdgeInsets value) {
    onNotifyWithCallback(() => floatingTextSpace = value);
  }

  FloatingVisibility floatingVisibility = FloatingVisibility.hide;

  void setFloatingVisibility(FloatingVisibility value) {
    onNotifyWithCallback(() => floatingVisibility = value);
  }

  bool get floatingVisible => !floatingVisibility.isInvisible;

  /// FOOTER PROPERTIES

  MainAxisAlignment get footerAlignment {
    if (floatingAlignment == Alignment.center) {
      return MainAxisAlignment.center;
    } else {
      if (_floatingAlignment == Alignment.centerRight) {
        return MainAxisAlignment.end;
      }
      if (_floatingAlignment == Alignment.centerLeft) {
        return MainAxisAlignment.start;
      }
      return MainAxisAlignment.spaceBetween;
    }
  }

  bool get footerVisible => helperTextVisible || counterVisible;

  Color? get footerTextColor => footerTextStyle?.color;

  TextStyle? get footerTextStyle {
    if (hasError) {
      return errorTextStyle;
    } else {
      return helperTextStyle;
    }
  }

  void _initFloatingTextProperties(EditText view) {
    floatingAlignment = view.floatingAlignment;
    floatingText = view.floatingText;
    floatingTextStyle = view.floatingTextStyle;
    floatingTextStyleState = view.floatingTextStyleState;
    floatingTextSpace = view.floatingTextSpace;
    floatingVisibility = view.floatingVisibility;
  }

  /// HELPER TEXT PROPERTIES
  String helperText = "";

  void setHelperText(String value) {
    onNotifyWithCallback(() => helperText = value);
  }

  Color? _helperTextColor;

  Color? get helperTextColor {
    return helperTextColorState?.fromController(this) ??
        _helperTextColor ??
        secondaryColor;
  }

  set helperTextColor(Color? value) => _helperTextColor = value;

  void setHelperTextColor(Color? value) {
    onNotifyWithCallback(() => helperTextColor = value);
  }

  ValueState<Color>? helperTextColorState;

  void setHelperTextColorState(ValueState<Color>? value) {
    onNotifyWithCallback(() => helperTextColorState = value);
  }

  TextStyle? _helperTextStyle;

  TextStyle? get helperTextStyle {
    return (helperTextStyleState?.fromController(this) ?? _helperTextStyle)
        ?.copyWith(color: helperTextColor);
  }

  set helperTextStyle(TextStyle? value) => _helperTextStyle = value;

  void setHelperTextStyle(TextStyle value) {
    onNotifyWithCallback(() => helperTextStyle = value);
  }

  ValueState<TextStyle>? helperTextStyleState;

  void setHelperTextStyleState(ValueState<TextStyle>? value) {
    onNotifyWithCallback(() => helperTextStyleState = value);
  }

  bool get helperTextVisible => hasError || helperText.isNotEmpty;

  void _initHelperTextProperties(EditText view) {
    helperText = view.helperText;
    helperTextColor = view.helperTextColor;
    helperTextColorState = view.helperTextColorState;
    helperTextStyle = view.helperTextStyle;
    helperTextStyleState = view.helperTextStyleState;
  }

  /// HINT TEXT PROPERTIES
  String hintText = "";

  void setHintText(String value) {
    onNotifyWithCallback(() => hintText = value);
  }

  Color? hintTextColor;

  void setHintTextColor(Color? value) {
    onNotifyWithCallback(() => hintTextColor = value);
  }

  TextStyle? _hintStyle;

  set hintStyle(TextStyle? value) => _hintStyle = value;

  TextStyle? get hintStyle {
    return _hintStyle?.copyWith(
          color: textColor,
          fontSize: textSize,
          fontWeight: textFontWeight,
          decoration: textDecoration,
          decorationColor: textDecorationColor,
          decorationStyle: textDecorationStyle,
          decorationThickness: textDecorationThickness,
          fontFamily: textFontFamily,
          fontStyle: textFontStyle,
          leadingDistribution: textLeadingDistribution,
          letterSpacing: letterSpacing,
          wordSpacing: wordSpacing,
        ) ??
        textStyle;
  }

  void _initHintTextProperties(EditText view) {
    hintText = view.hint;
    hintTextColor = view.hintColor;
  }

  /// INDICATOR PROPERTIES
  Widget? indicator;

  void setIndicator(Widget? value) {
    onNotifyWithCallback(() => indicator = value);
  }

  double indicatorSize = 24;

  void setIndicatorSize(double value) {
    onNotifyWithCallback(() => indicatorSize = value);
  }

  double indicatorStroke = 2;

  void setIndicatorStroke(double value) {
    onNotifyWithCallback(() => indicatorStroke = value);
  }

  Color? _indicatorStrokeColor;

  set indicatorStrokeColor(Color? value) => _indicatorStrokeColor = value;

  void setIndicatorStrokeColor(Color? value) {
    onNotifyWithCallback(() => indicatorStrokeColor = value);
  }

  ValueState<Color>? indicatorStrokeColorState;

  void setIndicatorStrokeColorState(ValueState<Color>? value) {
    onNotifyWithCallback(() => indicatorStrokeColorState = value);
  }

  Color? _indicatorStrokeBackground;

  set indicatorStrokeBackground(Color? value) {
    _indicatorStrokeBackground = value;
  }

  void setIndicatorStrokeBackground(Color? value) {
    onNotifyWithCallback(() => indicatorStrokeBackground = value);
  }

  ValueState<Color>? indicatorStrokeBackgroundState;

  void setIndicatorStrokeBackgroundState(ValueState<Color>? value) {
    onNotifyWithCallback(() => indicatorStrokeBackgroundState = value);
  }

  void setIndicatorVisibility(bool visible) {
    onNotifyWithCallback(() => indicatorVisible = visible);
  }

  void _initIndicatorProperties(EditText view) {
    indicator = view.indicator;
    indicatorSize = view.indicatorSize;
    indicatorStroke = view.indicatorStroke;
    indicatorStrokeColor = view.indicatorStrokeColor;
    indicatorStrokeColorState = view.indicatorStrokeColorState;
    indicatorStrokeBackground = view.indicatorStrokeBackground;
    indicatorStrokeBackgroundState = view.indicatorStrokeBackgroundState;
    indicatorVisible = view.indicatorVisible;
  }

  /// TEXT FIELD PROPERTIES
  bool autocorrect = true;

  void setAutocorrect(bool value) {
    onNotifyWithCallback(() => autocorrect = value);
  }

  List<String> autofillHints = const [];

  void setAutofillHints(List<String> value) {
    onNotifyWithCallback(() => autofillHints = value);
  }

  bool autoFocus = false;

  void setAutoFocus(bool value) {
    onNotifyWithCallback(() => autoFocus = value);
  }

  Clip clipBehaviorText = Clip.hardEdge;

  void setClipBehaviorText(Clip value) {
    onNotifyWithCallback(() => clipBehaviorText = value);
  }

  Color? cursorColor;

  void setCursorColor(Color? value) {
    onNotifyWithCallback(() => cursorColor = value);
  }

  double? cursorHeight;

  void setCursorHeight(double? value) {
    onNotifyWithCallback(() => cursorHeight = value);
  }

  bool cursorOpacityAnimates = false;

  void setCursorOpacityAnimates(bool value) {
    onNotifyWithCallback(() => cursorOpacityAnimates = value);
  }

  Radius? cursorRadius;

  void setCursorRadius(Radius? value) {
    onNotifyWithCallback(() => cursorRadius = value);
  }

  double cursorWidth = 2.0;

  void setCursorWidth(double value) {
    onNotifyWithCallback(() => cursorWidth = value);
  }

  ContentInsertionConfiguration? contentInsertionConfiguration;

  void setContentInsertionConfiguration(ContentInsertionConfiguration? value) {
    onNotifyWithCallback(() => contentInsertionConfiguration = value);
  }

  EditTextContextMenuBuilder? contextMenuBuilder;

  void setContextMenuBuilder(EditTextContextMenuBuilder? value) {
    onNotifyWithCallback(() => contextMenuBuilder = value);
  }

  DragStartBehavior dragStartBehavior = DragStartBehavior.start;

  void setDragStartBehavior(DragStartBehavior value) {
    onNotifyWithCallback(() => dragStartBehavior = value);
  }

  bool enableIMEPersonalizedLearning = true;

  void setEnableIMEPersonalizedLearning(bool value) {
    onNotifyWithCallback(() => enableIMEPersonalizedLearning = value);
  }

  bool? enableInteractiveSelection;

  void setEnableInteractiveSelection(bool? value) {
    onNotifyWithCallback(() => enableInteractiveSelection = value);
  }

  bool enableSuggestions = true;

  void setEnableSuggestions(bool value) {
    onNotifyWithCallback(() => enableSuggestions = value);
  }

  bool expands = false;

  void setExpands(bool value) {
    onNotifyWithCallback(() => expands = value);
  }

  Brightness keyboardAppearance = Brightness.light;

  void setKeyboardAppearance(Brightness value) {
    onNotifyWithCallback(() => keyboardAppearance = value);
  }

  List<TextInputFormatter>? inputFormatters;

  void setInputFormatters(List<TextInputFormatter>? value) {
    onNotifyWithCallback(() => inputFormatters = value);
  }

  TextInputType? inputType;

  void setInputType(TextInputType? value) {
    onNotifyWithCallback(() => inputType = value);
  }

  TextMagnifierConfiguration magnifierConfiguration =
      TextMagnifierConfiguration.disabled;

  void setMagnifierConfiguration(TextMagnifierConfiguration value) {
    onNotifyWithCallback(() => magnifierConfiguration = value);
  }

  int? minLines;

  void setMinLines(int? value) {
    onNotifyWithCallback(() => minLines = value);
  }

  MouseCursor? mouseCursor;

  void setMouseCursor(MouseCursor? value) {
    onNotifyWithCallback(() => mouseCursor = value);
  }

  bool? _obscureText;

  set obscureText(bool? value) => _obscureText = value;

  void setObscureText(bool? value) {
    onNotifyWithCallback(() => obscureText = value);
  }

  String obscuringCharacter = '•';

  void setObscuringCharacter(String value) {
    onNotifyWithCallback(() => obscuringCharacter = value);
  }

  bool readOnly = false;

  void setReadOnly(bool value) {
    onNotifyWithCallback(() => readOnly = value);
  }

  String? restorationId;

  void setRestorationId(String? value) {
    onNotifyWithCallback(() => restorationId = value);
  }

  bool scribbleEnabled = true;

  void setScribbleEnabled(bool value) {
    onNotifyWithCallback(() => scribbleEnabled = value);
  }

  ScrollController? scrollControllerText;

  void setScrollControllerText(ScrollController? value) {
    onNotifyWithCallback(() => scrollControllerText = value);
  }

  EdgeInsets textScrollPadding = const EdgeInsets.all(20);

  void setTextScrollPadding(EdgeInsets value) {
    onNotifyWithCallback(() => textScrollPadding = value);
  }

  ScrollPhysics? textScrollPhysics;

  void setTextScrollPhysics(ScrollPhysics? value) {
    onNotifyWithCallback(() => textScrollPhysics = value);
  }

  Color? secondaryColor;

  void setSecondaryColor(Color? value) {
    onNotifyWithCallback(() => secondaryColor = value);
  }

  TextSelectionControls? selectionControls;

  void setSelectionControls(TextSelectionControls? value) {
    onNotifyWithCallback(() => selectionControls = value);
  }

  BoxHeightStyle selectionHeightStyle = BoxHeightStyle.tight;

  void setSelectionHeightStyle(BoxHeightStyle value) {
    onNotifyWithCallback(() => selectionHeightStyle = value);
  }

  BoxWidthStyle selectionWidthStyle = BoxWidthStyle.tight;

  void setSelectionWidthStyle(BoxWidthStyle value) {
    onNotifyWithCallback(() => selectionWidthStyle = value);
  }

  bool? showCursor;

  void setShowCursor(bool? value) {
    onNotifyWithCallback(() => showCursor = value);
  }

  SmartDashesType? smartDashesType;

  void setSmartDashesType(SmartDashesType? value) {
    onNotifyWithCallback(() => smartDashesType = value);
  }

  SmartQuotesType? smartQuotesType;

  void setSmartQuotesType(SmartQuotesType? value) {
    onNotifyWithCallback(() => smartQuotesType = value);
  }

  SpellCheckConfiguration? spellCheckConfiguration;

  void setSpellCheckConfiguration(SpellCheckConfiguration? value) {
    onNotifyWithCallback(() => spellCheckConfiguration = value);
  }

  TextCapitalization textCapitalization = TextCapitalization.none;

  void setTextCapitalization(TextCapitalization value) {
    onNotifyWithCallback(() => textCapitalization = value);
  }

  TextInputAction? textInputAction;

  void setTextInputAction(TextInputAction? value) {
    onNotifyWithCallback(() => textInputAction = value);
  }

  UndoHistoryController? undoController;

  void setUndoController(UndoHistoryController? value) {
    onNotifyWithCallback(() => undoController = value);
  }

  EditTextPrivateCommandListener? _onAppPrivateCommand;

  set onAppPrivateCommand(EditTextPrivateCommandListener? listener) =>
      _onAppPrivateCommand = listener;

  void setOnEditTextPrivateCommandListener(
          EditTextPrivateCommandListener listener) =>
      onAppPrivateCommand = listener;

  EditTextVoidListener? _onEditingComplete;

  set onEditingComplete(EditTextVoidListener? listener) =>
      _onEditingComplete = listener;

  void setOnEditTextVoidListener(EditTextVoidListener listener) =>
      onEditingComplete = listener;

  EditTextSubmitListener? _onSubmitted;

  set onSubmitted(EditTextSubmitListener? listener) => _onSubmitted = listener;

  void setOnEditTextSubmitListener(EditTextSubmitListener listener) =>
      onSubmitted = listener;

  EditTextTapOutsideListener? _onTapOutside;

  set onTapOutside(EditTextTapOutsideListener? listener) =>
      _onTapOutside = listener;

  void setOnEditTextTapOutsideListener(EditTextTapOutsideListener listener) =>
      onTapOutside = listener;

  void _initTextFieldProperties(EditText view) {
    autocorrect = view.autocorrect;
    autofillHints = view.autofillHints;
    autoFocus = view.autoFocus;
    clipBehaviorText = view.clipBehaviorText;
    cursorColor = view.cursorColor;
    cursorHeight = view.cursorHeight;
    cursorOpacityAnimates = view.cursorOpacityAnimates;
    cursorRadius = view.cursorRadius;
    cursorWidth = view.cursorWidth;
    contentInsertionConfiguration = view.contentInsertionConfiguration;
    contextMenuBuilder = view.contextMenuBuilder;
    dragStartBehavior = view.dragStartBehavior;
    enableIMEPersonalizedLearning = view.enableIMEPersonalizedLearning;
    enableInteractiveSelection = view.enableInteractiveSelection;
    enableSuggestions = view.enableSuggestions;
    expands = view.expands;
    keyboardAppearance = view.keyboardAppearance;
    inputFormatters = view.inputFormatters;
    inputType = view.inputType;
    magnifierConfiguration = view.magnifierConfiguration;
    minLines = view.minLines;
    mouseCursor = view.mouseCursor;
    obscureText = view.obscureText;
    obscuringCharacter = view.obscuringCharacter;
    readOnly = view.readOnly;
    restorationId = view.restorationId;
    scribbleEnabled = view.scribbleEnabled;
    scrollControllerText = view.scrollControllerText;
    textScrollPadding = view.scrollPaddingText;
    textScrollPhysics = view.scrollPhysicsText;
    secondaryColor = view.secondaryColor;
    selectionControls = view.selectionControls;
    selectionHeightStyle = view.selectionHeightStyle;
    selectionWidthStyle = view.selectionWidthStyle;
    showCursor = view.showCursor;
    smartDashesType = view.smartDashesType;
    smartQuotesType = view.smartQuotesType;
    spellCheckConfiguration = view.spellCheckConfiguration;
    textCapitalization = view.textCapitalization;
    textInputAction = view.inputAction;
    undoController = view.undoController;
    // LISTENERS
    onAppPrivateCommand = view.onAppPrivateCommand;
    onEditingComplete = view.onEditingComplete;
    onSubmitted = view.onSubmitted;
    onTapOutside = view.onTapOutside;
  }

  /// UNDERLINE PROPERTIES
  Color? _underlineColor;

  Color? get underlineColor {
    return underlineColorState?.fromController(this) ??
        _underlineColor ??
        ValueState(
          primary: const Color(0xffe1e1e1),
          secondary: primary,
          error: const Color(0xFFFF7769),
        ).fromController(this);
  }

  set underlineColor(Color? value) => _underlineColor = value;

  void setUnderlineColor(Color? value) {
    onNotifyWithCallback(() => underlineColor = value);
  }

  ValueState<Color>? underlineColorState;

  void setUnderlineColorState(ValueState<Color>? value) {
    onNotifyWithCallback(() => underlineColorState = value);
  }

  double? _underlineHeight;

  double get underlineHeight {
    return underlineHeightState?.fromController(this) ?? _underlineHeight ?? 1;
  }

  set underlineHeight(double? value) => _underlineHeight = value;

  void setUnderlineHeight(double? value) {
    onNotifyWithCallback(() => underlineHeight = value);
  }

  ValueState<double>? underlineHeightState;

  void setUnderlineHeightState(ValueState<double>? value) {
    onNotifyWithCallback(() => underlineHeightState = value);
  }

  bool get underlineVisible {
    return background == null ||
        background == Colors.transparent && borderAll <= 0;
  }

  void _initUnderlineProperties(EditText view) {
    underlineColor = view.underlineColor;
    underlineColorState = view.underlineColorState;
    underlineHeight = view.underlineHeight;
    underlineHeightState = view.underlineHeightState;
  }

  EditTextController fromEditText(EditText view) {
    super.fromTextView(view);
    _initBaseProperties(view);
    _initCounterProperties(view);
    _initDrawableEndProperties(view);
    _initDrawableStartProperties(view);
    _initFloatingTextProperties(view);
    _initErrorTextProperties(view);
    _initHelperTextProperties(view);
    _initHintTextProperties(view);
    _initIndicatorProperties(view);
    _initTextFieldProperties(view);
    _initUnderlineProperties(view);
    return this;
  }

  dynamic get drawableEnd {
    if (drawableEndAsEye) {
      return drawableEndState?.detect(obscureText);
    }
    var value = drawableEndState?.fromController(this);
    return value ?? _drawableEnd;
  }

  double get drawableEndSize {
    var value = drawableEndSizeState?.fromController(this);
    return value ?? _drawableEndSize;
  }

  double? get drawableEndPadding {
    var value = drawableEndPaddingState?.fromController(this);
    return value ?? _drawableEndPadding;
  }

  EdgeInsets get drawableEndSpace {
    final isRTL = textDirection == TextDirection.rtl;
    final space = drawableEndPadding ?? 12;
    return EdgeInsets.only(
      left: !isRTL ? space : 0,
      right: isRTL ? space : 0,
    );
  }

  Color? get drawableEndTint {
    var value = drawableEndTintState?.fromController(this);
    return value ?? _drawableEndTint;
  }

  /// DRAWABLE START PROPERTIES
  dynamic get drawableStart {
    var value = drawableStartState?.fromController(this);
    return value ?? _drawableStart;
  }

  double get drawableStartSize {
    var value = drawableStartSizeState?.fromController(this);
    return value ?? _drawableStartSize;
  }

  double? get drawableStartPadding {
    var value = drawableStartPaddingState?.fromController(this);
    return value ?? _drawableStartPadding;
  }

  EdgeInsets get drawableStartSpace {
    final isRTL = textDirection == TextDirection.rtl;
    final space = drawableStartPadding ?? 12;
    return EdgeInsets.only(
      left: isRTL ? space : 0,
      right: !isRTL ? space : 0,
    );
  }

  Color? get drawableStartTint {
    var value = drawableStartTintState?.fromController(this);
    return value ?? _drawableStartTint;
  }

  String? get errorText => errorTextState?.fromController(this) ?? _errorText;

  bool get hasError => (errorText ?? "").isNotEmpty;

  Color? get indicatorStrokeColor {
    var value = indicatorStrokeColorState?.fromController(this);
    return value ?? _indicatorStrokeColor;
  }

  Color? get indicatorStrokeBackground {
    var value = indicatorStrokeBackgroundState?.fromController(this);
    return value ?? _indicatorStrokeBackground;
  }

  bool get obscureText {
    return _obscureText ?? (inputType == TextInputType.visiblePassword);
  }

  /// CALLBACK & LISTENERS

  EditTextPrivateCommandListener? get onAppPrivateCommand =>
      enabled ? _onAppPrivateCommand : null;

  EditTextVoidListener? get onEditingComplete =>
      enabled ? _onEditingComplete : null;

  EditTextSubmitListener? get onSubmitted => enabled ? _onSubmitted : null;

  EditTextTapOutsideListener? get onTapOutside =>
      enabled ? _onTapOutside : null;

  /// CUSTOMIZATIONS
  bool _initial = true;

  bool get isInitial => _initial;

  bool get isFocused => enabled && focused;

  bool get isReadMode => !enabled && readOnly;

  bool get isUnderlineHide => background != null || borderAll > 0;

  bool get isValid {
    if (onValidator != null) {
      return onValidator!(_editor.text);
    } else {
      return true;
    }
  }

  bool get isChecked {
    if (onActivator != null) {
      return valid;
    } else {
      return true;
    }
  }

  dynamic get iEnd => drawableEnd?.drawable(isFocused);

  dynamic get iStart => drawableStart?.drawable(isFocused);

  String get counter {
    var currentLength = text.length;
    final maxLength = maxCharacters;
    return maxLength > 0
        ? '$currentLength / $maxLength'
        : currentLength > 0
            ? "$currentLength"
            : "";
  }

  List<TextInputFormatter>? get _formatter {
    return [
      ...?inputFormatters,
      if (characters.isNotEmpty)
        FilteringTextInputFormatter.allow(RegExp("[$characters]")),
      if (ignorableCharacters.isNotEmpty)
        FilteringTextInputFormatter.deny(RegExp("[$ignorableCharacters]")),
      if (maxCharactersAsLimit && maxCharacters > 0)
        LengthLimitingTextInputFormatter(maxCharacters),
    ];
  }

  ViewError errorType(String text, [bool? valid]) {
    if (text.isEmpty && !_initial) {
      return ViewError.empty;
    } else if (!(valid ?? isValid)) {
      final length = text.length;
      if (maxCharacters > 0 && maxCharacters < length) {
        return ViewError.maximum;
      } else if ((minCharacters ?? 0) > 0 && (minCharacters ?? 0) > length) {
        return ViewError.minimum;
      } else {
        return ViewError.invalid;
      }
    } else {
      return ViewError.none;
    }
  }

  void _handleFocusChange() {
    if (_node.hasFocus != focused) {
      focused = _node.hasFocus;
      if (onFocusChanged(focused)) {
        onNotify();
      }
    }
  }

  void onChangeEye(bool value) {
    if (drawableEndAsEye) {
      onNotifyWithCallback(() => obscureText = !obscureText);
    }
  }

  bool onFocusChanged(bool focused) {
    return true;
  }

  bool _running = false;

  void _handleEditingChange(String value) {
    onNotifyWithCallback(() {
      _initial = false;
      valid = false;
      error = false;
      errorText = "";
      if (onChange != null) onChange!(value);
      if (onValid != null || onError != null || onActivator != null) {
        valid = isValid;
        if (valid && onActivator != null && !_initial) {
          _running = indicatorVisible;
          indicatorVisible = true;
          valid = false;
          error = false;
          onActivator!.call(_running, value).then((activate) {
            onNotifyWithCallback(() {
              indicatorVisible = false;
              valid = isValid;
              if (valid) {
                final x = valid;
                valid = activate && x;
                error = !activate && text.isNotEmpty && x;
                if (onValid != null) onValid!(valid);
                if (onError != null) {
                  if (error) {
                    errorText = onError!(ViewError.alreadyFound) ?? "";
                  } else {
                    errorText = onError!(errorType(value, valid)) ?? "";
                  }
                }
              }
            });
          });
        } else {
          indicatorVisible = false;
          valid = valid && isChecked;
          error = !valid && text.isNotEmpty;
          if (onValid != null) onValid!(valid);
          if (onError != null) {
            errorText = onError!(errorType(value, valid)) ?? "";
          }
        }
      }
    });
  }

  void showKeyboard(BuildContext context) async {
    FocusScope.of(context).requestFocus(_node);
  }

  void hideKeyboard(BuildContext context) => FocusScope.of(context).unfocus();

  void _dispose() {
    if (autoDisposeMode) dispose();
  }

  void dispose() {
    removeFocusListener();
    _editor.dispose();
    _node.dispose();
  }
}
