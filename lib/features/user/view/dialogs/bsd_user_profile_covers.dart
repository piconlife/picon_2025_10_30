import 'package:app_color/app_color.dart';
import 'package:app_color/extension.dart';
import 'package:app_dimen/app_dimen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_andomie/extensions/string.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_entity/flutter_entity.dart';
import 'package:in_app_navigator/in_app_navigator.dart';

import '../../../../app/res/icons.dart';
import '../../../../data/models/user.dart';
import '../../../../data/models/user_cover.dart';
import '../../../../roots/widgets/dialog_header.dart';
import '../../../../roots/widgets/gesture.dart';
import '../../../../roots/widgets/icon.dart';
import '../../../../roots/widgets/image.dart';
import '../../../../roots/widgets/scaffold_shimmer.dart';
import '../../../../roots/widgets/text.dart';
import '../cubits/cover_cubit.dart';

class UserProfileCoversBSD extends StatelessWidget {
  final String activeUrl;

  const UserProfileCoversBSD({super.key, required this.activeUrl});

  static Future show(BuildContext context, User user) {
    final cubit = context.read<UserCoverCubit?>();
    return showModalBottomSheet(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      builder: (context) {
        final child = UserProfileCoversBSD(activeUrl: user.coverPhoto.use);
        if (cubit != null) {
          return BlocProvider.value(value: cubit, child: child);
        }
        return BlocProvider(
          create: (context) => UserCoverCubit()..fetch(),
          child: child,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final dimen = context.dimens;
    final dark = context.dark;
    return BlocBuilder<UserCoverCubit, Response<UserCover>>(
      builder: (context, state) {
        return Container(
          width: double.infinity,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: context.dialogColor.primary,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(dimen.dp(20)),
              topRight: Radius.circular(dimen.dp(20)),
            ),
            boxShadow: [
              BoxShadow(color: context.mid.t05, blurRadius: dimen.dp(50)),
            ],
          ),
          child: DraggableScrollableSheet(
            expand: false,
            snap: true,
            builder: (context, controller) {
              return Column(
                children: [
                  const InAppDialogHeader("Choose cover photo"),
                  Divider(height: dimen.dp(1), color: context.dark.t05),
                  Expanded(
                    child: Builder(
                      builder: (context) {
                        if (state.result.isEmpty) {
                          if (state.status.isLoading) {
                            return InAppScaffoldShimmer();
                          } else {
                            return Center(
                              child: InAppText(
                                "No cover photos found!",
                                style: TextStyle(
                                  color: dark.t50,
                                  fontSize: dimen.dp(14),
                                ),
                              ),
                            );
                          }
                        }

                        return GridView.builder(
                          controller: controller,
                          itemCount: state.result.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                childAspectRatio: 1 / 1.2,
                                crossAxisSpacing: dimen.dp(2),
                                mainAxisSpacing: dimen.dp(2),
                              ),
                          padding: EdgeInsets.only(bottom: dimen.dp(50)),
                          itemBuilder: (context, index) {
                            final item = state.result.elementAtOrNull(index);
                            final isActivated = item?.photo == activeUrl;
                            return Stack(
                              fit: StackFit.expand,
                              children: [
                                InAppGesture(
                                  onTap: () => context.close(result: item),
                                  child: ColoredBox(
                                    color: dark.t05,
                                    child: InAppImage(
                                      item?.photo,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                if (isActivated) ...[
                                  ColoredBox(color: dark.t25),
                                  Padding(
                                    padding: EdgeInsets.all(dimen.dp(8)),
                                    child: InAppIcon(
                                      InAppIcons.nativeCheckMark.regular,
                                      color: context.light,
                                    ),
                                  ),
                                ],
                              ],
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}
