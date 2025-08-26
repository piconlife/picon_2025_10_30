import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_entity/entity.dart';

import '../../../../app/helpers/user.dart';
import '../../../../data/models/user_avatar.dart';
import '../../../../data/use_cases/user_avatar/create.dart';
import '../../../../data/use_cases/user_avatar/delete.dart';
import '../../../../data/use_cases/user_avatar/get_by_pagination.dart';

class UserAvatarCubit extends Cubit<Response<UserAvatar>> {
  final String uid;

  UserAvatarCubit([String? uid])
    : uid = uid ?? UserHelper.uid,
      super(Response());

  void fetch({int initialSize = 10, int fetchingSize = 5}) {
    emit(state.copyWith(status: Status.loading));
    GetUserAvatarsByPaginationUseCase.i().then(_attach).catchError((
      error,
      stackTrace,
    ) {
      emit(state.copyWith(status: Status.failure));
    });
  }

  void update(UserAvatar value) {
    emit(state.copyWith(data: value, requestCode: 202));
  }

  void _attach(Response<UserAvatar> response) {
    emit(
      state.copyWith(
        status: response.status,
        snapshot: response.snapshot,
        result: response.result,
        requestCode: 0,
      ),
    );
  }

  Future<Response<UserAvatar>> create(UserAvatar data) {
    return CreateUserAvatarUseCase.i(data).then((value) {
      if (value.isSuccessful) {
        emit(state.copyWith(result: state.result..insert(0, data)));
      }
      return value;
    });
  }

  Future<Response<UserAvatar>> delete(String id) {
    return DeleteUserAvatarUseCase.i(id).then((value) {
      if (value.isSuccessful) {
        emit(
          state.copyWith(
            result: state.result
              ..removeWhere((e) {
                return e.id == id;
              }),
          ),
        );
      }
      return value;
    });
  }
}
