import 'package:flutter/material.dart';
import 'package:in_app_navigator/generate.dart';

import '../../routes/paths.dart';
import 'view/pages/search_videos.dart';
import 'view/pages/upload_a_video.dart';

Map<String, RouteBuilder> get mChannelRoutes {
  return {
    Routes.uploadAVideo: _uploadAVideo,
    Routes.searchVideos: _searchVideos,
  };
}

Widget _uploadAVideo(BuildContext context, Object? args) {
  return const UploadAVideoPage();
}

Widget _searchVideos(BuildContext context, Object? args) {
  return const SearchVideosPage();
}
