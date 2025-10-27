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
    Keys.i.path,
    Keys.i.privacy,
    Keys.i.audience,
    Keys.i.photoUrl,
    Keys.i.description,
    Keys.i.likeCount,
    Keys.i.viewCount,
  ];

  Photo({
    super.id,
    super.timeMills,
    super.publisherId,
    super.path,
    super.audience,
    super.privacy,
    super.photoUrl,
    super.description,
    super.likeCount,
    super.viewCount,
  });

  Photo.create({
    required super.id,
    required super.timeMills,
    required super.publisherId,
    required super.path,
    required super.audience,
    required super.privacy,
    required super.photoUrl,
    super.description,
  });

  factory Photo.parse(Object? source) {
    final content = Content.parse(source);
    return Photo(
      id: content.id,
      timeMills: content.timeMills,
      publisherId: content.publisherId,
      path: content.path,
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
    String? path,
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
      path: path ?? this.path,
      photoUrl: photoUrl ?? this.photoUrl,
      description: description ?? this.description,
      likeCount: likeCount ?? this.likeCount,
      viewCount: viewCount ?? this.viewCount,
      audience: audience ?? this.audience,
      privacy: privacy ?? this.privacy,
    );
  }

  @override
  String toString() => "$Photo#$hashCode($idOrNull)";
}
