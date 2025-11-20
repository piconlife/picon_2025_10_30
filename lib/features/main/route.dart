import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../routes/builder.dart';
import '../../routes/paths.dart';
import '../social/data/cubits/feed_home_cubit.dart';
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
      BlocProvider(create: (context) => FeedHomeCubit(context)..load()),
      BlocProvider(create: (context) => VerifiedFeedCubit(context)..load()),
      BlocProvider(create: (context) => VerifiedUsersCubit(context)..load()),

      BlocProvider(create: (context) => UserFollowerCubit(context)..load()),
      BlocProvider(create: (context) => UserFollowingCubit(context)..load()),

      BlocProvider(create: (context) => UserAvatarCubit(context)),
      BlocProvider(create: (context) => UserCoverCubit(context)),
      BlocProvider(create: (context) => UserCubit(context)),
      BlocProvider(create: (context) => UserMemoryCubit(context)),
      BlocProvider(create: (context) => UserNoteCubit(context)),
      BlocProvider(create: (context) => UserPhotoCubit(context)),
      BlocProvider(create: (context) => UserPostCubit(context)),
      BlocProvider(create: (context) => UserStoryCubit(context)),
      BlocProvider(create: (context) => UserVideoCubit(context)),
      BlocProvider(create: (context) => UserReportCubit(context)),
    ],
    child: const MainPage(),
  );
}
