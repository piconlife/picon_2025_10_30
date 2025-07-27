part of 'view.dart';

class TextViewController extends ViewController {
  int maxCharacters = 0;

  void setMaxCharacters(int value) {
    onNotifyWithCallback(() => maxCharacters = value);
  }

  int? maxLines;

  void setMaxLines(int? value) {
    onNotifyWithCallback(() => maxLines = value);
  }

  Color? selectionColor;

  void setSelectionColor(Color? value) {
    onNotifyWithCallback(() => selectionColor = value);
  }

  String? semanticsLabel;

  void setSemanticsLabel(String? value) {
    onNotifyWithCallback(() => semanticsLabel = value);
  }

  bool? softWrap;

  void setSoftWrap(bool? value) {
    onNotifyWithCallback(() => softWrap = value);
  }

  StrutStyle? strutStyle;

  void setStrutStyle(StrutStyle? value) {
    onNotifyWithCallback(() => strutStyle = value);
  }

  double? letterSpacing;

  void setLetterSpacing(double? value) {
    onNotifyWithCallback(() => letterSpacing = value);
  }

  double lineSpacingExtra = 0;

  void setLineSpacingExtra(double value) {
    onNotifyWithCallback(() => lineSpacingExtra = value);
  }

  Locale? locale;

  void setLocale(Locale? value) {
    onNotifyWithCallback(() => locale = value);
  }

  double? wordSpacing;

  void setWordSpacing(double? value) {
    onNotifyWithCallback(() => wordSpacing = value);
  }

  String? ellipsis;

  void setEllipsis(String? value) {
    onNotifyWithCallback(() => ellipsis = value);
  }

  String? _text;

  set text(String? value) => _text = value;

  void setText(String? value) {
    onNotifyWithCallback(() => text = value);
  }

  String? textExtras;

  void setTextExtras(String? value) {
    onNotifyWithCallback(() => textExtras = value);
  }

  ValueState<String>? textState;

  void setTextState(ValueState<String>? value) {
    onNotifyWithCallback(() => textState = value);
  }

  TextAlign? textAlign;

  void setTextAlign(TextAlign? value) {
    onNotifyWithCallback(() => textAlign = value);
  }

  bool textAllCaps = false;

  void setTextAllCaps(bool value) {
    onNotifyWithCallback(() => textAllCaps = value);
  }

  Color? _textColor;

  set textColor(Color? value) => _textColor = value;

  void setTextColor(Color? value) {
    onNotifyWithCallback(() => textColor = value);
  }

  ValueState<Color>? textColorState;

  void setTextColorState(ValueState<Color>? value) {
    onNotifyWithCallback(() => textColorState = value);
  }

  TextDecoration? textDecoration;

  void setTextDecoration(TextDecoration? value) {
    onNotifyWithCallback(() => textDecoration = value);
  }

  Color? textDecorationColor;

  void setTextDecorationColor(Color? value) {
    onNotifyWithCallback(() => textDecorationColor = value);
  }

  TextDecorationStyle? textDecorationStyle;

  void setTextDecorationStyle(TextDecorationStyle? value) {
    onNotifyWithCallback(() => textDecorationStyle = value);
  }

  double? textDecorationThickness;

  void setTextDecorationThickness(double? value) {
    onNotifyWithCallback(() => textDecorationThickness = value);
  }

  TextDirection? textDirection;

  void setTextDirection(TextDirection? value) {
    onNotifyWithCallback(() => textDirection = value);
  }

  String? textFontFamily;

  void setTextFontFamily(String? value) {
    onNotifyWithCallback(() => textFontFamily = value);
  }

  FontStyle? textFontStyle;

  void setTextFontStyle(FontStyle? value) {
    onNotifyWithCallback(() => textFontStyle = value);
  }

  FontWeight? _textFontWeight;

  set textFontWeight(FontWeight? value) => _textFontWeight = value;

  void setTextFontWeight(FontWeight? value) {
    onNotifyWithCallback(() => textFontWeight = value);
  }

  ValueState<FontWeight>? textFontWeightState;

  void setTextFontWeightState(ValueState<FontWeight>? value) {
    onNotifyWithCallback(() => textFontWeightState = value);
  }

  TextHeightBehavior? textHeightBehavior;

  void setTextHeightBehavior(TextHeightBehavior? value) {
    onNotifyWithCallback(() => textHeightBehavior = value);
  }

  TextLeadingDistribution? textLeadingDistribution;

  void setTextLeadingDistribution(TextLeadingDistribution? value) {
    onNotifyWithCallback(() => textLeadingDistribution = value);
  }

  TextOverflow? textOverflow;

  void setTextOverflow(TextOverflow? value) {
    onNotifyWithCallback(() => textOverflow = value);
  }

  double? _textSize;

  set textSize(double? value) => _textSize = value;

  void setTextSize(double? value) {
    onNotifyWithCallback(() => textSize = value);
  }

  ValueState<double>? textSizeState;

  void setTextSizeState(ValueState<double>? value) {
    onNotifyWithCallback(() => textSizeState = value);
  }

  List<TextSpan> textSpans = [];

  void setTextSpans(List<TextSpan> value) {
    onNotifyWithCallback(() => textSpans = value);
  }

  TextStyle? _textStyle;

  set textStyle(TextStyle? value) => _textStyle = value;

  void setTextStyle(TextStyle? value) {
    onNotifyWithCallback(() => textStyle = value);
  }

  ValueState<TextStyle>? textStyleState;

  void setTextStyleState(ValueState<TextStyle>? value) {
    onNotifyWithCallback(() => textStyleState = value);
  }

  TextWidthBasis textWidthBasis = TextWidthBasis.parent;

  void setTextWidthBasis(TextWidthBasis value) {
    onNotifyWithCallback(() => textWidthBasis = value);
  }

  OnViewClickListener? _onTextClick;

  set onTextClick(OnViewClickListener? value) => _onTextClick ??= value;

  OnViewClickListener? get onTextClick => enabled ? _onTextClick : null;

  void setOnTextClickListener(OnViewClickListener? listener) {
    _onTextClick = listener;
  }

  /// PREFIX TEXT PROPERTIES
  FontStyle? prefixFontStyle;

  void setPrefixFontStyle(FontStyle? value) {
    onNotifyWithCallback(() => prefixFontStyle = value);
  }

  FontWeight? _prefixFontWeight;

  set prefixFontWeight(FontWeight? value) => _prefixFontWeight = value;

  void setPrefixFontWeight(FontWeight? value) {
    onNotifyWithCallback(() => prefixFontWeight = value);
  }

  ValueState<FontWeight>? prefixFontWeightState;

  void setPrefixFontWeightState(ValueState<FontWeight>? value) {
    onNotifyWithCallback(() => prefixFontWeightState = value);
  }

  String? _prefixText;

  set prefixText(String? value) => _prefixText = value;

  void setPrefixText(String? value) {
    onNotifyWithCallback(() => prefixText = value);
  }

  ValueState<String>? prefixTextState;

  void setPrefixTextState(ValueState<String>? value) {
    onNotifyWithCallback(() => prefixTextState = value);
  }

  bool prefixTextAllCaps = false;

  void setPrefixTextAllCaps(bool value) {
    onNotifyWithCallback(() => prefixTextAllCaps = value);
  }

  Color? _prefixTextColor;

  set prefixTextColor(Color? value) => _prefixTextColor = value;

  void setPrefixTextColor(Color? value) {
    onNotifyWithCallback(() => prefixTextColor = value);
  }

  ValueState<Color>? prefixTextColorState;

  void setPrefixTextColorState(ValueState<Color>? value) {
    onNotifyWithCallback(() => prefixTextColorState = value);
  }

  TextDecoration? prefixTextDecoration;

  void setPrefixTextDecoration(TextDecoration? value) {
    onNotifyWithCallback(() => prefixTextDecoration = value);
  }

  Color? prefixTextDecorationColor;

  void setPrefixTextDecorationColor(Color? value) {
    onNotifyWithCallback(() => prefixTextDecorationColor = value);
  }

  TextDecorationStyle? prefixTextDecorationStyle;

  void setPrefixTextDecorationStyle(TextDecorationStyle? value) {
    onNotifyWithCallback(() => prefixTextDecorationStyle = value);
  }

  double? prefixTextDecorationThickness;

  void setPrefixTextDecorationThickness(double? value) {
    onNotifyWithCallback(() => prefixTextDecorationThickness = value);
  }

  double? prefixTextLetterSpace;

  void setPrefixTextLetterSpace(double? value) {
    onNotifyWithCallback(() => prefixTextLetterSpace = value);
  }

  double? _prefixTextSize;

  set prefixTextSize(double? value) => _prefixTextSize = value;

  void setPrefixTextSize(double? value) {
    onNotifyWithCallback(() => prefixTextSize = value);
  }

  ValueState<double>? prefixTextSizeState;

  void setPrefixTextSizeState(ValueState<double>? value) {
    onNotifyWithCallback(() => prefixTextSizeState = value);
  }

  TextStyle? _prefixTextStyle;

  set prefixTextStyle(TextStyle? value) => _prefixTextStyle = value;

  void setPrefixTextStyle(TextStyle? value) {
    onNotifyWithCallback(() => prefixTextStyle = value);
  }

  ValueState<TextStyle>? prefixTextStyleState;

  void setPrefixTextStyleState(ValueState<TextStyle>? value) {
    onNotifyWithCallback(() => prefixTextStyleState = value);
  }

  bool prefixTextVisible = true;

  void setPrefixTextVisible(bool value) {
    onNotifyWithCallback(() => prefixTextVisible = value);
  }

  OnViewClickListener? _onPrefixClick;

  set onPrefixClick(OnViewClickListener? value) => _onPrefixClick ??= value;

  OnViewClickListener? get onPrefixClick => enabled ? _onPrefixClick : null;

  void setOnPrefixClickListener(OnViewClickListener? listener) {
    _onPrefixClick = listener;
  }

  /// SUFFIX TEXT PROPERTIES
  FontStyle? suffixFontStyle;

  void setSuffixFontStyle(FontStyle? value) {
    onNotifyWithCallback(() => suffixFontStyle = value);
  }

  FontWeight? _suffixFontWeight;

  set suffixFontWeight(FontWeight? value) => _suffixFontWeight = value;

  void setSuffixFontWeight(FontWeight? value) {
    onNotifyWithCallback(() => suffixFontWeight = value);
  }

  ValueState<FontWeight>? suffixFontWeightState;

  void setSuffixFontWeightState(ValueState<FontWeight>? value) {
    onNotifyWithCallback(() => suffixFontWeightState = value);
  }

  String? _suffixText;

  set suffixText(String? value) => _suffixText = value;

  void setSuffixText(String? value) {
    onNotifyWithCallback(() => suffixText = value);
  }

  ValueState<String>? suffixTextState;

  void setSuffixTextState(ValueState<String>? value) {
    onNotifyWithCallback(() => suffixTextState = value);
  }

  bool suffixTextAllCaps = false;

  void setSuffixTextAllCaps(bool value) {
    onNotifyWithCallback(() => suffixTextAllCaps = value);
  }

  Color? _suffixTextColor;

  set suffixTextColor(Color? value) => _suffixTextColor = value;

  void setSuffixTextColor(Color? value) {
    onNotifyWithCallback(() => suffixTextColor = value);
  }

  ValueState<Color>? suffixTextColorState;

  void setSuffixTextColorState(ValueState<Color>? value) {
    onNotifyWithCallback(() => suffixTextColorState = value);
  }

  TextDecoration? suffixTextDecoration;

  void setSuffixTextDecoration(TextDecoration? value) {
    onNotifyWithCallback(() => suffixTextDecoration = value);
  }

  Color? suffixTextDecorationColor;

  void setSuffixTextDecorationColor(Color? value) {
    onNotifyWithCallback(() => suffixTextDecorationColor = value);
  }

  TextDecorationStyle? suffixTextDecorationStyle;

  void setSuffixTextDecorationStyle(TextDecorationStyle? value) {
    onNotifyWithCallback(() => suffixTextDecorationStyle = value);
  }

  double? suffixTextDecorationThickness;

  void setSuffixTextDecorationThickness(double? value) {
    onNotifyWithCallback(() => suffixTextDecorationThickness = value);
  }

  double? suffixTextLetterSpace;

  void setSuffixTextLetterSpace(double? value) {
    onNotifyWithCallback(() => suffixTextLetterSpace = value);
  }

  double? _suffixTextSize;

  set suffixTextSize(double? value) => _suffixTextSize = value;

  void setSuffixTextSize(double? value) {
    onNotifyWithCallback(() => suffixTextSize = value);
  }

  ValueState<double>? suffixTextSizeState;

  void setSuffixTextSizeState(ValueState<double>? value) {
    onNotifyWithCallback(() => suffixTextSizeState = value);
  }

  TextStyle? _suffixTextStyle;

  set suffixTextStyle(TextStyle? value) => _suffixTextStyle = value;

  void setSuffixTextStyle(TextStyle? value) {
    onNotifyWithCallback(() => suffixTextStyle = value);
  }

  ValueState<TextStyle>? suffixTextStyleState;

  void setSuffixTextStyleState(ValueState<TextStyle>? value) {
    onNotifyWithCallback(() => suffixTextStyleState = value);
  }

  bool suffixTextVisible = true;

  void setSuffixTextVisible(bool value) {
    onNotifyWithCallback(() => suffixTextVisible = value);
  }

  OnViewClickListener? _onSuffixClick;

  OnViewClickListener? get onSuffixClick => enabled ? _onSuffixClick : null;

  set onSuffixClick(OnViewClickListener? value) => _onSuffixClick ??= value;

  void setOnSuffixClickListener(OnViewClickListener? listener) {
    _onSuffixClick = listener;
  }

  TextViewController fromTextView(TextView view) {
    super.fromView(view);

    ellipsis = view.ellipsis;

    maxCharacters = view.maxCharacters;
    maxLines = view.maxLines;
    locale = view.locale;

    letterSpacing = view.letterSpacing;
    lineSpacingExtra = view.lineSpacingExtra;
    selectionColor = view.selectionColor;
    semanticsLabel = view.semanticsLabel;
    softWrap = view.softWrap;
    strutStyle = view.strutStyle;
    wordSpacing = view.wordSpacing;

    text = view.text;
    textState = view.textState;
    textAlign = view.textAlign;
    textAllCaps = view.textAllCaps;
    textColor = view.textColor;
    textColorState = view.textColorState;
    textDecoration = view.textDecoration;
    textDecorationColor = view.textDecorationColor;
    textDecorationStyle = view.textDecorationStyle;
    textDecorationThickness = view.textDecorationThickness;
    textDirection = view.textDirection;
    textFontFamily = view.textFontFamily;
    textFontStyle = view.textFontStyle;
    textFontWeight = view.textFontWeight;
    textFontWeightState = view.textFontWeightState;
    textHeightBehavior = view.textHeightBehavior;
    textLeadingDistribution = view.textLeadingDistribution;
    textOverflow = view.textOverflow;
    textSize = view.textSize;
    textSizeState = view.textSizeState;
    textSpans = view.textSpans;
    textStyle = view.textStyle;
    textStyleState = view.textStyleState;
    textWidthBasis = view.textWidthBasis;
    textExtras = textExtrasFromSpans;
    onTextClick = view.onTextClick;

    ///PREFIX
    prefixFontStyle = view.prefixFontStyle;
    prefixFontWeight = view.prefixFontWeight;
    prefixFontWeightState = view.prefixFontWeightState;
    prefixText = view.prefixText;
    prefixTextState = view.prefixTextState;
    prefixTextAllCaps = view.prefixTextAllCaps;
    prefixTextColor = view.prefixTextColor;
    prefixTextColorState = view.prefixTextColorState;
    prefixTextDecoration = view.prefixTextDecoration;
    prefixTextDecorationColor = view.prefixTextDecorationColor;
    prefixTextDecorationStyle = view.prefixTextDecorationStyle;
    prefixTextDecorationThickness = view.prefixTextDecorationThickness;
    prefixTextLetterSpace = view.prefixTextLetterSpace;
    prefixTextSize = view.prefixTextSize;
    prefixTextSizeState = view.prefixTextSizeState;
    prefixTextStyle = view.prefixTextStyle;
    prefixTextStyleState = view.prefixTextStyleState;
    prefixTextVisible = view.prefixTextVisible;
    onPrefixClick = view.onPrefixClick;

    ///SUFFIX
    suffixFontStyle = view.suffixFontStyle;
    suffixFontWeight = view.suffixFontWeight;
    suffixFontWeightState = view.suffixFontWeightState;
    suffixText = view.suffixText;
    suffixTextState = view.suffixTextState;
    suffixTextAllCaps = view.suffixTextAllCaps;
    suffixTextColor = view.suffixTextColor;
    suffixTextColorState = view.suffixTextColorState;
    suffixTextDecoration = view.suffixTextDecoration;
    suffixTextDecorationColor = view.suffixTextDecorationColor;
    suffixTextDecorationStyle = view.suffixTextDecorationStyle;
    suffixTextDecorationThickness = view.suffixTextDecorationThickness;
    suffixTextLetterSpace = view.suffixTextLetterSpace;
    suffixTextSize = view.suffixTextSize;
    suffixTextSizeState = view.suffixTextSizeState;
    suffixTextStyle = view.suffixTextStyle;
    suffixTextStyleState = view.suffixTextStyleState;
    suffixTextVisible = view.suffixTextVisible;
    onSuffixClick = view.onSuffixClick;

    return this;
  }

  double? get spacingFactor {
    final x = (textSize ?? 0) + lineSpacingExtra;
    final y = x * 0.068;
    return lineSpacingExtra > 0 ? y : null;
  }

  String get text {
    final value = textState?.fromController(this) ?? _text ?? "";
    if (maxCharacters > 0 && !activated) {
      return value.substring(
        0,
        value.length > maxCharacters ? maxCharacters : value.length,
      );
    } else {
      return textAllCaps ? value.toUpperCase() : value;
    }
  }

  String get textExtrasFromSpans {
    StringBuffer buffer = StringBuffer();
    buffer.writeAll(textSpans.map((e) => e.text ?? ""));
    return buffer.toString();
  }

  Color? get textColor => textColorState?.fromController(this) ?? _textColor;

  FontWeight? get textFontWeight {
    return textFontWeightState?.fromController(this) ?? _textFontWeight;
  }

  double? get textSize => textSizeState?.fromController(this) ?? _textSize;

  TextStyle? get textStyle {
    final raw = textStyleState?.fromController(this) ?? _textStyle;
    return raw?.copyWith(
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
    );
  }

  /// PREFIX

  String? get prefixText {
    final value = prefixTextState?.fromController(this) ?? _prefixText;
    return prefixTextAllCaps ? value?.toUpperCase() : value;
  }

  Color? get prefixTextColor =>
      prefixTextColorState?.fromController(this) ?? _prefixTextColor;

  FontWeight? get prefixFontWeight {
    return prefixFontWeightState?.fromController(this) ?? _prefixFontWeight;
  }

  double? get prefixTextSize =>
      prefixTextSizeState?.fromController(this) ?? _prefixTextSize;

  TextStyle? get prefixTextStyle =>
      prefixTextStyleState?.fromController(this) ?? _prefixTextStyle;

  bool get isAutoPrefix {
    final a = maxCharacters > 0;
    final b = text.length > maxCharacters;
    return (a && b) || prefixTextVisible;
  }

  ///SUFFIX

  String? get suffixText {
    final value = suffixTextState?.fromController(this) ?? _suffixText;
    return suffixTextAllCaps ? value?.toUpperCase() : value;
  }

  Color? get suffixTextColor =>
      suffixTextColorState?.fromController(this) ?? _suffixTextColor;

  FontWeight? get suffixFontWeight {
    return suffixFontWeightState?.fromController(this) ?? _suffixFontWeight;
  }

  double? get suffixTextSize =>
      suffixTextSizeState?.fromController(this) ?? _suffixTextSize;

  TextStyle? get suffixTextStyle =>
      suffixTextStyleState?.fromController(this) ?? _suffixTextStyle;

  bool get isAutoSuffix {
    final a = maxCharacters > 0;
    final b = text.length > maxCharacters;
    return (a && b) || suffixTextVisible;
  }
}
