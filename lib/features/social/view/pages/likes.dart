import 'package:app_color/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_entity/entity.dart';

import '../../../../app/res/icons.dart';
import '../../../../data/models/feed_like.dart';
import '../../../../data/models/user.dart';
import '../../../../roots/widgets/appbar.dart';
import '../../../../roots/widgets/error.dart';
import '../../../../roots/widgets/scaffold_shimmer.dart';
import '../../../../roots/widgets/screen.dart';
import '../cubits/like_cubit.dart';
import '../templates/item_feed_like.dart';

class LikesPage extends StatefulWidget {
  final Object? args;
  final User? user;

  const LikesPage({super.key, this.args, this.user});

  @override
  State<LikesPage> createState() => _LikesPageState();
}

class _LikesPageState extends State<LikesPage> with ColorMixin {
  late final cubit = context.read<FeedLikeCubit>();

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
    return InAppScreen(
      theme: ThemeType.secondary,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: InAppAppbar(titleText: "Likes"),
        body: BlocBuilder<FeedLikeCubit, Response<FeedLike>>(
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
                return ItemFeedLike(data: item);
              },
            );
          },
        ),
      ),
    );
  }
}
