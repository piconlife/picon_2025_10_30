import 'package:flutter/material.dart';

import '../../../../data/enums/content.dart';
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
    switch (item.contentType) {
      case ContentType.none:
      case ContentType.photo:
      case ContentType.post:
        return ItemUserFeedPost(item: item);
      case ContentType.ads:
        return ItemUserFeedAds(item: item);
      case ContentType.avatar:
        return ItemUserFeedAvatar(item: item);
      case ContentType.business:
        return ItemUserFeedBusiness(item: item);
      case ContentType.cover:
        return ItemUserFeedCover(item: item);
      case ContentType.note:
        return ItemUserFeedNote(item: item);
      case ContentType.sponsored:
        return ItemUserFeedSponsored(item: item);
      case ContentType.memory:
        return ItemUserFeedMemory(item: item);
      case ContentType.video:
        return ItemUserFeedVideo(item: item);
    }
  }
}
