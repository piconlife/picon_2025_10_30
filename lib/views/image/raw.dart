part of 'view.dart';

class RawImageView extends StatelessWidget {
  final dynamic image;
  final ImageType imageType;
  final double? width, height;
  final BoxFit? scaleType;
  final bool cacheMode;
  final Color? tint;
  final BlendMode? tintMode;
  final ImageConfigNetwork? networkImageConfig;

  const RawImageView({
    super.key,
    this.width,
    this.height,
    this.cacheMode = true,
    this.image,
    this.imageType = ImageType.detect,
    this.scaleType,
    this.tint,
    this.tintMode,
    this.networkImageConfig,
  });

  @override
  Widget build(BuildContext context) {
    final type = ImageType.from(image, imageType);
    if (type == ImageType.asset) {
      return Image.asset(
        "$image",
        width: width,
        height: height,
        fit: scaleType,
        color: tint,
        colorBlendMode: tintMode,
      );
    } else if (type == ImageType.network) {
      if (cacheMode) {
        final config = networkImageConfig ?? const ImageConfigNetwork();
        return CachedNetworkImage(
          imageUrl: "$image",
          width: width,
          height: height,
          fit: scaleType,
          color: tint,
          colorBlendMode: tintMode,
          alignment: config.alignment,
          cacheKey: config.cacheKey,
          cacheManager: config.cacheManager,
          errorWidget: config.errorBuilder,
          errorListener: config.errorListener,
          fadeInCurve: config.fadeInCurve,
          fadeInDuration: config.fadeInDuration,
          fadeOutCurve: config.fadeOutCurve,
          fadeOutDuration: config.fadeOutDuration,
          filterQuality: config.filterQuality,
          httpHeaders: config.httpHeaders,
          imageBuilder: config.imageBuilder,
          imageRenderMethodForWeb: config.imageRenderMethodForWeb,
          matchTextDirection: config.matchTextDirection,
          maxHeightDiskCache: config.maxHeightDiskCache,
          maxWidthDiskCache: config.maxWidthDiskCache,
          memCacheHeight: config.memCacheHeight,
          memCacheWidth: config.memCacheWidth,
          placeholder: config.placeholder,
          placeholderFadeInDuration: config.placeholderFadeInDuration,
          progressIndicatorBuilder: config.progressBuilder,
          repeat: config.repeat,
          useOldImageOnUrlChange: config.useOldImageOnUrlChange,
        );
      } else {
        return Image.network(
          "$image",
          width: width,
          height: height,
          fit: scaleType,
          color: tint,
          colorBlendMode: tintMode,
        );
      }
    } else if (type == ImageType.file) {
      return Image.file(
        image,
        width: width,
        height: height,
        fit: scaleType,
        color: tint,
        colorBlendMode: tintMode,
      );
    } else if (type == ImageType.memory) {
      return Image.memory(
        image,
        width: width,
        height: height,
        fit: scaleType,
        color: tint,
        colorBlendMode: tintMode,
      );
    } else if (type == ImageType.svg) {
      return SvgPicture.asset(
        image,
        width: width,
        height: height,
        fit: scaleType ?? BoxFit.contain,
        colorFilter: tint != null
            ? ColorFilter.mode(
                tint!,
                tintMode ?? BlendMode.srcIn,
              )
            : null,
        theme: SvgTheme(
          currentColor: tint ?? const Color(0xFF808080),
        ),
      );
    } else if (type == ImageType.svgNetwork) {
      return SvgPicture.network(
        image,
        width: width,
        height: height,
        fit: scaleType ?? BoxFit.contain,
        colorFilter: tint != null
            ? ColorFilter.mode(
                tint!,
                tintMode ?? BlendMode.srcIn,
              )
            : null,
        theme: SvgTheme(
          currentColor: tint ?? const Color(0xFF808080),
        ),
      );
    } else if (type == ImageType.svgCode) {
      return SvgPicture.string(
        image,
        width: width,
        height: height,
        fit: scaleType ?? BoxFit.contain,
        colorFilter: tint != null
            ? ColorFilter.mode(
                tint!,
                tintMode ?? BlendMode.srcIn,
              )
            : null,
        theme: SvgTheme(
          currentColor: tint ?? const Color(0xFF808080),
        ),
      );
    } else {
      return SizedBox(
        width: width,
        height: height,
      );
    }
  }
}
