part of 'view.dart';

class _DottedText extends StatelessWidget {
  final ContentViewController controller;
  final String? text;
  final bool isParagraph;
  final bool showDot;

  const _DottedText({
    this.isParagraph = false,
    this.showDot = true,
    required this.text,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    var style = isParagraph ? controller.paragraphStyle : controller.titleStyle;
    final bulletSize = style.textSize / 2;
    final bulletPadding = (style.textSize * 0.18) + bulletSize / 2;
    return (text ?? "").isNotEmpty
        ? Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              if (showDot)
                Container(
                  alignment: Alignment.center,
                  width: bulletSize,
                  height: bulletSize,
                  margin: EdgeInsets.only(
                    right: bulletPadding * 1.5,
                    top: bulletPadding,
                  ),
                  decoration: BoxDecoration(
                    color: style.textColor,
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
              Expanded(
                child: Text(
                  text ?? "",
                  textAlign: style.textAlign,
                  style: TextStyle(
                    color: style.textColor,
                    fontSize: style.textSize,
                    fontWeight: style.fontWeight,
                  ),
                ),
              ),
            ],
          )
        : const SizedBox();
  }
}
