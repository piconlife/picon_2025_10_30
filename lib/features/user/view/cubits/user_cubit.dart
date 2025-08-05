import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_entity/entity.dart';

import '../../../../app/helpers/user.dart';
import '../../../../data/models/user.dart';
import '../../../../data/use_cases/user/get.dart';

class UserCubit extends Cubit<Response<User>> {
  final String uid;

  UserCubit([String? uid]) : uid = uid ?? UserHelper.uid, super(Response());

  void fetch({int initialSize = 10, int fetchingSize = 5}) {
    emit(state.copy(status: Status.loading));
    GetUserUseCase.i(uid).then(_attach).catchError((error, st) {
      emit(state.copy(status: Status.failure));
    });
  }

  void update(User value) {
    emit(state.copy(data: value, requestCode: 202));
  }

  void _attach(Response<User> response) {
    emit(
      state.copy(
        status: response.status,
        snapshot: response.snapshot,
        data: response.data,
        requestCode: 0,
      ),
    );
  }
}
