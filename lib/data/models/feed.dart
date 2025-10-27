import 'package:picon/app/extensions/string.dart';

import '../../app/helpers/user.dart';
import '../../features/chooser/data/models/country.dart';
import '../../features/chooser/data/models/profession.dart';
import '../../features/chooser/data/models/religion.dart';
import '../../roots/helpers/location.dart';
import '../enums/feed_type.dart';
import 'content.dart';
import 'user.dart';

class Feed extends Content {
  @override
  Iterable<String> get keys => [
    key.id,
    key.timeMills,
    // PUBLISHER
    key.publisherId,
    key.publisherAge,
    key.publisherGender,
    key.publisherProfession,
    key.publisherRating,
    key.publisherReligion,
    // LOCATION
    key.city,
    key.country,
    key.latitude,
    key.longitude,
    key.region,
    key.zip,
    // REFERENCE
    key.path,
    key.contentRef,
    key.recentRef,
    key.type,
  ];

  Feed.empty() : this._();

  Feed._({
    super.id,
    super.timeMills,
    // PUBLISHER
    super.publisherId,
    super.publisherAge,
    super.publisherGender,
    super.publisherProfession,
    super.publisherRating,
    super.publisherReligion,
    // LOCATION
    super.city,
    super.country,
    super.latitude,
    super.longitude,
    super.region,
    super.zip,
    // REFERENCES
    super.path,
    super.content,
    super.recent,
    super.recentPath,
    super.type,
  });

  Feed.create({
    required super.id,
    required super.timeMills,
    required super.type,
    required super.path,
    required super.content,
    super.recentPath,
    User? publisher,
  }) : super(
         publisherId: publisher?.id ?? UserHelper.uid,
         publisherAge: publisher?.age ?? UserHelper.user.age,
         publisherGender: publisher?.gender.id ?? UserHelper.user.gender.id,
         publisherProfession:
             InAppProfession.of(
               publisher?.profession ?? UserHelper.user.profession,
             )?.id ??
             (publisher?.profession ?? UserHelper.user.profession)?.asKey,
         publisherRating: publisher?.rating ?? UserHelper.user.rating,
         publisherReligion:
             InAppReligion.of(
               publisher?.religion ?? UserHelper.user.religion,
             )?.id ??
             (publisher?.religion ?? UserHelper.user.religion)?.asKey,
         // LOCATION
         city: LocationInfo.i.city?.asKey,
         country:
             InAppCountry.of(LocationInfo.i.countryCode?.asKey)?.id ??
             LocationInfo.i.countryCode?.asKey,
         latitude: LocationInfo.i.lat,
         longitude: LocationInfo.i.lon,
         region: LocationInfo.i.region?.asKey,
         zip: LocationInfo.i.zip,
       );

  factory Feed.parse(Object? source) {
    final content = Content.parse(source);
    return Feed._(
      id: content.id,
      timeMills: content.timeMills,
      // PUBLISHER
      publisherId: content.publisherId,
      publisherAge: content.publisherAge,
      publisherGender: content.publisherGender.id,
      publisherProfession: content.publisherProfession,
      publisherRating: content.publisherRating,
      publisherReligion: content.publisherReligion,
      // LOCATION
      city: content.city,
      country: content.country,
      latitude: content.latitude,
      longitude: content.longitude,
      region: content.region,
      zip: content.zip,
      // REFERENCES
      content: content.content,
      recent: content.recent,
      path: content.path,
      type: content.type,
    );
  }

  Feed copyWith({
    String? id,
    int? timeMills,
    String? publisherId,
    int? publisherAge,
    String? publisherGender,
    String? publisherProfession,
    double? publisherRating,
    String? publisherReligion,
    String? city,
    String? country,
    double? latitude,
    double? longitude,
    String? region,
    int? zip,
    String? path,
    Content? content,
    Content? recent,
    FeedType? type,
  }) {
    return Feed._(
      id: id ?? this.id,
      timeMills: timeMills ?? this.timeMills,
      publisherId: publisherId ?? this.publisherId,
      publisherAge: publisherAge ?? this.publisherAge,
      publisherGender: publisherGender ?? this.publisherGender.id,
      publisherProfession: publisherProfession ?? this.publisherProfession,
      publisherRating: publisherRating ?? this.publisherRating,
      publisherReligion: publisherReligion ?? this.publisherReligion,
      city: city ?? this.city,
      country: country ?? this.country,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      region: region ?? this.region,
      zip: zip ?? this.zip,
      path: path ?? this.path,
      content: content ?? this.content,
      recent: recent ?? this.recent,
      type: type ?? this.type,
    );
  }
}
