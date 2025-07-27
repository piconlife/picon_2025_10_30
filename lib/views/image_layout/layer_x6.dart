part of 'view.dart';

class _LayerX6<T> extends StatelessWidget {
  final ImageLayoutController<T> controller;

  const _LayerX6({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: controller.frameRatio ?? 1,
      child: Flex(
        direction: Axis.vertical,
        children: [
          Expanded(
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
                SizedBox(
                  width: controller.spaceBetween,
                ),
                _Builder(
                  controller: controller,
                  image: controller.items[2],
                  flexible: true,
                ),
              ],
            ),
          ),
          SizedBox(
            height: controller.spaceBetween,
          ),
          Expanded(
            child: Flex(
              direction: Axis.horizontal,
              children: [
                _Builder(
                  controller: controller,
                  image: controller.items[3],
                  flexible: true,
                ),
                SizedBox(
                  width: controller.spaceBetween,
                ),
                _Builder(
                  controller: controller,
                  image: controller.items[4],
                  flexible: true,
                ),
                SizedBox(
                  width: controller.spaceBetween,
                ),
                _Builder(
                  controller: controller,
                  image: controller.items[5],
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
