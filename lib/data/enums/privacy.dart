import 'package:flutter_andomie/core.dart';

import '../../app/res/icons.dart';

enum Privacy {
  everyone(
    name: "EVERYONE",
    icon: InAppIcons.user,
    title: "Everyone",
    subtitle: "Public",
  ),
  onlyFriends(
    name: "ONLY_FRIENDS",
    icon: InAppIcons.following,
    title: "Only friends",
  ),
  onlyMe(
    name: "ONLY_ME",
    icon: InAppIcons.lock,
    title: "Only me",
    subtitle: "Private",
  );

  final String name;
  final AndomieIcon icon;
  final String title;
  final String subtitle;

  bool get isOnlyMe => this == Privacy.onlyMe;

  bool get isOnlyFriends => this == Privacy.onlyFriends;

  bool get isEveryone => this == Privacy.everyone;

  bool get isPrivate => isOnlyMe;

  bool get isPublic => isEveryone;

  const Privacy({
    required this.name,
    required this.icon,
    required this.title,
    String? subtitle,
  }) : subtitle = subtitle ?? title;

  factory Privacy.parse(Object? value) {
    return values.where((e) {
          return e == value || e.name == value || e.title == value;
        }).firstOrNull ??
        Privacy.everyone;
  }
}
