import 'package:data_management/core.dart';
import 'package:flutter_entity/entity.dart';

import '../../constants/keys.dart';
import '../../models/user_follower.dart';
import 'base.dart';

class GetUserFollowersByPaginationUseCase extends BaseUserFollowerUseCase {
  GetUserFollowersByPaginationUseCase._();

  static GetUserFollowersByPaginationUseCase? _i;

  static GetUserFollowersByPaginationUseCase get i {
    return _i ??= GetUserFollowersByPaginationUseCase._();
  }

  Future<Response<UserFollower>> call({
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
