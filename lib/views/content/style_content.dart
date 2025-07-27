part of 'view.dart';

class ContentStyle {
  final FontWeight? fontWeight;
  final TextAlign? textAlign;
  final Color textColor;
  final double textSize;

  const ContentStyle({
    this.fontWeight,
    this.textAlign,
    this.textColor = Colors.black,
    this.textSize = 14,
  });

  ContentStyle copy({
    FontWeight? fontWeight,
    TextAlign? textAlign,
    Color? textColor,
    double? textSize,
  }) {
    return ContentStyle(
      fontWeight: fontWeight ?? this.fontWeight,
      textAlign: textAlign ?? this.textAlign,
      textColor: textColor ?? this.textColor,
      textSize: textSize ?? this.textSize,
    );
  }
}
