import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:in_app_navigator/generate.dart';
import 'package:in_app_navigator/route.dart';
import 'package:object_finder/object_finder.dart';

import '../../data/models/user.dart';
import '../../routes/paths.dart';
import '../social/data/cubits/feed_home_cubit.dart';
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
  Future<void> openUserProfile({String? uid, UserModel? user}) async {
    open(
      Routes.userProfile,
      args: {
        "uid": uid,
        "$UserModel": user,
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
          : BlocProvider(create: (context) => UserAvatarCubit(context)),
      userPostCubit != null
          ? BlocProvider.value(value: userPostCubit)
          : BlocProvider(create: (context) => UserPostCubit(context)),
      feedHomeCubit != null
          ? BlocProvider.value(value: feedHomeCubit)
          : BlocProvider(create: (context) => FeedHomeCubit(context)),
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
          : BlocProvider(create: (context) => UserCoverCubit(context)),
      userPostCubit != null
          ? BlocProvider.value(value: userPostCubit)
          : BlocProvider(create: (context) => UserPostCubit(context)),
      feedHomeCubit != null
          ? BlocProvider.value(value: feedHomeCubit)
          : BlocProvider(create: (context) => FeedHomeCubit(context)),
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
  UserModel? user = args.findOrNull(key: "$UserModel");
  String? uid = user?.id ?? args.findOrNull(key: "uid") ?? args.findOrNull();
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
          ? BlocProvider.value(value: avatarsCubit..load())
          : BlocProvider(
            create: (context) => UserAvatarCubit(context, uid)..load(),
          ),
      coversCubit != null
          ? BlocProvider.value(value: coversCubit..load())
          : BlocProvider(
            create: (context) => UserCoverCubit(context, uid)..load(),
          ),
      userCubit != null
          ? BlocProvider.value(value: userCubit..load())
          : BlocProvider(create: (context) => UserCubit(context, uid)..load()),
      memoryCubit != null
          ? BlocProvider.value(value: memoryCubit..load())
          : BlocProvider(
            create: (context) => UserMemoryCubit(context, uid)..load(),
          ),
      noteCubit != null
          ? BlocProvider.value(value: noteCubit..load())
          : BlocProvider(
            create: (context) => UserNoteCubit(context, uid)..load(),
          ),
      photoCubit != null
          ? BlocProvider.value(value: photoCubit..load())
          : BlocProvider(
            create: (context) => UserPhotoCubit(context, uid)..load(),
          ),
      postCubit != null
          ? BlocProvider.value(
            value:
                postCubit
                  ..load()
                  ..loadCounter(),
          )
          : BlocProvider(
            create:
                (context) =>
                    UserPostCubit(context, uid)
                      ..load()
                      ..loadCounter(),
          ),
      storyCubit != null
          ? BlocProvider.value(value: storyCubit..load())
          : BlocProvider(
            create: (context) => UserStoryCubit(context, uid)..load(),
          ),
      videoCubit != null
          ? BlocProvider.value(value: videoCubit..load())
          : BlocProvider(
            create: (context) => UserVideoCubit(context, uid)..load(),
          ),
      reportCubit != null
          ? BlocProvider.value(value: reportCubit..loadCounter())
          : BlocProvider(
            create: (context) => UserReportCubit(context, uid)..loadCounter(),
          ),
      userFollowerCubit != null
          ? BlocProvider.value(value: userFollowerCubit..loadCounter())
          : BlocProvider(
            create: (context) => UserFollowerCubit(context, uid)..loadCounter(),
          ),
      userFollowingCubit != null
          ? BlocProvider.value(value: userFollowingCubit..loadCounter())
          : BlocProvider(
            create:
                (context) => UserFollowingCubit(context, uid)..loadCounter(),
          ),
    ],
    child: UserProfilePage(args: args),
  );
}

Widget _profileReports(BuildContext context, Object? args) {
  UserModel? user = args.findOrNull(key: "$UserModel");
  UserReportCubit? reportCubit = args.findOrNull(key: "$UserReportCubit");
  return MultiBlocProvider(
    providers: [
      reportCubit != null
          ? BlocProvider.value(value: reportCubit)
          : BlocProvider(
            create: (context) {
              return UserReportCubit(context, user?.id)..load();
            },
          ),
    ],
    child: UserReportsPage(args: args, user: user),
  );
}

Widget _profileFeeds(BuildContext context, Object? args) {
  UserModel? user = args.findOrNull(key: "$UserModel");
  String? uid = user?.id ?? args.findOrNull(key: "uid") ?? args.findOrNull();
  FeedHomeCubit? feedHomeCubit = args.findOrNull(key: "$FeedHomeCubit");
  UserPostCubit? postCubit = args.findOrNull(key: "$UserPostCubit");
  return MultiBlocProvider(
    providers: [
      feedHomeCubit != null
          ? BlocProvider.value(value: feedHomeCubit)
          : BlocProvider(create: (context) => FeedHomeCubit(context)),
      postCubit != null
          ? BlocProvider.value(value: postCubit)
          : BlocProvider(
            create: (context) => UserPostCubit(context, uid)..load(),
          ),
    ],
    child: UserPostsPage(args: args, user: user),
  );
}

Widget _profileFollowers(BuildContext context, Object? args) {
  UserModel? user = args.findOrNull(key: "$UserModel");
  UserFollowerCubit? followerCubit = args.findOrNull(key: "$UserFollowerCubit");
  return MultiBlocProvider(
    providers: [
      followerCubit != null
          ? BlocProvider.value(value: followerCubit)
          : BlocProvider(
            create: (context) {
              return UserFollowerCubit(context, user?.id)..load();
            },
          ),
    ],
    child: UserFollowersPage(args: args, user: user),
  );
}

Widget _profileFollowings(BuildContext context, Object? args) {
  UserModel? user = args.findOrNull(key: "$UserModel");
  UserFollowingCubit? followingCubit = args.findOrNull(
    key: "$UserFollowingCubit",
  );
  return MultiBlocProvider(
    providers: [
      followingCubit != null
          ? BlocProvider.value(value: followingCubit)
          : BlocProvider(
            create: (context) => UserFollowingCubit(context, user?.id),
          ),
    ],
    child: UserFollowingsPage(args: args, user: user),
  );
}
