import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_entity/entity.dart';

import '../../../../app/base/data_cubit.dart';
import '../../../../app/helpers/user.dart';
import '../../../../data/managers/follow/action.dart';
import '../../../../data/managers/follow/manager.dart';
import '../../../../data/models/user_following.dart';
import '../../../../data/use_cases/user_following/count.dart';
import '../../../../data/use_cases/user_following/create.dart';
import '../../../../data/use_cases/user_following/delete.dart';
import '../../../../data/use_cases/user_following/get.dart';
import '../../../../data/use_cases/user_following/gets.dart';

class UserFollowingCubit extends DataCubit<FollowingModel>
    with WidgetsBindingObserver {
  final String uid;
  final FollowWriteManager manager;

  UserFollowingCubit(super.context, {String? uid, FollowWriteManager? manager})
    : uid = uid ?? UserHelper.uid,
      manager = manager ?? FollowWriteManager.i {
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  Future<void> close() {
    WidgetsBinding.instance.removeObserver(this);
    return super.close();
  }

  @override
  FollowingModel? createNewObject(Object? args) {
    if (uid.isEmpty) return null;
    return FollowingModel.create(uid: uid);
  }

  @override
  Future<Response<int>> onCount() => UserFollowingCountUseCase.i(uid);

  @override
  Future<Response<FollowingModel>> onCreate(FollowingModel data) {
    return UserFollowingCreateUseCase.i(data);
  }

  @override
  Future<Response<FollowingModel>> onDelete(FollowingModel data) {
    return onDeleteById(data.id);
  }

  @override
  Future<Response<FollowingModel>> onDeleteById(String id) {
    return UserFollowingDeleteUseCase.i(id);
  }

  @override
  Future<Response<FollowingModel>> onGetById(String id) {
    return UserFollowingGetUseCase.i(id);
  }

  @override
  Future<Response<FollowingModel>> onFetch({
    int? initialSize,
    int? fetchingSize,
    bool resultByMe = false,
  }) async {
    if (resultByMe) return Response(status: Status.undefined);
    return UserFollowingGetsUseCase.i(uid);
  }

  Future<void> follow(String otherUid) async {
    setExist(otherUid, true);
    await manager.enqueue(
      FollowAction(otherUid: otherUid, type: FollowActionType.follow),
    );
  }

  Future<void> unfollow(String otherUid) async {
    setExist(otherUid, false);
    await manager.enqueue(
      FollowAction(otherUid: otherUid, type: FollowActionType.unfollow),
    );
  }

  Future<bool> isMutual(String otherUid) async {
    final doc =
        await FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .collection('mutual_followers')
            .doc(otherUid)
            .get();
    return doc.exists;
  }

  Future<int> getFollowersCount(String uid) async {
    final doc =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    return doc.data()?['followersCount'] ?? 0;
  }

  Future<int> getFollowingsCount(String uid) async {
    final doc =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    return doc.data()?['followingsCount'] ?? 0;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      manager.trySync();
    }
  }
}
