import 'package:flutter/foundation.dart';
import 'package:flutter_entity/entity.dart';

import '../../../../app/base/data_cubit.dart';
import '../../../../app/helpers/user.dart';
import '../../../../data/models/user_cover.dart';
import '../../../../data/use_cases/user_cover/create.dart';
import '../../../../data/use_cases/user_cover/delete.dart';
import '../../../../data/use_cases/user_cover/get_by_pagination.dart';

class UserCoverCubit extends DataCubit<CoverModel> {
  final String uid;

  UserCoverCubit(super.context, [String? uid]) : uid = uid ?? UserHelper.uid;

  @override
  Future<Response<CoverModel>> onFetch({
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
  Future<Response<CoverModel>> onCreate(CoverModel data) async {
    return CreateUserCoverUseCase.i(data).then((value) {
      return value.copyWith(data: data);
    });
  }

  @override
  Future<Response<CoverModel>> onDelete(CoverModel data) {
    return onDeleteById(data.id);
  }

  @override
  Future<Response<CoverModel>> onDeleteById(String id) async {
    return DeleteUserCoverUseCase.i(id);
  }
}
