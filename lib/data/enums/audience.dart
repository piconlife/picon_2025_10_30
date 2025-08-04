enum Audience {
  everyone(name: "EVERYONE", title: "Everyone", subtitle: "Public"),
  forKids(name: "FOR_KIDS", title: "For kids", subtitle: "Private"),
  notForKids(name: "NOT_FOR_KIDS", title: "Not for kids", subtitle: "Public"),
  eighteenPlus(
    name: "EIGHTEEN_PLUS",
    title: "Eighteen (+18)",
    subtitle: "Public",
  );

  final String name;
  final String title;
  final String subtitle;

  bool get isEveryone => this == Audience.everyone;

  bool get isForKids => this == Audience.forKids;

  bool get isNotForKids => this == Audience.notForKids;

  bool get isEighteenPlus => this == Audience.eighteenPlus;

  bool get isPrivate => isForKids;

  bool get isPublic => isEveryone || isNotForKids || isEighteenPlus;

  const Audience({required this.name, required this.title, String? subtitle})
    : subtitle = subtitle ?? title;

  factory Audience.from(Object? value) {
    return values.where((e) {
          return e == value || e.name == value || e.title == value;
        }).firstOrNull ??
        Audience.everyone;
  }
}
