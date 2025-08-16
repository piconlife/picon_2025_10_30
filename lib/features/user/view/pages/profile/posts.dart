import 'package:app_color/app_color.dart';
import 'package:app_color/extension.dart';
import 'package:app_dimen/app_dimen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_andomie/extensions/spacing.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_entity/entity.dart';
import 'package:in_app_navigator/in_app_navigator.dart';

import '../../../../../app/helpers/user.dart';
import '../../../../../app/res/icons.dart';
import '../../../../../data/enums/content.dart';
import '../../../../../data/models/user_post.dart';
import '../../../../../roots/widgets/scaffold_shimmer.dart';
import '../../../../../roots/widgets/text.dart';
import '../../../../../routes/paths.dart';
import '../../cubits/post_cubit.dart';
import '../../templates/item_feed.dart';
import '../../templates/item_feed_placeholder.dart';
import '../../templates/nullable_body.dart';

class ProfilePostsSegment extends StatefulWidget {
  final String? uid;

  const ProfilePostsSegment({super.key, this.uid});

  @override
  State<ProfilePostsSegment> createState() => _ProfilePostsSegmentState();
}

class _ProfilePostsSegmentState extends State<ProfilePostsSegment> {
  @override
  Widget build(BuildContext context) {
    final dimen = context.dimens;
    final dark = context.dark;
    final isCurrentUser = UserHelper.isCurrentUser(widget.uid);
    return BlocBuilder<UserPostCubit, Response<UserPost>>(
      buildWhen: (previous, current) => current.requestCode == 0,
      builder: (context, state) {
        final result = state.result;
        if (result.isEmpty && state.status.isLoading) {
          return InAppScaffoldShimmer();
        }
        if (result.isEmpty && state.status.isResultNotFound) {
          return UserNullableBody(
            contentSpacing: 8,
            icon: isCurrentUser
                ? InAppIcons.write.solid
                : InAppIcons.feedPublic.regular,
            iconColor: isCurrentUser ? null : dark.t25,
            header: "No posts yet",
            body: "Currently no posts available.",
            buttonText: isCurrentUser ? "Take a new post" : null,
            onButtonClick: () => context.open(
              Routes.createUserPost,
              arguments: {"$ContentType": ContentType.post},
            ),
          );
        }

        return ListView.separated(
          shrinkWrap: true,
          padding: EdgeInsets.only(top: dimen.dp(4), bottom: dimen.dp(100)),
          itemBuilder: (context, index) {
            if (state.status.isResultNotFound) {
              return Center(
                child: Padding(
                  padding: EdgeInsets.all(dimen.dp(12)),
                  child: InAppText(
                    "COMPLETE",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: context.dark.t25),
                  ),
                ),
              );
            }
            final item = result.elementAtOrNull(index);
            if (item == null) {
              return const ItemUserFeedPlaceholder();
            } else {
              return ItemUserFeed(item: item);
            }
          },
          separatorBuilder: (context, index) {
            return dimen.dp(4).h;
          },
          itemCount: result.length,
        );
      },
    );
  }
}
