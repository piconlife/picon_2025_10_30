part of 'view.dart';

enum ImageLayoutLayers {
  x,
  x2,
  x3,
  x4,
  x5,
  x6,
  xn;

  factory ImageLayoutLayers.from(int size) {
    if (size == 1) {
      return ImageLayoutLayers.x;
    } else if (size == 2) {
      return ImageLayoutLayers.x2;
    } else if (size == 3) {
      return ImageLayoutLayers.x3;
    } else if (size == 4) {
      return ImageLayoutLayers.x4;
    } else if (size == 5) {
      return ImageLayoutLayers.x5;
    } else if (size == 6) {
      return ImageLayoutLayers.x6;
    } else {
      return ImageLayoutLayers.xn;
    }
  }
}
