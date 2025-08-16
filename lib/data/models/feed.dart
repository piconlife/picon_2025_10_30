import 'dart:convert';

import 'package:flutter_entity/entity.dart';
import 'package:picon/app/extensions/string.dart';

import '../../app/helpers/user.dart';
import '../../features/chooser/data/models/country.dart';
import '../../features/chooser/data/models/profession.dart';
import '../../features/chooser/data/models/religion.dart';
import '../../roots/helpers/location.dart';
import '../enums/content.dart';
import '../enums/privacy.dart';
import 'content.dart';
import 'photo.dart';
import 'user.dart';

class FeedKeys extends EntityKey {
  const FeedKeys._();

  static const FeedKeys i = FeedKeys._();

  // PUBLISHER
  final publisher = "publisher";
  final publisherAge = "publisher_age";
  final publisherGender = "publisher_gender";
  final publisherProfession = "publisher_profession";
  final publisherReligion = "publisher_religion";
  final publisherRating = "publisher_rating";

  // LOCATION
  final city = "city";
  final country = "country";
  final lat = "lat";
  final lon = "lon";
  final region = "region";
  final zip = "zip";

  // REFERENCE
  final path = "path";
  final ref = "ref";
  final type = "type";

  @override
  Iterable<String> get keys {
    return [
      id,
      timeMills,
      // PUBLISHER
      publisher,
      publisherAge,
      publisherGender,
      publisherProfession,
      publisherReligion,
      publisherRating,
      // LOCATION
      city,
      country,
      lat,
      lon,
      region,
      zip,
      // REFERENCE
      path,
      ref,
      type,
    ];
  }
}

class Feed extends Entity<FeedKeys> {
  // PUBLISHER
  String? publisher;
  int? publisherAge;
  String? publisherGender;
  String? publisherProfession;
  String? publisherReligion;
  double? publisherRating;

  // LOCATION
  String? city;
  String? country;
  double? lat;
  double? lon;
  String? region;
  int? zip;

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
    // PUBLISHER
    this.publisher,
    this.publisherAge,
    this.publisherGender,
    this.publisherProfession,
    this.publisherReligion,
    this.publisherRating,
    // LOCATION
    this.city,
    this.country,
    this.lat,
    this.lon,
    this.region,
    this.zip,
    // REFERENCES
    this.path,
    this.reference,
    ContentType? type,
  }) : _type = type;

  Feed.create({
    required super.id,
    required super.timeMills,
    required ContentType type,
    required this.path,
    required this.reference,
    User? publisher,
  }) : _type = type,
       // PUBLISHER
       publisher = publisher?.id ?? UserHelper.uid,
       publisherAge = publisher?.age ?? UserHelper.user.age,
       publisherGender = publisher?.gender.id ?? UserHelper.user.gender.id,
       publisherProfession =
           InAppProfession.of(
             publisher?.profession ?? UserHelper.user.profession,
           )?.id ??
           (publisher?.profession ?? UserHelper.user.profession)?.asKey,
       publisherRating = publisher?.rating ?? UserHelper.user.rating,
       publisherReligion =
           InAppReligion.of(
             publisher?.religion ?? UserHelper.user.religion,
           )?.id ??
           (publisher?.religion ?? UserHelper.user.religion)?.asKey,
       // LOCATION
       city = LocationInfo.i.city?.asKey,
       country =
           InAppCountry.of(LocationInfo.i.countryCode?.asKey)?.id ??
           LocationInfo.i.countryCode?.asKey,
       lat = LocationInfo.i.lat,
       lon = LocationInfo.i.lon,
       region = LocationInfo.i.region?.asKey,
       zip = LocationInfo.i.zip;

  factory Feed.parse(Object? source) {
    final key = FeedKeys.i;
    if (source is! Map) return Feed.empty();
    return Feed._(
      id: source.entityValue(key.id),
      timeMills: source.entityValue(key.timeMills),
      // PUBLISHER
      publisher: source.entityValue(key.publisher),
      publisherAge: source.entityValue(key.publisherAge),
      publisherGender: source.entityValue(key.publisherGender),
      publisherProfession: source.entityValue(key.publisherProfession),
      publisherReligion: source.entityValue(key.publisherReligion),
      publisherRating: source.entityValue(key.publisherRating),
      // LOCATION
      city: source.entityValue(key.city),
      country: source.entityValue(key.country),
      lat: source.entityValue(key.lat),
      lon: source.entityValue(key.lon),
      region: source.entityValue(key.region),
      zip: source.entityValue(key.zip),
      // REFERENCES
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
      // PUBLISHER
      key.publisher: publisher,
      key.publisherAge: publisherAge,
      key.publisherGender: publisherGender,
      key.publisherProfession: publisherProfession,
      key.publisherReligion: publisherReligion,
      key.publisherRating: publisherRating,
      // LOCATION
      key.city: city,
      key.country: country,
      key.lat: lat,
      key.lon: lon,
      key.region: region,
      key.zip: zip,
      // REFERENCES
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
      // PUBLISHER
      publisher.hashCode ^
      publisherAge.hashCode ^
      publisherGender.hashCode ^
      publisherProfession.hashCode ^
      publisherReligion.hashCode ^
      publisherRating.hashCode ^
      // LOCATION
      city.hashCode ^
      country.hashCode ^
      lat.hashCode ^
      lon.hashCode ^
      region.hashCode ^
      zip.hashCode ^
      // REFERENCES
      path.hashCode ^
      reference.hashCode ^
      _type.hashCode;

  @override
  bool operator ==(Object other) {
    return other is Feed &&
        other.id == id &&
        other.timeMills == timeMills &&
        // PUBLISHER
        other.publisher == publisher &&
        other.publisherAge == publisherAge &&
        other.publisherGender == publisherGender &&
        other.publisherProfession == publisherProfession &&
        other.publisherReligion == publisherReligion &&
        other.publisherRating == publisherRating &&
        // LOCATION
        other.city == city &&
        other.country == country &&
        other.lat == lat &&
        other.lon == lon &&
        other.region == region &&
        other.zip == zip &&
        // REFERENCES
        other.path == path &&
        other.reference == reference &&
        other._type == _type;
  }

  @override
  String toString() => "$Feed#$hashCode($json)";
}
