import 'package:app_color/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_entity/entity.dart';
import 'package:in_app_navigator/route.dart';

import '../../../../app/base/data_cubit.dart';
import '../../../../app/res/icons.dart';
import '../../../../data/models/like.dart';
import '../../../../data/models/user.dart';
import '../../../../roots/widgets/appbar.dart';
import '../../../../roots/widgets/body.dart';
import '../../../../roots/widgets/column.dart';
import '../../../../roots/widgets/error.dart';
import '../../../../roots/widgets/gesture.dart';
import '../../../../roots/widgets/icon.dart';
import '../../../../roots/widgets/image.dart';
import '../../../../roots/widgets/row.dart';
import '../../../../roots/widgets/scaffold_shimmer.dart';
import '../../../../roots/widgets/text.dart';
import '../../../../roots/widgets/user_builder.dart';
import '../../../../routes/paths.dart';
import '../../data/cubits/like_cubit.dart';
import '../widgets/follow_button.dart';

class LikesPage extends StatefulWidget {
  final Object? args;
  final UserModel? user;

  const LikesPage({super.key, this.args, this.user});

  static Future<void> open(BuildContext context) async {
    context.open(
      Routes.likes,
      args: {"$LikeCubit": DataCubit.of<LikeCubit>(context)},
    );
  }

  @override
  State<LikesPage> createState() => _LikesPageState();
}

class _LikesPageState extends State<LikesPage> with ColorMixin {
  late final cubit = context.read<LikeCubit>();

  final int initialSize = 25;
  final int fetchingSize = 50;

  void _fetch() {
    cubit.fetch(initialSize: initialSize, fetchingSize: fetchingSize);
  }

  void _refresh() {
    cubit.refresh(initialSize: initialSize, fetchingSize: fetchingSize);
  }

  @override
  Widget build(BuildContext context) {
    return InAppBody(
      theme: ThemeType.secondary,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: InAppAppbar(titleText: "Likes"),
        body: BlocBuilder<LikeCubit, Response<LikeModel>>(
          builder: (context, response) {
            if (response.isLoading) {
              return InAppScaffoldShimmer();
            }
            if (response.isInternetError || !response.isValid) {
              return InAppError(
                alignment: InAppErrorProperties.all(Alignment(0, -0.2)),
                type:
                    response.isInternetError
                        ? InAppErrorType.internet
                        : InAppErrorType.nullable,
                iconData: InAppErrorProperties(
                  nullable: InAppIcons.heart.regular,
                ),
                bodyText: InAppErrorProperties(nullable: "No hearts yet"),
                onRetry: InAppErrorProperties(internet: _refresh),
              );
            }
            return ListView.builder(
              itemCount: response.result.length,
              itemBuilder: (context, index) {
                final item = response.result.elementAt(index);
                return _buildItem(item);
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildItem(LikeModel item) {
    return InAppUserBuilder(
      id: item.id,
      builder: (context, user) {
        return Container(
          width: double.infinity,
          color: light,
          padding: EdgeInsets.all(12),
          child: InAppRow(
            spacing: 8,
            children: [
              SizedBox.square(
                dimension: 50,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    InAppGesture(
                      onTap: () {},
                      child: Container(
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                          color: dark.withValues(alpha: 0.05),
                          shape: BoxShape.circle,
                        ),
                        margin: EdgeInsets.only(right: 2, bottom: 2),
                        child: InAppImage(user.avatar, fit: BoxFit.cover),
                      ),
                    ),
                    if (user.isHeartUser || user.isCelebrityUser)
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          width: 20,
                          height: 20,
                          alignment: Alignment.center,
                          padding: EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: light,
                          ),
                          child: InAppIcon(
                            (user.isHeartUser
                                    ? InAppIcons.heart
                                    : InAppIcons.star)
                                .solid,
                            size: 18,
                            color:
                                user.isHeartUser
                                    ? context.red
                                    : context.primary,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              Expanded(
                child: InAppColumn(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if ((user.protectedName ?? '').isNotEmpty)
                      InAppText(
                        user.protectedName ?? user.username,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: TextStyle(
                          color: dark,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    InAppText(
                      user.username,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: TextStyle(
                        color: dark.withValues(alpha: 0.5),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              InAppFollowBuilder(
                publisher: item.publisher,
                builder: (context, selected, callback) {
                  return InAppGesture(
                    onTap: callback,
                    child: Container(
                      width: 90,
                      height: 35,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color:
                            selected
                                ? secondary.withValues(alpha: 0.1)
                                : secondary,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child:
                          selected
                              ? InAppIcon(Icons.check, color: secondary)
                              : InAppText(
                                'Follow',
                                style: TextStyle(
                                  color: lightAsFixed,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
