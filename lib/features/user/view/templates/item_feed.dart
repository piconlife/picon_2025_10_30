import 'package:flutter/material.dart';

import '../../../../data/enums/feed_type.dart';
import '../../../../data/models/user_post.dart';
import 'item_feed_ads.dart';
import 'item_feed_avatar.dart';
import 'item_feed_business.dart';
import 'item_feed_cover.dart';
import 'item_feed_memory.dart';
import 'item_feed_note.dart';
import 'item_feed_post.dart';
import 'item_feed_sponsored.dart';
import 'item_feed_video.dart';

class ItemUserFeed extends StatelessWidget {
  final UserPost item;

  const ItemUserFeed({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    switch (item.type) {
      case FeedType.none:
      case FeedType.photo:
      case FeedType.post:
        return ItemUserFeedPost(item: item);
      case FeedType.ads:
        return ItemUserFeedAds(item: item);
      case FeedType.avatar:
        return ItemUserFeedAvatar(item: item);
      case FeedType.business:
        return ItemUserFeedBusiness(item: item);
      case FeedType.cover:
        return ItemUserFeedCover(item: item);
      case FeedType.note:
        return ItemUserFeedNote(item: item);
      case FeedType.sponsored:
        return ItemUserFeedSponsored(item: item);
      case FeedType.memory:
        return ItemUserFeedMemory(item: item);
      case FeedType.video:
        return ItemUserFeedVideo(item: item);
    }
  }
}
