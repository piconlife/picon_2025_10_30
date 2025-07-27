part of 'view.dart';

class _LayerX3<T> extends StatelessWidget {
  final ImageLayoutController<T> controller;

  const _LayerX3({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: controller.frameRatio ?? 3 / 2.2,
      child: Flex(
        direction: Axis.horizontal,
        children: [
          _Builder(
            controller: controller,
            image: controller.items[0],
            dimension: 0.8,
          ),
          SizedBox(
            width: controller.spaceBetween,
          ),
          Expanded(
            child: Flex(
              direction: Axis.vertical,
              children: [
                _Builder(
                  controller: controller,
                  image: controller.items[1],
                  flexible: true,
                ),
                SizedBox(
                  height: controller.spaceBetween,
                ),
                _Builder(
                  controller: controller,
                  image: controller.items[2],
                  flexible: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
