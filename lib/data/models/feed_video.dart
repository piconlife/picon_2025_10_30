import '../../app/helpers/user.dart';
import '../constants/keys.dart';
import '../enums/privacy.dart';
import 'content.dart';
import 'user.dart';

List<String> _keys = [
  Keys.i.publisher,
  Keys.i.id,
  Keys.i.timeMills,
  Keys.i.parentId,
  Keys.i.privacy,
  Keys.i.videoUrl,
];

class FeedVideo extends Content {
  FeedVideo({
    super.publisher,
    super.id,
    super.timeMills,
    super.parentId,
    super.privacy,
    super.videoUrl,
  });

  factory FeedVideo.create({
    User? publisher,
    String? id,
    int? timeMills,
    String? parentId,
    Privacy? privacy,
    String? videoUrl,
  }) {
    publisher ??= UserHelper.user;
    return FeedVideo(
      id: id,
      timeMills: timeMills,
      parentId: parentId,
      privacy: privacy,
      publisher: publisher.id,
      videoUrl: videoUrl,
    );
  }

  factory FeedVideo.from(Object? source) {
    final data = Content.from(source);
    return FeedVideo(
      publisher: data.publisher,
      id: data.id,
      timeMills: data.timeMills,
      parentId: data.parentId,
      privacy: data.privacy,
      videoUrl: data.videoUrl,
    );
  }

  FeedVideo withFeedVideo({
    String? publisher,
    String? id,
    int? timeMills,
    String? parentId,
    Privacy? privacy,
    String? videoUrl,
  }) {
    return FeedVideo(
      publisher: publisher ?? this.publisher,
      id: id ?? this.id,
      timeMills: timeMills ?? this.timeMills,
      parentId: parentId ?? this.parentId,
      privacy: privacy ?? this.privacy,
      videoUrl: videoUrl ?? this.videoUrl,
    );
  }

  @override
  Map<String, dynamic> get source {
    final data = super.source.entries.where((item) => _keys.contains(item.key));
    return Map.fromEntries(data);
  }
}
