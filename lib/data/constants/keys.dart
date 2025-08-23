import 'package:flutter_entity/flutter_entity.dart';

class Keys extends EntityKey {
  const Keys();

  static Keys? _i;

  static Keys get i => _i ??= const Keys();

  // PUBLISHER
  final publisher = "publisher";
  final publisherRef = "@publisher";
  final publisherAge = "publisher_age";
  final publisherPhoto = "publisher_photo";
  final publisherProfession = "publisher_profession";
  final publisherProfilePath = "publisher_profile_path";
  final publisherProfileUrl = "publisher_profile_url";
  final publisherName = "publisher_name";
  final publisherShortName = "publisher_short_name";
  final publisherTitle = "publisher_title";
  final publisherRating = "publisher_rating";
  final publisherReligion = "publisher_religion";
  final publisherLatitude = "publisher_latitude";
  final publisherLongitude = "publisher_longitude";
  final publisherGender = "publisher_gender";

  // LOCATION
  final city = "city";
  final country = "country";
  final lat = "lat";
  final lon = "lon";
  final region = "region";
  final zip = "zip";

  // CONTENT
  final audience = "audience";
  final bookmarks = "bookmarks";
  final commentCount = "comment_count";
  final comments = "comments";
  final content = "content";
  final contentRef = "@content";
  final contents = "contents";
  final description = "description";
  final descriptions = "descriptions";
  final latitude = "latitude";
  final likeCount = "like_count";
  final likes = "likes";
  final link = "link";
  final name = "name";
  final longitude = "longitude";
  final parentId = "parent_id";
  final parentLink = "parent_link";
  final parentPath = "parent_path";
  final parentUrl = "parent_url";
  final path = "path";
  final photos = "photos";
  final photoIds = "photo_ids";
  final photoUrl = "photo_url";
  final photoUrls = "photo_urls";
  final priority = "priority";
  final privacy = "privacy";
  final recent = "recent";
  final recentRef = "@recent";
  final recentId = "recent_id";
  final recentPath = "recent_path";
  final referenceId = "reference_id";
  final referencePath = "reference_path";
  final reportCount = "report_count";
  final reports = "reports";
  final starCount = "star_count";
  final stars = "stars";
  final tags = "tags";
  final text = "text";
  final title = "title";
  final type = "type";
  final updatedAt = "updated_at";
  final url = "url";
  final userRating = "user_rating";
  final verified = "verified";
  final videos = "videos";
  final videoIds = "video_ids";
  final videoUrl = "video_url";
  final videoUrls = "video_urls";
  final viewCount = "view_count";
  final views = "views";

  @override
  Iterable<String> get keys {
    return [
      // PUBLISHER
      publisher,
      publisherAge,
      publisherPhoto,
      publisherProfession,
      publisherProfilePath,
      publisherProfileUrl,
      publisherName,
      publisherShortName,
      publisherTitle,
      publisherRating,
      publisherReligion,
      publisherLatitude,
      publisherLongitude,
      publisherGender,
      // CONTENT
      audience,
      bookmarks,
      commentCount,
      comments,
      content,
      contents,
      description,
      descriptions,
      latitude,
      likeCount,
      likes,
      link,
      name,
      longitude,
      parentId,
      parentLink,
      parentPath,
      parentUrl,
      path,
      photos,
      photoIds,
      photoUrl,
      photoUrls,
      priority,
      privacy,
      recent,
      recentId,
      recentPath,
      referenceId,
      referencePath,
      reportCount,
      reports,
      starCount,
      stars,
      tags,
      text,
      title,
      type,
      updatedAt,
      url,
      userRating,
      verified,
      videos,
      videoIds,
      videoUrl,
      videoUrls,
      viewCount,
      views,
    ];
  }
}
