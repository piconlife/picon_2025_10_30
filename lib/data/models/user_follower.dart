import 'package:flutter_entity/entity.dart';

import 'user.dart';

class UserFollowerKeys extends EntityKey {
  final uid = "uid";

  @override
  Iterable<String> get keys => [id, timeMills, uid];

  UserFollowerKeys._();

  static UserFollowerKeys? _i;

  static UserFollowerKeys get i => _i ??= UserFollowerKeys._();
}

class FollowerModel extends Entity<UserFollowerKeys> {
  final String? uid;
  final UserModel? user;

  FollowerModel({super.id, super.timeMills, this.uid, this.user});

  factory FollowerModel.from(Object? source) {
    if (source is! Map) return FollowerModel();
    final key = UserFollowerKeys.i;
    return FollowerModel(
      id: source.entityValue(key.id),
      timeMills: source.entityValue(key.timeMills),
      uid: source.entityValue(key.uid),
    );
  }

  FollowerModel copy({
    String? id,
    String? uid,
    int? timeMills,
    UserModel? user,
  }) {
    return FollowerModel(
      id: id ?? this.id,
      timeMills: timeMills ?? this.timeMills,
      uid: uid ?? this.uid,
      user: user ?? this.user,
    );
  }

  @override
  UserFollowerKeys makeKey() => UserFollowerKeys.i;

  @override
  Map<String, dynamic> get source => super.source..addAll({key.uid: uid});
}
