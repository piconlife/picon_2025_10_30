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

class FeedLike extends Content {
  FeedLike({
    super.publisher,
    super.id,
    super.timeMills,
    super.parentId,
    super.parentPath,
    super.privacy,
  });

  factory FeedLike.create({
    User? publisher,
    String? id,
    int? timeMills,
    String? parentId,
    String? parentPath,
    Privacy? privacy,
  }) {
    publisher ??= UserHelper.user;
    return FeedLike(
      publisher: publisher.id,
      id: id,
      timeMills: timeMills,
      parentId: parentId,
      parentPath: parentPath,
      privacy: privacy,
    );
  }

  factory FeedLike.from(Object? source) {
    final data = Content.from(source);
    return FeedLike(
      publisher: data.publisher,
      id: data.id,
      timeMills: data.timeMills,
      parentId: data.parentId,
      parentPath: data.parentPath,
      privacy: data.privacy,
    );
  }

  FeedLike withFeedLike({
    String? publisher,
    String? id,
    int? timeMills,
    String? parentId,
    String? parentPath,
    String? photoUrl,
    Privacy? privacy,
  }) {
    return FeedLike(
      publisher: publisher ?? this.publisher,
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
