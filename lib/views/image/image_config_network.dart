part of 'view.dart';

class ImageConfigNetwork {
  final Alignment alignment;
  final BaseCacheManager? cacheManager;
  final String? cacheKey;
  final LoadingErrorWidgetBuilder? errorBuilder;
  final ValueChanged<Object>? errorListener;
  final Curve fadeInCurve;
  final Duration fadeInDuration;
  final Curve fadeOutCurve;
  final Duration? fadeOutDuration;
  final FilterQuality filterQuality;
  final Map<String, String>? httpHeaders;
  final ImageWidgetBuilder? imageBuilder;
  final ImageRenderMethodForWeb imageRenderMethodForWeb;
  final bool matchTextDirection;
  final int? maxHeightDiskCache;
  final int? maxWidthDiskCache;
  final int? memCacheHeight;
  final int? memCacheWidth;
  final PlaceholderWidgetBuilder? placeholder;
  final ProgressIndicatorBuilder? progressBuilder;
  final Duration? placeholderFadeInDuration;
  final ImageRepeat repeat;
  final bool useOldImageOnUrlChange;

  const ImageConfigNetwork({
    this.alignment = Alignment.center,
    this.cacheManager,
    this.cacheKey,
    this.errorBuilder,
    this.errorListener,
    this.fadeInCurve = Curves.easeIn,
    this.fadeInDuration = const Duration(milliseconds: 500),
    this.fadeOutCurve = Curves.easeOut,
    this.fadeOutDuration,
    this.filterQuality = FilterQuality.low,
    this.httpHeaders,
    this.imageBuilder,
    this.imageRenderMethodForWeb = ImageRenderMethodForWeb.HtmlImage,
    this.matchTextDirection = false,
    this.maxHeightDiskCache,
    this.maxWidthDiskCache,
    this.memCacheHeight,
    this.memCacheWidth,
    this.placeholder,
    this.progressBuilder,
    this.placeholderFadeInDuration,
    this.repeat = ImageRepeat.noRepeat,
    this.useOldImageOnUrlChange = false,
  });
}
