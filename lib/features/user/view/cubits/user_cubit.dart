import 'package:flutter_entity/entity.dart';

import '../../../../app/base/data_cubit.dart';
import '../../../../app/helpers/user.dart';
import '../../../../data/models/user.dart';
import '../../../../data/use_cases/user/get.dart';

class UserCubit extends DataCubit<UserModel> {
  final String uid;

  UserCubit(super.context, [String? uid]) : uid = uid ?? UserHelper.uid;

  @override
  Future<Response<UserModel>> onFetch({
    int? initialSize,
    int? fetchingSize,
    bool resultByMe = false,
  }) async {
    if (resultByMe) return Response(status: Status.undefined);
    return GetUserUseCase.i(uid);
  }
}
