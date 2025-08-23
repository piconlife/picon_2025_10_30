import 'package:picon/app/extensions/string.dart';

import '../../app/helpers/user.dart';
import '../../features/chooser/data/models/country.dart';
import '../../features/chooser/data/models/profession.dart';
import '../../features/chooser/data/models/religion.dart';
import '../../roots/helpers/location.dart';
import 'content.dart';
import 'user.dart';

class Feed extends Content {
  Feed.empty() : this._();

  Feed._({
    super.id,
    super.timeMills,
    // PUBLISHER
    super.publisherId,
    super.publisherAge,
    super.publisherGender,
    super.publisherProfession,
    super.publisherReligion,
    super.publisherRating,
    // LOCATION
    super.city,
    super.country,
    super.latitude,
    super.longitude,
    super.region,
    super.zip,
    // REFERENCES
    super.path,
    super.reference,
    super.content,
    super.type,
  });

  Feed.create({
    required super.id,
    required super.timeMills,
    required super.type,
    required super.path,
    required super.reference,
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
      publisherReligion: content.publisherReligion,
      publisherRating: content.publisherRating,
      // LOCATION
      city: content.city,
      country: content.country,
      latitude: content.latitude,
      longitude: content.longitude,
      region: content.region,
      zip: content.zip,
      // REFERENCES
      content: content.content,
      path: content.path,
      reference: content.content.path,
      type: content.type,
    );
  }

  @override
  Iterable<String> get keys => [
    key.id,
    key.timeMills,
    // PUBLISHER
    key.publisher,
    key.publisherAge,
    key.publisherGender,
    key.publisherProfession,
    key.publisherReligion,
    key.publisherRating,
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
    key.type,
  ];
}
