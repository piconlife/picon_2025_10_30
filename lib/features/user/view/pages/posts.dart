import 'package:app_dimen/app_dimen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_entity/flutter_entity.dart';

import '../../../../app/res/icons.dart';
import '../../../../data/models/user.dart';
import '../../../../data/models/user_post.dart';
import '../../../../roots/widgets/appbar.dart';
import '../../../../roots/widgets/complete_text.dart';
import '../../../../roots/widgets/exception.dart';
import '../../../../roots/widgets/scaffold_shimmer.dart';
import '../cubits/post_cubit.dart';
import '../templates/item_feed.dart';
import '../templates/item_feed_placeholder.dart';

class UserPostsPage extends StatelessWidget {
  final Object? args;
  final User? user;

  const UserPostsPage({super.key, this.args, this.user});

  @override
  Widget build(BuildContext context) {
    final dimen = context.dimens;
    return Scaffold(
      appBar: InAppAppbar(
        titleText: user != null ? "${user?.username ?? ""}'s feeds" : "Feeds",
      ),
      body: BlocBuilder<UserPostCubit, Response<UserPost>>(
        builder: (context, response) {
          if (response.isLoading) return InAppScaffoldShimmer();
          if (!response.isValid) {
            return Align(
              alignment: Alignment(0, -0.2),
              child: InAppException(
                "No posts yet!",
                icon: InAppIcons.quillPen.regular,
                spaceBetween: dimen.dp(24),
              ),
            );
          }
          final isComplete = response.result.isNotEmpty && response.isNullable;
          return ListView.separated(
            itemCount: response.result.length + (isComplete ? 1 : 0),
            itemBuilder: (context, index) {
              if (isComplete && index == response.result.length) {
                return InAppCompleteText();
              }
              final item = response.result.elementAtOrNull(index);
              if (item == null) {
                return const ItemUserFeedPlaceholder();
              } else {
                return ItemUserFeed(item: item);
              }
            },
            separatorBuilder: (context, index) {
              return SizedBox(height: dimen.dp(4));
            },
          );
        },
      ),
    );
  }
}
