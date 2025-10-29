import 'package:flutter_entity/entity.dart';

import '../../app/helpers/user.dart';
import '../enums/like_type.dart';

class FeedLikeKeys extends EntityKey {
  const FeedLikeKeys._();

  static const FeedLikeKeys i = FeedLikeKeys._();

  final parentPath = "parentPath";
  final type = "type";

  @override
  Iterable<String> get keys => [id, timeMills, type, parentPath];
}

class FeedLike extends Entity<FeedLikeKeys> {
  String? _parentPath;
  LikeType? _type;

  String? get parentPath => _parentPath;

  String get publisher => id;

  LikeType get type => _type ?? LikeType.like;

  bool get isMe => id == UserHelper.uid;

  bool get isEmpty => id.isEmpty;

  FeedLike.empty();

  FeedLike._({super.id, super.timeMills, String? parentPath, LikeType? type})
    : _parentPath = parentPath,
      _type = type;

  FeedLike.create({super.timeMills, required String parentPath, LikeType? type})
    : _parentPath = parentPath,
      _type = type,
      super.auto(id: UserHelper.uid);

  factory FeedLike.parse(Object? source) {
    if (source is! Map) return FeedLike.empty();
    final key = FeedLikeKeys.i;
    return FeedLike._(
      id: source.entityValue(key.id),
      timeMills: source.entityValue(key.timeMills),
      parentPath: source.entityValue(key.parentPath),
      type: source.entityValue(key.type, LikeType.parse),
    );
  }

  @override
  FeedLikeKeys makeKey() => FeedLikeKeys.i;

  @override
  Map<String, dynamic> get source {
    return {
      key.id: id,
      key.timeMills: timeMills,
      key.parentPath: _parentPath,
      key.type: _type?.name,
    };
  }

  @override
  int get hashCode =>
      Object.hash(idOrNull, timeMillsOrNull, _parentPath, _type);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! FeedLike) return false;
    return idOrNull == other.idOrNull &&
        timeMillsOrNull == other.timeMillsOrNull &&
        _parentPath == other._parentPath &&
        _type == other._type;
  }

  @override
  String toString() => "$FeedLike#$hashCode($filtered)";
}
