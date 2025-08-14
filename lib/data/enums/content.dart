enum ContentType {
  none("NONE", ""),
  ads("ADS", "Ads"),
  avatar("AVATAR", "Avatar"),
  business("BUSINESS", "Business"),
  cover("COVER", "Cover"),
  note("NOTE", "Note"),
  photo("PHOTO", "Photo"),
  sponsored("SPONSORED", "Sponsored"),
  memory("MEMORY", "Memory"),
  post("POST", "Post"),
  video("VIDEO", "Video");

  final String name;
  final String value;

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

  const ContentType(this.name, this.value);

  factory ContentType.parse(Object? value) {
    return values.where((e) {
          return e == value ||
              e.toString().toLowerCase() == value.toString().toLowerCase() ||
              e.index == value ||
              e.name == value ||
              e.value == value;
        }).firstOrNull ??
        ContentType.none;
  }
}
