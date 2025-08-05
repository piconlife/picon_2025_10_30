import 'package:app_dimen/app_dimen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_andomie/core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_entity/entity.dart';

import '../../../../app/res/icons.dart';
import '../../../../data/models/user.dart';
import '../../../../data/models/user_follower.dart';
import '../../../../roots/widgets/appbar.dart';
import '../../../../roots/widgets/exception.dart';
import '../../../../roots/widgets/scaffold_shimmer.dart';
import '../cubits/follower_cubit.dart';
import '../templates/item_user_follower.dart';

class UserFollowersPage extends StatefulWidget {
  final Object? args;
  final User? user;

  const UserFollowersPage({super.key, this.args, this.user});

  @override
  State<UserFollowersPage> createState() => _UserFollowersPageState();
}

class _UserFollowersPageState extends State<UserFollowersPage> {
  @override
  Widget build(BuildContext context) {
    final dimen = context.dimens;
    return Scaffold(
      appBar: InAppAppbar(
        titleText: widget.user != null
            ? "${widget.user?.username ?? ""}'s followers"
            : "Followers",
      ),
      body: BlocBuilder<UserFollowerCubit, Response<Selection<UserFollower>>>(
        builder: (context, response) {
          if (response.isLoading) {
            return InAppScaffoldShimmer();
          }
          if (!response.isValid) {
            return Align(
              alignment: Alignment(0, -0.2),
              child: InAppException(
                "No followers yet!",
                icon: InAppIcons.followers.regular,
                spaceBetween: dimen.dp(24),
              ),
            );
          }
          return ListView.builder(
            itemCount: response.result.length,
            itemBuilder: (context, index) {
              final item = response.result.elementAt(index);
              return ItemUserFollower(selection: item);
            },
          );
        },
      ),
    );
  }
}
