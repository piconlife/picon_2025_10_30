import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:object_finder/object_finder.dart';

import '../../data/models/content.dart';
import '../../routes/builder.dart';
import '../../routes/paths.dart';
import '../social/data/cubits/like_cubit.dart';
import '../social/data/cubits/view_cubit.dart';
import 'view/pages/preview_photos.dart';
import 'view/pages/preview_videos.dart';

Map<String, RouteBuilder> get mPreviewRoutes {
  return {
    Routes.previewPhotos: _previewPhotos,
    Routes.previewVideos: _previewVideos,
  };
}

Widget _previewPhotos(BuildContext context, Object? args) {
  Content? content = args.getOrNull("$Content");
  LikeCubit? likeCubit = args.findOrNull(key: "$LikeCubit");
  ViewCubit? viewCubit = args.findOrNull(key: "$ViewCubit");
  final parentPath = content?.parentPath ?? '';
  if (parentPath.isEmpty) return PreviewPhotosPage(args: args);
  return MultiBlocProvider(
    providers: [
      likeCubit != null
          ? BlocProvider.value(value: likeCubit)
          : BlocProvider(
            create: (context) => LikeCubit(context, parentPath)..loadCounter(),
          ),
      likeCubit != null
          ? BlocProvider.value(value: likeCubit)
          : BlocProvider(
            create: (context) => LikeCubit(context, parentPath)..loadCounter(),
          ),
      if (viewCubit != null) BlocProvider.value(value: viewCubit),
    ],
    child: PreviewPhotosPage(args: args),
  );
}

Widget _previewVideos(BuildContext context, Object? args) {
  return const PreviewVideosPage();
}
