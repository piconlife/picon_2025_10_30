enum CommentType {
  none("NONE", ""),
  text("TEXT", "Text"),
  emoji("EMOJI", "Emoji"),
  gif("GIF", "Gif"),
  photo("PHOTO", "Photo"),
  video("VIDEO", "Video");

  final String name;
  final String value;

  bool get isText => this == text;

  bool get isEmoji => this == emoji;

  bool get isGif => this == gif;

  bool get isPhoto => this == photo;

  bool get isVideo => this == video;

  const CommentType(this.name, this.value);

  factory CommentType.parse(Object? value) {
    return values.where((e) {
          return e == value ||
              e.toString().toLowerCase() == value.toString().toLowerCase() ||
              e.index == value ||
              e.name == value ||
              e.value == value;
        }).firstOrNull ??
        CommentType.none;
  }
}
