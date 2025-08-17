import 'package:app_color/app_color.dart';
import 'package:app_color/extension.dart';
import 'package:app_dimen/app_dimen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_entity/flutter_entity.dart';
import 'package:in_app_navigator/in_app_navigator.dart';

import '../../../../../data/enums/feed_type.dart';
import '../../../../../data/models/feed.dart';
import '../../../../../routes/paths.dart';
import '../../../../app/res/icons.dart';
import '../../../../roots/widgets/scaffold_shimmer.dart';
import '../../../../roots/widgets/text.dart';
import '../cubits/verified_feed_cubit.dart';
import '../templates/item_feed.dart';
import '../templates/nullable_body.dart';

class FeedVerifiedPage extends StatelessWidget {
  const FeedVerifiedPage({super.key});

  @override
  Widget build(BuildContext context) {
    final dimen = context.dimens;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: BlocBuilder<VerifiedFeedCubit, Response<Feed>>(
        buildWhen: (previous, current) => current.requestCode == 0,
        builder: (context, state) {
          final result = state.result;
          if (result.isEmpty && state.status.isLoading) {
            return const InAppScaffoldShimmer();
          }
          if (result.isEmpty && state.status.isResultNotFound) {
            return InAppNullableBody(
              icon: InAppIcons.write.solid,
              header: "No posts yet",
              body: "Currently no posts available.",
              buttonText: "Take a new post",
              onButtonClick: () =>
                  context.open(Routes.createUserPost, arguments: FeedType.post),
            );
          }

          return ListView.separated(
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
              return ItemFeed(item: result.elementAt(index));
            },
            separatorBuilder: (context, index) => SizedBox(height: dimen.dp(4)),
            itemCount: result.length,
          );
        },
      ),
    );
  }
}
