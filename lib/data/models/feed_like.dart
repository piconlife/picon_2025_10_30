import 'package:flutter_entity/entity.dart';

import '../../app/helpers/user.dart';
import '../enums/like_type.dart';

class FeedLikeKeys extends EntityKey {
  const FeedLikeKeys._();

  static const FeedLikeKeys i = FeedLikeKeys._();

  final type = "type";

  @override
  Iterable<String> get keys => [id, timeMills, type];
}

class FeedLike extends Entity<FeedLikeKeys> {
  LikeType? _type;

  String get publisher => id;

  LikeType get type => _type ?? LikeType.like;

  bool get isMe => id == UserHelper.uid;

  bool get isEmpty => id.isEmpty;

  FeedLike.empty();

  FeedLike._({super.id, super.timeMills, LikeType? type}) : _type = type;

  FeedLike.create({super.timeMills, LikeType? type})
    : _type = type,
      super.auto(id: UserHelper.uid);

  factory FeedLike.parse(Object? source) {
    if (source is! Map) return FeedLike.empty();
    final key = FeedLikeKeys.i;
    return FeedLike._(
      id: source.entityValue(key.id),
      timeMills: source.entityValue(key.timeMills),
      type: source.entityValue(key.type, LikeType.parse),
    );
  }

  @override
  FeedLikeKeys makeKey() => FeedLikeKeys.i;

  @override
  Map<String, dynamic> get source {
    return {key.id: id, key.timeMills: timeMills, key.type: _type?.name};
  }

  @override
  int get hashCode => id.hashCode ^ timeMills.hashCode ^ type.hashCode;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! FeedLike) return false;
    return id == other.id && timeMills == other.timeMills && type == other.type;
  }

  @override
  String toString() => "$FeedLike#$hashCode($filtered)";
}
