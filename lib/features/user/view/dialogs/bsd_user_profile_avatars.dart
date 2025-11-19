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
import '../../../../data/models/user_avatar.dart';
import '../../../../roots/widgets/avatar.dart';
import '../../../../roots/widgets/dialog_header.dart';
import '../../../../roots/widgets/icon.dart';
import '../../../../roots/widgets/scaffold_shimmer.dart';
import '../../../../roots/widgets/text.dart';
import '../cubits/avatar_cubit.dart';

class UserProfileAvatarsBSD extends StatelessWidget {
  final String activeUrl;

  const UserProfileAvatarsBSD({super.key, required this.activeUrl});

  static Future show(BuildContext context, User user) {
    final cubit = context.read<UserAvatarCubit?>();
    return showModalBottomSheet(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      builder: (context) {
        final child = UserProfileAvatarsBSD(activeUrl: user.avatar.use);
        if (cubit != null) {
          return BlocProvider.value(value: cubit, child: child);
        }
        return BlocProvider(
          create: (context) => UserAvatarCubit(context)..load(),
          child: child,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final dimen = context.dimens;
    final dark = context.dark;
    return BlocBuilder<UserAvatarCubit, Response<UserAvatar>>(
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
                  ColoredBox(
                    color: dark.t05,
                    child: const InAppDialogHeader("Choose avatar"),
                  ),
                  Expanded(
                    child: Builder(
                      builder: (context) {
                        if (state.result.isEmpty) {
                          if (state.status.isLoading) {
                            return InAppScaffoldShimmer();
                          } else {
                            return Center(
                              child: InAppText(
                                "No avatar found!",
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
                                crossAxisCount: 4,
                                crossAxisSpacing: dimen.dp(32),
                                mainAxisSpacing: dimen.dp(32),
                              ),
                          padding: EdgeInsets.only(
                            left: dimen.dp(16),
                            right: dimen.dp(16),
                            top: dimen.dp(16),
                            bottom: dimen.dp(50),
                          ),
                          itemBuilder: (context, index) {
                            final item = state.result.elementAtOrNull(index);
                            final photoUrl = item?.photoUrl;
                            final isActivated = photoUrl == activeUrl;
                            return Stack(
                              fit: StackFit.expand,
                              children: [
                                InAppAvatar(
                                  photoUrl,
                                  backgroundColor: dark.t05,
                                  onTap: () => context.close(result: item),
                                ),
                                if (isActivated) ...[
                                  DecoratedBox(
                                    decoration: BoxDecoration(
                                      color: dark.t25,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
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
