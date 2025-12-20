import 'package:hive_flutter/hive_flutter.dart';

part 'action.g.dart';

const kFollowActionHiveKey = 'follow_queue';

@HiveType(typeId: 21)
class FollowAction extends HiveObject {
  @HiveField(0)
  final String otherUid;

  @HiveField(1)
  final int typeIndex; // 0 = follow, 1 = unfollow

  @HiveField(2)
  final DateTime createdAt;

  FollowAction({
    required this.otherUid,
    required FollowActionType type,
    DateTime? createdAt,
  }) : typeIndex = type.index,
       createdAt = createdAt ?? DateTime.now();

  FollowActionType get type => FollowActionType.values[typeIndex];
}

enum FollowActionType { follow, unfollow }
