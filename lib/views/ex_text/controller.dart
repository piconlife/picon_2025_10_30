part of 'view.dart';

class ExTextViewController extends TextViewController {
  String? expendedText;

  void setExpendedText(String? value) {
    onNotifyWithCallback(() => expendedText = value);
  }

  double? expendedCharacterSpace;

  void setExpendedCharacterSpace(double? value) {
    onNotifyWithCallback(() => expendedCharacterSpace = value);
  }

  Color? expendedTextColor;

  void setExpendedTextColor(Color? value) {
    onNotifyWithCallback(() => expendedTextColor = value);
  }

  double? expendedTextSize;

  void setExpendedTextSize(double? value) {
    onNotifyWithCallback(() => expendedTextSize = value);
  }

  FontStyle? expendedTextStyle;

  void setExpendedTextStyle(FontStyle? value) {
    onNotifyWithCallback(() => expendedTextStyle = value);
  }

  bool expendedTextVisible = false;

  void setExpendedTextVisible(bool value) {
    onNotifyWithCallback(() => expendedTextVisible = value);
  }

  FontWeight? expendedTextWeight;

  void setExpendedTextWeight(FontWeight? value) {
    onNotifyWithCallback(() => expendedTextWeight = value);
  }

  ExTextViewController fromExTextView(ExTextView view) {
    super.fromTextView(view);
    expendedText = view.expendedText;
    expendedCharacterSpace = view.expendedCharacterSpace;
    expendedTextColor = view.expendedTextColor;
    expendedTextSize = view.expendedTextSize;
    expendedTextVisible = view.expendedTextVisible;
    expendedTextWeight = view.expendedTextWeight;
    return this;
  }

  @override
  int get maxCharacters => activated ? 0 : super.maxCharacters;

  @override
  int? get maxLines => null;

  @override
  String? get suffixText => activated ? expendedText : super.suffixText;

  @override
  Color? get suffixTextColor =>
      (activated
          ? expendedTextColor ?? super.suffixTextColor
          : super.suffixTextColor) ??
      textColor?.withOpacity(1 / 3);

  @override
  FontStyle? get suffixFontStyle => activated
      ? expendedTextStyle ?? super.suffixFontStyle
      : super.suffixFontStyle;

  @override
  FontWeight? get suffixFontWeight => activated
      ? expendedTextWeight ?? super.suffixFontWeight
      : super.suffixFontWeight;

  @override
  double? get suffixTextSize => activated
      ? expendedTextSize ?? super.suffixTextSize
      : super.suffixTextSize;

  @override
  double? get suffixTextLetterSpace => activated
      ? expendedCharacterSpace ?? super.suffixTextLetterSpace
      : super.suffixTextLetterSpace;

  @override
  bool get suffixTextVisible => expendedText != null && expendedTextVisible;

  @override
  TextOverflow? get textOverflow => null;

  void _config() {
    setOnClickListener((context) => onNotifyToggleWithActivator());
  }
}
