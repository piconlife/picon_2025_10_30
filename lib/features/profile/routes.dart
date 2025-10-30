import 'package:flutter/material.dart';
import 'package:flutter_app_navigator/app_navigator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:in_app_navigator/in_app_navigator.dart';
import 'package:object_finder/object_finder.dart';

import '../../routes/paths.dart';
import '../social/data/cubits/feed_home_cubit.dart';
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
import 'view/pages/profile.dart';

extension ProfileRouteHelper on BuildContext {
  Future<void> openProfile() async {
    open(
      Routes.profile,
      arguments: {
        "$FeedHomeCubit": read<FeedHomeCubit>(),
        "$UserCubit": read<UserCubit>(),
        "$UserFollowerCubit": read<UserFollowerCubit>(),
        "$UserFollowingCubit": read<UserFollowingCubit>(),
        "$UserMemoryCubit": read<UserMemoryCubit>(),
        "$UserNoteCubit": read<UserNoteCubit>(),
        "$UserPostCubit": read<UserPostCubit>(),
        "$UserPhotoCubit": read<UserPhotoCubit>(),
        "$UserReportCubit": read<UserReportCubit>(),
        "$UserStoryCubit": read<UserStoryCubit>(),
        "$UserVideoCubit": read<UserVideoCubit>(),
        "$UserAvatarCubit": read<UserAvatarCubit>(),
        "$UserCoverCubit": read<UserCoverCubit>(),
      },
    );
  }
}

Map<String, RouteBuilder> get mProfileRoutes {
  return {Routes.profile: _profile};
}

Widget _profile(BuildContext context, Object? args) {
  FeedHomeCubit? feedHomeCubit = args.findOrNull(key: "$FeedHomeCubit");
  UserCubit? userCubit = args.findOrNull(key: "$UserCubit");
  UserFollowerCubit? userFollowerCubit = args.findOrNull(
    key: "$UserFollowerCubit",
  );
  UserFollowingCubit? userFollowingCubit = args.findOrNull(
    key: "$UserFollowingCubit",
  );
  UserMemoryCubit? memoryCubit = args.findOrNull(key: "$UserMemoryCubit");
  UserNoteCubit? noteCubit = args.findOrNull(key: "$UserNoteCubit");
  UserPhotoCubit? photoCubit = args.findOrNull(key: "$UserPhotoCubit");
  UserPostCubit? postCubit = args.findOrNull(key: "$UserPostCubit");
  UserReportCubit? reportCubit = args.findOrNull(key: "$UserReportCubit");
  UserStoryCubit? storyCubit = args.findOrNull(key: "$UserStoryCubit");
  UserVideoCubit? videoCubit = args.findOrNull(key: "$UserVideoCubit");
  UserAvatarCubit? avatarsCubit = args.findOrNull(key: "$UserAvatarCubit");
  UserCoverCubit? coversCubit = args.findOrNull(key: "$UserCoverCubit");

  return MultiBlocProvider(
    providers: [
      feedHomeCubit != null
          ? BlocProvider.value(value: feedHomeCubit)
          : BlocProvider(create: (context) => FeedHomeCubit(context)),
      avatarsCubit != null
          ? BlocProvider.value(value: avatarsCubit)
          : BlocProvider(create: (context) => UserAvatarCubit(context)),
      coversCubit != null
          ? BlocProvider.value(value: coversCubit)
          : BlocProvider(create: (context) => UserCoverCubit(context)),
      userCubit != null
          ? BlocProvider.value(value: userCubit)
          : BlocProvider(create: (context) => UserCubit(context)),
      memoryCubit != null
          ? BlocProvider.value(value: memoryCubit)
          : BlocProvider(create: (context) => UserMemoryCubit(context)),
      noteCubit != null
          ? BlocProvider.value(value: noteCubit)
          : BlocProvider(create: (context) => UserNoteCubit(context)),
      photoCubit != null
          ? BlocProvider.value(value: photoCubit)
          : BlocProvider(create: (context) => UserPhotoCubit(context)),
      postCubit != null
          ? BlocProvider.value(value: postCubit)
          : BlocProvider(create: (context) => UserPostCubit(context)),
      storyCubit != null
          ? BlocProvider.value(value: storyCubit)
          : BlocProvider(create: (context) => UserStoryCubit(context)),
      videoCubit != null
          ? BlocProvider.value(value: videoCubit)
          : BlocProvider(create: (context) => UserVideoCubit(context)),
      reportCubit != null
          ? BlocProvider.value(value: reportCubit)
          : BlocProvider(create: (context) => UserReportCubit(context)),
      userFollowerCubit != null
          ? BlocProvider.value(value: userFollowerCubit)
          : BlocProvider(create: (context) => UserFollowerCubit(context)),
      userFollowingCubit != null
          ? BlocProvider.value(value: userFollowingCubit)
          : BlocProvider(create: (context) => UserFollowingCubit(context)),
    ],
    child: ProfilePage(),
  );
}
