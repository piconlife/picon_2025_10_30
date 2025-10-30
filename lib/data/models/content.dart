import 'package:collection/collection.dart';
import 'package:data_management/core.dart';
import 'package:flutter_entity/flutter_entity.dart';
import 'package:picon/data/parsers/enum_parser.dart';

import '../../app/helpers/user.dart';
import '../constants/keys.dart';
import '../enums/audience.dart';
import '../enums/feed_type.dart';
import '../enums/gender.dart';
import '../enums/privacy.dart';

const _equality = DeepCollectionEquality();

class Content extends Entity<Keys> {
  // ---------------------------------------------------------------------------
  // ----------------------------------COMMON-----------------------------------
  // ---------------------------------------------------------------------------
  // PUBLISHER FIELDS
  String? _publisherId;
  int? _publisherAge;
  Gender? _publisherGender;
  double? _publisherLatitude;
  double? _publisherLongitude;
  String? _publisherName;
  String? _publisherPhotoUrl;
  String? _publisherProfession;
  String? _publisherProfilePath;
  String? _publisherProfileUrl;
  double? _publisherRating;
  String? _publisherReligion;
  String? _publisherShortName;
  String? _publisherTitle;

  // LOCATION FIELDS
  String? _city;
  String? _country;
  double? _latitude;
  double? _longitude;
  String? _region;
  int? _zip;

  // SETTERS (PUBLISHER)
  set publisherId(String? value) => _publisherId = value;

  set publisherAge(int? value) => _publisherAge = value;

  set publisherGender(Gender? value) => _publisherGender = value;

  set publisherLatitude(double? value) => _publisherLatitude = value;

  set publisherLongitude(double? value) => _publisherLongitude = value;

  set publisherName(String? value) => _publisherName = value;

  set publisherPhotoUrl(String? value) => _publisherPhotoUrl = value;

  set publisherProfession(String? value) => _publisherProfession = value;

  set publisherProfilePath(String? value) => _publisherProfilePath = value;

  set publisherProfileUrl(String? value) => _publisherProfileUrl = value;

  set publisherRating(double? value) => _publisherRating = value;

  set publisherReligion(String? value) => _publisherReligion = value;

  set publisherShortName(String? value) => _publisherShortName = value;

  set publisherTitle(String? value) => _publisherTitle = value;

  // SETTERS (LOCATIONS)
  set city(String? value) => _city = value;

  set country(String? value) => _country = value;

  set latitude(double? value) => _latitude = value;

  set longitude(double? value) => _longitude = value;

  set region(String? value) => _region = value;

  set zip(int? value) => _zip = value;

  // GETTERS (PUBLISHER)
  String? get publisherId => _string(_publisherId ?? _content?._publisherId);

  int get publisherAge => _int(_publisherAge ?? _content?._publisherAge) ?? 0;

  Gender get publisherGender =>
      _publisherGender ?? _content?._publisherGender ?? Gender.male;

  double get publisherLatitude =>
      _double(_publisherLatitude ?? _content?._publisherLatitude) ?? 0;

  double get publisherLongitude =>
      _double(_publisherLongitude ?? _content?._publisherLongitude) ?? 0;

  String? get publisherName =>
      _string(_publisherName ?? _content?._publisherName);

  String? get publisherPhotoUrl =>
      _string(_publisherPhotoUrl ?? _content?._publisherPhotoUrl, url: true);

  String? get publisherProfession =>
      _string(_publisherProfession ?? _content?._publisherProfession);

  String? get publisherProfilePath =>
      _string(_publisherProfilePath ?? _content?._publisherProfilePath);

  String? get publisherProfileUrl => _string(
    _publisherProfileUrl ?? _content?._publisherProfileUrl,
    url: true,
  );

  double get publisherRating =>
      _double(_publisherRating ?? _content?._publisherRating) ?? 0;

  String? get publisherReligion =>
      _string(_publisherReligion ?? _content?._publisherReligion);

  String? get publisherShortName =>
      _string(_publisherShortName ?? _content?._publisherShortName);

  String? get publisherTitle =>
      _string(_publisherTitle ?? _content?._publisherTitle);

  // GETTERS (LOCATION)
  String? get city => _string(_city ?? _content?._city);

  String? get country => _string(_country ?? _content?._country);

  double get latitude => _double(_latitude ?? _content?._latitude) ?? 0;

  double get longitude => _double(_longitude ?? _content?._longitude) ?? 0;

  String? get region => _string(_region ?? _content?._region);

  int? get zip => _int(_zip ?? _content?._zip);

  // ---------------------------------------------------------------------------
  // ---------------------------------BOOLEANS----------------------------------
  // ---------------------------------------------------------------------------
  // FIELDS
  bool? _verified;

  // SETTERS
  set verified(bool? value) => _verified = value;

  // GETTERS
  bool get verified => _verified ?? _content?._verified ?? false;

  // GETTER (CUSTOM)
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
    return (translatedTitle ?? translatedDescription ?? '').isNotEmpty;
  }

  bool get isPublisher => publisherId == UserHelper.uid;

  bool get isReported => reports.contains(UserHelper.uid);

  bool get isDescription => (description ?? '').isNotEmpty;

  bool get isTitled => (title ?? '').isNotEmpty;

  bool get isTranslatable => isTitled || isDescription;

  bool get isShareMode => privacy.isEveryone || isPublisher;

  bool get isPhotoMode => (photoUrl ?? '').isNotEmpty;

  bool get isVideoMode => (videoUrl ?? '').isNotEmpty;

  // ---------------------------------------------------------------------------
  // ---------------------------------INTEGERS----------------------------------
  // ---------------------------------------------------------------------------
  // FIELDS
  int? _commentCount;
  int? _likeCount;
  int? _priority;
  int? _reportCount;
  int? _starCount;
  int? _viewCount;

  // SETTERS
  set commentCount(int? value) => _commentCount = value;

  set likeCount(int? value) => _likeCount = value;

  set priority(int? value) => _priority = value;

  set reportCount(int? value) => _reportCount = value;

  set starCount(int? value) => _starCount = value;

  set viewCount(int? value) => _viewCount = value;

  // GETTERS
  int get commentCount => _int(_commentCount ?? _content?._commentCount) ?? 0;

  int get likeCount => _int(_likeCount ?? _content?._likeCount) ?? 0;

  int get priority => _int(_priority ?? _content?._priority) ?? 0;

  int get reportCount => _int(_reportCount ?? _content?._reportCount) ?? 0;

  int get starCount => _int(_starCount ?? _content?._starCount) ?? 0;

  int get viewCount => _int(_viewCount ?? _content?._viewCount) ?? 0;

  // ---------------------------------------------------------------------------
  // ----------------------------------DOUBLES----------------------------------
  // ---------------------------------------------------------------------------

  // ---------------------------------------------------------------------------
  // ---------------------------------REFERENCES--------------------------------
  // ---------------------------------------------------------------------------
  // COUNTER FIELDS
  String? _commentCountRef;
  String? _likeCountRef;
  String? _reportCountRef;
  String? _starCountRef;
  String? _viewCountRef;

  // OBJECT FIELDS
  String? _contentRef;
  String? _recentRef;

  // SETTERS (COUNTER)
  set commentCountRef(String? value) => _commentCountRef = value;

  set likeCountRef(String? value) => _likeCountRef = value;

  set reportCountRef(String? value) => _reportCountRef = value;

  set starCountRef(String? value) => _starCountRef = value;

  set viewCountRef(String? value) => _viewCountRef = value;

  // SETTER (OBJECT)
  set contentRef(String? value) => _contentRef = value;

  set recentRef(String? value) => _recentRef = value;

  // GETTERS (COUNTER)
  String? get commentCountRef =>
      _counterRef(_commentCountRef ?? _content?._commentCountRef);

  String? get likeCountRef =>
      _counterRef(_likeCountRef ?? _content?._likeCountRef);

  String? get reportCountRef =>
      _counterRef(_reportCountRef ?? _content?._reportCountRef);

  String? get starCountRef =>
      _counterRef(_starCountRef ?? _content?._starCountRef);

  String? get viewCountRef =>
      _counterRef(_viewCountRef ?? _content?._viewCountRef);

  // GETTERS (OBJECT)
  String? get contentRef => _objectRef(_contentRef ?? _content?._contentRef);

  String? get recentRef => _objectRef(_recentRef ?? _content?._recentRef);

  // ---------------------------------------------------------------------------
  // ----------------------------------STRINGS----------------------------------
  // ---------------------------------------------------------------------------
  // FIELDS
  String? _description;
  String? _link;
  String? _name;
  String? _parentId;
  String? _parentLink;
  String? _parentPath;
  String? _reference;
  String? _parentUrl;
  String? _path;
  String? _photoUrl;
  String? _recentId;
  String? _referenceId;
  String? _text;
  String? _title;
  String? _url;
  String? _videoUrl;

  // SETTERS

  set description(String? value) => _description = value;

  set link(String? value) => _link = value;

  set name(String? value) => _name = value;

  set parentId(String? value) => _parentId = value;

  set parentLink(String? value) => _parentLink = value;

  set parentPath(String? value) => _parentPath = value;

  set reference(String? value) => _reference = value;

  set parentUrl(String? value) => _parentUrl = value;

  set path(String? value) => _path = value;

  set photoUrl(String? value) => _photoUrl = value;

  set recentId(String? value) => _recentId = value;

  set referenceId(String? value) => _referenceId = value;

  set text(String? value) => _text = value;

  set title(String? value) => _title = value;

  set url(String? value) => _url = value;

  set videoUrl(String? value) => _videoUrl = value;

  // GETTERS

  String? get description => _normalizedDescription;

  String? get descriptionOrNull =>
      _string(_description ?? _content?._description);

  String? get link => _string(_link ?? _content?._link, url: true);

  String? get name => _string(_name ?? _content?._name);

  String? get parentId => _string(_parentId ?? _content?._parentId);

  String? get parentLink =>
      _string(_parentLink ?? _content?._parentLink, url: true);

  String? get parentPath => _string(_parentPath ?? _content?._parentPath);

  String? get reference => _string(_reference ?? _content?._reference);

  String? get parentUrl =>
      _string(_parentUrl ?? _content?._parentUrl, url: true);

  String? get path => _string(_path ?? _content?._path);

  String? get photoUrl => _normalizedPhotoUrl;

  String? get recentId => _string(_recentId ?? _content?._recentId);

  String? get referenceId => _string(_referenceId ?? _content?._referenceId);

  String? get text => _string(_text ?? _content?._text);

  String? get title => _string(_title ?? _content?._title);

  String? get url => _string(_url ?? _content?._url, url: true);

  String? get videoUrl => _string(_videoUrl ?? _content?._videoUrl, url: true);

  // GETTERS (NORMALIZERS)

  String? get _normalizedDescription {
    if ((_description ?? '').isNotEmpty) return _description;
    if ((_content?._description ?? '').isNotEmpty) {
      return _content!._description!;
    }
    if ((_descriptions ?? []).isNotEmpty) return _descriptions!.first;
    if ((_content?._descriptions ?? []).isNotEmpty) {
      return _content!._descriptions!.first;
    }
    return null;
  }

  String? get _normalizedPhotoUrl {
    if (_photoUrl.isUrl) return _photoUrl!;
    if (_photoUrls.isNotEmpty && _photoUrls!.first.isUrl) {
      return _photoUrls!.first;
    }
    if ((_photos ?? []).isNotEmpty && _photos!.first._photoUrl.isUrl) {
      return _photos!.first._photoUrl;
    }
    if ((_content?._photoUrl ?? '').isUrl) return _content!._photoUrl!;
    if ((_content?._photoUrls ?? []).isNotEmpty &&
        _content!._photoUrls!.first.isUrl) {
      return _content!._photoUrls!.first;
    }
    if ((_content?._photos ?? []).isNotEmpty &&
        _content!._photos!.first._photoUrl.isUrl) {
      return _content!._photos!.first._photoUrl;
    }
    return null;
  }

  // ---------------------------------------------------------------------------
  // ------------------------------LIST OF STRINGS------------------------------
  // ---------------------------------------------------------------------------
  // FIELDS
  List<String>? _bookmarks;
  List<String>? _comments;
  List<String>? _descriptions;
  List<String>? _likes;
  List<String>? _photosRef;
  List<String>? _photoIds;
  List<String>? _photoUrls;
  List<String>? _reports;
  List<String>? _stars;
  List<String>? _tags;
  List<String>? _videoIds;
  List<String>? _videoUrls;
  List<String>? _views;

  // SETTERS
  set bookmarks(List<String>? value) => _bookmarks = value;

  set comments(List<String>? value) => _comments = value;

  set descriptions(List<String>? value) => _descriptions = value;

  set likes(List<String>? value) => _likes = value;

  set photosRef(List<String>? value) => _photosRef = value;

  set photoIds(List<String>? value) => _photoIds = value;

  set photoUrls(List<String>? value) => _photoUrls = value;

  set reports(List<String>? value) => _reports = value;

  set stars(List<String>? value) => _stars = value;

  set tags(List<String>? value) => _tags = value;

  set videoIds(List<String>? value) => _videoIds = value;

  set videoUrls(List<String>? value) => _videoUrls = value;

  set views(List<String>? value) => _views = value;

  // GETTERS
  List<String> get bookmarks => _strings(_bookmarks ?? _content?._bookmarks);

  List<String> get comments => _strings(_comments ?? _content?._comments);

  List<String> get descriptions => _normalizedDescriptions;

  List<String> get likes => _strings(_likes ?? _content?._likes, url: true);

  List<String> get photosRef =>
      _strings(_photosRef ?? _content?._photosRef, ref: true);

  List<String> get photoIds => _strings(_photoIds ?? _content?._photoIds);

  List<String> get photoUrls => _normalizedPhotoUrls;

  List<String> get reports => _strings(_reports ?? _content?._reports);

  List<String> get stars => _strings(_stars ?? _content?._stars);

  List<String> get tags => _strings(_tags ?? _content?._tags);

  List<String> get videoIds => _strings(_videoIds ?? _content?._videoIds);

  List<String> get videoUrls =>
      _strings(_videoUrls ?? _content?._videoUrls, url: true);

  List<String> get views => _strings(_views ?? _content?._views);

  // GETTERS (NORMALIZERS)

  List<String> get _normalizedDescriptions {
    if (_descriptions.isNotEmpty) return _descriptions!;
    if ((_content?._descriptions ?? []).isNotEmpty) {
      return _content!._descriptions!;
    }
    if (_description.isNotEmpty) return [_description!];
    if ((_content?._description ?? '').isNotEmpty) {
      return [_content!._description!];
    }
    return [];
  }

  List<String> get _normalizedPhotoUrls {
    if (_photoUrls.isUrls) return _photoUrls!;
    final x = _photos?.map((e) => e._photoUrl).whereType<String>().toList();
    if (x.isUrls) return x!;
    if (_photoUrl.isUrl) return [_photoUrl!];
    if ((_content?._photoUrls ?? []).isUrls) return _content!._photoUrls!;
    final y =
        _content?._photos?.map((e) => e._photoUrl).whereType<String>().toList();
    if (y.isUrls) return y!;
    if ((_content?._photoUrl ?? '').isUrl) return [_content!._photoUrl!];
    return [];
  }

  // ---------------------------------------------------------------------------
  // -----------------------------------ENUMS-----------------------------------
  // ---------------------------------------------------------------------------
  // FIELDS
  Audience? _audience;
  Privacy? _privacy;
  FeedType? _type;

  // SETTERS
  set audience(Audience? value) => _audience = value;

  set privacy(Privacy? value) => _privacy = value;

  set type(FeedType? value) => _type = value;

  // GETTERS
  Audience get audience =>
      _audience ?? _content?._audience ?? Audience.everyone;

  Privacy get privacy => _privacy ?? _content?._privacy ?? Privacy.everyone;

  FeedType get type => _type ?? _content?.type ?? FeedType.none;

  // ---------------------------------------------------------------------------
  // ----------------------------------OBJECTS----------------------------------
  // ---------------------------------------------------------------------------
  // FIELDS
  Content? _content;
  Content? _recent;

  // SETTERS
  set content(Content? value) => _content = value;

  set recent(Content? value) => _recent = value;

  // GETTERS
  Content get content => _content ?? Content.empty();

  Content? get contentOrNull => _content;

  Content get recent => _recent ?? Content.empty();

  Content? get recentOrNull => _recent;

  // ---------------------------------------------------------------------------
  // -------------------------------LIST OF OBJECTS-----------------------------
  // ---------------------------------------------------------------------------
  // FIELDS
  List<Content>? _contents;
  List<Content>? _photos;
  List<Content>? _videos;

  // SETTERS
  set contents(List<Content>? value) => _contents = value;

  set photos(List<Content>? value) => _photos = value;

  set videos(List<Content>? value) => _videos = value;

  // GETTERS
  List<Content> get contents => _contents ?? _content?._contents ?? [];

  List<Content> get photos => _photos ?? _content?._photos ?? [];

  List<Content> get videos => _videos ?? _content?._videos ?? [];

  // ---------------------------------------------------------------------------
  // ------------------------IF NEEDED (INTERNAL USE ONLY)----------------------
  // ---------------------------------------------------------------------------
  String? translatedTitle;
  String? translatedDescription;
  List<String>? translatedDescriptions;

  // ---------------------------------------------------------------------------
  // ------------------------------):CONSTRUCTORS:(-----------------------------
  // ---------------------------------------------------------------------------

  Content.empty();

  Content({
    // -------------------------------------------------------------------------
    // --------------------------------COMMON-----------------------------------
    // -------------------------------------------------------------------------
    // ROOT
    super.id,
    super.timeMills,
    // PUBLISHER
    String? publisherId,
    int? publisherAge,
    Gender? publisherGender,
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
    // LOCATION
    String? city,
    String? country,
    double? latitude,
    double? longitude,
    String? region,
    int? zip,
    // -------------------------------------------------------------------------
    // ---------------------------------BOOLEANS--------------------------------
    // -------------------------------------------------------------------------
    bool? verified,
    // -------------------------------------------------------------------------
    // ---------------------------------INTEGERS--------------------------------
    // -------------------------------------------------------------------------
    int? commentCount,
    int? likeCount,
    int? priority,
    int? reportCount,
    int? starCount,
    int? viewCount,
    // -------------------------------------------------------------------------
    // ----------------------------------DOUBLES--------------------------------
    // -------------------------------------------------------------------------

    // ---------------------------------------------------------------------------
    // ---------------------------------REFERENCES--------------------------------
    // ---------------------------------------------------------------------------
    // COUNTER
    String? commentCountRef,
    String? likeCountRef,
    String? reportCountRef,
    String? starCountRef,
    String? viewCountRef,
    // OBJECT
    String? contentRef,
    String? recentRef,
    // -------------------------------------------------------------------------
    // ----------------------------------STRINGS--------------------------------
    // -------------------------------------------------------------------------
    String? description,
    String? link,
    String? name,
    String? parentId,
    String? parentLink,
    String? parentPath,
    String? reference,
    String? parentUrl,
    String? path,
    String? photoUrl,
    String? recentId,
    String? referenceId,
    String? text,
    String? title,
    String? url,
    String? videoUrl,
    // -------------------------------------------------------------------------
    // ------------------------------LIST OF STRINGS----------------------------
    // -------------------------------------------------------------------------
    List<String>? bookmarks,
    List<String>? comments,
    List<String>? descriptions,
    List<String>? likes,
    List<String>? photosRef,
    List<String>? photoIds,
    List<String>? photoUrls,
    List<String>? reports,
    List<String>? stars,
    List<String>? tags,
    List<String>? videoIds,
    List<String>? videoUrls,
    List<String>? views,
    // -------------------------------------------------------------------------
    // -----------------------------------ENUMS---------------------------------
    // -------------------------------------------------------------------------
    Audience? audience,
    Privacy? privacy,
    FeedType? type,

    // -------------------------------------------------------------------------
    // ----------------------------------OBJECTS--------------------------------
    // -------------------------------------------------------------------------
    Content? content,
    Content? recent,
    // -------------------------------------------------------------------------
    // -------------------------------LIST OF OBJECTS---------------------------
    // -------------------------------------------------------------------------
    List<Content>? contents,
    List<Content>? photos,
    List<Content>? videos,
  }) : // ----------------------------------------------------------------------
       // --------------------------------COMMON--------------------------------
       // ----------------------------------------------------------------------
       // PUBLISHER
       _publisherId = publisherId,
       _publisherAge = publisherAge,
       _publisherGender = publisherGender,
       _publisherLatitude = publisherLatitude,
       _publisherLongitude = publisherLongitude,
       _publisherName = publisherName,
       _publisherPhotoUrl = publisherPhotoUrl,
       _publisherProfession = publisherProfession,
       _publisherProfilePath = publisherProfilePath,
       _publisherProfileUrl = publisherProfileUrl,
       _publisherRating = publisherRating,
       _publisherReligion = publisherReligion,
       _publisherShortName = publisherShortName,
       _publisherTitle = publisherTitle,
       // LOCATION
       _city = city,
       _country = country,
       _latitude = latitude,
       _longitude = longitude,
       _region = region,
       _zip = zip,
       // ----------------------------------------------------------------------
       // ---------------------------------BOOLEANS-----------------------------
       // ----------------------------------------------------------------------
       _verified = verified,
       // ----------------------------------------------------------------------
       // ---------------------------------INTEGERS-----------------------------
       // ----------------------------------------------------------------------
       _commentCount = commentCount,
       _likeCount = likeCount,
       _priority = priority,
       _reportCount = reportCount,
       _starCount = starCount,
       _viewCount = viewCount,
       // ----------------------------------------------------------------------
       // ----------------------------------DOUBLES-----------------------------
       // ----------------------------------------------------------------------

       // ----------------------------------------------------------------------
       // ---------------------------------REFERENCES---------------------------
       // ----------------------------------------------------------------------
       // COUNTER
       _commentCountRef = commentCountRef,
       _likeCountRef = likeCountRef,
       _reportCountRef = reportCountRef,
       _starCountRef = starCountRef,
       _viewCountRef = viewCountRef,
       // OBJECT
       _contentRef = contentRef,
       _recentRef = recentRef,
       // ----------------------------------------------------------------------
       // ----------------------------------STRINGS-----------------------------
       // ----------------------------------------------------------------------
       _description = description,
       _link = link,
       _name = name,
       _parentId = parentId,
       _parentLink = parentLink,
       _parentPath = parentPath,
       _reference = reference,
       _parentUrl = parentUrl,
       _path = path,
       _photoUrl = photoUrl,
       _recentId = recentId,
       _referenceId = referenceId,
       _text = text,
       _title = title,
       _url = url,
       _videoUrl = videoUrl,
       // ----------------------------------------------------------------------
       // ------------------------------LIST OF STRINGS-------------------------
       // ----------------------------------------------------------------------
       _bookmarks = bookmarks,
       _comments = comments,
       _descriptions = descriptions,
       _likes = likes,
       _photosRef = photosRef,
       _photoIds = photoIds,
       _photoUrls = photoUrls,
       _reports = reports,
       _stars = stars,
       _tags = tags,
       _videoIds = videoIds,
       _videoUrls = videoUrls,
       _views = views,

       // ----------------------------------------------------------------------
       // -----------------------------------ENUMS------------------------------
       // ----------------------------------------------------------------------
       _audience = audience,
       _privacy = privacy,
       _type = type,

       // ----------------------------------------------------------------------
       // ----------------------------------OBJECTS-----------------------------
       // ----------------------------------------------------------------------
       _content = content,
       _recent = recent,
       // ----------------------------------------------------------------------
       // -------------------------------LIST OF OBJECTS------------------------
       // ----------------------------------------------------------------------
       _contents = contents,
       _photos = photos,
       _videos = videos;

  factory Content.parse(Object? source) {
    if (source is! Map) return Content.empty();
    final key = Keys.i;
    return Content(
      // -----------------------------------------------------------------------
      // --------------------------------COMMON---------------------------------
      // -----------------------------------------------------------------------
      // ROOT
      id: source.entityValue(key.id),
      timeMills: source.entityValue(key.timeMills),
      // PUBLISHER
      publisherId: source.entityValue(key.publisherId),
      publisherAge: source.entityValue(key.publisherAge),
      publisherGender: source.entityValue(
        key.publisherGender,
        Gender.values.parse,
      ),
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
      // LOCATION
      city: source.entityValue(key.city),
      country: source.entityValue(key.country),
      latitude: source.entityValue(key.latitude),
      longitude: source.entityValue(key.longitude),
      region: source.entityValue(key.region),
      zip: source.entityValue(key.zip),
      // -----------------------------------------------------------------------
      // ---------------------------------BOOLEANS------------------------------
      // -----------------------------------------------------------------------
      verified: source.entityValue(key.verified),
      // -----------------------------------------------------------------------
      // ---------------------------------INTEGERS------------------------------
      // -----------------------------------------------------------------------
      commentCount: source.entityValue(key.commentCount),
      likeCount: source.entityValue(key.likeCount),
      priority: source.entityValue(key.priority),
      reportCount: source.entityValue(key.reportCount),
      starCount: source.entityValue(key.starCount),
      viewCount: source.entityValue(key.viewCount),
      // -----------------------------------------------------------------------
      // ----------------------------------DOUBLES------------------------------
      // -----------------------------------------------------------------------
      // -----------------------------------------------------------------------
      // ---------------------------------REFERENCES----------------------------
      // -----------------------------------------------------------------------
      // COUNTER
      commentCountRef: source.entityValue(key.commentCountRef),
      likeCountRef: source.entityValue(key.likeCountRef),
      reportCountRef: source.entityValue(key.reportCountRef),
      starCountRef: source.entityValue(key.starCountRef),
      viewCountRef: source.entityValue(key.viewCountRef),
      // OBJECT
      contentRef: source.entityValue(key.contentRef),
      recentRef: source.entityValue(key.recentRef),
      // -----------------------------------------------------------------------
      // ----------------------------------STRINGS------------------------------
      // -----------------------------------------------------------------------
      description: source.entityValue(key.description),
      link: source.entityValue(key.link),
      name: source.entityValue(key.name),
      parentId: source.entityValue(key.parentId),
      parentLink: source.entityValue(key.parentLink),
      parentPath: source.entityValue(key.parentPath),
      reference: source.entityValue(key.reference),
      parentUrl: source.entityValue(key.parentUrl),
      path: source.entityValue(key.path),
      photoUrl: source.entityValue(key.photoUrl),
      recentId: source.entityValue(key.recentId),
      referenceId: source.entityValue(key.referenceId),
      text: source.entityValue(key.text),
      title: source.entityValue(key.title),
      url: source.entityValue(key.url),
      videoUrl: source.entityValue(key.videoUrl),
      // -----------------------------------------------------------------------
      // ------------------------------LIST OF STRINGS--------------------------
      // -----------------------------------------------------------------------
      bookmarks: source.entityValues(key.bookmarks),
      comments: source.entityValues(key.comments),
      descriptions: source.entityValues(key.descriptions),
      likes: source.entityValues(key.likes),
      photosRef: source.entityValues(key.photosRef),
      photoIds: source.entityValues(key.photoIds),
      photoUrls: source.entityValues(key.photoUrls),
      reports: source.entityValues(key.reports),
      stars: source.entityValues(key.stars),
      tags: source.entityValues(key.tags),
      videoIds: source.entityValues(key.videoIds),
      videoUrls: source.entityValues(key.videoUrls),
      views: source.entityValues(key.views),
      // -----------------------------------------------------------------------
      // -----------------------------------ENUMS-------------------------------
      // -----------------------------------------------------------------------
      audience: source.entityValue(key.audience, Audience.values.parse),
      privacy: source.entityValue(key.privacy, Privacy.values.parse),
      type: source.entityValue(key.type, FeedType.values.parse),
      // -----------------------------------------------------------------------
      // ----------------------------------OBJECTS------------------------------
      // -----------------------------------------------------------------------
      content: source.entityValue(key.content, Content.parse),
      recent: source.entityValue(key.recent, Content.parse),
      // -----------------------------------------------------------------------
      // -------------------------------LIST OF OBJECTS-------------------------
      // -----------------------------------------------------------------------
      contents: source.entityValues(key.contents, Content.parse),
      photos: source.entityValues(key.photos, Content.parse),
      videos: source.entityValues(key.videos, Content.parse),
    );
  }

  @override
  Keys makeKey() => Keys.i;

  @override
  bool isInsertable(String key, value) {
    return value != null && keys.contains(key);
  }

  DataFieldValueWriter? createWriter([Map<String, dynamic>? value]) {
    if (path == null || path!.isEmpty) return null;
    return DataFieldValueWriter.set(path!, value ?? filtered);
  }

  DataFieldValueWriter? updateWriter(Map<String, dynamic> updates) {
    if (path == null || path!.isEmpty) return null;
    return DataFieldValueWriter.update(path!, updates);
  }

  DataFieldValueWriter? deleteWriter() {
    if (path == null || path!.isEmpty) return null;
    return DataFieldValueWriter.delete(path!);
  }

  @override
  Map<String, dynamic> get source {
    final entries = {
      // ----------------------------------------------------------------------
      // --------------------------------COMMON--------------------------------
      // ----------------------------------------------------------------------
      // PUBLISHER
      if (_publisherId.isNotEmpty) key.publisherId: _publisherId,
      if ((_publisherAge ?? 0) > 0) key.publisherAge: _publisherAge,
      if ((_publisherGender ?? Gender.male) != Gender.male)
        key.publisherGender: _publisherGender?.name,
      if ((_publisherLatitude ?? 0) > 0)
        key.publisherLatitude: _publisherLatitude,
      if ((_publisherLongitude ?? 0) > 0)
        key.publisherLongitude: _publisherLongitude,
      if (_publisherName.isNotEmpty) key.publisherName: _publisherName,
      if (_publisherPhotoUrl.isUrl) key.publisherPhotoUrl: _publisherPhotoUrl,
      if (_publisherProfession.isNotEmpty)
        key.publisherProfession: _publisherProfession,
      if (_publisherProfilePath.isNotEmpty)
        key.publisherProfilePath: _publisherProfilePath,
      if (_publisherProfileUrl.isUrl)
        key.publisherProfileUrl: _publisherProfileUrl,
      if ((_publisherRating ?? 0) > 0) key.publisherRating: _publisherRating,
      if (_publisherReligion.isNotEmpty)
        key.publisherReligion: _publisherReligion,
      if (_publisherShortName.isNotEmpty)
        key.publisherShortName: _publisherShortName,
      if (_publisherTitle.isNotEmpty) key.publisherTitle: _publisherTitle,
      // LOCATION
      if (_city.isNotEmpty) key.city: _city,
      if (_country.isNotEmpty) key.country: _country,
      if ((_latitude ?? 0) > 0) key.latitude: _latitude,
      if ((_longitude ?? 0) > 0) key.longitude: _longitude,
      if (_region.isNotEmpty) key.region: _region,
      if ((_zip ?? 0) > 0) key.zip: _zip,
      // ----------------------------------------------------------------------
      // ---------------------------------BOOLEANS-----------------------------
      // ----------------------------------------------------------------------
      if (_verified ?? false) key.verified: _verified,
      // ----------------------------------------------------------------------
      // ---------------------------------INTEGERS-----------------------------
      // ----------------------------------------------------------------------
      if ((_commentCount ?? 0) > 0) key.commentCount: _commentCount,
      if ((_likeCount ?? 0) > 0) key.likeCount: _likeCount,
      if ((_priority ?? 0) > 0) key.priority: _priority,
      if ((_reportCount ?? 0) > 0) key.reportCount: _reportCount,
      if ((_starCount ?? 0) > 0) key.starCount: _starCount,
      if ((_viewCount ?? 0) > 0) key.viewCount: _viewCount,
      // ----------------------------------------------------------------------
      // ----------------------------------DOUBLES-----------------------------
      // ----------------------------------------------------------------------
      // ----------------------------------------------------------------------
      // ---------------------------------REFERENCES---------------------------
      // ----------------------------------------------------------------------
      // COUNTER
      if (_commentCountRef.isNotEmpty) key.commentCountRef: _commentCountRef,
      if (_likeCountRef.isNotEmpty) key.likeCountRef: _likeCountRef,
      if (_reportCountRef.isNotEmpty) key.reportCountRef: _reportCountRef,
      if (_starCountRef.isNotEmpty) key.starCountRef: _starCountRef,
      if (_viewCountRef.isNotEmpty) key.viewCountRef: _viewCountRef,
      // OBJECT
      if (_contentRef.isNotEmpty) key.contentRef: _contentRef,
      if (_recentRef.isNotEmpty) key.recentRef: _recentRef,
      // ----------------------------------------------------------------------
      // ----------------------------------STRINGS-----------------------------
      // ----------------------------------------------------------------------
      if (_description.isNotEmpty) key.description: _description,
      if (_link.isUrl) key.link: _link,
      if (_name.isNotEmpty) key.name: _name,
      if (_parentId.isNotEmpty) key.parentId: _parentId,
      if (_parentLink.isUrl) key.parentLink: _parentLink,
      if (_parentPath.isNotEmpty) key.parentPath: _parentPath,
      if (_reference.isNotEmpty) key.reference: _reference,
      if (_parentUrl.isUrl) key.parentUrl: _parentUrl,
      if (_path.isNotEmpty) key.path: _path,
      if (_photoUrl.isUrl) key.photoUrl: _photoUrl,
      if (_recentId.isNotEmpty) key.recentId: _recentId,
      if (_referenceId.isNotEmpty) key.referenceId: _referenceId,
      if (_text.isNotEmpty) key.text: _text,
      if (_title.isNotEmpty) key.title: _title,
      if (_url.isUrl) key.url: _url,
      if (_videoUrl.isUrl) key.videoUrl: _videoUrl,
      // ----------------------------------------------------------------------
      // ------------------------------LIST OF STRINGS-------------------------
      // ----------------------------------------------------------------------
      if (_bookmarks.isNotEmpty) key.bookmarks: _bookmarks,
      if (_comments.isNotEmpty) key.comments: _comments,
      if (_descriptions.isNotEmpty) key.descriptions: _descriptions,
      if (_likes.isNotEmpty) key.likes: _likes,
      if (_photosRef.isNotEmpty) key.photosRef: _photosRef,
      if (_photoIds.isNotEmpty) key.photoIds: _photoIds,
      if (_photoUrls.isUrls) key.photoUrls: _photoUrls,
      if (_reports.isNotEmpty) key.reports: _reports,
      if (_stars.isNotEmpty) key.stars: _stars,
      if (_tags.isNotEmpty) key.tags: _tags,
      if (_videoIds.isNotEmpty) key.videoIds: _videoIds,
      if (_videoUrls.isUrls) key.videoUrls: _videoUrls,
      if (_views.isNotEmpty) key.views: _views,

      // ----------------------------------------------------------------------
      // -----------------------------------ENUMS------------------------------
      // ----------------------------------------------------------------------
      if ((_audience ?? Audience.everyone) != Audience.everyone)
        key.audience: _audience?.name,
      if ((_privacy ?? Privacy.everyone) != Privacy.everyone)
        key.privacy: _privacy?.name,
      if ((_type ?? FeedType.none) != FeedType.none) key.type: _type?.name,

      // ----------------------------------------------------------------------
      // ----------------------------------OBJECTS-----------------------------
      // ----------------------------------------------------------------------
      // SOURCE
      if (_content != null) key.content: _content?.source,
      if (_recent != null) key.recent: _recent?.source,
      // CREATE METADATA
      if (_content != null) key.contentRef: _content?.createWriter(),
      if (_recent != null) key.recentRef: _recent?.createWriter(),
      // ----------------------------------------------------------------------
      // -------------------------------LIST OF OBJECTS------------------------
      // ----------------------------------------------------------------------
      // SOURCE
      if ((_contents ?? []).isNotEmpty)
        key.contents: _contents?.map((e) => e.source).toList(),
      if ((_photos ?? []).isNotEmpty)
        key.photos: _photos?.map((e) => e.source).toList(),
      if ((_videos ?? []).isNotEmpty)
        key.videos: _videos?.map((e) => e.source).toList(),
      // CREATE METADATA
      if ((_contents ?? []).isNotEmpty)
        key.contentsRef: _contents?.map((e) => e.createWriter()).toList(),
      if ((_photos ?? []).isNotEmpty)
        key.photosRef: _photos?.map((e) => e.createWriter()).toList(),
      if ((_videos ?? []).isNotEmpty)
        key.videosRef: _videos?.map((e) => e.createWriter()).toList(),
    }.entries.where((e) => isInsertable(e.key, e.value));
    return super.source..addAll(Map.fromEntries(entries));
  }

  Iterable<String> get keys => [
    // -------------------------------------------------------------------------
    // --------------------------------COMMON-----------------------------------
    // -------------------------------------------------------------------------
    // ROOT
    key.id,
    key.timeMills,
    // PUBLISHER
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
    // LOCATION
    key.city,
    key.country,
    key.latitude,
    key.longitude,
    key.region,
    key.zip,
    // -------------------------------------------------------------------------
    // ---------------------------------BOOLEANS--------------------------------
    // -------------------------------------------------------------------------
    key.verified,
    // -------------------------------------------------------------------------
    // ---------------------------------INTEGERS--------------------------------
    // -------------------------------------------------------------------------
    key.commentCount,
    key.likeCount,
    key.priority,
    key.reportCount,
    key.starCount,
    key.viewCount,
    // -------------------------------------------------------------------------
    // ----------------------------------DOUBLES--------------------------------
    // -------------------------------------------------------------------------
    // -------------------------------------------------------------------------
    // ---------------------------------REFERENCES------------------------------
    // -------------------------------------------------------------------------
    // COUNTER
    key.commentCountRef,
    key.likeCountRef,
    key.reportCountRef,
    key.starCountRef,
    key.viewCountRef,
    // OBJECT
    key.contentRef,
    key.recentRef,
    // -------------------------------------------------------------------------
    // ----------------------------------STRINGS--------------------------------
    // -------------------------------------------------------------------------
    key.description,
    key.link,
    key.name,
    key.parentId,
    key.parentLink,
    key.parentPath,
    key.reference,
    key.parentUrl,
    key.path,
    key.photoUrl,
    key.recentId,
    key.referenceId,
    key.text,
    key.title,
    key.url,
    key.videoUrl,
    // -------------------------------------------------------------------------
    // ------------------------------LIST OF STRINGS----------------------------
    // -------------------------------------------------------------------------
    key.bookmarks,
    key.comments,
    key.descriptions,
    key.likes,
    key.photosRef,
    key.photoIds,
    key.photoUrls,
    key.reports,
    key.stars,
    key.tags,
    key.videoIds,
    key.videoUrls,
    key.views,

    // -------------------------------------------------------------------------
    // -----------------------------------ENUMS---------------------------------
    // -------------------------------------------------------------------------
    key.audience,
    key.privacy,
    key.type,

    // -------------------------------------------------------------------------
    // ----------------------------------OBJECTS--------------------------------
    // -------------------------------------------------------------------------
    key.content,
    key.recent,
    // -------------------------------------------------------------------------
    // -------------------------------LIST OF OBJECTS---------------------------
    // -------------------------------------------------------------------------
    key.contents,
    key.photos,
    key.videos,
  ];

  @override
  int get hashCode => Object.hashAll([
    // -------------------------------------------------------------------------
    // --------------------------------COMMON-----------------------------------
    // -------------------------------------------------------------------------
    // ROOt
    idOrNull,
    timeMillsOrNull,
    // PUBLISHER
    _publisherId,
    _publisherAge,
    _publisherGender,
    _publisherLatitude,
    _publisherLongitude,
    _publisherName,
    _publisherPhotoUrl,
    _publisherProfession,
    _publisherProfilePath,
    _publisherProfileUrl,
    _publisherRating,
    _publisherReligion,
    _publisherShortName,
    _publisherTitle,
    // LOCATION
    _city,
    _country,
    _latitude,
    _longitude,
    _region,
    _zip,
    // -------------------------------------------------------------------------
    // ---------------------------------BOOLEANS--------------------------------
    // -------------------------------------------------------------------------
    _verified,
    // -------------------------------------------------------------------------
    // ---------------------------------INTEGERS--------------------------------
    // -------------------------------------------------------------------------
    _commentCount,
    _likeCount,
    _priority,
    _reportCount,
    _starCount,
    _viewCount,
    // -------------------------------------------------------------------------
    // ----------------------------------DOUBLES--------------------------------
    // -------------------------------------------------------------------------
    // -------------------------------------------------------------------------
    // ---------------------------------REFERENCES------------------------------
    // -------------------------------------------------------------------------
    // COUNTER
    _commentCountRef,
    _likeCountRef,
    _reportCountRef,
    _starCountRef,
    _viewCountRef,
    // OBJECT
    _contentRef,
    _recentRef,
    // -------------------------------------------------------------------------
    // ----------------------------------STRINGS--------------------------------
    // -------------------------------------------------------------------------
    _description,
    _link,
    _name,
    _parentId,
    _parentLink,
    _parentPath,
    _reference,
    _parentUrl,
    _path,
    _photoUrl,
    _recentId,
    _referenceId,
    _text,
    _title,
    _url,
    _videoUrl,
    // -------------------------------------------------------------------------
    // ------------------------------LIST OF STRINGS----------------------------
    // -------------------------------------------------------------------------
    _equality.hash(_bookmarks),
    _equality.hash(_comments),
    _equality.hash(_descriptions),
    _equality.hash(_likes),
    _equality.hash(_photosRef),
    _equality.hash(_photoIds),
    _equality.hash(_photoUrls),
    _equality.hash(_reports),
    _equality.hash(_stars),
    _equality.hash(_tags),
    _equality.hash(_videoIds),
    _equality.hash(_videoUrls),
    _equality.hash(_views),

    // -------------------------------------------------------------------------
    // -----------------------------------ENUMS---------------------------------
    // -------------------------------------------------------------------------
    _audience,
    _privacy,
    _type,

    // -------------------------------------------------------------------------
    // ----------------------------------OBJECTS--------------------------------
    // -------------------------------------------------------------------------
    _content,
    _recent,
    // -------------------------------------------------------------------------
    // -------------------------------LIST OF OBJECTS---------------------------
    // -------------------------------------------------------------------------
    _equality.hash(_contents),
    _equality.hash(_photos),
    _equality.hash(_videos),
  ]);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (runtimeType != other.runtimeType) return false;
    return other is Content &&
        // ---------------------------------------------------------------------
        // --------------------------------COMMON-------------------------------
        // ---------------------------------------------------------------------
        // ROOt
        idOrNull == other.idOrNull &&
        timeMillsOrNull == other.timeMillsOrNull &&
        // PUBLISHER
        _publisherId == other._publisherId &&
        _publisherAge == other._publisherAge &&
        _publisherGender == other._publisherGender &&
        _publisherLatitude == other._publisherLatitude &&
        _publisherLongitude == other._publisherLongitude &&
        _publisherName == other._publisherName &&
        _publisherPhotoUrl == other._publisherPhotoUrl &&
        _publisherProfession == other._publisherProfession &&
        _publisherProfilePath == other._publisherProfilePath &&
        _publisherProfileUrl == other._publisherProfileUrl &&
        _publisherRating == other._publisherRating &&
        _publisherReligion == other._publisherReligion &&
        _publisherShortName == other._publisherShortName &&
        _publisherTitle == other._publisherTitle &&
        // LOCATION
        _city == other._city &&
        _country == other._country &&
        _latitude == other._latitude &&
        _longitude == other._longitude &&
        _region == other._region &&
        _zip == other._zip &&
        // ---------------------------------------------------------------------
        // ---------------------------------BOOLEANS----------------------------
        // ---------------------------------------------------------------------
        _verified == other._verified &&
        // ---------------------------------------------------------------------
        // ---------------------------------INTEGERS----------------------------
        // ---------------------------------------------------------------------
        _commentCount == other._commentCount &&
        _likeCount == other._likeCount &&
        _priority == other._priority &&
        _reportCount == other._reportCount &&
        _starCount == other._starCount &&
        _viewCount == other._viewCount &&
        // ---------------------------------------------------------------------
        // ----------------------------------DOUBLES----------------------------
        // ---------------------------------------------------------------------
        // ---------------------------------------------------------------------
        // ---------------------------------REFERENCES--------------------------
        // ---------------------------------------------------------------------
        // COUNTER
        _commentCountRef == other._commentCountRef &&
        _likeCountRef == other._likeCountRef &&
        _reportCountRef == other._reportCountRef &&
        _starCountRef == other._starCountRef &&
        _viewCountRef == other._viewCountRef &&
        // OBJECT
        _contentRef == other._contentRef &&
        _recentRef == other._recentRef &&
        // ---------------------------------------------------------------------
        // ----------------------------------STRINGS----------------------------
        // ---------------------------------------------------------------------
        _description == other._description &&
        _link == other._link &&
        _name == other._name &&
        _parentId == other._parentId &&
        _parentLink == other._parentLink &&
        _parentPath == other._parentPath &&
        _reference == other._reference &&
        _parentUrl == other._parentUrl &&
        _path == other._path &&
        _photoUrl == other._photoUrl &&
        _recentId == other._recentId &&
        _referenceId == other._referenceId &&
        _text == other._text &&
        _title == other._title &&
        _url == other._url &&
        _videoUrl == other._videoUrl &&
        // ---------------------------------------------------------------------
        // ------------------------------LIST OF STRINGS------------------------
        // ---------------------------------------------------------------------
        _equality.equals(_bookmarks, other._bookmarks) &&
        _equality.equals(_comments, other._comments) &&
        _equality.equals(_descriptions, other._descriptions) &&
        _equality.equals(_likes, other._likes) &&
        _equality.equals(_photosRef, other._photosRef) &&
        _equality.equals(_photoIds, other._photoIds) &&
        _equality.equals(_photoUrls, other._photoUrls) &&
        _equality.equals(_reports, other._reports) &&
        _equality.equals(_stars, other._stars) &&
        _equality.equals(_tags, other._tags) &&
        _equality.equals(_videoIds, other._videoIds) &&
        _equality.equals(_videoUrls, other._videoUrls) &&
        _equality.equals(_views, other._views) &&
        // ---------------------------------------------------------------------
        // -----------------------------------ENUMS-----------------------------
        // ---------------------------------------------------------------------
        _audience == other._audience &&
        _privacy == other._privacy &&
        _type == other._type &&
        // ---------------------------------------------------------------------
        // ----------------------------------OBJECTS----------------------------
        // ---------------------------------------------------------------------
        _content == other._content &&
        _recent == other._recent &&
        // ---------------------------------------------------------------------
        // -------------------------------LIST OF OBJECTS-----------------------
        // ---------------------------------------------------------------------
        _equality.equals(_contents, other._contents) &&
        _equality.equals(_photos, other._photos) &&
        _equality.equals(_videos, other._videos);
  }

  @override
  String toString() => "$Content#$hashCode($idOrNull)";
}

int? _int(int? value) {
  if (value == null) return null;
  if (value == 0) return null;
  return value;
}

double? _double(double? value) {
  if (value == null) return null;
  if (value == 0) return null;
  return value;
}

String? _string(String? value, {bool url = false, bool ref = false}) {
  if (value == null) return null;
  if (value.isEmpty) return null;
  if (url && !value.startsWith("https://")) return null;
  if (ref && !value.startsWith("@")) return null;
  return value;
}

List<String> _strings(
  List<String>? value, {
  bool url = false,
  bool ref = false,
}) {
  if (value == null) return [];
  if (value.isEmpty) return [];
  if (url && !value.every((e) => e.startsWith("https://"))) return [];
  if (ref && !value.every((e) => e.startsWith("@"))) return [];
  return value;
}

String? _counterRef(String? value) {
  if (value == null) return null;
  if (value.isEmpty) return null;
  if (!value.startsWith("#")) return null;
  return value;
}

String? _objectRef(String? value) {
  if (value == null) return null;
  if (value.isEmpty) return null;
  if (!value.startsWith("@")) return null;
  return value;
}

extension StringHelper on String? {
  bool get isEmpty => this == null || this!.isEmpty;

  bool get isNotEmpty => this != null && this!.isNotEmpty;

  bool get isUrl => this != null && this!.startsWith("https://");

  bool get isRef => this != null && this!.startsWith("@");
}

extension StringsHelper on List<String>? {
  bool get isEmpty => this == null || this!.isEmpty;

  bool get isNotEmpty => this != null && this!.isNotEmpty;

  bool get isUrls {
    return this != null && this!.isNotEmpty && this!.every((e) => e.isUrl);
  }

  bool get isRefs =>
      this != null && this!.isNotEmpty && this!.every((e) => e.isRef);
}
