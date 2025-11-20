import 'package:app_color/app_color.dart';
import 'package:app_color/extension.dart';
import 'package:app_dimen/app_dimen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_andomie/extensions.dart';
import 'package:flutter_andomie/extensions/list.dart';
import 'package:flutter_androssy_dialogs/dialogs.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_entity/entity.dart';
import 'package:in_app_navigator/route.dart';

import '../../../../../app/helpers/user.dart';
import '../../../../../app/res/icons.dart';
import '../../../../../data/enums/feed_type.dart';
import '../../../../../data/models/user_post.dart';
import '../../../../../roots/utils/image_provider.dart';
import '../../../../../roots/widgets/image.dart';
import '../../../../../roots/widgets/scaffold_shimmer.dart';
import '../../../../../roots/widgets/text.dart';
import '../../../../../routes/paths.dart';
import '../../cubits/photo_cubit.dart';
import '../../templates/nullable_body.dart';

class ProfilePhotosSegment extends StatefulWidget {
  final String? uid;

  const ProfilePhotosSegment({super.key, this.uid});

  @override
  State<ProfilePhotosSegment> createState() => _ProfilePhotosSegmentState();
}

class _ProfilePhotosSegmentState extends State<ProfilePhotosSegment> {
  void _choose(BuildContext context) async {
    final feedback = await context.open(Routes.choosePhoto);
    if (!context.mounted) return;
    if (feedback is! EditablePhotoFeedback || feedback.isEmpty) {
      context.showWarningSnackBar("No photos selected!");
      return;
    }
    context.open(
      Routes.createUserPost,
      args: {"$FeedType": FeedType.photo, "$EditablePhotoFeedback": feedback},
    );
  }

  @override
  Widget build(BuildContext context) {
    final dimen = context.dimens;
    final isCurrentUser = UserHelper.isCurrentUser(widget.uid);
    return BlocBuilder<UserPhotoCubit, Response<UserPost>>(
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
                    : InAppIcons.gallery.regular,
            iconColor: isCurrentUser ? null : context.dark.t25,
            header: "No photos yet",
            body: "Currently no photos available.",
            buttonText: isCurrentUser ? "Upload a photo" : null,
            onButtonClick: () => _choose(context),
          );
        }

        return GridView.builder(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 4,
            mainAxisSpacing: 4,
          ),
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
            final item = result.elementAt(index);
            return Container(
              color: context.dark.t05,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  InAppImage(
                    item.photoUrl,
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  if (item.photoUrls.use.length > 1)
                    Positioned(
                      bottom: 12,
                      right: 12,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black38,
                          borderRadius: BorderRadius.circular(dimen.dp(6)),
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: dimen.dp(8),
                          vertical: dimen.dp(2),
                        ),
                        child: InAppText(
                          item.photoUrls?.length.toString(),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: dimen.dp(12),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
          itemCount: result.length,
        );
      },
    );
  }
}
