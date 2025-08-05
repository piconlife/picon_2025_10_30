import 'package:flutter/material.dart';

import '../../../../data/enums/content.dart';
import '../../../../data/models/feed.dart';
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
    switch (item.contentType) {
      case ContentType.none:
      case ContentType.photo:
      case ContentType.post:
        return ItemFeedPost(item: item);
      case ContentType.ads:
        return ItemFeedAds(item: item);
      case ContentType.avatar:
        return ItemFeedAvatar(item: item);
      case ContentType.business:
        return ItemFeedBusiness(item: item);
      case ContentType.cover:
        return ItemFeedCover(item: item);
      case ContentType.note:
        return ItemFeedNote(item: item);
      case ContentType.sponsored:
        return ItemFeedSponsored(item: item);
      case ContentType.memory:
        return ItemFeedMemory(item: item);
      case ContentType.video:
        return ItemFeedVideo(item: item);
    }
  }
}
