import '../constants/keys.dart';
import '../enums/audience.dart';
import '../enums/privacy.dart';
import 'content.dart';

class Photo extends Content {
  @override
  Iterable<String> get keys => [
    Keys.i.id,
    Keys.i.timeMills,
    Keys.i.publisherId,
    Keys.i.parentId,
    Keys.i.parentPath,
    Keys.i.path,
    Keys.i.photoUrl,
    Keys.i.privacy,
    Keys.i.description,
    Keys.i.likeCount,
    Keys.i.viewCount,
  ];

  Photo({
    super.id,
    super.timeMills,
    super.publisherId,
    super.parentId,
    super.path,
    super.parentPath,
    super.photoUrl,
    super.description,
    super.likeCount,
    super.viewCount,
    super.audience,
    super.privacy,
  });

  Photo.create({
    required super.id,
    required super.timeMills,
    required super.publisherId,
    required super.parentId,
    required super.path,
    required super.parentPath,
    required super.photoUrl,
    required super.audience,
    required super.privacy,
  });

  factory Photo.parse(Object? source) {
    final content = Content.parse(source);
    return Photo(
      id: content.id,
      timeMills: content.timeMills,
      publisherId: content.publisherId,
      parentId: content.parentId,
      path: content.path,
      parentPath: content.parentPath,
      photoUrl: content.photoUrl,
      description: content.description,
      audience: content.audience,
      privacy: content.privacy,
      likeCount: content.likeCount,
      viewCount: content.viewCount,
    );
  }

  Photo copyWith({
    String? id,
    int? timeMills,
    String? publisherId,
    String? parentId,
    String? path,
    String? parentPath,
    String? photoUrl,
    String? description,
    int? likeCount,
    int? viewCount,
    Audience? audience,
    Privacy? privacy,
  }) {
    return Photo(
      id: id ?? this.id,
      timeMills: timeMills ?? this.timeMills,
      publisherId: publisherId ?? this.publisherId,
      parentId: parentId ?? this.parentId,
      path: path ?? this.path,
      parentPath: parentPath ?? this.parentPath,
      photoUrl: photoUrl ?? this.photoUrl,
      description: description ?? this.description,
      likeCount: likeCount ?? this.likeCount,
      viewCount: viewCount ?? this.viewCount,
      audience: audience ?? this.audience,
      privacy: privacy ?? this.privacy,
    );
  }

  @override
  String toString() => "$Photo#$hashCode($filtered)";
}
