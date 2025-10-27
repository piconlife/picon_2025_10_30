import 'param_keys.dart';

class Paths {
  const Paths._();

  static const settings = "settings";

  static const ads = "ads";
  static const avatars = "avatars";
  static const businesses = "businesses";
  static const businessAds = "$businesses/{${ParamKeys.uid}}/$ads";
  static const businessSponsors = "$businesses/{${ParamKeys.uid}}/$sponsors";
  static const channels = "channels";
  static const comments = "comments";
  static const covers = "covers";
  static const feeds = "feeds";
  static const feedLikes = "{${ParamKeys.path}}/$likes";
  static const feedComments = "{${ParamKeys.path}}/$comments";
  static const feedStars = "{${ParamKeys.path}}/$stars";
  static const feedVideos = "{${ParamKeys.path}}/$videos";
  static const followers = "followers";
  static const followings = "followings";
  static const likes = "likes";
  static const memories = "memories";
  static const notes = "notes";
  static const photos = "photos";
  static const posts = "posts";
  static const recentFeeds = "recent_feeds";
  static const reports = "reports";
  static const sponsors = "sponsors";
  static const stars = "stars";
  static const stories = "stories";
  static const users = "users";
  static const userEmails = "user_emails";
  static const userPhones = "user_phones";
  static const userNames = "user_names";
  static const videos = "videos";
  static const userAvatars = "$users/{${ParamKeys.uid}}/$avatars";
  static const userBusiness = "$users/{${ParamKeys.uid}}/$businesses";
  static const userCovers = "$users/{${ParamKeys.uid}}/$covers";
  static const userFollowers = "$users/{${ParamKeys.uid}}/$followers";
  static const userFollowings = "$users/{${ParamKeys.uid}}/$followings";
  static const userMemories = "$users/{${ParamKeys.uid}}/$memories";
  static const userNotes = "$users/{${ParamKeys.uid}}/$notes";
  static const userPhotos = "$users/{${ParamKeys.uid}}/$photos";
  static const userPhotoRef = "$userPhotos/{${ParamKeys.id}}";
  static const userPosts = "$users/{${ParamKeys.uid}}/$posts";
  static const userPost = "$userPosts/{${ParamKeys.id}}";
  static const userReports = "$users/{${ParamKeys.uid}}/$reports";
  static const userStories = "$users/{${ParamKeys.uid}}/$stories";
  static const userVideos = "$users/{${ParamKeys.uid}}/$videos";
}
