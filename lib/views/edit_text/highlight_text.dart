part of 'view.dart';

class _HighlightText extends StatelessWidget {
  final bool valid;
  final bool visible;
  final String? text;
  final TextAlign? textAlign;
  final TextDirection? textDirection;
  final TextStyle? textStyle;
  final Color? textColor;

  const _HighlightText({
    this.visible = true,
    required this.text,
    this.textAlign,
    this.textDirection,
    this.textStyle,
    this.textColor,
    this.valid = false,
  });

  @override
  Widget build(BuildContext context) {
    final style = textStyle ??
        TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: valid ? textColor ?? Colors.grey : Colors.transparent,
        );
    return Visibility(
      visible: visible,
      child: Text(
        text ?? "",
        textAlign: textAlign,
        textDirection: textDirection,
        style: style,
      ),
    );
  }
}
