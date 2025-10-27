enum Audience {
  everyone(name: "EVERYONE", label: "Everyone", subtitle: "Public"),
  forKids(name: "FOR_KIDS", label: "For kids", subtitle: "Private"),
  notForKids(name: "NOT_FOR_KIDS", label: "Not for kids", subtitle: "Public"),
  eighteenPlus(
    name: "EIGHTEEN_PLUS",
    label: "Eighteen (+18)",
    subtitle: "Public",
  );

  final String name;
  final String label;
  final String description;

  bool get isEveryone => this == Audience.everyone;

  bool get isForKids => this == Audience.forKids;

  bool get isNotForKids => this == Audience.notForKids;

  bool get isEighteenPlus => this == Audience.eighteenPlus;

  bool get isPrivate => isForKids;

  bool get isPublic => isEveryone || isNotForKids || isEighteenPlus;

  const Audience({required this.name, required this.label, String? subtitle})
    : description = subtitle ?? label;
}
