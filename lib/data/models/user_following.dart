import 'package:flutter_entity/entity.dart';

import 'user.dart';

class UserFollowingKeys extends EntityKey {
  final uid = "uid";

  @override
  Iterable<String> get keys => [id, timeMills, uid];

  UserFollowingKeys._();

  static UserFollowingKeys? _i;

  static UserFollowingKeys get i => _i ??= UserFollowingKeys._();
}

class UserFollowing extends Entity<UserFollowingKeys> {
  final String? uid;
  final User? user;

  UserFollowing({super.id, super.timeMills, this.uid, this.user});

  factory UserFollowing.from(Object? source) {
    if (source is! Map) return UserFollowing();
    final key = UserFollowingKeys.i;
    return UserFollowing(
      id: source.entityValue(key.id),
      timeMills: source.entityValue(key.timeMills),
      uid: source.entityValue(key.uid),
    );
  }

  UserFollowing copy({String? id, String? uid, int? timeMills, User? user}) {
    return UserFollowing(
      id: id ?? this.id,
      timeMills: timeMills ?? this.timeMills,
      uid: uid ?? this.uid,
      user: user ?? this.user,
    );
  }

  @override
  UserFollowingKeys makeKey() => UserFollowingKeys.i;

  @override
  Map<String, dynamic> get source => super.source..addAll({key.uid: uid});
}
