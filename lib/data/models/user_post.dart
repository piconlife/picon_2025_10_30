import 'dart:convert';

import 'package:flutter_entity/entity.dart';

import '../../app/helpers/user.dart';
import '../enums/content.dart';
import '../enums/privacy.dart';
import 'photo.dart';

class UserPostKeys {
  const UserPostKeys._();

  static const timeMills = "time_mills";
  static const commentCount = "comment_count";
  static const likeCount = "like_count";
  static const reportCount = "report_count";
  static const starCount = "star_count";
  static const viewCount = "view_count";

  static const id = "id";
  static const publisher = "publisher";
  static const path = "path";
  static const description = "description";
  static const title = "title";
  static const audience = "audience";
  static const privacy = "privacy";
  static const type = "type";

  static const tags = "tags";
}

class UserPost extends Entity {
  // RAW DATA
  int? commentCount;
  int? likeCount;
  int? reportCount;
  int? starCount;
  int? viewCount;

  String? publisher;
  String? path;
  String? description;
  String? title;
  String? audience;
  String? privacy;
  String? type;

  List<String>? tags;

  // TEMPORARY DATA
  String? translatedTitle;
  String? translatedDescription;
  List<Photo>? photos;

  bool get isPublisher => publisher == UserHelper.uid;

  bool get isTitled => (title ?? '').isNotEmpty;

  bool get isDescription => (description ?? '').isNotEmpty;

  bool get isTranslatable => isTitled || isDescription;

  bool get isTranslated {
    return (translatedTitle ?? translatedDescription ?? '').isNotEmpty;
  }

  bool get isShareMode => isPublisher || privacy == Privacy.everyone.name;

  bool get isPhotoMode => type == ContentType.photo.name;

  bool get isVideoMode => type == ContentType.video.name;

  List<String> get photoUrls {
    return photos
            ?.map((e) => e.photoUrl ?? '')
            .where((e) => e.isNotEmpty)
            .toList() ??
        [];
  }

  UserPost({
    // RAW DATA
    super.id,
    super.timeMills,
    this.publisher,
    this.title,
    this.path,
    this.description,
    this.audience,
    this.privacy,
    this.type,
    this.commentCount,
    this.likeCount,
    this.reportCount,
    this.starCount,
    this.viewCount,
    this.tags,
    // TEMPORARY DATA
    this.translatedTitle,
    this.translatedDescription,
    this.photos,
  });

  UserPost.create({
    required super.id,
    required super.timeMills,
    required this.publisher,
    required this.title,
    required this.path,
    required this.description,
    required this.audience,
    required this.privacy,
    required this.type,
    required this.tags,
  });

  factory UserPost.from(Object? source) {
    return UserPost(
      id: source.entityValue(UserPostKeys.id),
      timeMills: source.entityValue(UserPostKeys.timeMills),
      publisher: source.entityValue(UserPostKeys.publisher),
      title: source.entityValue(UserPostKeys.title),
      path: source.entityValue(UserPostKeys.path),
      description: source.entityValue(UserPostKeys.description),
      audience: source.entityValue(UserPostKeys.audience),
      privacy: source.entityValue(UserPostKeys.privacy),
      type: source.entityValue(UserPostKeys.type),
      commentCount: source.entityValue(UserPostKeys.commentCount),
      likeCount: source.entityValue(UserPostKeys.likeCount),
      reportCount: source.entityValue(UserPostKeys.reportCount),
      starCount: source.entityValue(UserPostKeys.starCount),
      viewCount: source.entityValue(UserPostKeys.viewCount),
      tags: source.entityValue(UserPostKeys.tags),
    );
  }

  @override
  Map<String, dynamic> get source {
    return {
      UserPostKeys.id: id,
      UserPostKeys.timeMills: timeMills,
      UserPostKeys.publisher: publisher,
      UserPostKeys.title: title,
      UserPostKeys.path: path,
      UserPostKeys.description: description,
      UserPostKeys.audience: audience,
      UserPostKeys.privacy: privacy,
      UserPostKeys.type: type,
      UserPostKeys.commentCount: commentCount,
      UserPostKeys.likeCount: likeCount,
      UserPostKeys.reportCount: reportCount,
      UserPostKeys.starCount: starCount,
      UserPostKeys.viewCount: viewCount,
      UserPostKeys.tags: tags,
    };
  }

  @override
  String get json => jsonEncode(source);

  @override
  int get hashCode =>
      id.hashCode ^
      timeMills.hashCode ^
      publisher.hashCode ^
      title.hashCode ^
      path.hashCode ^
      description.hashCode ^
      audience.hashCode ^
      privacy.hashCode ^
      type.hashCode ^
      commentCount.hashCode ^
      likeCount.hashCode ^
      reportCount.hashCode ^
      starCount.hashCode ^
      viewCount.hashCode ^
      tags.hashCode;

  @override
  bool operator ==(Object other) {
    return other is UserPost &&
        other.id == id &&
        other.timeMills == timeMills &&
        other.publisher == publisher &&
        other.title == title &&
        other.path == path &&
        other.description == description &&
        other.audience == audience &&
        other.privacy == privacy &&
        other.type == type &&
        other.commentCount == commentCount &&
        other.likeCount == likeCount &&
        other.reportCount == reportCount &&
        other.starCount == starCount &&
        other.viewCount == viewCount &&
        other.tags == tags;
  }

  @override
  String toString() => "$UserPost#$hashCode($json)";
}
