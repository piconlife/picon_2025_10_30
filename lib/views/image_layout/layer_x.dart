part of 'view.dart';

class _LayerX<T> extends StatelessWidget {
  final ImageLayoutController<T> controller;

  const _LayerX({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return controller.isRational
        ? _Builder(
            controller: controller,
            image: controller.items[0],
            dimension: controller.ratio,
          )
        : _Builder(
            controller: controller,
            image: controller.items[0],
            maxHeight: 500,
            resizable: true,
          );
  }
}
