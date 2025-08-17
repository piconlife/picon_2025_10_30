enum LikeType {
  like("LIKE", "Like", ""),
  heart("HEART", "Heart", ""),
  wow("WOW", "Wow", ""),
  sad("SAD", "Sad", "");

  final String name;
  final String label;
  final String icon;

  const LikeType(this.name, this.label, this.icon);

  factory LikeType.parse(Object? value) {
    return values.where((e) {
          return e == value ||
              e.toString().toLowerCase() == value.toString().toLowerCase() ||
              e.index == value ||
              e.name == value ||
              e.label == value;
        }).firstOrNull ??
        LikeType.like;
  }
}
