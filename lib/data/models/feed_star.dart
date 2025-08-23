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
  Keys.i.parentPath,
  Keys.i.privacy,
];

class FeedStar extends Content {
  FeedStar({
    super.publisherId,
    super.id,
    super.timeMills,
    super.parentId,
    super.parentPath,
    super.privacy,
  });

  factory FeedStar.create({
    User? publisher,
    String? id,
    int? timeMills,
    String? parentId,
    String? parentPath,
    Privacy? privacy,
  }) {
    publisher ??= UserHelper.user;
    return FeedStar(
      publisherId: publisher.id,
      id: id,
      timeMills: timeMills,
      parentId: parentId,
      parentPath: parentPath,
      privacy: privacy,
    );
  }

  factory FeedStar.from(Object? source) {
    final data = Content.parse(source);
    return FeedStar(
      publisherId: data.publisherId,
      id: data.id,
      timeMills: data.timeMills,
      parentId: data.parentId,
      parentPath: data.parentPath,
      privacy: data.privacy,
    );
  }

  FeedStar withFeedStar({
    String? publisher,
    String? id,
    int? timeMills,
    String? parentId,
    String? parentPath,
    String? photoUrl,
    Privacy? privacy,
  }) {
    return FeedStar(
      publisherId: publisher ?? this.publisherId,
      id: id ?? this.id,
      timeMills: timeMills ?? this.timeMills,
      parentId: parentId ?? this.parentId,
      parentPath: parentPath ?? this.parentPath,
      privacy: privacy ?? this.privacy,
    );
  }

  @override
  Map<String, dynamic> get source {
    final data = super.source.entries.where((item) => _keys.contains(item.key));
    return Map.fromEntries(data);
  }
}
