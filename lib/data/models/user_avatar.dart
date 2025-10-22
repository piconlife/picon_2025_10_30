import 'package:flutter_entity/entity.dart';

import '../enums/privacy.dart';

class UserAvatarKeys extends EntityKey {
  UserAvatarKeys._();

  static final i = UserAvatarKeys._();
  final publisher = "publisher";
  final publisherId = "publisherId";
  final publisherRef = "@publisher";
  final path = "path";
  final description = "description";
  final photo = "photo";
  final privacy = "privacy";

  @override
  Iterable<String> get keys => [
    id,
    timeMills,
    publisherId,
    path,
    description,
    photo,
    privacy,
  ];
}

class UserAvatar extends Entity<UserAvatarKeys> {
  String? description;
  String? path;
  String? photo;
  Privacy? privacy;
  String? publisher;

  bool get isEmpty => filtered.isEmpty;

  bool get isNotEmpty => !isEmpty;

  UserAvatar({
    super.id,
    super.timeMills,
    this.description,
    this.path,
    this.photo,
    this.privacy,
    this.publisher,
  });

  factory UserAvatar.parse(Object? source) {
    if (source is! Map) return UserAvatar();
    final key = UserAvatarKeys.i;
    return UserAvatar(
      id: source.entityValue(key.id),
      timeMills: source.entityValue(key.timeMills),
      description: source.entityValue(key.description),
      path: source.entityValue(key.path),
      photo: source.entityValue(key.photo),
      privacy: source.entityValue(key.privacy, Privacy.parse),
      publisher: source.entityValue(key.publisherId),
    );
  }

  @override
  UserAvatarKeys makeKey() => UserAvatarKeys.i;

  @override
  Map<String, dynamic> get source {
    return {
      key.id: id,
      key.timeMills: timeMills,
      key.description: description,
      key.path: path,
      key.photo: photo,
      key.privacy: privacy?.name,
      key.publisherId: publisher,
    };
  }

  @override
  int get hashCode => source.hashCode;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! UserAvatar) return false;
    return source == other.source;
  }

  @override
  String toString() => "$UserAvatar#$hashCode($source)";
}
