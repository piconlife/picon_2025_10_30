part of 'view.dart';

class ImageLayoutController<T> extends ViewController {
  double? frameRatio;
  ImageLayoutFrameRatioBuilder? frameRatioBuilder;
  Color? itemBackground;
  double spaceBetween = 4;
  ImageType? imageType;
  List<T> items = [];
  dynamic placeholder;
  ImageType? placeholderType;

  @override
  ImageLayoutController<T> fromView(
    YMRView<ViewController> view, {
    double? frameRatio,
    ImageLayoutFrameRatioBuilder? frameBuilder,
    Color? itemBackground,
    double? itemSpace,
    ImageType? itemType,
    List<T>? items,
    dynamic placeholder,
    ImageType? placeholderType,
  }) {
    super.fromView(view);
    this.frameRatio = frameRatio;
    this.frameRatioBuilder = frameBuilder;
    this.itemBackground = itemBackground;
    this.spaceBetween = itemSpace ?? 4;
    this.imageType = itemType;
    this.items = items ?? [];
    this.placeholder = placeholder;
    this.placeholderType = placeholderType;
    return this;
  }

  bool get isRational => ratio > 0;

  int get invisibleItemSize => items.length - 5;

  int get itemSize => items.length;

  double get ratio {
    return frameRatioBuilder?.call(
          ImageLayoutLayers.from(itemSize),
        ) ??
        frameRatio ??
        0;
  }

  ImageLayoutLayers get layer => ImageLayoutLayers.from(itemSize);
}
