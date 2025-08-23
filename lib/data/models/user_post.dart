import '../enums/feed_type.dart';
import 'content.dart';

class UserPost extends Content {
  UserPost({
    super.id,
    super.timeMills,
    super.path,
    super.publisherId,
    super.reference,
    super.type,
    super.content,
  });

  UserPost.create({
    required super.id,
    required super.timeMills,
    required super.publisherId,
    required super.title,
    required super.path,
    required super.description,
    required super.audience,
    required super.privacy,
    required super.type,
    required super.tags,
  });

  UserPost.createForAvatar({
    required super.id,
    required super.timeMills,
    required super.publisherId,
    required super.path,
    required super.reference,
  }) : super(type: FeedType.avatar);

  UserPost.createForCover({
    required super.id,
    required super.timeMills,
    required super.publisherId,
    required super.path,
    required super.reference,
  }) : super(type: FeedType.cover);

  factory UserPost.parse(Object? source) {
    final content = Content.parse(source);
    if (source is! Map) return UserPost();
    return UserPost(
      id: content.id,
      timeMills: content.timeMills,
      // REFERENCES
      content: content.content,
      publisherId: content.publisherId,
      path: content.path,
      reference: content.reference,
      type: content.type,
    );
  }

  @override
  Iterable<String> get keys => [
    key.id,
    key.timeMills,
    key.publisher,
    key.path,
    key.contentRef,
    key.type,
  ];
}
