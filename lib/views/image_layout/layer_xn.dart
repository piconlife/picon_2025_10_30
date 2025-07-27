part of 'view.dart';

class _LayerXn<T> extends StatelessWidget {
  final ImageLayoutController<T> controller;

  const _LayerXn({
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
                Expanded(
                  child: SizedBox(
                    width: double.infinity,
                    height: double.infinity,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        _Builder(
                          controller: controller,
                          image: controller.items[5],
                        ),
                        Container(
                          alignment: Alignment.center,
                          width: double.infinity,
                          height: double.infinity,
                          color: Colors.black.withOpacity(0.35),
                          child: Text(
                            "+${controller.invisibleItemSize}",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
