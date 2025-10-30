import 'package:flutter/foundation.dart';
import 'package:flutter_entity/entity.dart';

import '../../../../app/base/data_cubit.dart';
import '../../../../app/helpers/user.dart';
import '../../../../data/models/user_cover.dart';
import '../../../../data/use_cases/user_cover/create.dart';
import '../../../../data/use_cases/user_cover/delete.dart';
import '../../../../data/use_cases/user_cover/get_by_pagination.dart';

class UserCoverCubit extends DataCubit<UserCover> {
  final String uid;

  UserCoverCubit(super.context, [String? uid]) : uid = uid ?? UserHelper.uid;

  @override
  Future<Response<UserCover>> onFetch({
    int? initialSize,
    int? fetchingSize,
    bool resultByMe = false,
  }) async {
    if (resultByMe) return Response(status: Status.undefined);
    return GetUserCoversByPaginationUseCase.i(
      uid: uid,
      initialSize: initialSize ?? 10,
      fetchingSize: fetchingSize ?? 5,
      snapshot: state.snapshot,
    );
  }

  @protected
  @override
  Future<Response<UserCover>> onCreate(UserCover data) async {
    return CreateUserCoverUseCase.i(data).then((value) {
      return value.copyWith(data: data);
    });
  }

  @override
  Future<Response<UserCover>> onDelete(UserCover data) {
    return onDeleteById(data.id);
  }

  @override
  Future<Response<UserCover>> onDeleteById(String id) async {
    return DeleteUserCoverUseCase.i(id);
  }
}
