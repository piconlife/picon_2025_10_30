import 'package:flutter/material.dart';
import 'package:flutter_andomie/extensions/object.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../data/enums/feed_type.dart';
import '../../../../data/models/feed.dart';
import '../cubits/comment_cubit.dart';
import '../cubits/like_cubit.dart';
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
  final Feed item;

  const ItemFeed({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    if (item.reference.isNotValid) return SizedBox();
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) {
            return FeedLikeCubit(item.reference!)
              ..count()
              ..fetchByMe();
          },
        ),
        BlocProvider(
          create: (context) {
            return FeedCommentCubit(item.reference!)..count();
          },
        ),
      ],
      child: _buildLayout(context),
    );
  }

  Widget _buildLayout(BuildContext context) {
    switch (item.type) {
      case FeedType.none:
      case FeedType.photo:
      case FeedType.post:
        return ItemFeedPost(item: item);
      case FeedType.ads:
        return ItemFeedAds(item: item);
      case FeedType.avatar:
        return ItemFeedAvatar(item: item);
      case FeedType.business:
        return ItemFeedBusiness(item: item);
      case FeedType.cover:
        return ItemFeedCover(item: item);
      case FeedType.note:
        return ItemFeedNote(item: item);
      case FeedType.sponsored:
        return ItemFeedSponsored(item: item);
      case FeedType.memory:
        return ItemFeedMemory(item: item);
      case FeedType.video:
        return ItemFeedVideo(item: item);
    }
  }
}
