import 'package:data_management/core.dart';
import 'package:flutter_entity/entity.dart';

import '../../constants/keys.dart';
import '../../models/user_following.dart';
import 'base.dart';

class GetUserFollowingsByPaginationUseCase extends BaseUserFollowingUseCase {
  GetUserFollowingsByPaginationUseCase._();

  static GetUserFollowingsByPaginationUseCase? _i;

  static GetUserFollowingsByPaginationUseCase get i {
    return _i ??= GetUserFollowingsByPaginationUseCase._();
  }

  Future<Response<UserFollowing>> call({
    String? uid,
    int? initialSize,
    int? fetchingSize,
    Object? snapshot,
  }) {
    return repository.getByQuery(
      params: getParams(uid),
      sorts: [DataSorting(Keys.i.timeMills, descending: true)],
      selections: [
        if (snapshot != null) DataSelection.startAfterDocument(snapshot),
      ],
      options: DataPagingOptions(
        initialFetchSize: initialSize,
        fetchingSize: fetchingSize,
      ),
    );
  }
}
