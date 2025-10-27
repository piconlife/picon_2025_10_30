import 'package:flutter_andomie/core.dart';

import '../../app/res/icons.dart';

enum Privacy {
  everyone(
    name: "EVERYONE",
    icon: InAppIcons.user,
    label: "Everyone",
    subtitle: "Public",
  ),
  onlyFriends(
    name: "ONLY_FRIENDS",
    icon: InAppIcons.following,
    label: "Only friends",
  ),
  onlyMe(
    name: "ONLY_ME",
    icon: InAppIcons.lock,
    label: "Only me",
    subtitle: "Private",
  );

  final String name;
  final AndomieIcon icon;
  final String label;
  final String description;

  bool get isOnlyMe => this == Privacy.onlyMe;

  bool get isOnlyFriends => this == Privacy.onlyFriends;

  bool get isEveryone => this == Privacy.everyone;

  bool get isPrivate => isOnlyMe;

  bool get isPublic => isEveryone;

  const Privacy({
    required this.name,
    required this.icon,
    required this.label,
    String? subtitle,
  }) : description = subtitle ?? label;

  factory Privacy.parse(Object? value) {
    return values.where((e) {
          return e == value || e.name == value || e.label == value;
        }).firstOrNull ??
        Privacy.everyone;
  }
}
