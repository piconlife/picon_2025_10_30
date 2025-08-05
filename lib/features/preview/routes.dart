import 'package:flutter/material.dart';
import 'package:flutter_app_navigator/app_navigator.dart';

import '../../routes/paths.dart';
import 'view/pages/preview_photos.dart';
import 'view/pages/preview_videos.dart';

Map<String, RouteBuilder> get mPreviewRoutes {
  return {
    Routes.previewPhotos: _previewPhotos,
    Routes.previewVideos: _previewVideos,
  };
}

Widget _previewPhotos(BuildContext context, Object? args) {
  return PreviewPhotosPage(args: args);
}

Widget _previewVideos(BuildContext context, Object? args) {
  return const PreviewVideosPage();
}
