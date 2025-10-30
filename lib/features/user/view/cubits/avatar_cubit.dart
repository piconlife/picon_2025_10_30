import 'package:flutter/foundation.dart';
import 'package:flutter_entity/entity.dart';

import '../../../../app/base/data_cubit.dart';
import '../../../../app/helpers/user.dart';
import '../../../../data/models/user_avatar.dart';
import '../../../../data/use_cases/user_avatar/create.dart';
import '../../../../data/use_cases/user_avatar/delete.dart';
import '../../../../data/use_cases/user_avatar/get_by_pagination.dart';

class UserAvatarCubit extends DataCubit<UserAvatar> {
  final String uid;

  UserAvatarCubit(super.context, [String? uid]) : uid = uid ?? UserHelper.uid;

  @override
  Future<Response<UserAvatar>> onFetch({
    int? initialSize,
    int? fetchingSize,
    bool resultByMe = false,
  }) async {
    if (resultByMe) return Response(status: Status.undefined);
    return GetUserAvatarsByPaginationUseCase.i(
      uid: uid,
      initialSize: initialSize ?? 10,
      fetchingSize: fetchingSize ?? 5,
      snapshot: state.snapshot,
    );
  }

  @protected
  @override
  Future<Response<UserAvatar>> onCreate(UserAvatar data) async {
    return CreateUserAvatarUseCase.i(data).then((value) {
      return value.copyWith(data: data);
    });
  }

  @override
  Future<Response<UserAvatar>> onDelete(UserAvatar data) {
    return onDeleteById(data.id);
  }

  @override
  Future<Response<UserAvatar>> onDeleteById(String id) async {
    return DeleteUserAvatarUseCase.i(id);
  }
}
