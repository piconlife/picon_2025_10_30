import 'package:app_color/app_color.dart';
import 'package:app_color/extension.dart';
import 'package:app_dimen/app_dimen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_andomie/models/selection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_entity/flutter_entity.dart';
import 'package:in_app_navigator/in_app_navigator.dart';

import '../../../../../data/enums/feed_type.dart';
import '../../../../../data/models/user.dart';
import '../../../../../routes/paths.dart';
import '../../../../app/res/icons.dart';
import '../../../../roots/widgets/scaffold_shimmer.dart';
import '../../../../roots/widgets/text.dart';
import '../cubits/verified_users_cubit.dart';
import '../templates/item_user_verified.dart';
import '../templates/nullable_body.dart';

class FeedVerifierPage extends StatelessWidget {
  const FeedVerifierPage({super.key});

  @override
  Widget build(BuildContext context) {
    final dimen = context.dimens;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: BlocBuilder<VerifiedUsersCubit, Response<Selection<User>>>(
        builder: (context, state) {
          final result = state.result;
          if (result.isEmpty && state.status.isLoading) {
            return const InAppScaffoldShimmer();
          }
          if (state.result.isEmpty && state.status.isFailure) {
            return InAppNullableBody(
              icon: InAppIcons.following.solid,
              header: "No friends yet",
              body: "Currently no friends yet.",
              buttonText: "Make a friends",
              onButtonClick:
                  () => context.open(
                    Routes.createUserPost,
                    arguments: FeedType.post,
                  ),
            );
          }
          if (result.isEmpty && state.status.isResultNotFound) {
            return InAppNullableBody(
              icon: InAppIcons.write.solid,
              header: "No friends yet",
              body: "Currently no friends yet.",
              buttonText: "Make a friends",
              onButtonClick:
                  () => context.open(
                    Routes.createUserPost,
                    arguments: FeedType.post,
                  ),
            );
          }

          return ListView.builder(
            shrinkWrap: true,
            itemBuilder: (context, index) {
              final item = result.elementAt(index);
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
              return ItemVerifiedUser(
                selection: item,
                onFollow:
                    () => context.read<VerifiedUsersCubit>().update(
                      context,
                      item.reverse,
                    ),
              );
            },
            itemCount: result.length,
          );
        },
      ),
    );
  }
}
