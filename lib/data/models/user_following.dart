import 'package:flutter_entity/entity.dart';

import 'user.dart';

class UserFollowingKeys extends EntityKey {
  const UserFollowingKeys._();

  static UserFollowingKeys i = const UserFollowingKeys._();

  final verified = "verified";

  @override
  Iterable<String> get keys => [id, timeMills, verified];
}

class UserFollowing extends Entity<UserFollowingKeys> {
  bool? verified;

  User content = User();

  UserFollowing.empty();

  UserFollowing._({super.id, super.timeMills, this.verified});

  UserFollowing.create({required String uid, super.timeMills, this.verified})
    : super.auto(id: uid);

  factory UserFollowing.parse(Object? source) {
    if (source is! Map) return UserFollowing._();
    final key = UserFollowingKeys.i;
    return UserFollowing._(
      id: source.entityValue(key.id),
      timeMills: source.entityValue(key.timeMills),
      verified: source.entityValue(key.verified),
    );
  }

  @override
  UserFollowingKeys makeKey() => UserFollowingKeys.i;

  @override
  Map<String, dynamic> get source => {
    key.id: id,
    key.timeMills: timeMills,
    key.verified: verified,
  };

  @override
  int get hashCode =>
      idOrNull.hashCode ^ timeMillsOrNull.hashCode ^ verified.hashCode;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserFollowing &&
        other.id == id &&
        other.timeMills == timeMills &&
        other.verified == verified;
  }

  @override
  String toString() => "$UserFollowing#$hashCode($filteredJson)";
}
