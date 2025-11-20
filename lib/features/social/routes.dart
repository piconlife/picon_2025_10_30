import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:in_app_navigator/generate.dart';
import 'package:object_finder/object_finder.dart';

import '../../routes/paths.dart';
import '../user/view/cubits/following_cubit.dart';
import '../user/view/cubits/post_cubit.dart';
import 'data/cubits/feed_home_cubit.dart';
import 'data/cubits/like_cubit.dart';
import 'view/cubits/comment_cubit.dart';
import 'view/pages/comments.dart';
import 'view/pages/create_a_memory.dart';
import 'view/pages/create_a_note.dart';
import 'view/pages/create_a_story.dart';
import 'view/pages/create_a_video.dart';
import 'view/pages/create_post.dart';
import 'view/pages/likes.dart';
import 'view/pages/search_feed.dart';

Map<String, RouteBuilder> get mSocialRoutes {
  return {
    Routes.createUserPost: _createUserPost,
    Routes.createAMemory: _createAMemory,
    Routes.createANote: _createANote,
    Routes.createAStory: _createAStory,
    Routes.createAVideo: _createAVideo,
    Routes.searchFeeds: _searchFeeds,
    Routes.comments: _comments,
    Routes.likes: _likes,
  };
}

Widget _createUserPost(BuildContext context, Object? args) {
  FeedHomeCubit? feedHomeCubit = args.findOrNull(key: "$FeedHomeCubit");
  UserPostCubit? userPostCubit = args.findOrNull(key: "$UserPostCubit");
  return MultiBlocProvider(
    providers: [
      feedHomeCubit != null
          ? BlocProvider.value(value: feedHomeCubit)
          : BlocProvider(create: (context) => FeedHomeCubit(context)),
      userPostCubit != null
          ? BlocProvider.value(value: userPostCubit)
          : BlocProvider(create: (context) => UserPostCubit(context)),
    ],
    child: CreatePostPage(args: args),
  );
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
  final commentCubit = args.findOrNull<CommentCubit>(key: "$CommentCubit");
  return MultiBlocProvider(
    providers: [
      commentCubit != null
          ? BlocProvider.value(value: commentCubit..load())
          : BlocProvider(
            create: (context) => CommentCubit(context, '')..load(),
          ),
    ],
    child: CommentsPage(args: args),
  );
}

Widget _likes(BuildContext context, Object? args) {
  String? path = args.findOrNull(key: "path");
  final likeCubit = args.findOrNull<LikeCubit>(key: "$LikeCubit");
  final followingCubit = args.findOrNull<UserFollowingCubit>(
    key: "$UserFollowingCubit",
  );
  return MultiBlocProvider(
    providers: [
      likeCubit != null
          ? BlocProvider.value(value: likeCubit..load())
          : BlocProvider(
            create: (context) => LikeCubit(context, path ?? '')..load(),
          ),
      followingCubit != null
          ? BlocProvider.value(value: followingCubit)
          : BlocProvider(
            create: (context) => UserFollowingCubit(context, path),
          ),
    ],
    child: LikesPage(args: args),
  );
}
