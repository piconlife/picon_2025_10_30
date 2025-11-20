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
import '../../../../../data/models/user_video.dart';
import '../../../../../roots/widgets/scaffold_shimmer.dart';
import '../../../../../roots/widgets/text.dart';
import '../../../../../routes/paths.dart';
import '../../cubits/video_cubit.dart';
import '../../templates/nullable_body.dart';

class ProfileVideosSegment extends StatefulWidget {
  final String? uid;

  const ProfileVideosSegment({super.key, this.uid});

  @override
  State<ProfileVideosSegment> createState() => _ProfileVideosSegmentState();
}

class _ProfileVideosSegmentState extends State<ProfileVideosSegment> {
  @override
  Widget build(BuildContext context) {
    final dimen = context.dimens;
    final isCurrentUser = UserHelper.isCurrentUser(widget.uid);
    return BlocBuilder<UserVideoCubit, Response<UserVideo>>(
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
            header: "No videos yet",
            body: "Currently no videos available.",
            buttonText: isCurrentUser ? "Upload a video" : null,
            onButtonClick:
                () => context.open(
                  Routes.createAVideo,
                  args: {"$FeedType": FeedType.video},
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
