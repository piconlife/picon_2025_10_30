import 'package:picon/app/extensions/string.dart';

import '../../app/helpers/user.dart';
import '../../features/chooser/data/models/country.dart';
import '../../features/chooser/data/models/profession.dart';
import '../../features/chooser/data/models/religion.dart';
import '../../roots/helpers/location.dart';
import '../constants/content_types.dart';
import '../enums/content_state.dart';
import '../enums/feed_type.dart';
import '../enums/gender.dart';
import 'content.dart';
import 'user.dart';
import 'user_post.dart';

class FeedModel extends ContentModel {
  @override
  Iterable<String> get keys => [
    key.id,
    key.timeMills,
    key.contentType,
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

  FeedModel.empty() : this._();

  FeedModel._({
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
    super.recentRef,
    super.type,
    super.uiState,
  }) : super(contentType: ContentType.feed);

  FeedModel.create({
    required super.id,
    required super.timeMills,
    required super.type,
    required super.path,
    required super.content,
    super.recentRef,
    UserModel? publisher,
  }) : super(
         contentType: ContentType.feed,
         publisherId: publisher?.id ?? UserHelper.uid,
         publisherAge: publisher?.age ?? UserHelper.user.age,
         publisherGender: publisher?.gender ?? UserHelper.user.gender,
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
         uiState: ContentUiState.processing,
       );

  factory FeedModel.parse(Object? source) {
    final content = source is FeedModel ? source : ContentModel.parse(source);
    return FeedModel._(
      id: content.id,
      timeMills: content.timeMills,
      // PUBLISHER
      publisherId: content.publisherId,
      publisherAge: content.publisherAge,
      publisherGender: content.publisherGender,
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
      content: normalize(content.content),
      recent: content.recent,
      path: content.path,
      type: content.type,
    );
  }

  static ContentModel normalize(ContentModel raw) {
    final type = raw.contentType;
    if (type == ContentType.userPost) {
      return PostModel.parse(raw);
    } else {
      return raw;
    }
  }

  FeedModel copyWith({
    String? id,
    int? timeMills,
    String? publisherId,
    int? publisherAge,
    Gender? publisherGender,
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
    ContentModel? content,
    ContentModel? recent,
    FeedType? type,
    ContentUiState? uiState,
  }) {
    return FeedModel._(
      id: stringify(id, this.id),
      timeMills: stringify(timeMills, this.timeMills),
      publisherId: stringify(publisherId, this.publisherId),
      publisherAge: stringify(publisherAge, this.publisherAge),
      publisherGender: stringify(publisherGender, this.publisherGender),
      publisherProfession: stringify(
        publisherProfession,
        this.publisherProfession,
      ),
      publisherRating: stringify(publisherRating, this.publisherRating),
      publisherReligion: stringify(publisherReligion, this.publisherReligion),
      city: stringify(city, this.city),
      country: stringify(country, this.country),
      latitude: stringify(latitude, this.latitude),
      longitude: stringify(longitude, this.longitude),
      region: stringify(region, this.region),
      zip: stringify(zip, this.zip),
      path: stringify(path, this.path),
      content: stringify(content, this.content),
      recent: stringify(recent, this.recent),
      type: stringify(type, this.type),
      uiState: stringify(uiState, this.uiState),
    );
  }
}
