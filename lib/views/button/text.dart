part of 'view.dart';

class _Text extends StatelessWidget {
  final ButtonController controller;

  const _Text({
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return RawTextView(
      text: controller.text,
      textAlign: TextAlign.center,
      textColor: controller.color,
      textSize: controller.textSize,
      textFontWeight: controller.textFontWeight,
      textStyle: controller.textStyle,
    );
  }
}
