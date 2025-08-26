import 'package:data_management/core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_andomie/extensions/list.dart';
import 'package:flutter_andomie/models/selection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_entity/entity.dart';

import '../../../../app/helpers/user.dart';
import '../../../../data/models/user.dart';
import '../../../../data/use_cases/user/get_users_by_ids.dart';

class VerifiedUsersCubit extends Cubit<Response<Selection<User>>> {
  VerifiedUsersCubit() : super(Response());

  void fetch() async {
    final ids = UserHelper.followings;
    if (ids.isEmpty) return emit(state.copyWith(status: Status.notFound));
    emit(state.copyWith(status: Status.loading));
    GetUsersByIdsUseCase.i(ids).then(_attach).catchError((e, st) {
      emit(state.copyWith(status: Status.failure));
    });
  }

  void update(BuildContext context, Selection<User> value) {
    emit(
      state.copyWith(
        result: state.result.change(value, (e) {
          return e.data.id == value.data.id;
        }),
      ),
    );
    DataFieldValue field;
    if (value.selected) {
      field = DataFieldValue.arrayRemove([value.id]);
    } else {
      field = DataFieldValue.arrayUnion([value.id]);
    }
    UserHelper.update(context, {UserKeys.i.approvals: field});
  }

  void _attach(Response<User> response) {
    final data = state.result;
    if (response.result.isNotEmpty) {
      data.addAll(
        response.result.map((e) {
          return Selection(
            id: e.id,
            data: e,
            selected: UserHelper.approvals.contains(e.id),
          );
        }),
      );
    }
    emit(
      state.copyWith(
        status: response.status,
        snapshot: response.snapshot,
        result: data,
        requestCode: 0,
      ),
    );
  }
}
