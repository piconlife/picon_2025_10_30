import 'package:flutter/material.dart';
import 'package:flutter_andomie/extensions/object.dart';
import 'package:flutter_app_navigator/app_navigator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../routes/paths.dart';
import '../social/view/cubits/follower_cubit.dart';
import 'view/pages/profile.dart';

Map<String, RouteBuilder> get mProfileRoutes {
  return {Routes.profile: _profile};
}

Widget _profile(BuildContext context, Object? args) {
  FollowerCubit? followerCubit = args.findOrNull(key: "$FollowerCubit");
  return MultiBlocProvider(
    providers: [
      if (followerCubit != null) BlocProvider.value(value: followerCubit),
    ],
    child: const ProfilePage(),
  );
}
