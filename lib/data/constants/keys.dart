import 'package:flutter_entity/flutter_entity.dart';

class Keys extends EntityKey {
  const Keys() : super(id: "id", timeMills: "timeMills");

  static Keys? _i;

  static Keys get i => _i ??= const Keys();

  // ---------------------------------------------------------------------------
  // --------------------------------COMMON-------------------------------------
  // ---------------------------------------------------------------------------
  // PUBLISHER
  final publisherId = 'publisherId';
  final publisherAge = 'publisherAge';
  final publisherGender = 'publisherGender';
  final publisherLatitude = 'publisherLatitude';
  final publisherLongitude = 'publisherLongitude';
  final publisherName = 'publisherName';
  final publisherPhotoUrl = 'publisherPhotoUrl';
  final publisherProfession = 'publisherProfession';
  final publisherProfilePath = 'publisherProfilePath';
  final publisherProfileUrl = 'publisherProfileUrl';
  final publisherRating = 'publisherRating';
  final publisherReligion = 'publisherReligion';
  final publisherShortName = 'publisherShortName';
  final publisherTitle = 'publisherTitle';

  // LOCATION
  final city = 'city';
  final country = 'country';
  final latitude = 'latitude';
  final longitude = 'longitude';
  final region = 'region';
  final zip = 'zip';

  // ---------------------------------------------------------------------------
  // ---------------------------------BOOLEANS----------------------------------
  // ---------------------------------------------------------------------------
  final verified = 'verified';

  // ---------------------------------------------------------------------------
  // ---------------------------------INTEGERS----------------------------------
  // ---------------------------------------------------------------------------
  final commentCount = 'commentCount';
  final likeCount = 'likeCount';
  final priority = 'priority';
  final reportCount = 'reportCount';
  final starCount = 'starCount';
  final updatedAt = 'updatedAt';
  final viewCount = 'viewCount';

  // ---------------------------------------------------------------------------
  // ----------------------------------DOUBLES----------------------------------
  // ---------------------------------------------------------------------------

  // ---------------------------------------------------------------------------
  // ----------------------------------STRINGS----------------------------------
  // ---------------------------------------------------------------------------
  final description = 'description';
  final link = 'link';
  final name = 'name';
  final parentLink = 'parentLink';
  final parentId = 'parentId';
  final parentPath = 'parentPath';
  final parentUrl = 'parentUrl';
  final path = 'path';
  final photoUrl = 'photoUrl';
  final recentId = 'recentId';
  final reference = 'reference';
  final referenceId = 'referenceId';
  final text = 'text';
  final title = 'title';
  final url = 'url';
  final videoUrl = 'videoUrl';

  // ---------------------------------------------------------------------------
  // ------------------------------LIST OF STRINGS------------------------------
  // ---------------------------------------------------------------------------
  final bookmarks = 'bookmarks';
  final comments = 'comments';
  final descriptions = 'descriptions';
  final likes = 'likes';
  final photoIds = 'photoIds';
  final photoUrls = 'photoUrls';
  final reports = 'reports';
  final stars = 'stars';
  final tags = 'tags';
  final videoIds = 'videoIds';
  final videoUrls = 'videoUrls';
  final views = 'views';

  // ---------------------------------------------------------------------------
  // -----------------------------------ENUMS-----------------------------------
  // ---------------------------------------------------------------------------
  final audience = 'audience';
  final privacy = 'privacy';
  final type = 'type';

  // ---------------------------------------------------------------------------
  // ----------------------------------OBJECTS----------------------------------
  // ---------------------------------------------------------------------------
  // SOURCE
  final content = 'content';
  final recent = 'recent';

  // METADATA
  final contentRef = '@content';
  final recentRef = '@recent';

  // ---------------------------------------------------------------------------
  // -------------------------------LIST OF OBJECTS-----------------------------
  // ---------------------------------------------------------------------------
  // SOURCE
  final contents = 'contents';
  final photos = 'photos';
  final videos = 'videos';

  // METADATA
  final contentsRef = '@contents';
  final photosRef = '@photos';
  final videosRef = '@videos';
}
