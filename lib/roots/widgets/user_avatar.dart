import 'package:auth_management/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_androssy_kits/core/cached_network_image.dart';

import '../../app/res/placeholders.dart';
import '../../data/models/user.dart';
import 'gesture.dart';
import 'image.dart';

class AndrossyAvatar extends StatelessWidget {
  final double size;
  final double border;
  final double innerBorder;
  final Color? borderColor;
  final Color? backgroundColor;
  final double fadeWidthFraction;
  final BoxShadow? shadow;
  final Widget? child;

  const AndrossyAvatar({
    super.key,
    this.size = 20.0,
    this.border = 0,
    this.borderColor,
    this.backgroundColor,
    this.innerBorder = 0,
    this.fadeWidthFraction = 0,
    this.shadow,
    this.child,
  });

  Widget _buildShader(BuildContext context, Widget? child) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double width = constraints.maxWidth;
        double fadeWidth = width * fadeWidthFraction;
        return ShaderMask(
          shaderCallback: (bounds) {
            return RadialGradient(
              colors: [Colors.black, Colors.transparent],
              stops: [1.0 - fadeWidth / width, 1.0],
            ).createShader(bounds);
          },
          blendMode: BlendMode.dstIn,
          child: child,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget child = Container(
      clipBehavior: Clip.antiAlias,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: backgroundColor,
        boxShadow: border <= 0 && shadow != null ? [shadow!] : null,
      ),
      child:
          fadeWidthFraction > 0
              ? _buildShader(context, this.child)
              : this.child,
    );

    if (border > 0) {
      child = Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          border:
              border > 0
                  ? Border.all(
                    color: borderColor ?? Colors.white,
                    width: border,
                    strokeAlign: BorderSide.strokeAlignInside,
                  )
                  : null,
          shape: BoxShape.circle,
          boxShadow: shadow != null ? [shadow!] : null,
          color: shadow != null ? backgroundColor : null,
        ),
        padding: innerBorder > 0 ? EdgeInsets.all(innerBorder) : null,
        child: child,
      );
    }
    return SizedBox.square(dimension: size, child: child);
  }
}

class InAppUserAvatar extends StatelessWidget {
  final bool isLocal;
  final dynamic url;
  final double size;
  final double border;
  final double innerBorder;
  final Color? borderColor;
  final Color? backgroundColor;
  final double fadeWidthFraction;
  final BoxShadow? shadow;
  final VoidCallback? onTap;

  const InAppUserAvatar({
    super.key,
    this.isLocal = false,
    this.url,
    this.size = 40,
    this.border = 0,
    this.borderColor,
    this.backgroundColor,
    this.innerBorder = 0,
    this.fadeWidthFraction = 0,
    this.shadow,
    this.onTap,
  });

  Widget child(BuildContext context, String? url) {
    return InAppGesture(
      onTap: onTap,
      child: AndrossyAvatar(
        backgroundColor: backgroundColor,
        border: border,
        innerBorder: innerBorder,
        borderColor: borderColor,
        size: size,
        shadow: shadow,
        fadeWidthFraction: fadeWidthFraction,
        child: InAppImage(
          url,
          fit: BoxFit.cover,
          networkImageConfig: AndrossyNetworkImageConfig(
            errorWidget: (context, url, error) {
              return InAppImage(InAppPlaceholders.user, fit: BoxFit.cover);
            },
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLocal) {
      return AuthConsumer<UserModel>(
        builder: (context, value) {
          return child(context, value?.photo ?? url ?? InAppPlaceholders.user);
        },
      );
    } else {
      return child(context, url ?? InAppPlaceholders.user);
    }
  }
}
