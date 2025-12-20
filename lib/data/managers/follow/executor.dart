import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../app/helpers/user.dart';
import 'action.dart';

class FollowExecutor {
  final FirebaseFirestore firestore;
  final String meUid;

  FollowExecutor({FirebaseFirestore? firestore, String? uid})
    : firestore = firestore ?? FirebaseFirestore.instance,
      meUid = uid ?? UserHelper.uid;

  Future<void> execute(FollowAction action) async {
    final other = action.otherUid;
    final batch = firestore.batch();

    final meRef = firestore.collection('users').doc(meUid);
    final otherRef = firestore.collection('users').doc(other);

    final meFollowingsRef = meRef.collection('followings').doc(other);
    final otherFollowersRef = otherRef.collection('followers').doc(meUid);

    switch (action.type) {
      case FollowActionType.follow:
        batch.set(meFollowingsRef, {'at': FieldValue.serverTimestamp()});
        batch.set(otherFollowersRef, {'at': FieldValue.serverTimestamp()});

        batch.update(meRef, {'followingsCount': FieldValue.increment(1)});
        batch.update(otherRef, {'followersCount': FieldValue.increment(1)});

        // Check mutual follow
        final otherFollowingsSnapshot =
            await otherRef.collection('followings').doc(meUid).get();
        final isMutual = otherFollowingsSnapshot.exists;

        if (isMutual) {
          batch.set(meRef.collection('mutualFollowers').doc(other), {});
          batch.set(otherRef.collection('mutualFollowers').doc(meUid), {});
        }
        break;

      case FollowActionType.unfollow:
        batch.delete(meFollowingsRef);
        batch.delete(otherFollowersRef);

        batch.update(meRef, {'followingsCount': FieldValue.increment(-1)});
        batch.update(otherRef, {'followersCount': FieldValue.increment(-1)});

        batch.delete(meRef.collection('mutualFollowers').doc(other));
        batch.delete(otherRef.collection('mutualFollowers').doc(meUid));
        break;
    }

    await batch.commit();
  }
}
