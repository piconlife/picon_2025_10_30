import 'package:flutter_andomie/utils/key_generator.dart';
import 'package:flutter_entity/flutter_entity.dart';

import '../../app/helpers/user.dart';
import '../constants/keys.dart';
import '../enums/audience.dart';
import '../enums/feed_type.dart';
import '../enums/privacy.dart';
import 'photo.dart';
import 'user.dart';

class Content extends Entity<Keys> {
  // PUBLISHER
  String? _publisherId;
  int? publisherAge;
  String? publisherPhoto;
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
  List<Photo>? photos;
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
    // PUBLISHER
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
    String? publisherId,
    String? publisherGender,

    // LOCATION
    this.city,
    this.country,
    this.latitude,
    this.longitude,
    this.region,
    this.zip,

    // REFERENCES
    this.path,
    this.reference,
    Content? content,
    FeedType? type,

    // OTHERS
    String? id,
    super.timeMills,
    Audience? audience,
    this.bookmarks,
    this.contents,
    this.commentCount,
    this.comments,
    String? description,
    List<String>? descriptions,
    this.likeCount,
    this.likes,
    this.link,
    this.name,
    this.parentId,
    this.parentLink,
    this.parentPath,
    this.parentUrl,
    this.photos,
    this.photoIds,
    this.photoUrl,
    Iterable<String>? photoUrls,
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
  }) : _publisherId = publisherId,
       _publisherGender = publisherGender,
       _photoUrls = photoUrls?.toList(),
       _audience = audience,
       _content = content,
       _privacy = privacy,
       _type = type,
       _recent = recent,
       _description = description,
       _descriptions = descriptions,
       super(id: id ?? KeyGenerator.generateKey(extraKeySize: 8));

  factory Content.parse(Object? source) {
    final key = Keys.i;
    return Content(
      // PUBLISHER
      publisherId: source.entityValue(key.publisher),
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
      photos: source.entityValues(key.photos, Photo.parse),
      priority: source.entityValue(key.priority),
      recentId: source.entityValue(key.recentId),
      recentPath: source.entityValue(key.recentPath),
      referenceId: source.entityValue(key.referenceId),
      referencePath: source.entityValue(key.referencePath),
      description: source.entityValue(key.description),
      descriptions: source.entityValues(key.descriptions),
      url: source.entityValue(key.url),
      verified: source.entityValue(key.verified),
      videos: source.entityValues(key.videos, Content.parse),
      videoIds: source.entityValues(key.videoIds),
      videoUrl: source.entityValue(key.videoUrl),
      videoUrls: source.entityValues(key.videoUrls),
      views: source.entityValues(key.views),
      viewCount: source.entityValue(key.viewCount),
      bookmarks: source.entityValues(key.bookmarks),
      content: source.entityValue(key.content, Content.parse),
      contents: source.entityValues(key.contents, Content.parse),
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
      privacy: source.entityValue(key.privacy, Privacy.parse),
      type: source.entityValue(key.type, FeedType.parse),
      recent: source.entityValue(key.recent, Content.parse),
    );
  }

  @override
  bool isInsertable(String key, value) {
    return value != null && keys.contains(key);
  }

  Iterable<String> get keys => key.keys;

  @override
  Map<String, dynamic> get source {
    final entries = {
      // PUBLISHER INFO
      key.publisher: _publisherId,
      // key.publisherRef: publisher,
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
