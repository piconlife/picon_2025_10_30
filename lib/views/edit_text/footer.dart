part of 'view.dart';

class _Footer extends StatelessWidget {
  final EditTextController controller;

  const _Footer(this.controller);

  @override
  Widget build(BuildContext context) {
    final cv = controller.counterVisibility;
    final counterVisible = !cv.isInvisible;
    final hasError = controller.hasError;
    return Container(
      width: double.infinity,
      padding: controller.floatingTextSpace.copyWith(bottom: 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        textDirection: controller.textDirection,
        mainAxisAlignment: controller.footerAlignment,
        children: [
          _HighlightText(
            visible: hasError || controller.helperText.isNotEmpty,
            text: hasError ? controller.errorText : controller.helperText,
            textAlign: controller.textAlign,
            textDirection: controller.textDirection,
            textStyle: controller.footerTextStyle,
            textColor: hasError
                ? controller.errorTextColor
                : controller.helperTextColor,
            valid: hasError || controller.helperText.isNotEmpty,
          ),
          _HighlightText(
            visible: counterVisible && controller.textAlign != TextAlign.center,
            text: controller.counter,
            textAlign: TextAlign.end,
            textDirection: controller.textDirection,
            textStyle: controller.counterTextStyle,
            textColor: hasError
                ? controller.errorTextColor
                : controller.counterTextColor,
            valid: counterVisible && (controller.isFocused || cv.isVisible),
          ),
        ],
      ),
    );
  }
}
