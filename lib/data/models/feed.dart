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

  final publisher = "publisher";
  final publisherAge = "publisher_age";
  final publisherGender = "publisher_gender";
  final publisherProfession = "publisher_profession";
  final publisherReligion = "publisher_religion";
  final publisherRating = "publisher_rating";
  final publisherTitle = "publisher_title";

  final lat = "lat";
  final lon = "lon";
  final path = "path";
  final ref = "ref";
  final type = "type";

  @override
  Iterable<String> get keys => [
    id,
    timeMills,
    publisher,
    publisherAge,
    publisherGender,
    publisherProfession,
    publisherReligion,
    publisherRating,
    publisherTitle,
    lat,
    lon,
    path,
    ref,
    type,
  ];
}

class Feed extends Entity<FeedKeys> {
  // PUBLISHER
  String? publisher;
  int? publisherAge;
  double? publisherGender;
  String? publisherProfession;
  String? publisherReligion;
  String? publisherRating;
  String? publisherTitle;

  // RAW FIELDS
  double? lat;
  double? lon;
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

  Content recent = Content();
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

  Feed.empty() : this._();

  Feed._({
    super.id,
    super.timeMills,
    this.publisher,
    this.publisherAge,
    this.publisherGender,
    this.publisherProfession,
    this.publisherReligion,
    this.publisherRating,
    this.publisherTitle,
    this.lat,
    this.lon,
    this.path,
    this.reference,
    ContentType? type,
  }) : _type = type;

  Feed({
    required super.id,
    required super.timeMills,
    required this.publisher,
    required this.publisherAge,
    required this.publisherGender,
    required this.publisherProfession,
    required this.publisherReligion,
    required this.publisherRating,
    required this.publisherTitle,
    required this.lat,
    required this.lon,
    required this.path,
    required this.reference,
    required ContentType? type,
  }) : _type = type;

  factory Feed.parse(Object? source) {
    final key = FeedKeys.i;
    if (source is! Map) return Feed.empty();
    return Feed._(
      id: source.entityValue(key.id),
      timeMills: source.entityValue(key.timeMills),
      publisher: source.entityValue(key.publisher),
      publisherAge: source.entityValue(key.publisherAge),
      publisherGender: source.entityValue(key.publisherGender),
      publisherProfession: source.entityValue(key.publisherProfession),
      publisherReligion: source.entityValue(key.publisherReligion),
      publisherRating: source.entityValue(key.publisherRating),
      publisherTitle: source.entityValue(key.publisherTitle),
      lat: source.entityValue(key.lat),
      lon: source.entityValue(key.lon),
      path: source.entityValue(key.path),
      reference: source.entityValue(key.ref),
      type: source.entityValue(key.type, ContentType.parse),
    );
  }

  @override
  FeedKeys makeKey() => FeedKeys.i;

  @override
  Map<String, dynamic> get source {
    return {
      key.id: id,
      key.timeMills: timeMills,
      key.publisher: publisher,
      key.publisherAge: publisherAge,
      key.publisherGender: publisherGender,
      key.publisherProfession: publisherProfession,
      key.publisherReligion: publisherReligion,
      key.publisherRating: publisherRating,
      key.publisherTitle: publisherTitle,
      key.lat: lat,
      key.lon: lon,
      key.path: path,
      key.ref: reference,
      key.type: _type?.name,
    };
  }

  @override
  String get json => jsonEncode(source);

  @override
  int get hashCode =>
      id.hashCode ^
      timeMills.hashCode ^
      publisher.hashCode ^
      publisherAge.hashCode ^
      publisherGender.hashCode ^
      publisherProfession.hashCode ^
      publisherReligion.hashCode ^
      publisherRating.hashCode ^
      publisherTitle.hashCode ^
      lat.hashCode ^
      lon.hashCode ^
      path.hashCode ^
      reference.hashCode ^
      _type.hashCode;

  @override
  bool operator ==(Object other) {
    return other is Feed &&
        other.id == id &&
        other.timeMills == timeMills &&
        other.publisher == publisher &&
        other.publisherAge == publisherAge &&
        other.publisherGender == publisherGender &&
        other.publisherProfession == publisherProfession &&
        other.publisherReligion == publisherReligion &&
        other.publisherRating == publisherRating &&
        other.publisherTitle == publisherTitle &&
        other.lat == lat &&
        other.lon == lon &&
        other.path == path &&
        other.reference == reference &&
        other._type == _type;
  }

  @override
  String toString() => "$Feed#$hashCode($json)";
}
