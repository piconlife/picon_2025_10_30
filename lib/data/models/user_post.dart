import 'dart:convert';

import 'package:flutter_entity/entity.dart';

import '../../app/helpers/user.dart';
import '../enums/content.dart';
import '../enums/privacy.dart';
import 'content.dart';
import 'photo.dart';

class UserPostKeys extends EntityKey {
  const UserPostKeys._();

  static const UserPostKeys i = UserPostKeys._();

  final path = "path";
  final pid = "pid";
  final ref = "ref";
  final type = "type";

  @override
  Iterable<String> get keys => [id, path, pid, ref, timeMills, type];
}

class UserPost extends Entity<UserPostKeys> {
  // RAW FIELDS
  String? publisher;
  String? path;
  String? reference;
  ContentType? _type;

  ContentType get contentType => _type ?? ContentType.none;

  // MODIFIABLE FIELDS
  String? description;
  List<String> photoUrls = [];
  List<String> comments = [];
  List<String> likes = [];
  List<String> stars = [];

  List<Content> contents = [];

  int? commentCount;
  int? likeCount;
  int? reportCount;
  int? starCount;
  int? viewCount;

  String? title;
  String? audience;
  Privacy? privacy;
  List<String>? tags;

  // TEMPORARY FIELDS
  String? translatedTitle;
  String? translatedDescription;
  List<Photo>? photos;

  String? get photoUrl => photoUrls.firstOrNull;

  bool get isPublisher => publisher == UserHelper.uid;

  bool get isTitled => (title ?? '').isNotEmpty;

  bool get isDescription => (description ?? '').isNotEmpty;

  bool get isTranslatable => isTitled || isDescription;

  bool get isTranslated {
    return (translatedTitle ?? translatedDescription ?? '').isNotEmpty;
  }

  bool get isShareMode => isPublisher || privacy == Privacy.everyone;

  bool get isPhotoMode => _type == ContentType.photo;

  bool get isVideoMode => _type == ContentType.video;

  UserPost({
    super.id,
    super.timeMills,
    this.path,
    this.publisher,
    this.reference,
    ContentType? type,

    this.title,
    this.description,
    this.audience,
    this.privacy,
    this.commentCount,
    this.likeCount,
    this.reportCount,
    this.starCount,
    this.viewCount,
    this.tags,
    this.translatedTitle,
    this.translatedDescription,
    this.photos,
  }) : _type = type;

  UserPost.create({
    required super.id,
    required super.timeMills,
    required this.publisher,
    required this.title,
    required this.path,
    required this.description,
    required this.audience,
    required this.privacy,
    required ContentType? type,
    required this.tags,
  }) : _type = type;

  UserPost.createForAvatar({
    required super.id,
    required super.timeMills,
    required this.publisher,
    required this.path,
    required this.reference,
  }) : _type = ContentType.avatar;

  UserPost.createForCover({
    required super.id,
    required super.timeMills,
    required this.publisher,
    required this.path,
    required this.reference,
  }) : _type = ContentType.cover;

  factory UserPost.parse(Object? source) {
    final key = UserPostKeys.i;
    if (source is! Map) return UserPost();
    return UserPost(
      id: source.entityValue(key.id),
      path: source.entityValue(key.path),
      publisher: source.entityValue(key.pid),
      reference: source.entityValue(key.ref),
      timeMills: source.entityValue(key.timeMills),
      type: source.entityValue(key.type, ContentType.parse),
    );
  }

  @override
  UserPostKeys makeKey() => UserPostKeys.i;

  @override
  Map<String, dynamic> get source {
    return {
      key.id: id,
      key.path: path,
      key.pid: publisher,
      key.ref: reference,
      key.timeMills: timeMills,
      key.type: _type?.name,
    };
  }

  @override
  String get json => jsonEncode(source);

  @override
  int get hashCode =>
      id.hashCode ^
      path.hashCode ^
      publisher.hashCode ^
      reference.hashCode ^
      timeMills.hashCode ^
      _type.hashCode;

  @override
  bool operator ==(Object other) {
    return other is UserPost &&
        other.id == id &&
        other.path == path &&
        other.publisher == publisher &&
        other.reference == reference &&
        other.timeMills == timeMills &&
        other._type == _type;
  }

  @override
  String toString() => "$UserPost#$hashCode($json)";
}
