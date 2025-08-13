import 'package:data_management/core.dart';
import 'package:flutter_entity/entity.dart';

import '../../constants/keys.dart';
import '../../models/user_post.dart';
import 'base.dart';

class GetUserVideosByPaginationUseCase extends BaseUserPostUseCase {
  GetUserVideosByPaginationUseCase._();

  static GetUserVideosByPaginationUseCase? _i;

  static GetUserVideosByPaginationUseCase get i {
    return _i ??= GetUserVideosByPaginationUseCase._();
  }

  Future<Response<UserPost>> call({
    String? uid,
    int? initialSize,
    int? fetchingSize,
    Object? snapshot,
    bool singletonMode = true,
  }) {
    return repository.getByQuery(
      singletonMode: singletonMode,
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
