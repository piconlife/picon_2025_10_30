import 'package:app_dimen/app_dimen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_entity/entity.dart';

import '../../../../app/res/icons.dart';
import '../../../../data/models/user.dart';
import '../../../../data/models/user_following.dart';
import '../../../../roots/widgets/appbar.dart';
import '../../../../roots/widgets/exception.dart';
import '../../../../roots/widgets/scaffold_shimmer.dart';
import '../cubits/following_cubit.dart';
import '../templates/item_user_following.dart';

class UserFollowingsPage extends StatefulWidget {
  final Object? args;
  final User? user;

  const UserFollowingsPage({super.key, this.args, this.user});

  @override
  State<UserFollowingsPage> createState() => _UserFollowingsPageState();
}

class _UserFollowingsPageState extends State<UserFollowingsPage> {
  @override
  Widget build(BuildContext context) {
    final dimen = context.dimens;
    return Scaffold(
      appBar: InAppAppbar(
        titleText:
            widget.user != null
                ? "${widget.user?.username ?? ""}'s followings"
                : "Followings",
      ),
      body: BlocBuilder<UserFollowingCubit, Response<UserFollowing>>(
        builder: (context, response) {
          if (response.isLoading) {
            return InAppScaffoldShimmer();
          }
          if (!response.isValid) {
            return Align(
              alignment: Alignment(0, -0.2),
              child: InAppException(
                "No followings yet!",
                icon: InAppIcons.following.regular,
                spaceBetween: dimen.dp(24),
                iconAdjustment: EdgeInsets.only(left: dimen.dp(16)),
              ),
            );
          }
          return ListView.builder(
            itemCount: response.result.length,
            itemBuilder: (context, index) {
              final item = response.result.elementAt(index);
              return ItemUserFollowing(data: item);
            },
          );
        },
      ),
    );
  }
}
