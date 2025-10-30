import 'package:flutter_entity/entity.dart';

import '../../app/helpers/user.dart';

class ViewKeys extends EntityKey {
  const ViewKeys._();

  static const ViewKeys i = ViewKeys._();

  final parentPath = "parentPath";

  @override
  Iterable<String> get keys => [id, timeMills, parentPath];
}

class ViewModel extends Entity<ViewKeys> {
  String? _parentPath;

  String? get parentPath => _parentPath;

  String get publisher => id;

  bool get isMe => id == UserHelper.uid;

  bool get isEmpty => id.isEmpty;

  ViewModel.empty();

  ViewModel._({super.id, super.timeMills, String? parentPath})
    : _parentPath = parentPath;

  ViewModel.create({super.timeMills, required String parentPath})
    : _parentPath = parentPath,
      super.auto(id: UserHelper.uid);

  factory ViewModel.parse(Object? source) {
    if (source is! Map) return ViewModel.empty();
    final key = ViewKeys.i;
    return ViewModel._(
      id: source.entityValue(key.id),
      timeMills: source.entityValue(key.timeMills),
      parentPath: source.entityValue(key.parentPath),
    );
  }

  @override
  ViewKeys makeKey() => ViewKeys.i;

  @override
  Map<String, dynamic> get source {
    return {key.id: id, key.timeMills: timeMills, key.parentPath: _parentPath};
  }

  @override
  int get hashCode => Object.hash(idOrNull, timeMillsOrNull, _parentPath);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! ViewModel) return false;
    return idOrNull == other.idOrNull &&
        timeMillsOrNull == other.timeMillsOrNull &&
        _parentPath == other._parentPath;
  }

  @override
  String toString() => "$ViewModel#$hashCode($filtered)";
}
