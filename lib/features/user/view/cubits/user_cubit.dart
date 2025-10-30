import 'package:flutter_entity/entity.dart';

import '../../../../app/base/data_cubit.dart';
import '../../../../app/helpers/user.dart';
import '../../../../data/models/user.dart';
import '../../../../data/use_cases/user/get.dart';

class UserCubit extends DataCubit<User> {
  final String uid;

  UserCubit([String? uid]) : uid = uid ?? UserHelper.uid;

  @override
  Future<Response<User>> fetch({
    int? initialSize,
    int? fetchingSize,
    bool resultByMe = false,
  }) async {
    if (resultByMe) return Response(status: Status.undefined);
    return GetUserUseCase.i(uid);
  }

  void update(User value) {
    emit(state.copyWith(data: value, requestCode: 202));
  }
}
