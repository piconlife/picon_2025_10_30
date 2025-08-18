import 'package:flutter/material.dart';
import 'package:flutter_andomie/extensions/object.dart';
import 'package:flutter_app_navigator/app_navigator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../routes/paths.dart';
import '../user/view/cubits/following_cubit.dart';
import 'view/cubits/comment_cubit.dart';
import 'view/cubits/like_cubit.dart';
import 'view/pages/comments.dart';
import 'view/pages/create_a_memory.dart';
import 'view/pages/create_a_note.dart';
import 'view/pages/create_a_story.dart';
import 'view/pages/create_a_video.dart';
import 'view/pages/likes.dart';
import 'view/pages/search_feed.dart';

Map<String, RouteBuilder> get mSocialRoutes {
  return {
    Routes.createAMemory: _createAMemory,
    Routes.createANote: _createANote,
    Routes.createAStory: _createAStory,
    Routes.createAVideo: _createAVideo,
    Routes.searchFeeds: _searchFeeds,
    Routes.comments: _comments,
    Routes.likes: _likes,
  };
}

Widget _createAMemory(BuildContext context, Object? args) {
  return const CreateAMemoryPage();
}

Widget _createANote(BuildContext context, Object? args) {
  return const CreateANotePage();
}

Widget _createAStory(BuildContext context, Object? args) {
  return const CreateAStoryPage();
}

Widget _createAVideo(BuildContext context, Object? args) {
  return const CreateAVideoPage();
}

Widget _searchFeeds(BuildContext context, Object? args) {
  return const SearchFeedsPage();
}

Widget _comments(BuildContext context, Object? args) {
  final commentCubit = args.findOrNull<FeedCommentCubit>(
    key: "$FeedCommentCubit",
  );
  return MultiBlocProvider(
    providers: [
      commentCubit != null
          ? BlocProvider.value(value: commentCubit..fetch())
          : BlocProvider(create: (context) => FeedCommentCubit('')..fetch()),
    ],
    child: CommentsPage(args: args),
  );
}

Widget _likes(BuildContext context, Object? args) {
  final likeCubit = args.findOrNull<FeedLikeCubit>(key: "$FeedLikeCubit");
  final followingCubit = args.findOrNull<UserFollowingCubit>(
    key: "$UserFollowingCubit",
  );
  return MultiBlocProvider(
    providers: [
      likeCubit != null
          ? BlocProvider.value(value: likeCubit..fetch())
          : BlocProvider(create: (context) => FeedLikeCubit('')..fetch()),
      followingCubit != null
          ? BlocProvider.value(value: followingCubit)
          : BlocProvider(create: (context) => UserFollowingCubit()),
    ],
    child: LikesPage(args: args),
  );
}
