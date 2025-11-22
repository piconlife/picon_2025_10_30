import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:in_app_cache/in_app_cache.dart';

import '../../../../data/enums/feed_type.dart';
import '../../../../data/models/feed.dart';
import '../../../../data/models/view.dart';
import '../../data/cubits/like_cubit.dart';
import '../../data/cubits/star_cubit.dart';
import '../../data/cubits/view_cubit.dart';
import '../cubits/comment_cubit.dart';
import 'item_feed_ads.dart';
import 'item_feed_avatar.dart';
import 'item_feed_business.dart';
import 'item_feed_cover.dart';
import 'item_feed_memory.dart';
import 'item_feed_note.dart';
import 'item_feed_post.dart';
import 'item_feed_sponsored.dart';
import 'item_feed_video.dart';

class ItemFeed extends StatefulWidget {
  final int index;
  final Feed item;

  const ItemFeed({super.key, required this.index, required this.item});

  @override
  State<ItemFeed> createState() => _ItemFeedState();
}

class _ItemFeedState extends State<ItemFeed> {
  String path = '';
  late LikeCubit likeCubit;
  late StarCubit starCubit;
  late ViewCubit viewCubit;
  late CommentCubit commentCubit;

  void _init() {
    final path = widget.item.contentPath;
    if (path == null || path.isEmpty) return;
    this.path = path;
    likeCubit = Cache.put("like_cubit[$path]", () {
      return LikeCubit(context, path, initialCount: widget.item.likeCount)
        ..loadCounter()
        ..load(resultByMe: true);
    });
    starCubit = Cache.put("star_cubit[$path]", () {
      return StarCubit(context, path, initialCount: widget.item.starCount)
        ..loadCounter()
        ..load(resultByMe: true);
    });
    viewCubit = Cache.put("view_cubit[$path]", () {
      return ViewCubit(context, path, initialCount: widget.item.viewCount)
        ..loadCounter()
        ..load(resultByMe: true);
    });
    commentCubit = Cache.put("comment_cubit[$path]", () {
      return CommentCubit(context, path, initialCount: widget.item.commentCount)
        ..loadCounter();
    });
  }

  void _seen(_) {
    viewCubit.seen(ViewModel.create(parentPath: path));
  }

  @override
  void initState() {
    super.initState();
    _init();
    WidgetsBinding.instance.addPostFrameCallback(_seen);
  }

  @override
  void didUpdateWidget(covariant ItemFeed oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.item != oldWidget.item) {
      _init();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (path.isEmpty) return SizedBox.shrink();
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: likeCubit),
        BlocProvider.value(value: starCubit),
        BlocProvider.value(value: viewCubit),
        BlocProvider.value(value: commentCubit),
      ],
      child: _buildLayout(context),
    );
  }

  Widget _buildLayout(BuildContext context) {
    switch (widget.item.type) {
      case FeedType.none:
      case FeedType.photo:
      case FeedType.post:
        return ItemFeedPost(index: widget.index, item: widget.item);
      case FeedType.ads:
        return ItemFeedAds(index: widget.index, item: widget.item);
      case FeedType.avatar:
        return ItemFeedAvatar(index: widget.index, item: widget.item);
      case FeedType.business:
        return ItemFeedBusiness(index: widget.index, item: widget.item);
      case FeedType.cover:
        return ItemFeedCover(index: widget.index, item: widget.item);
      case FeedType.note:
        return ItemFeedNote(index: widget.index, item: widget.item);
      case FeedType.sponsored:
        return ItemFeedSponsored(index: widget.index, item: widget.item);
      case FeedType.memory:
        return ItemFeedMemory(index: widget.index, item: widget.item);
      case FeedType.video:
        return ItemFeedVideo(index: widget.index, item: widget.item);
    }
  }
}
