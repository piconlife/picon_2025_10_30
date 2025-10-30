import 'package:flutter_entity/entity.dart';

import '../../app/helpers/user.dart';
import '../../data/parsers/enum_parser.dart';
import '../enums/like_type.dart';

class LikeKeys extends EntityKey {
  const LikeKeys._();

  static const LikeKeys i = LikeKeys._();

  final parentPath = "parentPath";
  final type = "type";

  @override
  Iterable<String> get keys => [id, timeMills, type, parentPath];
}

class LikeModel extends Entity<LikeKeys> {
  String? _parentPath;
  LikeType? _type;

  String? get parentPath => _parentPath;

  String get publisher => id;

  LikeType get type => _type ?? LikeType.like;

  bool get isMe => id == UserHelper.uid;

  bool get isEmpty => id.isEmpty;

  LikeModel.empty();

  LikeModel._({super.id, super.timeMills, String? parentPath, LikeType? type})
    : _parentPath = parentPath,
      _type = type;

  LikeModel.create({
    super.timeMills,
    required String parentPath,
    LikeType? type,
  }) : _parentPath = parentPath,
       _type = type,
       super.auto(id: UserHelper.uid);

  factory LikeModel.parse(Object? source) {
    if (source is! Map) return LikeModel.empty();
    final key = LikeKeys.i;
    return LikeModel._(
      id: source.entityValue(key.id),
      timeMills: source.entityValue(key.timeMills),
      parentPath: source.entityValue(key.parentPath),
      type: source.entityValue(key.type, LikeType.values.parse),
    );
  }

  @override
  LikeKeys makeKey() => LikeKeys.i;

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
    if (other is! LikeModel) return false;
    return idOrNull == other.idOrNull &&
        timeMillsOrNull == other.timeMillsOrNull &&
        _parentPath == other._parentPath &&
        _type == other._type;
  }

  @override
  String toString() => "$LikeModel#$hashCode($filtered)";
}
