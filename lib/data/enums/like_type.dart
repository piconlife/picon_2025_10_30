enum LikeType {
  like("LIKE", "Like", ""),
  heart("HEART", "Heart", ""),
  wow("WOW", "Wow", ""),
  sad("SAD", "Sad", "");

  final String name;
  final String label;
  final String icon;

  const LikeType(this.name, this.label, this.icon);
}
