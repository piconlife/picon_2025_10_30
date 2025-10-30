import 'package:flutter_entity/entity.dart';

import '../../app/helpers/user.dart';
import '../../data/parsers/enum_parser.dart';
import '../enums/privacy.dart';

class StarKeys extends EntityKey {
  const StarKeys._();

  static const StarKeys i = StarKeys._();

  final parentPath = "parentPath";
  final privacy = "privacy";

  @override
  Iterable<String> get keys => [id, timeMills, privacy, parentPath];
}

class StarModel extends Entity<StarKeys> {
  String? _parentPath;
  Privacy? _privacy;

  String? get parentPath => _parentPath;

  String get publisher => id;

  Privacy get privacy => _privacy ?? Privacy.onlyMe;

  bool get isMe => id == UserHelper.uid;

  bool get isEmpty => id.isEmpty;

  StarModel.empty();

  StarModel._({super.id, super.timeMills, String? parentPath, Privacy? privacy})
    : _parentPath = parentPath,
      _privacy = privacy;

  StarModel.create({
    super.timeMills,
    required String parentPath,
    Privacy? privacy,
  }) : _parentPath = parentPath,
       _privacy = privacy,
       super.auto(id: UserHelper.uid);

  factory StarModel.parse(Object? source) {
    if (source is! Map) return StarModel.empty();
    final key = StarKeys.i;
    return StarModel._(
      id: source.entityValue(key.id),
      timeMills: source.entityValue(key.timeMills),
      parentPath: source.entityValue(key.parentPath),
      privacy: source.entityValue(key.privacy, Privacy.values.parse),
    );
  }

  @override
  StarKeys makeKey() => StarKeys.i;

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
    if (other is! StarModel) return false;
    return idOrNull == other.idOrNull &&
        timeMillsOrNull == other.timeMillsOrNull &&
        _parentPath == other._parentPath &&
        _privacy == other._privacy;
  }

  @override
  String toString() => "$StarModel#$hashCode($filtered)";
}
