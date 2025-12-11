import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:in_app_navigator/typedefs.dart';
import 'package:object_finder/object_finder.dart';

import '../../routes/paths.dart';
import '../user/view/cubits/bookmark_cubit.dart';
import 'view/pages/preview_photos.dart';
import 'view/pages/preview_videos.dart';

Map<String, RouteBuilder> get mPreviewRoutes {
  return {
    Routes.previewPhotos: _previewPhotos,
    Routes.previewVideos: _previewVideos,
  };
}

Widget _previewPhotos(BuildContext context, Object? args) {
  UserBookmarkCubit? userBookmarkCubit = args.findOrNull(
    key: '$UserBookmarkCubit',
  );
  return MultiBlocProvider(
    providers: [
      userBookmarkCubit != null
          ? BlocProvider.value(value: userBookmarkCubit)
          : BlocProvider(
            create: (context) => UserBookmarkCubit(context)..load(),
          ),
    ],
    child: PreviewPhotosPage(args: args),
  );
}

Widget _previewVideos(BuildContext context, Object? args) {
  return const PreviewVideosPage();
}
