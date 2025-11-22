import 'package:flutter_entity/entity.dart';

import '../../../../app/base/data_cubit.dart';
import '../../../../app/helpers/user.dart';
import '../../../../data/models/user_story.dart';
import '../../../../data/use_cases/user_story/get_by_pagination.dart';

class UserStoryCubit extends DataCubit<StoryModel> {
  final String uid;

  UserStoryCubit(super.context, [String? uid]) : uid = uid ?? UserHelper.uid;

  @override
  Future<Response<StoryModel>> onFetch({
    int? initialSize,
    int? fetchingSize,
    bool resultByMe = false,
  }) async {
    if (resultByMe) return Response(status: Status.undefined);
    return GetUserStoriesByPaginationUseCase.i(
      uid: uid,
      initialSize: initialSize ?? 10,
      fetchingSize: fetchingSize ?? 5,
      snapshot: state.snapshot,
    );
  }
}
