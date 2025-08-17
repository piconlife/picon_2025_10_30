import 'package:flutter_andomie/utils/path_parser.dart';

import '../constants/paths.dart';

enum FeedType {
  none("NONE", "", ""),
  ads("ADS", "Ads", Paths.ads),
  avatar("AVATAR", "Avatar", Paths.avatars),
  business("BUSINESS", "Business", Paths.businesses),
  cover("COVER", "Cover", Paths.covers),
  note("NOTE", "Note", Paths.notes),
  photo("PHOTO", "Photo", Paths.photos),
  sponsored("SPONSORED", "Sponsored", Paths.sponsors),
  memory("MEMORY", "Memory", Paths.memories),
  post("POST", "Post", Paths.posts),
  video("VIDEO", "Video", Paths.videos);

  final String name;
  final String value;
  final String path;

  bool get isAds => this == ads;

  bool get isAvatar => this == avatar;

  bool get isBusiness => this == business;

  bool get isCover => this == cover;

  bool get isMemory => this == memory;

  bool get isNote => this == note;

  bool get isPhoto => this == photo;

  bool get isPost => this == post;

  bool get isSponsored => this == sponsored;

  bool get isVideo => this == video;

  const FeedType(this.name, this.value, this.path);

  factory FeedType.fromRef(String ref) {
    final x = PathParser.parse(ref).collections;
    return FeedType.parse(x.lastOrNull);
  }

  factory FeedType.parse(Object? value) {
    return values.where((e) {
          return e == value ||
              e.toString().toLowerCase() == value.toString().toLowerCase() ||
              e.index == value ||
              e.name == value ||
              e.value == value ||
              e.path == value;
        }).firstOrNull ??
        FeedType.none;
  }
}
