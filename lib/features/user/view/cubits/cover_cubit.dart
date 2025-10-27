import 'package:flutter_entity/entity.dart';

import '../../../../app/base/data_cubit.dart';
import '../../../../app/helpers/user.dart';
import '../../../../data/models/user_cover.dart';
import '../../../../data/use_cases/user_cover/create.dart';
import '../../../../data/use_cases/user_cover/delete.dart';
import '../../../../data/use_cases/user_cover/get_by_pagination.dart';

class UserCoverCubit extends DataCubit<UserCover> {
  final String uid;

  UserCoverCubit([String? uid]) : uid = uid ?? UserHelper.uid;

  @override
  void fetch({int initialSize = 10, int fetchingSize = 5}) {
    emit(state.copyWith(status: Status.loading));
    GetUserCoversByPaginationUseCase.i().then(_attach).catchError((
      error,
      stackTrace,
    ) {
      emit(state.copyWith(status: Status.failure));
    });
  }

  void update(UserCover value) {
    emit(state.copyWith(data: value, requestCode: 202));
  }

  void _attach(Response<UserCover> response) {
    emit(
      state.copyWith(
        status: response.status,
        snapshot: response.snapshot,
        result: response.result,
        requestCode: 0,
      ),
    );
  }

  Future<Response<UserCover>> create(UserCover data) {
    return CreateUserCoverUseCase.i(data).then((value) {
      if (value.isSuccessful) {
        emit(state.copyWith(result: state.result..insert(0, data)));
      }
      return value;
    });
  }

  Future<Response<UserCover>> delete(String id) {
    return DeleteUserCoverUseCase.i(id).then((value) {
      if (value.isSuccessful) {
        emit(
          state.copyWith(
            result:
                state.result..removeWhere((e) {
                  return e.id == id;
                }),
          ),
        );
      }
      return value;
    });
  }
}
