import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import '../../../../roots/helpers/user.dart';
import '../../../../roots/preferences/preferences.dart';

const _kScoreLastUpdateTime = "kScoreLastUpdateTime";

class Streak extends ValueNotifier<int> {
  Streak._() : super(0);

  static Streak? _i;

  String? get uid => UserHelper.uid;

  static Streak get i => _i ??= Streak._();

  bool get isTodayScored {
    final last = getLastUpdateTime();
    if (last != null) {
      final day = DateTime.now().difference(last).inDays;
      return day == 0;
    } else {
      return false;
    }
  }

  bool get isOverdue {
    final last = getLastUpdateTime();
    if (last != null) {
      final now = DateTime.now();
      final x = DateTime(now.year, now.month, now.day);
      final day = x.difference(last).inDays;
      return day > 1;
    } else {
      return true;
    }
  }

  DateTime? getLastUpdateTime() {
    final timeMills = Preferences.getInt(_kScoreLastUpdateTime, 0);
    if (timeMills != 0) {
      return DateTime.fromMillisecondsSinceEpoch(timeMills);
    } else {
      return null;
    }
  }

  Future<UserScore?> getScore([String? uid]) async {
    uid ??= this.uid;
    if (uid != null) {
      final ref = FirebaseFirestore.instance.collection("scores").doc(uid);
      return ref.get().then((value) {
        final data = value.data();
        if (data != null) {
          return UserScore.from(data);
        } else {
          return null;
        }
      });
    } else {
      return null;
    }
  }

  void initScore([String? uid]) {
    getScore(uid).then((score) {
      updateScoreOnly(score?.current ?? value);
    });
  }

  void updateScoreOnly(int score) {
    value = score;
    // PartnerHelper.update(args: {
    //   PartnerKeys.streak: score,
    // });
    notifyListeners();
  }

  void setLastUpdateTime(int score) {
    final now = DateTime.now();
    final x = DateTime(now.year, now.month, now.day);
    final defaultMS = x.millisecondsSinceEpoch;
    Preferences.setInt(_kScoreLastUpdateTime, defaultMS);
    updateScoreOnly(score);
  }

  void updateScore() async {
    try {
      if (!isTodayScored) {
        // StreakController.to.markCalendar();
        if (uid != null) {
          final ref = FirebaseFirestore.instance.collection("scores").doc(uid);
          if (isOverdue) {
            const score = UserScore.initial();
            updateScoreOnly(score.current);
            await ref.set({"current": score.current}, SetOptions(merge: true));
            setLastUpdateTime(score.current);
          } else {
            int currentValue = value + 1;
            updateScoreOnly(currentValue);
            final old = await getScore(uid);
            if (old != null) {
              final oldHighest = old.highest;
              final current = old.current + 1;
              final highest = current > oldHighest ? current : oldHighest;
              updateScoreOnly(current);
              await ref.update({"current": current, "highest": highest});
              setLastUpdateTime(current);
            } else {
              const score = UserScore.initial();
              updateScoreOnly(score.current);
              await ref.set({
                "current": score.current,
              }, SetOptions(merge: true));
              setLastUpdateTime(score.current);
            }
          }
        }
      }
    } catch (_) {}
  }
}

class UserScore {
  final int current;
  final int highest;

  const UserScore({required this.current, required this.highest});

  const UserScore.initial() : this(current: 1, highest: 1);

  const UserScore.zero() : this(current: 0, highest: 0);

  factory UserScore.from(Map<String, dynamic>? source) {
    source ??= {};
    final current = source["current"];
    final highest = source["highest"];
    return UserScore(
      current: current is int ? current : 0,
      highest: highest is int ? highest : 0,
    );
  }

  UserScore copy({int? current, int? highest}) {
    return UserScore(
      current: current ?? this.current,
      highest: highest ?? this.highest,
    );
  }

  Map<String, dynamic> get source {
    return {"current": current, "highest": highest};
  }
}
