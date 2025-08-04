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
  Keys.i.text,
];

class FeedComment extends Content {
  FeedComment({
    super.publisher,
    super.id,
    super.timeMills,
    super.parentId,
    super.parentPath,
    super.privacy,
    super.text,
  });

  factory FeedComment.create({
    User? publisher,
    String? id,
    int? timeMills,
    String? parentId,
    String? parentPath,
    Privacy? privacy,
    String? text,
  }) {
    publisher ??= UserHelper.user;
    return FeedComment(
      publisher: publisher.id,
      id: id,
      timeMills: timeMills,
      parentId: parentId,
      parentPath: parentPath,
      privacy: privacy,
      text: text,
    );
  }

  factory FeedComment.from(Object? source) {
    final data = Content.from(source);
    return FeedComment(
      publisher: data.publisher,
      id: data.id,
      timeMills: data.timeMills,
      parentId: data.parentId,
      parentPath: data.parentPath,
      privacy: data.privacy,
      text: data.text,
    );
  }

  FeedComment withFeedComment({
    String? publisher,
    String? id,
    int? timeMills,
    String? parentId,
    String? parentPath,
    String? photoUrl,
    Privacy? privacy,
    String? text,
  }) {
    return FeedComment(
      publisher: publisher ?? this.publisher,
      id: id ?? this.id,
      timeMills: timeMills ?? this.timeMills,
      parentId: parentId ?? this.parentId,
      parentPath: parentPath ?? this.parentPath,
      privacy: privacy ?? this.privacy,
      text: text ?? this.text,
    );
  }

  @override
  Map<String, dynamic> get source {
    final data = super.source.entries.where((item) => _keys.contains(item.key));
    return Map.fromEntries(data);
  }
}
