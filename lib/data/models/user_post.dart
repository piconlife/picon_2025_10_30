import '../enums/audience.dart';
import '../enums/feed_type.dart';
import '../enums/privacy.dart';
import 'content.dart';

class UserPost extends Content {
  @override
  Iterable<String> get keys => [
    key.id,
    key.timeMills,
    key.publisherId,
    key.path,
    key.audience,
    key.privacy,
    key.type,
    key.title,
    key.description,
    key.tags,
    key.photosRef,
  ];

  UserPost({
    super.id,
    super.timeMills,
    super.publisherId,
    super.path,
    super.audience,
    super.privacy,
    super.type,
    super.title,
    super.description,
    super.tags,
    super.photos,
  });

  UserPost.create({
    required super.id,
    required super.timeMills,
    required super.publisherId,
    required super.path,
    required super.audience,
    required super.privacy,
    required super.type,
    required super.title,
    required super.description,
    required super.tags,
    super.photos,
  });

  UserPost.createForAvatar({
    required super.id,
    required super.timeMills,
    required super.publisherId,
    required super.path,
  }) : super(type: FeedType.avatar);

  UserPost.createForCover({
    required super.id,
    required super.timeMills,
    required super.publisherId,
    required super.path,
  }) : super(type: FeedType.cover);

  factory UserPost.parse(Object? source) {
    final content = Content.parse(source);
    if (source is! Map) return UserPost();
    return UserPost(
      id: content.id,
      timeMills: content.timeMills,
      publisherId: content.publisherId,
      path: content.path,
      audience: content.audience,
      privacy: content.privacy,
      type: content.type,
      title: content.title,
      description: content.description,
      tags: content.tags,
      photos: content.photos,
    );
  }

  UserPost copyWith({
    String? id,
    int? timeMills,
    String? publisherId,
    String? path,
    Audience? audience,
    Privacy? privacy,
    FeedType? type,
    String? title,
    String? description,
    List<String>? tags,
    List<Content>? photos,
  }) {
    return UserPost(
      id: id ?? this.id,
      timeMills: timeMills ?? this.timeMills,
      publisherId: publisherId ?? this.publisherId,
      path: path ?? this.path,
      audience: audience ?? this.audience,
      privacy: privacy ?? this.privacy,
      type: type ?? this.type,
      title: title ?? this.title,
      description: description ?? this.description,
      tags: tags ?? this.tags,
      photos: photos ?? this.photos,
    );
  }
}
