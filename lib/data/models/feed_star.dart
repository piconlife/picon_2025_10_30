import 'package:flutter_entity/entity.dart';

import '../../app/helpers/user.dart';
import '../../data/parsers/enum_parser.dart';
import '../enums/privacy.dart';

class FeedStarKeys extends EntityKey {
  const FeedStarKeys._();

  static const FeedStarKeys i = FeedStarKeys._();

  final parentPath = "parentPath";
  final privacy = "privacy";

  @override
  Iterable<String> get keys => [id, timeMills, privacy, parentPath];
}

class FeedStar extends Entity<FeedStarKeys> {
  String? _parentPath;
  Privacy? _privacy;

  String? get parentPath => _parentPath;

  String get publisher => id;

  Privacy get privacy => _privacy ?? Privacy.onlyMe;

  bool get isMe => id == UserHelper.uid;

  bool get isEmpty => id.isEmpty;

  FeedStar.empty();

  FeedStar._({super.id, super.timeMills, String? parentPath, Privacy? privacy})
    : _parentPath = parentPath,
      _privacy = privacy;

  FeedStar.create({
    super.timeMills,
    required String parentPath,
    Privacy? privacy,
  }) : _parentPath = parentPath,
       _privacy = privacy,
       super.auto(id: UserHelper.uid);

  factory FeedStar.parse(Object? source) {
    if (source is! Map) return FeedStar.empty();
    final key = FeedStarKeys.i;
    return FeedStar._(
      id: source.entityValue(key.id),
      timeMills: source.entityValue(key.timeMills),
      parentPath: source.entityValue(key.parentPath),
      privacy: source.entityValue(key.privacy, Privacy.values.parse),
    );
  }

  @override
  FeedStarKeys makeKey() => FeedStarKeys.i;

  @override
  Map<String, dynamic> get source {
    return {
      key.id: id,
      key.timeMills: timeMills,
      key.parentPath: _parentPath,
      key.privacy: _privacy?.name,
    };
  }

  @override
  int get hashCode {
    return Object.hash(idOrNull, timeMillsOrNull, _parentPath, _privacy);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! FeedStar) return false;
    return idOrNull == other.idOrNull &&
        timeMillsOrNull == other.timeMillsOrNull &&
        _parentPath == other._parentPath &&
        _privacy == other._privacy;
  }

  @override
  String toString() => "$FeedStar#$hashCode($filtered)";
}
