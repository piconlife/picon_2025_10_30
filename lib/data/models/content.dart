import 'package:collection/collection.dart';
import 'package:flutter_entity/flutter_entity.dart';

import '../../app/helpers/user.dart';
import '../constants/keys.dart';
import '../enums/audience.dart';
import '../enums/feed_type.dart';
import '../enums/privacy.dart';
import 'user.dart';

const _equality = DeepCollectionEquality();

class Content extends Entity<Keys> {
  // PUBLISHER
  String? _publisherId;
  int? publisherAge;
  String? publisherPhotoUrl;
  String? publisherProfession;
  String? publisherProfilePath;
  String? publisherProfileUrl;
  String? publisherName;
  String? publisherShortName;
  String? publisherTitle;
  double? publisherRating;
  String? publisherReligion;
  double? publisherLatitude;
  double? publisherLongitude;
  String? _publisherGender;

  // LOCATION
  String? city;
  String? country;
  double? latitude;
  double? longitude;
  String? region;
  int? zip;

  // CONTENT
  Audience? _audience;
  List<String>? bookmarks;
  Content? _content;
  List<Content>? contents;
  List<String>? comments;
  int? commentCount;
  String? _description;
  List<String>? _descriptions;
  List<String>? likes;
  int? likeCount;
  String? link;
  String? name;
  String? parentId;
  String? parentLink;
  String? parentPath;
  String? reference;
  String? parentUrl;
  String? path;
  List<String>? photosRef;
  List<Content>? photos;
  List<String>? photoIds;
  String? photoUrl;
  List<String>? _photoUrls;
  int? priority;
  Privacy? _privacy;
  Content? _recent;
  String? recentId;
  String? recentPath;
  String? referenceId;
  String? referencePath;
  int? reportCount;
  List<String>? reports;
  int? starCount;
  List<String>? stars;
  List<String>? tags;
  String? text;
  String? title;
  FeedType? _type;
  String? url;
  bool? verified;
  List<Content>? videos;
  List<String>? videoIds;
  String? videoUrl;
  List<String>? videoUrls;
  int? viewCount;
  List<String>? views;

  // LOCAL INFO
  String? translatedTitle;
  String? translatedDescription;
  List<String>? translatedDescriptions;

  String? get publisherId => _publisherId ?? _content?._publisherId;

  Content get content => _content ?? Content();

  bool get isTranslated {
    return (translatedTitle ??
            translatedDescription ??
            translatedDescriptions?.firstOrNull ??
            '')
        .isNotEmpty;
  }

  String? get description {
    return _description ??
        _descriptions?.firstOrNull ??
        content._description ??
        content._descriptions?.firstOrNull;
  }

  List<String>? get descriptions {
    return _descriptions ?? (_description != null ? [_description!] : null);
  }

  bool get isPublisher => publisherId == UserHelper.uid;

  bool get isReported => reports?.contains(UserHelper.uid) ?? false;

  bool get isDescription {
    return (_description ?? _descriptions?.firstOrNull ?? '').isNotEmpty;
  }

  bool get isTitled => (title ?? '').isNotEmpty;

  bool get isTranslatable => isTitled || isDescription;

  bool get isShareMode => privacy.isEveryone || isPublisher;

  bool get isPhotoMode => photoUrlAt != null;

  bool get isVideoMode => (videoUrl ?? videoUrls?.firstOrNull) != null;

  Gender get publisherGender => Gender.from(_publisherGender);

  String? get photoUrlAt {
    return photoUrl ??
        _photoUrls?.firstOrNull ??
        content.photoUrl ??
        content._photoUrls?.firstOrNull;
  }

  List<String> get photoUrls {
    return _photoUrls ?? [if (photoUrl != null) photoUrl!];
  }

  Audience get audience => _audience ?? Audience.everyone;

  Privacy get privacy => _privacy ?? Privacy.everyone;

  FeedType get type => _type ?? FeedType.none;

  Content get recent => _recent ?? Content();

  Content({
    // -------------------------------------------------------------------------
    // ROOT
    // -------------------------------------------------------------------------
    super.id,
    super.timeMills,

    // -------------------------------------------------------------------------
    // PUBLISHER
    // -------------------------------------------------------------------------
    String? publisherId,
    this.publisherAge,
    String? publisherGender,
    this.publisherLatitude,
    this.publisherLongitude,
    this.publisherName,
    this.publisherPhotoUrl,
    this.publisherProfession,
    this.publisherProfilePath,
    this.publisherProfileUrl,
    this.publisherRating,
    this.publisherReligion,
    this.publisherShortName,
    this.publisherTitle,

    // -------------------------------------------------------------------------
    // ID & PATH
    // -------------------------------------------------------------------------
    this.parentId,
    this.parentPath,
    this.path,
    this.recentPath,
    this.referencePath,

    // -------------------------------------------------------------------------
    // LOCATION
    // -------------------------------------------------------------------------
    this.city,
    this.country,
    this.latitude,
    this.longitude,
    this.region,
    this.zip,

    // -------------------------------------------------------------------------
    // ENUMS
    // -------------------------------------------------------------------------
    Audience? audience,
    Privacy? privacy,
    FeedType? type,

    // -------------------------------------------------------------------------
    // REFERENCE
    // -------------------------------------------------------------------------
    Content? content,
    this.photos,
    Content? recent,

    // -------------------------------------------------------------------------
    // IF NEEDED
    // -------------------------------------------------------------------------
    // -------------------------------------------------------------------------
    // ARRAYS
    // -------------------------------------------------------------------------
    this.tags,

    // -------------------------------------------------------------------------
    // INT & DOUBLE
    // -------------------------------------------------------------------------
    this.likeCount,
    this.priority,
    this.viewCount,

    // -------------------------------------------------------------------------
    // STRING
    // -------------------------------------------------------------------------
    String? description,
    this.name,
    this.title,

    // -------------------------------------------------------------------------
    // URL
    // -------------------------------------------------------------------------
    this.photoUrl,
    this.videoUrl,

    // -------------------------------------------------------------------------
    // IF NEEDED (INTERNAL USE ONLY)
    // -------------------------------------------------------------------------
    this.translatedTitle,
    this.translatedDescription,
    this.translatedDescriptions,
  }) : // ----------------------------------------------------------------------
       // PUBLISHER
       // ----------------------------------------------------------------------
       _publisherId = publisherId,
       _publisherGender = publisherGender,

       // ----------------------------------------------------------------------
       // ENUMS
       // ----------------------------------------------------------------------
       _audience = audience,
       _privacy = privacy,
       _type = type,

       // ----------------------------------------------------------------------
       // REFERENCE
       // ----------------------------------------------------------------------
       _content = content,
       _recent = recent,

       // ----------------------------------------------------------------------
       // IF NEEDED
       // ----------------------------------------------------------------------
       _description = description;

  factory Content.parse(Object? source) {
    final key = Keys.i;
    return Content(
      // -----------------------------------------------------------------------
      // ROOT
      // -----------------------------------------------------------------------
      id: source.entityValue(key.id),
      timeMills: source.entityValue(key.timeMills),

      // -----------------------------------------------------------------------
      // PUBLISHER
      // -----------------------------------------------------------------------
      publisherId: source.entityValue(key.publisherId),
      publisherAge: source.entityValue(key.publisherAge),
      publisherGender: source.entityValue(key.publisherGender),
      publisherLatitude: source.entityValue(key.publisherLatitude),
      publisherLongitude: source.entityValue(key.publisherLongitude),
      publisherName: source.entityValue(key.publisherName),
      publisherPhotoUrl: source.entityValue(key.publisherPhotoUrl),
      publisherProfession: source.entityValue(key.publisherProfession),
      publisherProfilePath: source.entityValue(key.publisherProfilePath),
      publisherProfileUrl: source.entityValue(key.publisherProfileUrl),
      publisherRating: source.entityValue(key.publisherRating),
      publisherReligion: source.entityValue(key.publisherReligion),
      publisherShortName: source.entityValue(key.publisherShortName),
      publisherTitle: source.entityValue(key.publisherTitle),

      // -----------------------------------------------------------------------
      // ID & PATH
      // -----------------------------------------------------------------------
      parentId: source.entityValue(key.parentId),
      parentPath: source.entityValue(key.parentPath),
      path: source.entityValue(key.path),
      recentPath: source.entityValue(key.recentPath),
      referencePath: source.entityValue(key.referencePath),

      // -----------------------------------------------------------------------
      // LOCATION
      // -----------------------------------------------------------------------
      city: source.entityValue(key.city),
      country: source.entityValue(key.country),
      latitude: source.entityValue(key.latitude),
      longitude: source.entityValue(key.longitude),
      region: source.entityValue(key.region),
      zip: source.entityValue(key.zip),

      // -----------------------------------------------------------------------
      // ENUMS
      // -----------------------------------------------------------------------
      audience: source.entityValue(key.audience, Audience.from),
      privacy: source.entityValue(key.privacy, Privacy.parse),
      type: source.entityValue(key.type, FeedType.parse),

      // -----------------------------------------------------------------------
      // REFERENCE
      // -----------------------------------------------------------------------
      content: source.entityValue(key.contentRef, Content.parse),
      photos: source.entityValues(key.photosRef, Content.parse),
      recent: source.entityValue(key.recentRef, Content.parse),

      // -----------------------------------------------------------------------
      // IF NEEDED
      // -----------------------------------------------------------------------
      // ARRAYS
      // -----------------------------------------------------------------------
      tags: source.entityValues(key.tags),

      // -----------------------------------------------------------------------
      // INT & DOUBLE
      // -----------------------------------------------------------------------
      likeCount: source.entityValue(key.likeCount),
      priority: source.entityValue(key.priority),
      viewCount: source.entityValue(key.viewCount),

      // -----------------------------------------------------------------------
      // STRING
      // -----------------------------------------------------------------------
      description: source.entityValue(key.description),
      name: source.entityValue(key.name),
      title: source.entityValue(key.title),

      // -----------------------------------------------------------------------
      // URL
      // -----------------------------------------------------------------------
      photoUrl: source.entityValue(key.photoUrl),
      videoUrl: source.entityValue(key.videoUrl),
    );
  }

  @override
  Keys makeKey() => Keys.i;

  @override
  bool isInsertable(String key, value) => value != null && keys.contains(key);

  Map<String, dynamic> get metadata {
    return {key.path: path, "create": source};
  }

  @override
  Map<String, dynamic> get source {
    final entries = {
      // -----------------------------------------------------------------------
      // PUBLISHER
      // -----------------------------------------------------------------------
      key.publisherId: _publisherId,
      key.publisherAge: publisherAge,
      key.publisherGender: _publisherGender,
      key.publisherLatitude: publisherLatitude,
      key.publisherLongitude: publisherLongitude,
      key.publisherName: publisherName,
      key.publisherPhotoUrl: publisherPhotoUrl,
      key.publisherProfession: publisherProfession,
      key.publisherProfilePath: publisherProfilePath,
      key.publisherProfileUrl: publisherProfileUrl,
      key.publisherRating: publisherRating,
      key.publisherReligion: publisherReligion,
      key.publisherShortName: publisherShortName,
      key.publisherTitle: publisherTitle,

      // -----------------------------------------------------------------------
      // LOCATION
      // -----------------------------------------------------------------------
      key.city: city,
      key.country: country,
      key.latitude: latitude,
      key.longitude: longitude,
      key.region: region,
      key.zip: zip,

      // -----------------------------------------------------------------------
      // ID & PATH
      // -----------------------------------------------------------------------
      key.parentId: parentId,
      key.parentPath: parentPath,
      key.path: path,
      key.recentPath: recentPath,
      key.referencePath: referencePath,

      // -----------------------------------------------------------------------
      // REFERENCE
      // -----------------------------------------------------------------------
      key.contentRef: _content?.metadata,
      key.photosRef: photos?.map((e) => e.metadata).toList(),
      key.recentRef: _recent?.metadata,

      // -----------------------------------------------------------------------
      // ENUMS
      // -----------------------------------------------------------------------
      key.audience: _audience?.name,
      key.privacy: _privacy?.name,
      key.type: _type?.name,

      // -----------------------------------------------------------------------
      // ARRAY
      // -----------------------------------------------------------------------
      key.tags: tags,

      // -----------------------------------------------------------------------
      // STRING
      // -----------------------------------------------------------------------
      key.description: _description,
      key.name: name,
      key.title: title,

      // -----------------------------------------------------------------------
      // URL
      // -----------------------------------------------------------------------
      key.photoUrl: photoUrl,
      key.videoUrl: videoUrl,

      // -----------------------------------------------------------------------
      // INT & DOUBLE
      // -----------------------------------------------------------------------
      key.likeCount: likeCount,
      key.priority: priority,
      key.viewCount: viewCount,
    }.entries.where((e) => isInsertable(e.key, e.value));
    return super.source..addAll(Map.fromEntries(entries));
  }

  Iterable<String> get keys => [];

  @override
  int get hashCode => Object.hashAll([
    idOrNull,
    timeMillsOrNull,
    // PUBLISHER
    _publisherId,
    publisherAge,
    _publisherGender,
    publisherLatitude,
    publisherLongitude,
    publisherName,
    publisherPhotoUrl,
    publisherProfession,
    publisherProfilePath,
    publisherProfileUrl,
    publisherRating,
    publisherReligion,
    publisherShortName,
    publisherTitle,

    // LOCATION
    city,
    country,
    latitude,
    longitude,
    region,
    zip,

    // PATH
    parentId,
    parentPath,
    path,
    recentPath,
    referencePath,

    // REFERENCE
    if (_content != null) _content,
    if (photos != null && photos!.isNotEmpty) _equality.hash(photos),
    if (_recent != null) _recent,

    // TYPE
    _audience?.name,
    _privacy?.name,
    _type?.name,

    // ARRAY
    _equality.hash(tags),

    // STRING
    _description,
    name,
    title,

    // -------------------------------------------------------------------------
    // URL
    // -------------------------------------------------------------------------
    photoUrl,
    videoUrl,

    // INT & DOUBLE
    likeCount,
    priority,
    viewCount,
  ]);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Content &&
        idOrNull == other.idOrNull &&
        timeMillsOrNull == other.timeMillsOrNull &&
        // PUBLISHER
        _publisherId == other._publisherId &&
        publisherAge == other.publisherAge &&
        _publisherGender == other._publisherGender &&
        publisherLatitude == other.publisherLatitude &&
        publisherLongitude == other.publisherLongitude &&
        publisherName == other.publisherName &&
        publisherPhotoUrl == other.publisherPhotoUrl &&
        publisherProfession == other.publisherProfession &&
        publisherProfilePath == other.publisherProfilePath &&
        publisherProfileUrl == other.publisherProfileUrl &&
        publisherRating == other.publisherRating &&
        publisherReligion == other.publisherReligion &&
        publisherShortName == other.publisherShortName &&
        publisherTitle == other.publisherTitle &&
        // LOCATION
        city == other.city &&
        country == other.country &&
        latitude == other.latitude &&
        longitude == other.longitude &&
        region == other.region &&
        zip == other.zip &&
        // PATH
        parentId == other.parentId &&
        parentPath == other.parentPath &&
        path == other.path &&
        recentPath == other.recentPath &&
        referencePath == other.referencePath &&
        // REFERENCE
        _content == other._content &&
        _equality.equals(photos, other.photos) &&
        _recent == other._recent &&
        // TYPE
        _audience == other._audience &&
        _privacy == other._privacy &&
        _type == other._type &&
        // ARRAY
        _equality.equals(tags, other.tags) &&
        // STRING
        _description == other._description &&
        name == other.name &&
        title == other.title &&
        // URL
        photoUrl == other.photoUrl &&
        videoUrl == other.videoUrl &&
        // INT & DOUBLE
        likeCount == other.likeCount &&
        priority == other.priority &&
        viewCount == other.viewCount;
  }
}
