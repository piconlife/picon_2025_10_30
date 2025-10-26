import 'package:flutter_entity/flutter_entity.dart';

class Keys extends EntityKey {
  const Keys();

  static Keys? _i;

  static Keys get i => _i ??= const Keys();

  // PUBLISHER
  final publisherId = "publisherId";
  final publisherAge = "publisherAge";
  final publisherLatitude = "publisherLatitude";
  final publisherLongitude = "publisherLongitude";
  final publisherName = "publisherName";
  final publisherProfession = "publisherProfession";
  final publisherProfilePath = "publisherProfilePath";
  final publisherProfileUrl = "publisherProfileUrl";
  final publisherPhotoUrl = "publisherPhotoUrl";
  final publisherRating = "publisherRating";
  final publisherReligion = "publisherReligion";
  final publisherShortName = "publisherShortName";
  final publisherTitle = "publisherTitle";
  final publisherGender = "publisherGender";

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
  final photosRef = "@photos";
  final photoRef = "@photo";
  final photo = "photo";
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
}
