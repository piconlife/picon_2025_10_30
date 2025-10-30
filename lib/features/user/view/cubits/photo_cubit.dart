import 'package:flutter_entity/entity.dart';

import '../../../../app/base/data_cubit.dart';
import '../../../../app/helpers/user.dart';
import '../../../../data/models/user_post.dart';
import '../../../../data/use_cases/user_post/get_photos_by_pagination.dart';

class UserPhotoCubit extends DataCubit<UserPost> {
  final String uid;

  UserPhotoCubit([String? uid]) : uid = uid ?? UserHelper.uid;

  @override
  Future<Response<UserPost>> fetch({
    int? initialSize,
    int? fetchingSize,
    bool resultByMe = false,
  }) async {
    if (resultByMe) return Response(status: Status.undefined);
    return GetUserPhotosByPaginationUseCase.i(
      uid: uid,
      initialSize: initialSize ?? 10,
      fetchingSize: fetchingSize ?? 5,
      snapshot: state.snapshot,
    );
  }

  void add(UserPost data) {
    if (!data.isPhotoMode) return;
    emit(state.copyWith(result: state.result..insert(0, data)));
  }
}
