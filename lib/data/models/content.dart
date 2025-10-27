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

  bool get isPrivacyAllow {
    if (UserHelper.isCurrentUser(publisherId)) return true;
    if (privacy.isOnlyMe) return false;
    if (privacy.isEveryone) return true;
    if (privacy.isOnlyFriends && UserHelper.isFollowing(publisherId)) {
      return true;
    }
    return false;
  }

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

  Content.empty();

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
      content: source.entityValue(key.content, Content.parse),
      photos: source.entityValues(key.photos, Content.parse),
      recent: source.entityValue(key.recent, Content.parse),

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

  Content change({
    // -------------------------------------------------------------------------
    // ROOT
    // -------------------------------------------------------------------------
    String? id,
    int? timeMills,

    // -------------------------------------------------------------------------
    // PUBLISHER
    // -------------------------------------------------------------------------
    String? publisherId,
    int? publisherAge,
    String? publisherGender,
    double? publisherLatitude,
    double? publisherLongitude,
    String? publisherName,
    String? publisherPhotoUrl,
    String? publisherProfession,
    String? publisherProfilePath,
    String? publisherProfileUrl,
    double? publisherRating,
    String? publisherReligion,
    String? publisherShortName,
    String? publisherTitle,

    // -------------------------------------------------------------------------
    // ID & PATH
    // -------------------------------------------------------------------------
    String? parentId,
    String? parentPath,
    String? path,
    String? recentPath,
    String? referencePath,

    // -------------------------------------------------------------------------
    // LOCATION
    // -------------------------------------------------------------------------
    String? city,
    String? country,
    double? latitude,
    double? longitude,
    String? region,
    int? zip,

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
    List<Content>? photos,
    Content? recent,

    // -------------------------------------------------------------------------
    // IF NEEDED
    // -------------------------------------------------------------------------
    // ARRAYS
    // -------------------------------------------------------------------------
    List<String>? tags,

    // -------------------------------------------------------------------------
    // INT & DOUBLE
    // -------------------------------------------------------------------------
    int? likeCount,
    int? priority,
    int? viewCount,

    // -------------------------------------------------------------------------
    // STRING
    // -------------------------------------------------------------------------
    String? description,
    String? name,
    String? title,

    // -------------------------------------------------------------------------
    // URL
    // -------------------------------------------------------------------------
    String? photoUrl,
    String? videoUrl,
  }) {
    return Content(
      // -----------------------------------------------------------------------
      // ROOT
      // -----------------------------------------------------------------------
      id: id ?? idOrNull,
      timeMills: timeMills ?? timeMillsOrNull,

      // -----------------------------------------------------------------------
      // PUBLISHER
      // -----------------------------------------------------------------------
      publisherId: publisherId ?? this.publisherId,
      publisherAge: publisherAge ?? this.publisherAge,
      publisherGender: publisherGender ?? _publisherGender,
      publisherLatitude: publisherLatitude ?? this.publisherLatitude,
      publisherLongitude: publisherLongitude ?? this.publisherLongitude,
      publisherName: publisherName ?? this.publisherName,
      publisherPhotoUrl: publisherPhotoUrl ?? this.publisherPhotoUrl,
      publisherProfession: publisherProfession ?? this.publisherProfession,
      publisherProfilePath: publisherProfilePath ?? this.publisherProfilePath,
      publisherProfileUrl: publisherProfileUrl ?? this.publisherProfileUrl,
      publisherRating: publisherRating ?? this.publisherRating,
      publisherReligion: publisherReligion ?? this.publisherReligion,
      publisherShortName: publisherShortName ?? this.publisherShortName,
      publisherTitle: publisherTitle ?? this.publisherTitle,

      // -----------------------------------------------------------------------
      // ID & PATH
      // -----------------------------------------------------------------------
      parentId: parentId ?? this.parentId,
      parentPath: parentPath ?? this.parentPath,
      path: path ?? this.path,
      recentPath: recentPath ?? this.recentPath,
      referencePath: referencePath ?? this.referencePath,

      // -----------------------------------------------------------------------
      // LOCATION
      // -----------------------------------------------------------------------
      city: city ?? this.city,
      country: country ?? this.country,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      region: region ?? this.region,
      zip: zip ?? this.zip,

      // -----------------------------------------------------------------------
      // ENUMS
      // -----------------------------------------------------------------------
      audience: audience ?? _audience,
      privacy: privacy ?? _privacy,
      type: type ?? _type,

      // -----------------------------------------------------------------------
      // REFERENCE
      // -----------------------------------------------------------------------
      content: content ?? _content,
      photos: photos ?? this.photos,
      recent: recent ?? _recent,

      // -----------------------------------------------------------------------
      // IF NEEDED
      // -----------------------------------------------------------------------
      // ARRAYS
      // -----------------------------------------------------------------------
      tags: tags ?? this.tags,

      // -----------------------------------------------------------------------
      // INT & DOUBLE
      // -----------------------------------------------------------------------
      likeCount: likeCount ?? this.likeCount,
      priority: priority ?? this.priority,
      viewCount: viewCount ?? this.viewCount,

      // -----------------------------------------------------------------------
      // STRING
      // -----------------------------------------------------------------------
      description: description ?? this.description,
      name: name ?? this.name,
      title: title ?? this.title,

      // -----------------------------------------------------------------------
      // URL
      // -----------------------------------------------------------------------
      photoUrl: photoUrl ?? this.photoUrl,
      videoUrl: videoUrl ?? this.videoUrl,
    );
  }

  @override
  Keys makeKey() => Keys.i;

  @override
  bool isInsertable(String key, value) {
    return value != null && keys.contains(key);
  }

  Map<String, dynamic> get metadata {
    return {key.path: path, "create": filtered};
  }

  @override
  Map<String, dynamic> get source {
    final entries = {
      // -----------------------------------------------------------------------
      // PUBLISHER
      // -----------------------------------------------------------------------
      if ((publisherId ?? '').isNotEmpty) key.publisherId: _publisherId,
      if ((publisherAge ?? 0) > 0) key.publisherAge: publisherAge,
      if ((_publisherGender ?? '').isNotEmpty)
        key.publisherGender: _publisherGender,
      if ((publisherLatitude ?? 0) != 0)
        key.publisherLatitude: publisherLatitude,
      if ((publisherLongitude ?? 0) != 0)
        key.publisherLongitude: publisherLongitude,
      if ((publisherName ?? '').isNotEmpty) key.publisherName: publisherName,
      if ((publisherPhotoUrl ?? '').isNotEmpty)
        key.publisherPhotoUrl: publisherPhotoUrl,
      if ((publisherProfession ?? '').isNotEmpty)
        key.publisherProfession: publisherProfession,
      if ((publisherProfilePath ?? '').isNotEmpty)
        key.publisherProfilePath: publisherProfilePath,
      if ((publisherProfileUrl ?? '').isNotEmpty)
        key.publisherProfileUrl: publisherProfileUrl,
      if ((publisherRating ?? 0) > 0) key.publisherRating: publisherRating,
      if ((publisherReligion ?? '').isNotEmpty)
        key.publisherReligion: publisherReligion,
      if ((publisherShortName ?? '').isNotEmpty)
        key.publisherShortName: publisherShortName,
      if ((publisherTitle ?? '').isNotEmpty) key.publisherTitle: publisherTitle,

      // -----------------------------------------------------------------------
      // LOCATION
      // -----------------------------------------------------------------------
      if ((city ?? '').isNotEmpty) key.city: city,
      if ((country ?? '').isNotEmpty) key.country: country,
      if ((latitude ?? 0) != 0) key.latitude: latitude,
      if ((longitude ?? 0) != 0) key.longitude: longitude,
      if ((region ?? '').isNotEmpty) key.region: region,
      if ((zip ?? 0) != 0) key.zip: zip,

      // -----------------------------------------------------------------------
      // ID & PATH
      // -----------------------------------------------------------------------
      if ((parentId ?? '').isNotEmpty) key.parentId: parentId,
      if ((parentPath ?? '').isNotEmpty) key.parentPath: parentPath,
      if ((path ?? '').isNotEmpty) key.path: path,
      if ((recentPath ?? '').isNotEmpty) key.recentRef: recentPath,
      if ((referencePath ?? '').isNotEmpty) key.referencePath: referencePath,

      // -----------------------------------------------------------------------
      // REFERENCE
      // -----------------------------------------------------------------------
      if (_content != null) key.contentRef: _content?.metadata,
      if ((photos ?? []).isNotEmpty)
        key.photosRef: photos?.map((e) => e.metadata).toList(),
      if (_recent != null) key.recentRef: _recent?.metadata,

      // -----------------------------------------------------------------------
      // ENUMS
      // -----------------------------------------------------------------------
      if (_audience != null && _audience != Audience.everyone)
        key.audience: _audience?.name,
      if (_privacy != null && _privacy != Privacy.everyone)
        key.privacy: _privacy?.name,
      if (_type != null && _type != FeedType.none) key.type: _type?.name,

      // -----------------------------------------------------------------------
      // ARRAY
      // -----------------------------------------------------------------------
      if ((tags ?? []).isNotEmpty) key.tags: tags,

      // -----------------------------------------------------------------------
      // STRING
      // -----------------------------------------------------------------------
      if ((description ?? '').isNotEmpty) key.description: _description,
      if ((name ?? '').isNotEmpty) key.name: name,
      if ((title ?? '').isNotEmpty) key.title: title,

      // -----------------------------------------------------------------------
      // URL
      // -----------------------------------------------------------------------
      if ((photoUrl ?? '').isNotEmpty) key.photoUrl: photoUrl,
      if ((videoUrl ?? '').isNotEmpty) key.videoUrl: videoUrl,

      // -----------------------------------------------------------------------
      // INT & DOUBLE
      // -----------------------------------------------------------------------
      if ((likeCount ?? 0) != 0) key.likeCount: likeCount,
      if ((priority ?? 0) != 0) key.priority: priority,
      if ((viewCount ?? 0) != 0) key.viewCount: viewCount,
    }.entries.where((e) => isInsertable(e.key, e.value));
    return super.source..addAll(Map.fromEntries(entries));
  }

  Iterable<String> get keys => [
    // -------------------------------------------------------------------------
    // PUBLISHER
    // -------------------------------------------------------------------------
    key.publisherId,
    key.publisherAge,
    key.publisherGender,
    key.publisherLatitude,
    key.publisherLongitude,
    key.publisherName,
    key.publisherPhotoUrl,
    key.publisherProfession,
    key.publisherProfilePath,
    key.publisherProfileUrl,
    key.publisherRating,
    key.publisherReligion,
    key.publisherShortName,
    key.publisherTitle,

    // -------------------------------------------------------------------------
    // LOCATION
    // -------------------------------------------------------------------------
    key.city,
    key.country,
    key.latitude,
    key.longitude,
    key.region,
    key.zip,

    // -------------------------------------------------------------------------
    // ID & PATH
    // -------------------------------------------------------------------------
    key.parentId,
    key.parentPath,
    key.path,
    key.recentPath,
    key.referencePath,

    // -------------------------------------------------------------------------
    // REFERENCE
    // -------------------------------------------------------------------------
    key.contentRef,
    key.photosRef,
    key.recentRef,

    // -------------------------------------------------------------------------
    // ENUMS
    // -------------------------------------------------------------------------
    key.audience,
    key.privacy,
    key.type,

    // -------------------------------------------------------------------------
    // ARRAY
    // -------------------------------------------------------------------------
    key.tags,

    // -------------------------------------------------------------------------
    // STRING
    // -------------------------------------------------------------------------
    key.description,
    key.name,
    key.title,

    // -------------------------------------------------------------------------
    // URL
    // -------------------------------------------------------------------------
    key.photoUrl,
    key.videoUrl,

    // -------------------------------------------------------------------------
    // INT & DOUBLE
    // -------------------------------------------------------------------------
    key.likeCount,
    key.priority,
    key.viewCount,
  ];

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
