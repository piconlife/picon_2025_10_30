import 'package:app_color/app_color.dart';
import 'package:app_color/extension.dart';
import 'package:app_dimen/app_dimen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_entity/entity.dart';
import 'package:in_app_navigator/in_app_navigator.dart';

import '../../../../../app/helpers/user.dart';
import '../../../../../app/res/icons.dart';
import '../../../../../data/enums/feed_type.dart';
import '../../../../../data/models/user_note.dart';
import '../../../../../roots/widgets/scaffold_shimmer.dart';
import '../../../../../roots/widgets/text.dart';
import '../../../../../routes/paths.dart';
import '../../cubits/note_cubit.dart';
import '../../templates/nullable_body.dart';

class ProfileNotesSegment extends StatefulWidget {
  final String? uid;

  const ProfileNotesSegment({super.key, this.uid});

  @override
  State<ProfileNotesSegment> createState() => _ProfileNotesSegmentState();
}

class _ProfileNotesSegmentState extends State<ProfileNotesSegment> {
  @override
  Widget build(BuildContext context) {
    final dimen = context.dimens;
    final isCurrentUser = UserHelper.isCurrentUser(widget.uid);
    return BlocBuilder<UserNoteCubit, Response<UserNote>>(
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
                : InAppIcons.notes.regular,
            iconColor: isCurrentUser ? null : context.dark.t25,
            header: "No notes yet",
            body: "Currently no notes available.",
            buttonText: isCurrentUser ? "Create a new note" : null,
            onButtonClick: () => context.open(
              Routes.createANote,
              arguments: {"$FeedType": FeedType.note},
            ),
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
            // final item = result.elementAt(index);
            return const SizedBox();
          },
          itemCount: result.length,
        );
      },
    );
  }
}
