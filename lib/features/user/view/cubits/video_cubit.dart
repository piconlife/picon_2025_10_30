import 'package:flutter_entity/entity.dart';

import '../../../../app/base/data_cubit.dart';
import '../../../../app/helpers/user.dart';
import '../../../../data/models/user_video.dart';
import '../../../../data/use_cases/user_video/get_by_pagination.dart';

class UserVideoCubit extends DataCubit<VideoModel> {
  final String uid;

  UserVideoCubit(super.context, [String? uid]) : uid = uid ?? UserHelper.uid;

  @override
  Future<Response<VideoModel>> onFetch({
    int? initialSize,
    int? fetchingSize,
    bool resultByMe = false,
  }) async {
    if (resultByMe) return Response(status: Status.undefined);
    return GetUserVideosByPaginationUseCase.i(
      uid: uid,
      initialSize: initialSize ?? 10,
      fetchingSize: fetchingSize ?? 5,
      snapshot: state.snapshot,
    );
  }
}
