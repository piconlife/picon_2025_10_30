import 'dart:convert';

import 'package:flutter_entity/entity.dart';

import '../../app/helpers/user.dart';
import '../enums/content.dart';
import '../enums/privacy.dart';
import 'content.dart';
import 'photo.dart';

class FeedKeys extends EntityKey {
  const FeedKeys._();

  static const FeedKeys i = FeedKeys._();

  final path = "path";
  final pid = "pid";
  final ref = "ref";
  final type = "type";

  @override
  Iterable<String> get keys => [id, path, pid, ref, timeMills, type];
}

class Feed extends Entity<FeedKeys> {
  // RAW FIELDS
  String? publisher;
  String? path;
  String? reference;
  ContentType? _type;

  // MODIFIABLE FIELDS
  List<String>? comments;
  List<String>? likes;
  List<String>? stars;

  Content? _recent;
  List<Content>? contents;

  Content get recent => _recent ?? Content();

  int? commentCount;
  int? likeCount;
  int? reportCount;
  int? starCount;
  int? viewCount;

  String? description;
  String? title;
  String? audience;
  String? privacy;
  List<String>? tags;

  // TEMPORARY FIELDS
  String? translatedTitle;
  String? translatedDescription;
  List<Photo>? photos;

  ContentType get contentType => _type ?? ContentType.none;

  bool get isPublisher => publisher == UserHelper.uid;

  bool get isTitled => (title ?? '').isNotEmpty;

  bool get isDescription => (description ?? '').isNotEmpty;

  bool get isTranslatable => isTitled || isDescription;

  bool get isTranslated {
    return (translatedTitle ?? translatedDescription ?? '').isNotEmpty;
  }

  bool get isShareMode => isPublisher || privacy == Privacy.everyone.name;

  bool get isPhotoMode => _type == ContentType.photo;

  bool get isVideoMode => _type == ContentType.video;

  List<String> get photoUrls {
    return photos
            ?.map((e) => e.photoUrl ?? '')
            .where((e) => e.isNotEmpty)
            .toList() ??
        [];
  }

  String? get photoUrl => photoUrls.firstOrNull;

  Feed._({
    super.id,
    super.timeMills,
    this.path,
    this.publisher,
    this.reference,
    ContentType? type,
  }) : _type = type;

  Feed.createForAvatar({
    required super.id,
    required super.timeMills,
    required this.publisher,
    required this.path,
    required this.reference,
  }) : _type = ContentType.avatar;

  Feed.createForCover({
    required super.id,
    required super.timeMills,
    required this.publisher,
    required this.path,
    required this.reference,
  }) : _type = ContentType.cover;

  Feed.createForPost({
    required super.id,
    required super.timeMills,
    required this.publisher,
    required this.path,
    required this.reference,
  }) : _type = ContentType.post;

  factory Feed.parse(Object? source) {
    final key = FeedKeys.i;
    if (source is! Map) return Feed._();
    return Feed._(
      id: source.entityValue(key.id),
      path: source.entityValue(key.path),
      publisher: source.entityValue(key.pid),
      reference: source.entityValue(key.ref),
      timeMills: source.entityValue(key.timeMills),
      type: source.entityValue(key.type, ContentType.parse),
    );
  }

  @override
  FeedKeys makeKey() => FeedKeys.i;

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
    return other is Feed &&
        other.id == id &&
        other.path == path &&
        other.publisher == publisher &&
        other.reference == reference &&
        other.timeMills == timeMills &&
        other._type == _type;
  }

  @override
  String toString() => "$Feed#$hashCode($json)";
}
