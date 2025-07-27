part of 'view.dart';

class _LayerX2<T> extends StatelessWidget {
  final ImageLayoutController<T> controller;

  const _LayerX2({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: controller.frameRatio ?? 3 / 1.8,
      child: Flex(
        direction: Axis.horizontal,
        children: [
          _Builder(
            controller: controller,
            image: controller.items[0],
            flexible: true,
          ),
          SizedBox(
            width: controller.spaceBetween,
          ),
          _Builder(
            controller: controller,
            image: controller.items[1],
            flexible: true,
          ),
        ],
      ),
    );
  }
}
