import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:in_app_navigator/in_app_navigator.dart';

import '../../data/models/user.dart';
import '../../routes/paths.dart';
import '../social/data/cubits/feed_home_cubit.dart';
import 'view/cubits/avatar_cubit.dart';
import 'view/cubits/bookmark_cubit.dart';
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

extension UserRouteHelper on BuildContext {
  Future<void> openUserProfile({String? uid, UserModel? user}) async {
    open(
      Routes.userProfile,
      args: {
        "uid": uid,
        "$UserModel": user,
        "$FeedHomeCubit": read<FeedHomeCubit>(),
        "$UserCubit": read<UserCubit>(),
        "$UserBookmarkCubit": read<UserBookmarkCubit>(),
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
