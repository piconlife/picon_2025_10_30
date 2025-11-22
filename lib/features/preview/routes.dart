import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:in_app_navigator/typedefs.dart';
import 'package:object_finder/object_finder.dart';

import '../../data/models/content.dart';
import '../../routes/paths.dart';
import '../social/data/cubits/like_cubit.dart';
import '../social/data/cubits/view_cubit.dart';
import '../social/view/cubits/comment_cubit.dart';
import 'view/pages/preview_photos.dart';
import 'view/pages/preview_videos.dart';

Map<String, RouteBuilder> get mPreviewRoutes {
  return {
    Routes.previewPhotos: _previewPhotos,
    Routes.previewVideos: _previewVideos,
  };
}

Widget _previewPhotos(BuildContext context, Object? args) {
  ContentModel? content = args.getOrNull("$ContentModel");
  LikeCubit? likeCubit = args.findOrNull(key: "$LikeCubit");
  ViewCubit? viewCubit = args.findOrNull(key: "$ViewCubit");
  CommentCubit? commentCubit = args.findOrNull(key: "$CommentCubit");
  final parentPath = content?.contentPath ?? '';
  if (parentPath.isEmpty) return PreviewPhotosPage(args: args);
  return MultiBlocProvider(
    providers: [
      likeCubit != null
          ? BlocProvider.value(value: likeCubit)
          : BlocProvider(
            create: (context) {
              return LikeCubit(context, parentPath)
                ..loadCounter()
                ..load(resultByMe: true);
            },
          ),
      viewCubit != null
          ? BlocProvider.value(value: viewCubit)
          : BlocProvider(
            create: (context) {
              return ViewCubit(context, parentPath)
                ..loadCounter()
                ..load(resultByMe: true);
            },
          ),
      commentCubit != null
          ? BlocProvider.value(value: commentCubit)
          : BlocProvider(
            create: (context) {
              return CommentCubit(context, parentPath)
                ..loadCounter()
                ..load(resultByMe: true);
            },
          ),
    ],
    child: PreviewPhotosPage(args: args),
  );
}

Widget _previewVideos(BuildContext context, Object? args) {
  return const PreviewVideosPage();
}
