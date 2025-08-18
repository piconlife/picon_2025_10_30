import 'package:flutter/material.dart';
import 'package:flutter_app_navigator/app_navigator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../routes/paths.dart';
import '../social/view/cubits/feed_home_cubit.dart';
import '../social/view/cubits/follower_cubit.dart';
import '../social/view/cubits/verified_feed_cubit.dart';
import '../social/view/cubits/verified_users_cubit.dart';
import '../user/view/cubits/following_cubit.dart';
import '../user/view/cubits/post_cubit.dart';
import 'views/pages/main.dart';

Map<String, RouteBuilder> get mMainRoutes {
  return {Routes.main: _main};
}

Widget _main(BuildContext context, Object? args) {
  return MultiBlocProvider(
    providers: [
      BlocProvider(create: (_) => FollowerCubit()..fetch()),
      BlocProvider(create: (_) => UserPostCubit()..fetch()),
      BlocProvider(create: (_) => FeedHomeCubit()..fetch()),
      BlocProvider(create: (_) => VerifiedFeedCubit()..fetch()),
      BlocProvider(create: (_) => VerifiedUsersCubit()..fetch()),
      BlocProvider(create: (_) => UserFollowingCubit()..fetch()),
    ],
    child: const MainPage(),
  );
}
