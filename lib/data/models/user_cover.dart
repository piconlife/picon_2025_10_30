import 'package:flutter_entity/entity.dart';

import '../enums/privacy.dart';

class UserCoverKeys extends EntityKey {
  UserCoverKeys._();

  static final i = UserCoverKeys._();
  final publisher = "publisher";
  final path = "path";
  final description = "description";
  final photoUrl = "photoUrl";
  final privacy = "privacy";

  @override
  Iterable<String> get keys => [
    id,
    timeMills,
    publisher,
    path,
    description,
    photoUrl,
    privacy,
  ];
}

class UserCover extends Entity<UserCoverKeys> {
  String? description;
  String? path;
  String? photoUrl;
  Privacy? privacy;
  String? publisher;

  UserCover({
    super.id,
    super.timeMills,
    this.description,
    this.path,
    this.photoUrl,
    this.privacy,
    this.publisher,
  });

  factory UserCover.parse(Object? source) {
    if (source! is Map) return UserCover();
    final key = UserCoverKeys.i;
    return UserCover(
      id: source.entityValue(key.id),
      timeMills: source.entityValue(key.timeMills),
      description: source.entityValue(key.description),
      path: source.entityValue(key.path),
      photoUrl: source.entityValue(key.photoUrl),
      privacy: source.entityValue(key.privacy, Privacy.parse),
      publisher: source.entityValue(key.publisher),
    );
  }

  @override
  Map<String, dynamic> get source {
    return {
      key.id: id,
      key.timeMills: timeMills,
      key.description: description,
      key.path: path,
      key.photoUrl: photoUrl,
      key.privacy: privacy?.name,
      key.publisher: publisher,
    };
  }

  @override
  int get hashCode => source.hashCode;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! UserCover) return false;
    return source == other.source;
  }

  @override
  String toString() => "$UserCover#$hashCode($source)";
}
