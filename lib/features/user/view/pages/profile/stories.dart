import 'package:app_color/app_color.dart';
import 'package:app_color/extension.dart';
import 'package:app_dimen/app_dimen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_entity/entity.dart';
import 'package:in_app_navigator/route.dart';

import '../../../../../app/helpers/user.dart';
import '../../../../../app/res/icons.dart';
import '../../../../../data/enums/feed_type.dart';
import '../../../../../data/models/user_memory.dart';
import '../../../../../roots/widgets/scaffold_shimmer.dart';
import '../../../../../roots/widgets/text.dart';
import '../../../../../routes/paths.dart';
import '../../cubits/memory_cubit.dart';
import '../../templates/nullable_body.dart';

class ProfileStoriesSegment extends StatefulWidget {
  final String? uid;

  const ProfileStoriesSegment({super.key, this.uid});

  @override
  State<ProfileStoriesSegment> createState() => _ProfileStoriesSegmentState();
}

class _ProfileStoriesSegmentState extends State<ProfileStoriesSegment> {
  @override
  Widget build(BuildContext context) {
    final dimen = context.dimens;
    final isCurrentUser = UserHelper.isCurrentUser(widget.uid);
    return BlocBuilder<UserMemoryCubit, Response<MemoryModel>>(
      buildWhen: (previous, current) => current.requestCode == 0,
      builder: (context, state) {
        final result = state.result;
        if (result.isEmpty && state.status.isLoading) {
          return InAppScaffoldShimmer();
        }
        if (result.isEmpty && state.status.isResultNotFound) {
          return UserNullableBody(
            contentSpacing: 8,
            icon:
                isCurrentUser
                    ? InAppIcons.write.solid
                    : InAppIcons.feedPublic.regular,
            iconColor: isCurrentUser ? null : context.dark.t25,
            header: "No stories yet",
            body: "Currently no stories available.",
            buttonText: isCurrentUser ? "Create a new story" : null,
            onButtonClick:
                () => context.open(
                  Routes.createAMemory,
                  args: {"$FeedType": FeedType.memory},
                ),
          );
        }

        return ListView.separated(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
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
            // final item = result.elementAt(index);
            return const SizedBox();
          },
          separatorBuilder: (context, index) {
            return SizedBox(height: dimen.dp(4));
          },
          itemCount: result.length,
        );
      },
    );
  }
}
