part of 'view.dart';

class _Icon extends StatelessWidget {
  final ButtonController controller;
  final bool visible;

  const _Icon({
    required this.controller,
    this.visible = true,
  });

  @override
  Widget build(BuildContext context) {
    return IconView(
      visibility: visible,
      marginStart: !controller.isCenterText && controller.isEndIconVisible
          ? controller.iconSpace
          : null,
      marginEnd: !controller.isCenterText && controller.isStartIconVisible
          ? controller.iconSpace
          : null,
      positionType: controller.isCenterText
          ? controller.isEndIconVisible
              ? ViewPositionType.right
              : ViewPositionType.left
          : null,
      icon: controller.icon,
      tint: controller.iconTint,
      size: controller.iconSize,
    );
  }
}
