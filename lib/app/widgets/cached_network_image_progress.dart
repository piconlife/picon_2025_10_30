import 'package:app_color/app_color.dart';
import 'package:app_color/extension.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../roots/widgets/shimmer.dart';

class InAppCachedNetworkImageProgress extends StatelessWidget {
  final double? width;
  final double? height;
  final String url;
  final DownloadProgress progress;

  const InAppCachedNetworkImageProgress({
    super.key,
    required this.url,
    required this.progress,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return InAppShimmer(
      child: Container(width: width, height: height, color: context.dark.t05),
    );
  }
}
