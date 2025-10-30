import 'package:app_color/app_color.dart';
import 'package:app_dimen/app_dimen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_andomie/core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:in_app_navigator/in_app_navigator.dart';

import '../../../../data/models/content.dart';
import '../../../../data/models/user_post.dart';
import '../../../../routes/paths.dart';
import '../cubits/post_cubit.dart';
import 'feed_body.dart';
import 'stared_feed_footer.dart';
import 'user_post_header.dart';

class ItemUserFeedPost extends StatefulWidget {
  final int index;
  final UserPost item;
  final Function(BuildContext context, UserPost item)? onClick;

  const ItemUserFeedPost({
    super.key,
    required this.index,
    required this.item,
    this.onClick,
  });

  @override
  State<ItemUserFeedPost> createState() => _ItemUserFeedPostState();
}

class _ItemUserFeedPostState extends State<ItemUserFeedPost> {
  late UserPost item = widget.item;

  Future<void> _translate() async {
    context.read<UserPostCubit>().translate(widget.index, item, (value) {
      setState(() => item = value);
    });
  }

  Future<void> _preview(int index) async {
    context.open(
      Routes.previewPhotos,
      arguments: {"$Content": item, "index": index},
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // if (!item.isTranslated && Settings.i.autoTranslationMode.use) {
    //   _translate();
    // }
  }

  @override
  Widget build(BuildContext context) {
    final dimen = context.dimens;
    final light = context.light;
    final description =
        item.isTranslated
            ? item.translatedDescription ?? item.description
            : item.description;
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(color: light),
      child: Column(
        children: [
          UserPostHeader(item: item, onTranslate: _translate),
          if (item.photos.use.isEmpty)
            Divider(height: 1, indent: dimen.dp(16), endIndent: dimen.dp(16)),
          UserFeedImageBody(
            description: description,
            photos: item.photos,
            onTap: _preview,
          ),
          SizedBox(height: dimen.dp(12)),
          UserStaredFeedFooter(
            id: item.id,
            path: item.path.use,
            likes: [],
            stars: [],
            comments: [],
            onLiked: (value) {
              context.read<UserPostCubit>().replace(widget.index, (e) => item);
            },
            onStared: (value) {
              context.read<UserPostCubit>().replace(widget.index, (e) => item);
            },
          ),
          SizedBox(height: dimen.dp(8)),
        ],
      ),
    );
  }
}
