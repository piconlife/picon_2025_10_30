part of 'view.dart';

class _Builder<T> extends StatelessWidget {
  final ImageLayoutController<T> controller;
  final double? maxHeight;
  final T image;
  final double? dimension;
  final bool flexible, resizable;

  const _Builder({
    super.key,
    required this.controller,
    required this.image,
    this.flexible = false,
    this.resizable = false,
    this.maxHeight,
    this.dimension,
  });

  @override
  Widget build(BuildContext context) {
    return ImageView(
      dimensionRatio: dimension,
      flex: flexible ? 1 : null,
      width: double.infinity,
      height: resizable ? null : double.infinity,
      heightMax: maxHeight,
      background: controller.itemBackground,
      image: image,
      imageType: controller.imageType,
      placeholder: controller.placeholder,
      placeholderType: controller.placeholderType,
      scaleType: BoxFit.cover,
    );
  }
}
