import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:in_app_cache/in_app_cache.dart';

import '../../../../data/enums/feed_type.dart';
import '../../../../data/models/feed.dart';
import '../cubits/comment_cubit.dart';
import '../cubits/like_cubit.dart';
import '../cubits/star_cubit.dart';
import 'item_feed_ads.dart';
import 'item_feed_avatar.dart';
import 'item_feed_business.dart';
import 'item_feed_cover.dart';
import 'item_feed_memory.dart';
import 'item_feed_note.dart';
import 'item_feed_post.dart';
import 'item_feed_sponsored.dart';
import 'item_feed_video.dart';

class ItemFeed extends StatelessWidget {
  final int index;
  final Feed item;

  const ItemFeed({super.key, required this.index, required this.item});

  @override
  Widget build(BuildContext context) {
    final path = item.content.path;
    if (path == null || path.isEmpty) return const SizedBox.shrink();

    FeedLikeCubit likeCubit = Cache.put("like_cubit[$path]", () {
      return FeedLikeCubit(path, initialCount: item.likeCount)
        ..count()
        ..fetchByMe();
    });
    FeedStarCubit starCubit = Cache.put("star_cubit[$path]", () {
      return FeedStarCubit(path, initialCount: item.starCount)
        ..count()
        ..fetchByMe();
    });
    FeedCommentCubit commentCubit = Cache.put("comment_cubit[$path]", () {
      return FeedCommentCubit(path, initialCount: item.commentCount)..count();
    });

    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: likeCubit),
        BlocProvider.value(value: starCubit),
        BlocProvider.value(value: commentCubit),
      ],
      child: _buildLayout(context),
    );
  }

  Widget _buildLayout(BuildContext context) {
    switch (item.type) {
      case FeedType.none:
      case FeedType.photo:
      case FeedType.post:
        return ItemFeedPost(index: index, item: item);
      case FeedType.ads:
        return ItemFeedAds(index: index, item: item);
      case FeedType.avatar:
        return ItemFeedAvatar(index: index, item: item);
      case FeedType.business:
        return ItemFeedBusiness(index: index, item: item);
      case FeedType.cover:
        return ItemFeedCover(index: index, item: item);
      case FeedType.note:
        return ItemFeedNote(index: index, item: item);
      case FeedType.sponsored:
        return ItemFeedSponsored(index: index, item: item);
      case FeedType.memory:
        return ItemFeedMemory(index: index, item: item);
      case FeedType.video:
        return ItemFeedVideo(index: index, item: item);
    }
  }
}
