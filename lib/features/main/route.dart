import 'package:flutter/material.dart';
import 'package:flutter_app_navigator/app_navigator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../routes/paths.dart';
import '../social/view/cubits/feed_home_cubit.dart';
import '../social/view/cubits/verified_feed_cubit.dart';
import '../social/view/cubits/verified_users_cubit.dart';
import '../user/view/cubits/avatar_cubit.dart';
import '../user/view/cubits/cover_cubit.dart';
import '../user/view/cubits/follower_cubit.dart';
import '../user/view/cubits/following_cubit.dart';
import '../user/view/cubits/memory_cubit.dart';
import '../user/view/cubits/note_cubit.dart';
import '../user/view/cubits/photo_cubit.dart';
import '../user/view/cubits/post_cubit.dart';
import '../user/view/cubits/report_cubit.dart';
import '../user/view/cubits/story_cubit.dart';
import '../user/view/cubits/user_cubit.dart';
import '../user/view/cubits/video_cubit.dart';
import 'views/pages/main.dart';

Map<String, RouteBuilder> get mMainRoutes {
  return {Routes.main: _main};
}

Widget _main(BuildContext context, Object? args) {
  return MultiBlocProvider(
    providers: [
      BlocProvider(create: (_) => FeedHomeCubit()..initial()),
      BlocProvider(create: (_) => VerifiedFeedCubit()..initial()),
      BlocProvider(create: (_) => VerifiedUsersCubit()..initial()),

      BlocProvider(create: (_) => UserFollowerCubit()..initial()),
      BlocProvider(create: (_) => UserFollowingCubit()..initial()),

      BlocProvider(create: (_) => UserAvatarCubit()),
      BlocProvider(create: (_) => UserCoverCubit()),
      BlocProvider(create: (_) => UserCubit()),
      BlocProvider(create: (_) => UserMemoryCubit()),
      BlocProvider(create: (_) => UserNoteCubit()),
      BlocProvider(create: (_) => UserPhotoCubit()),
      BlocProvider(create: (_) => UserPostCubit()),
      BlocProvider(create: (_) => UserStoryCubit()),
      BlocProvider(create: (_) => UserVideoCubit()),
      BlocProvider(create: (_) => UserReportCubit()),
    ],
    child: const MainPage(),
  );
}
