import 'package:flutter_andomie/utils.dart';
import 'package:flutter_entity/flutter_entity.dart';

import '../../app/helpers/user.dart';
import '../constants/keys.dart';
import '../enums/audience.dart';
import '../enums/content.dart';
import '../enums/privacy.dart';
import 'photo.dart';
import 'user.dart';

class Content extends Entity<Keys> {
  // PUBLISHER

  final String? publisher;
  final int? publisherAge;
  final String? publisherPhoto;
  final String? publisherProfession;
  final String? publisherProfilePath;
  final String? publisherProfileUrl;
  final String? publisherName;
  final String? publisherShortName;
  final String? publisherTitle;
  final double? publisherRating;
  final String? publisherReligion;
  final double? publisherLatitude;
  final double? publisherLongitude;
  final String? _publisherGender;

  // CONTENT
  final Audience? _audience;
  final List<String>? bookmarks;
  final List<Content>? contents;
  final List<String>? comments;
  final int? commentCount;
  final String? _description;
  final List<String>? _descriptions;
  final double? latitude;
  final double? longitude;
  final List<String>? likes;
  final int? likeCount;
  final String? link;
  final String? name;
  final String? parentId;
  final String? parentLink;
  final String? parentPath;
  final String? parentUrl;
  final String? path;
  final List<Photo>? photos;
  final List<String>? photoIds;
  final String? photoUrl;
  final List<String>? photoUrls;
  final int? priority;
  final Privacy? _privacy;
  final Content? _recent;
  final String? recentId;
  final String? recentPath;
  final String? referenceId;
  final String? referencePath;
  final int? reportCount;
  final List<String>? reports;
  final int? starCount;
  final List<String>? stars;
  final List<String>? tags;
  final String? text;
  final String? title;
  final ContentType? _type;
  final String? url;
  final bool? verified;
  final List<Content>? videos;
  final List<String>? videoIds;
  final String? videoUrl;
  final List<String>? videoUrls;
  final int? viewCount;
  final List<String>? views;

  // LOCAL INFO
  final String? translatedTitle;
  final String? translatedDescription;
  final List<String>? translatedDescriptions;

  bool get isTranslated {
    return (translatedTitle ??
            translatedDescription ??
            translatedDescriptions?.firstOrNull ??
            '')
        .isNotEmpty;
  }

  String? get description => _description ?? _descriptions?.firstOrNull;

  List<String>? get descriptions {
    return _descriptions ?? (_description != null ? [_description] : null);
  }

  bool get isPublisher => publisher != UserHelper.uid;

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

  String? get photoUrlAt => photoUrl ?? photoUrls?.firstOrNull;

  Audience get audience => _audience ?? Audience.everyone;

  Privacy get privacy => _privacy ?? Privacy.everyone;

  ContentType get contentType => _type ?? ContentType.none;

  Content get recent => _recent ?? Content();

  Content({
    // PUBLISHER
    this.publisher,
    this.publisherAge,
    this.publisherPhoto,
    this.publisherProfession,
    this.publisherProfilePath,
    this.publisherProfileUrl,
    this.publisherName,
    this.publisherShortName,
    this.publisherTitle,
    this.publisherRating,
    this.publisherReligion,
    this.publisherLatitude,
    this.publisherLongitude,
    String? publisherGender,

    // CONTENT
    String? id,
    super.timeMills,
    Audience? audience,
    this.bookmarks,
    this.contents,
    this.commentCount,
    this.comments,
    String? description,
    List<String>? descriptions,
    this.latitude,
    this.likeCount,
    this.likes,
    this.link,
    this.longitude,
    this.name,
    this.parentId,
    this.parentLink,
    this.parentPath,
    this.parentUrl,
    this.photos,
    this.photoIds,
    this.photoUrl,
    this.photoUrls,
    this.path,
    this.priority,
    Privacy? privacy,
    Content? recent,
    this.recentId,
    this.recentPath,
    this.referenceId,
    this.referencePath,
    this.reportCount,
    this.reports,
    this.starCount,
    this.stars,
    this.tags,
    this.text,
    this.title,
    ContentType? type,
    this.url,
    this.verified,
    this.videos,
    this.videoIds,
    this.videoUrl,
    this.videoUrls,
    this.viewCount,
    this.views,
    // LOCAL INFO
    this.translatedTitle,
    this.translatedDescription,
    this.translatedDescriptions,
  }) : _publisherGender = publisherGender,
       _audience = audience,
       _privacy = privacy,
       _type = type,
       _recent = recent,
       _description = description,
       _descriptions = descriptions,
       super(id: id ?? KeyGenerator.generateKey(extraKeySize: 8));

  Content withContent({
    // PUBLISHER
    String? publisher,
    int? publisherAge,
    String? publisherPhoto,
    String? publisherProfession,
    String? publisherProfilePath,
    String? publisherProfileUrl,
    String? publisherName,
    String? publisherShortName,
    String? publisherTitle,
    double? publisherRating,
    String? publisherReligion,
    double? publisherLatitude,
    double? publisherLongitude,
    String? publisherGender,

    // CONTENT
    String? id,
    int? timeMills,
    String? description,
    List<String>? descriptions,
    String? text,
    String? title,
    String? link,
    String? path,
    String? parentId,
    String? parentPath,
    List<Photo>? photos,
    List<String>? photoIds,
    String? photoUrl,
    List<String>? photoUrls,
    int? priority,
    Content? recent,
    String? recentId,
    String? recentPath,
    String? referenceId,
    String? referencePath,
    String? url,
    bool? verified,
    List<Content>? videos,
    List<String>? videoIds,
    String? videoUrl,
    List<String>? videoUrls,
    List<String>? views,
    int? viewCount,
    List<String>? bookmarks,
    List<Content>? contents,
    int? commentCount,
    List<String>? comments,
    int? likeCount,
    List<String>? likes,
    String? name,
    int? reportCount,
    List<String>? reports,
    int? starCount,
    List<String>? stars,
    List<String>? tags,
    Audience? audience,
    Privacy? privacy,
    String? publisherId,
    ContentType? type,

    // LOCAL INFO
    // LOCAL INFO
    String? translatedTitle,
    String? translatedDescription,
    List<String>? translatedDescriptions,
  }) {
    return Content(
      // PUBLISHER
      publisher: publisher ?? this.publisher,
      publisherAge: publisherAge ?? this.publisherAge,
      publisherPhoto: publisherPhoto ?? this.publisherPhoto,
      publisherProfession: publisherProfession ?? this.publisherProfession,
      publisherProfilePath: publisherProfilePath ?? this.publisherProfilePath,
      publisherProfileUrl: publisherProfileUrl ?? this.publisherProfileUrl,
      publisherName: publisherName ?? this.publisherName,
      publisherShortName: publisherShortName ?? this.publisherShortName,
      publisherTitle: publisherTitle ?? this.publisherTitle,
      publisherRating: publisherRating ?? this.publisherRating,
      publisherReligion: publisherReligion ?? this.publisherReligion,
      publisherLatitude: publisherLatitude ?? this.publisherLatitude,
      publisherLongitude: publisherLongitude ?? this.publisherLongitude,
      publisherGender: publisherGender ?? _publisherGender,
      // CONTENT
      id: id ?? this.id,
      timeMills: timeMills ?? this.timeMills,
      text: text ?? this.text,
      title: title ?? this.title,
      link: link ?? this.link,
      path: path ?? this.path,
      parentId: parentId ?? this.parentId,
      parentPath: parentPath ?? this.parentPath,
      photos: photos ?? this.photos,
      photoIds: photoIds ?? this.photoIds,
      photoUrl: photoUrl ?? this.photoUrl,
      photoUrls: photoUrls ?? this.photoUrls,
      priority: priority ?? this.priority,
      recentId: recentId ?? this.recentId,
      recentPath: recentPath ?? this.recentPath,
      referenceId: referenceId ?? this.referenceId,
      referencePath: referencePath ?? this.referencePath,
      description: description ?? this.description,
      descriptions: descriptions ?? this.descriptions,
      url: url ?? this.url,
      verified: verified ?? this.verified,
      videos: videos ?? this.videos,
      videoIds: videoIds ?? this.videoIds,
      videoUrl: videoUrl ?? this.videoUrl,
      videoUrls: videoUrls ?? this.videoUrls,
      views: views ?? this.views,
      viewCount: viewCount ?? this.viewCount,
      bookmarks: bookmarks ?? this.bookmarks,
      contents: contents ?? this.contents,
      commentCount: commentCount ?? this.commentCount,
      comments: comments ?? this.comments,
      likeCount: likeCount ?? this.likeCount,
      likes: likes ?? this.likes,
      name: name ?? this.name,
      reportCount: reportCount ?? this.reportCount,
      reports: reports ?? this.reports,
      starCount: starCount ?? this.starCount,
      stars: stars ?? this.stars,
      tags: tags ?? this.tags,
      recent: recent ?? _recent,
      audience: audience ?? _audience,
      privacy: privacy ?? _privacy,
      type: type ?? _type,

      // LOCAL INFO
      translatedTitle: translatedTitle ?? this.translatedTitle,
      translatedDescription:
          translatedDescription ?? this.translatedDescription,
      translatedDescriptions:
          translatedDescriptions ?? this.translatedDescriptions,
    );
  }

  factory Content.from(Object? source) {
    final key = Keys.i;
    return Content(
      // PUBLISHER
      publisher: source.entityValue(key.publisher),
      publisherAge: source.entityValue(key.publisherAge),
      publisherPhoto: source.entityValue(key.publisherPhoto),
      publisherProfession: source.entityValue(key.publisherProfession),
      publisherProfilePath: source.entityValue(key.publisherProfilePath),
      publisherProfileUrl: source.entityValue(key.publisherProfileUrl),
      publisherName: source.entityValue(key.publisherName),
      publisherShortName: source.entityValue(key.publisherShortName),
      publisherTitle: source.entityValue(key.publisherTitle),
      publisherRating: source.entityValue(key.publisherRating),
      publisherReligion: source.entityValue(key.publisherReligion),
      publisherLatitude: source.entityValue(key.publisherLatitude),
      publisherLongitude: source.entityValue(key.publisherLongitude),
      publisherGender: source.entityValue(key.publisherGender),

      // CONTENT
      id: source.entityValue(key.id),
      timeMills: source.entityValue(key.timeMills),
      text: source.entityValue(key.text),
      title: source.entityValue(key.title),
      link: source.entityValue(key.link),
      path: source.entityValue(key.path),
      parentId: source.entityValue(key.parentId),
      parentPath: source.entityValue(key.parentPath),
      photoUrl: source.entityValue(key.photoUrl),
      photoUrls: source.entityValues(key.photoUrls),
      photos: source.entityValues(key.photos, Photo.from),
      priority: source.entityValue(key.priority),
      recentId: source.entityValue(key.recentId),
      recentPath: source.entityValue(key.recentPath),
      referenceId: source.entityValue(key.referenceId),
      referencePath: source.entityValue(key.referencePath),
      description: source.entityValue(key.description),
      descriptions: source.entityValues(key.descriptions),
      url: source.entityValue(key.url),
      verified: source.entityValue(key.verified),
      videos: source.entityValues(key.videos, Content.from),
      videoIds: source.entityValues(key.videoIds),
      videoUrl: source.entityValue(key.videoUrl),
      videoUrls: source.entityValues(key.videoUrls),
      views: source.entityValues(key.views),
      viewCount: source.entityValue(key.viewCount),
      bookmarks: source.entityValues(key.bookmarks),
      contents: source.entityValues(key.contents, Content.from),
      commentCount: source.entityValue(key.commentCount),
      comments: source.entityValues(key.comments),
      likeCount: source.entityValue(key.likeCount),
      likes: source.entityValues(key.likes),
      name: source.entityValue(key.name),
      reportCount: source.entityValue(key.reportCount),
      reports: source.entityValues(key.reports),
      starCount: source.entityValue(key.starCount),
      stars: source.entityValues(key.stars),
      tags: source.entityValues(key.tags),
      audience: source.entityValue(key.audience, Audience.from),
      privacy: source.entityValue(key.privacy, Privacy.from),
      type: source.entityValue(key.type, ContentType.from),
      recent: source.entityValue(key.recent, Content.from),
    );
  }

  @override
  Keys makeKey() => Keys.i;

  @override
  bool isInsertable(String key, value) => this.key.keys.contains(key);

  @override
  Map<String, dynamic> get source {
    final entries = {
      // PUBLISHER INFO
      key.publisher: publisher,
      key.publisherAge: publisherAge,
      key.publisherPhoto: publisherPhoto,
      key.publisherProfession: publisherProfession,
      key.publisherProfilePath: publisherProfilePath,
      key.publisherProfileUrl: publisherProfileUrl,
      key.publisherName: publisherName,
      key.publisherShortName: publisherShortName,
      key.publisherTitle: publisherTitle,
      key.publisherRating: publisherRating,
      key.publisherReligion: publisherReligion,
      key.publisherLatitude: publisherLatitude,
      key.publisherLongitude: publisherLongitude,
      key.publisherGender: _publisherGender,
      // CONTENT INFO
      key.text: text,
      key.title: title,
      key.link: link,
      key.path: path,
      key.parentId: parentId,
      key.parentPath: parentPath,
      key.photoUrl: photoUrl,
      key.photoIds: photoIds,
      key.photoUrls: photoUrls,
      key.priority: priority,
      key.recentId: recentId,
      key.recentPath: recentPath,
      key.referenceId: referenceId,
      key.referencePath: referencePath,
      key.description: _description,
      key.descriptions: _descriptions,
      key.url: url,
      key.verified: verified,
      key.videoIds: videoIds,
      key.videoUrl: videoUrl,
      key.videoUrls: videoUrls,
      key.views: views,
      key.viewCount: viewCount,
      key.bookmarks: bookmarks,
      key.commentCount: commentCount,
      key.comments: comments,
      key.likeCount: likeCount,
      key.likes: likes,
      key.name: name,
      key.reportCount: reportCount,
      key.reports: reports,
      key.starCount: starCount,
      key.stars: stars,
      key.tags: tags,
      key.audience: _audience?.name,
      key.privacy: _privacy?.name,
      key.type: _type?.name,
      key.recent: _recent?.source,
    }.entries.where((e) => isInsertable(e.key, e.value));
    return super.source..addAll(Map.fromEntries(entries));
  }

  @override
  int get hashCode => id.hashCode;

  @override
  bool operator ==(Object other) {
    return other is Content && id == other.id && hashCode == other.hashCode;
  }
}
