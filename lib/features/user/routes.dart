import 'package:flutter/material.dart';
import 'package:flutter_app_navigator/app_navigator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:in_app_navigator/in_app_navigator.dart';
import 'package:object_finder/object_finder.dart';

import '../../data/models/user.dart';
import '../../routes/paths.dart';
import '../social/view/cubits/feed_home_cubit.dart';
import '../social/view/cubits/follower_cubit.dart';
import 'view/cubits/avatar_cubit.dart';
import 'view/cubits/cover_cubit.dart';
import 'view/cubits/follower_cubit.dart';
import 'view/cubits/following_cubit.dart';
import 'view/cubits/memory_cubit.dart';
import 'view/cubits/note_cubit.dart';
import 'view/cubits/photo_cubit.dart';
import 'view/cubits/post_cubit.dart';
import 'view/cubits/report_cubit.dart';
import 'view/cubits/story_cubit.dart';
import 'view/cubits/user_cubit.dart';
import 'view/cubits/video_cubit.dart';
import 'view/pages/edit_address.dart';
import 'view/pages/edit_cover_photo.dart';
import 'view/pages/edit_profile_photo.dart';
import 'view/pages/followers.dart';
import 'view/pages/followings.dart';
import 'view/pages/posts.dart';
import 'view/pages/profile.dart';
import 'view/pages/reports.dart';

extension UserRouteHelper on BuildContext {
  Future<void> openUserProfile({String? uid, User? user}) async {
    open(
      Routes.userProfile,
      arguments: {
        "uid": uid,
        "$User": user,
        "$FeedHomeCubit": read<FeedHomeCubit>(),
        "$FollowerCubit": read<FollowerCubit>(),
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

Map<String, RouteBuilder> get mUserRoutes {
  return {
    Routes.editUserProfilePhoto: _editUserProfilePhoto,
    Routes.editUserCoverPhoto: _editUserCoverPhoto,
    Routes.editUserPrimaryAddress: _editUserPrimaryAddress,
    Routes.editUserSecondaryAddress: _editUserSecondaryAddress,
    Routes.userProfile: _profile,
    Routes.userReports: _profileReports,
    Routes.userFeeds: _profileFeeds,
    Routes.userFollowers: _profileFollowers,
    Routes.userFollowings: _profileFollowings,
  };
}

Widget _editUserProfilePhoto(BuildContext context, Object? args) {
  UserAvatarCubit? avatarCubit = args.findOrNull(key: "$UserAvatarCubit");
  UserPostCubit? userPostCubit = args.findOrNull(key: "$UserPostCubit");
  FeedHomeCubit? feedHomeCubit = args.findOrNull(key: "$FeedHomeCubit");
  return MultiBlocProvider(
    providers: [
      avatarCubit != null
          ? BlocProvider.value(value: avatarCubit)
          : BlocProvider(create: (context) => UserAvatarCubit()),
      userPostCubit != null
          ? BlocProvider.value(value: userPostCubit)
          : BlocProvider(create: (context) => UserPostCubit()),
      feedHomeCubit != null
          ? BlocProvider.value(value: feedHomeCubit)
          : BlocProvider(create: (context) => FeedHomeCubit()),
    ],
    child: EditUserProfilePhotoPage(args: args),
  );
}

Widget _editUserCoverPhoto(BuildContext context, Object? args) {
  UserCoverCubit? coversCubit = args.findOrNull(key: "$UserCoverCubit");
  UserPostCubit? userPostCubit = args.findOrNull(key: "$UserPostCubit");
  FeedHomeCubit? feedHomeCubit = args.findOrNull(key: "$FeedHomeCubit");
  return MultiBlocProvider(
    providers: [
      coversCubit != null
          ? BlocProvider.value(value: coversCubit)
          : BlocProvider(create: (context) => UserCoverCubit()),
      userPostCubit != null
          ? BlocProvider.value(value: userPostCubit)
          : BlocProvider(create: (context) => UserPostCubit()),
      feedHomeCubit != null
          ? BlocProvider.value(value: feedHomeCubit)
          : BlocProvider(create: (context) => FeedHomeCubit()),
    ],
    child: EditUserCoverPhotoPage(args: args),
  );
}

Widget _editUserPrimaryAddress(BuildContext context, Object? args) {
  return EditUserAddressPage(args: args, primary: true);
}

Widget _editUserSecondaryAddress(BuildContext context, Object? args) {
  return EditUserAddressPage(args: args);
}

Widget _profile(BuildContext context, Object? args) {
  User? user = args.findOrNull(key: "$User");
  String? uid = user?.id ?? args.findOrNull(key: "uid") ?? args.findOrNull();
  FeedHomeCubit? feedHomeCubit = args.findOrNull(key: "$FeedHomeCubit");
  FollowerCubit? followerCubit = args.findOrNull(key: "$FollowerCubit");
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
          : BlocProvider(create: (_) => FeedHomeCubit()),
      if (followerCubit != null) BlocProvider.value(value: followerCubit),
      avatarsCubit != null
          ? BlocProvider.value(value: avatarsCubit..initial())
          : BlocProvider(create: (_) => UserAvatarCubit(uid)..fetch()),
      coversCubit != null
          ? BlocProvider.value(value: coversCubit..initial())
          : BlocProvider(create: (context) => UserCoverCubit(uid)..fetch()),
      userCubit != null
          ? BlocProvider.value(value: userCubit..initial())
          : BlocProvider(create: (context) => UserCubit(uid)..fetch()),
      memoryCubit != null
          ? BlocProvider.value(value: memoryCubit..initial())
          : BlocProvider(create: (context) => UserMemoryCubit(uid)..fetch()),
      noteCubit != null
          ? BlocProvider.value(value: noteCubit..initial())
          : BlocProvider(create: (context) => UserNoteCubit(uid)..fetch()),
      photoCubit != null
          ? BlocProvider.value(value: photoCubit..initial())
          : BlocProvider(create: (context) => UserPhotoCubit(uid)..fetch()),
      postCubit != null
          ? BlocProvider.value(
            value:
                postCubit
                  ..initial()
                  ..initialCount(),
          )
          : BlocProvider(
            create:
                (_) =>
                    UserPostCubit(uid)
                      ..fetch()
                      ..count(),
          ),
      storyCubit != null
          ? BlocProvider.value(value: storyCubit..initial())
          : BlocProvider(create: (_) => UserStoryCubit(uid)..fetch()),
      videoCubit != null
          ? BlocProvider.value(value: videoCubit..initial())
          : BlocProvider(create: (_) => UserVideoCubit(uid)..fetch()),
      reportCubit != null
          ? BlocProvider.value(value: reportCubit..initialCount())
          : BlocProvider(create: (_) => UserReportCubit(uid)..count()),
      userFollowerCubit != null
          ? BlocProvider.value(value: userFollowerCubit..initialCount())
          : BlocProvider(create: (_) => UserFollowerCubit(uid)..count()),
      userFollowingCubit != null
          ? BlocProvider.value(value: userFollowingCubit..initialCount())
          : BlocProvider(create: (_) => UserFollowingCubit(uid)..count()),
    ],
    child: UserProfilePage(args: args),
  );
}

Widget _profileReports(BuildContext context, Object? args) {
  User? user = args.findOrNull(key: "$User");
  UserReportCubit? reportCubit = args.findOrNull(key: "$UserReportCubit");
  return MultiBlocProvider(
    providers: [
      reportCubit != null
          ? BlocProvider.value(value: reportCubit)
          : BlocProvider(
            create: (context) {
              return UserReportCubit(user?.id)..fetch();
            },
          ),
    ],
    child: UserReportsPage(args: args, user: user),
  );
}

Widget _profileFeeds(BuildContext context, Object? args) {
  User? user = args.findOrNull(key: "$User");
  UserPostCubit? postCubit = args.findOrNull(key: "$UserPostCubit");
  return MultiBlocProvider(
    providers: [
      postCubit != null
          ? BlocProvider.value(value: postCubit)
          : BlocProvider(create: (context) => UserPostCubit(user?.id)..fetch()),
    ],
    child: UserPostsPage(args: args, user: user),
  );
}

Widget _profileFollowers(BuildContext context, Object? args) {
  User? user = args.findOrNull(key: "$User");
  UserFollowerCubit? followerCubit = args.findOrNull(key: "$UserFollowerCubit");
  return MultiBlocProvider(
    providers: [
      followerCubit != null
          ? BlocProvider.value(value: followerCubit)
          : BlocProvider(
            create: (context) {
              return UserFollowerCubit(user?.id)..fetch();
            },
          ),
    ],
    child: UserFollowersPage(args: args, user: user),
  );
}

Widget _profileFollowings(BuildContext context, Object? args) {
  User? user = args.findOrNull(key: "$User");
  UserFollowingCubit? followingCubit = args.findOrNull(
    key: "$UserFollowingCubit",
  );
  return MultiBlocProvider(
    providers: [
      followingCubit != null
          ? BlocProvider.value(value: followingCubit)
          : BlocProvider(create: (context) => UserFollowingCubit(user?.id)),
    ],
    child: UserFollowingsPage(args: args, user: user),
  );
}
