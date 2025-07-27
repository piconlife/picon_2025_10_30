part of 'view.dart';

class _ParagraphText extends StatelessWidget {
  final ContentViewController controller;
  final Content content;
  final bool showDot;

  const _ParagraphText({
    required this.content,
    required this.controller,
    this.showDot = true,
  });

  @override
  Widget build(BuildContext context) {
    var titleStyle = controller.titleStyle;
    var paragraphStyle = controller.paragraphStyle;
    var isParagraphMode = (content.title ?? "").isEmpty;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          _DottedText(
            controller: controller,
            isParagraph: isParagraphMode,
            showDot: showDot,
            text: isParagraphMode ? content.body : content.title,
          ),
          if (!isParagraphMode)
            Container(
              padding: EdgeInsets.only(
                top: paragraphStyle.textSize / 2,
                left: showDot ? titleStyle.textSize * 1.2 : 0,
              ),
              child: Text(
                content.body ?? "",
                textAlign: paragraphStyle.textAlign,
                style: TextStyle(
                  color: paragraphStyle.textColor,
                  fontSize: paragraphStyle.textSize,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
