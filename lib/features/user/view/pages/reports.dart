import 'package:app_dimen/app_dimen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_entity/entity.dart';

import '../../../../app/res/icons.dart';
import '../../../../app/widgets/complete_text.dart';
import '../../../../data/models/user.dart';
import '../../../../data/models/user_report.dart';
import '../../../../roots/widgets/appbar.dart';
import '../../../../roots/widgets/exception.dart';
import '../../../../roots/widgets/scaffold_shimmer.dart';
import '../cubits/report_cubit.dart';

class UserReportsPage extends StatelessWidget {
  final Object? args;
  final User? user;

  const UserReportsPage({super.key, this.args, this.user});

  @override
  Widget build(BuildContext context) {
    final dimen = context.dimens;
    return Scaffold(
      appBar: InAppAppbar(
        titleText:
            user != null ? "${user?.username ?? ""}'s reports" : "Reports",
      ),
      body: BlocBuilder<UserReportCubit, Response<UserReport>>(
        builder: (context, response) {
          if (response.isLoading) return InAppScaffoldShimmer();
          if (!response.isValid) {
            return Align(
              alignment: Alignment(0, -0.2),
              child: InAppException(
                "No reports yet!",
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
              return SizedBox();
              final item = response.result.elementAtOrNull(index);
              if (item == null) {
                // return const ItemFeedPlaceholder();
              } else {
                // return ItemUserPost(
                //   item: item,
                // );
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
