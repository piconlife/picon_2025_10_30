part of 'view.dart';

class _Header extends StatelessWidget {
  final EditTextController controller;

  const _Header(this.controller);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      alignment: controller.floatingAlignment,
      padding: controller.floatingTextSpace.copyWith(top: 0),
      child: _HighlightText(
        text: controller.floatingText,
        textAlign: controller.textAlign,
        textDirection: controller.textDirection,
        textStyle: controller.floatingTextStyle,
      ),
    );
  }
}
