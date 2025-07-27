part of 'view.dart';

enum ImageType {
  unknown,
  detect,
  asset,
  file,
  memory,
  network,
  svg,
  svgCode,
  svgNetwork;

  factory ImageType.from(dynamic data, [ImageType type = ImageType.detect]) {
    if (type == ImageType.detect || type == ImageType.unknown) {
      if (data is String) {
        if (data.isAsset) {
          if (data.isSvg) {
            return ImageType.svg;
          } else {
            return ImageType.asset;
          }
        } else if (data.isNetwork) {
          if (data.isSvg) {
            return ImageType.svgNetwork;
          } else {
            return ImageType.network;
          }
        } else if (data.isSvgCode) {
          return ImageType.svgCode;
        } else {
          return ImageType.unknown;
        }
      } else if (data is File) {
        return ImageType.file;
      } else if (data is Uint8List) {
        return ImageType.memory;
      } else {
        return ImageType.unknown;
      }
    } else {
      return type;
    }
  }
}
