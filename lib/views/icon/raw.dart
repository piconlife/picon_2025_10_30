part of 'view.dart';

class RawIconView extends StatelessWidget {
  final BoxFit? fit;
  final dynamic icon;
  final double? size;
  final Color? tint;
  final BlendMode tintMode;

  const RawIconView({
    super.key,
    required this.icon,
    this.fit,
    this.size,
    this.tint,
    this.tintMode = BlendMode.srcIn,
  });

  @override
  Widget build(BuildContext context) {
    final type = getType(icon);
    switch (type) {
      case IconType.icon:
        return Icon(
          icon,
          color: tint,
          size: size,
        );
      case IconType.svg:
        return SvgPicture.asset(
          icon,
          width: size,
          height: size,
          fit: fit ?? BoxFit.contain,
          colorFilter: tint != null
              ? ColorFilter.mode(
                  tint!,
                  tintMode,
                )
              : null,
          theme: SvgTheme(
            currentColor: tint ?? const Color(0xFF808080),
          ),
        );
      case IconType.png:
        return Image.asset(
          icon,
          color: tint,
          width: size,
          height: size,
          fit: fit,
          colorBlendMode: tintMode,
        );
      default:
        return SizedBox(
          width: size,
          height: size,
        );
    }
  }

  IconType getType(dynamic source) {
    if (source is IconData) {
      return IconType.icon;
    } else if (source is String) {
      if (source.endsWith('.svg')) {
        return IconType.svg;
      } else if (source.endsWith('.png')) {
        return IconType.png;
      } else {
        return IconType.none;
      }
    } else {
      return IconType.none;
    }
  }
}
