import 'dart:convert';

import 'package:flutter_entity/entity.dart';

import '../../app/helpers/user.dart';
import '../enums/privacy.dart';

class PhotoKeys {
  const PhotoKeys._();

  static const id = "id";
  static const timeMills = "time_mills";
  static const publisher = "publisher";
  static const path = "path";
  static const parentId = "parent_id";
  static const parentPath = "parent_path";
  static const photoUrl = "photo_url";
  static const description = "description";
  static const privacy = "privacy";
  static const likeCount = "like_count";
  static const viewCount = "view_count";
}

class Photo extends Entity {
  String? publisher;
  String? parentId;
  String? path;
  String? parentPath;
  String? photoUrl;
  Privacy? _privacy;
  String? description;

  int? likeCount;
  int? viewCount;

  Privacy get privacy => _privacy ?? Privacy.onlyMe;

  set privacy(Privacy value) => _privacy = value;

  bool get isPrivacyAllow {
    if (UserHelper.isCurrentUser(publisher)) return true;
    if (privacy.isOnlyMe) return false;
    if (privacy.isEveryone) return true;
    if (privacy.isOnlyFriends && UserHelper.isFollowing(publisher)) return true;
    return false;
  }

  Photo({
    super.id,
    super.timeMills,
    this.publisher,
    this.parentId,
    this.path,
    this.parentPath,
    this.photoUrl,
    this.description,
    this.likeCount,
    this.viewCount,
    Privacy? privacy,
  }) : _privacy = privacy;

  Photo.create({
    required super.id,
    required super.timeMills,
    required this.publisher,
    required this.parentId,
    required this.path,
    required this.parentPath,
    required this.photoUrl,
    required Privacy? privacy,
  }) : _privacy = privacy;

  factory Photo.from(Object? source) {
    return Photo(
      id: source.entityValue(PhotoKeys.id),
      timeMills: source.entityValue(PhotoKeys.timeMills),
      publisher: source.entityValue(PhotoKeys.publisher),
      parentId: source.entityValue(PhotoKeys.parentId),
      path: source.entityValue(PhotoKeys.path),
      parentPath: source.entityValue(PhotoKeys.parentPath),
      photoUrl: source.entityValue(PhotoKeys.photoUrl),
      description: source.entityValue(PhotoKeys.description),
      privacy: source.entityValue(PhotoKeys.privacy),
      likeCount: source.entityValue(PhotoKeys.likeCount),
      viewCount: source.entityValue(PhotoKeys.viewCount),
    );
  }

  @override
  Map<String, dynamic> get source {
    return {
      PhotoKeys.id: id,
      PhotoKeys.timeMills: timeMills,
      PhotoKeys.publisher: publisher,
      PhotoKeys.parentId: parentId,
      PhotoKeys.path: path,
      PhotoKeys.parentPath: parentPath,
      PhotoKeys.photoUrl: photoUrl,
      PhotoKeys.privacy: _privacy?.name,
      PhotoKeys.description: description,
      PhotoKeys.likeCount: likeCount,
      PhotoKeys.viewCount: viewCount,
    };
  }

  @override
  String get json => jsonEncode(source);

  @override
  int get hashCode =>
      id.hashCode ^
      timeMills.hashCode ^
      publisher.hashCode ^
      parentId.hashCode ^
      path.hashCode ^
      parentPath.hashCode ^
      photoUrl.hashCode ^
      _privacy.hashCode ^
      description.hashCode ^
      likeCount.hashCode ^
      viewCount.hashCode;

  @override
  bool operator ==(Object other) {
    return other is Photo &&
        other.id == id &&
        other.timeMills == timeMills &&
        other.publisher == publisher &&
        other.parentId == parentId &&
        other.path == path &&
        other.parentPath == parentPath &&
        other.photoUrl == photoUrl &&
        other._privacy == _privacy &&
        other.description == description &&
        other.likeCount == likeCount &&
        other.viewCount == viewCount;
  }

  @override
  String toString() => "$Photo#$hashCode($json)";
}
