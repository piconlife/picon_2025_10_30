import 'package:flutter/material.dart';
import 'package:flutter_andomie/models/selection.dart';
import 'package:flutter_entity/entity.dart';

import '../../../../app/base/data_cubit.dart';
import '../../../../app/helpers/user.dart';
import '../../../../data/models/user_following.dart';
import '../../../../data/use_cases/user_following/create.dart';
import '../../../../data/use_cases/user_following/delete.dart';
import '../../../../data/use_cases/user_following/get.dart';
import '../../../../data/use_cases/user_following/update.dart';

class UserFollowingCubit extends DataCubit<Selection<UserFollowing>> {
  final String? uid;

  UserFollowingCubit([String? uid]) : uid = uid ?? UserHelper.uid;

  @override
  void fetch() async {
    if (uid == null || uid!.isEmpty) {
      return emit(state.copy(status: Status.notFound));
    }
    emit(state.copy(status: Status.loading));
    GetUserFollowingsUseCase.i().then(_attach).catchError((error, st) {
      emit(state.copy(status: Status.failure));
    });
  }

  @override
  void insert(BuildContext context, Selection<UserFollowing> data) {
    emit(state.copy(result: put(data, 0)));
    CreateUserFollowingUseCase.i(data.data).then((value) {
      if (value.isSuccessful) return;
      emit(state.copy(result: pop(data.id)));
    });
  }

  @override
  void delete(BuildContext context, String id) {
    emit(state.copy(result: change(id, (e) => e.copy(loading: true))));
    DeleteUserFollowingUseCase.i(id).then((value) {
      if (value.isSuccessful) {
        emit(state.copy(result: remove(id)));
        return;
      }
      emit(state.copy(result: change(id, (e) => e.copy(loading: false))));
    });
  }

  @override
  void update(BuildContext context, String id, Map<String, dynamic> updates) {
    emit(
      state.copy(
        result: change(id, (e) {
          return e.copy(loading: true);
        }),
      ),
    );
    UpdateUserFollowingUseCase.i(id, updates).then((value) {
      if (value.isSuccessful) {
        emit(
          state.copy(
            result: change(id, (e) {
              return e.copy(loading: false, data: value.data);
            }),
          ),
        );
        return;
      }
      emit(state.copy(result: change(id, (e) => e.copy(loading: false))));
    });
  }

  void _attach(Response<UserFollowing> response) {
    final data = state.result;
    if (response.result.isNotEmpty) {
      data.addAll(
        response.result.map((e) {
          return Selection(
            id: e.id,
            data: e,
            selected: UserHelper.followings.contains(e.id),
          );
        }),
      );
    }
    emit(
      state.copy(
        status: response.status,
        snapshot: response.snapshot,
        result: data,
        requestCode: 0,
      ),
    );
  }
}
