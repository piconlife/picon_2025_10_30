import 'package:data_management/core.dart';
import 'package:flutter_entity/entity.dart';

import '../../constants/keys.dart';
import '../../models/user_post.dart';
import 'base.dart';

class GetUserPostsByPaginationUseCase extends BaseUserPostUseCase {
  GetUserPostsByPaginationUseCase._();

  static GetUserPostsByPaginationUseCase? _i;

  static GetUserPostsByPaginationUseCase get i {
    return _i ??= GetUserPostsByPaginationUseCase._();
  }

  Future<Response<UserPost>> call({
    String? uid,
    int? initialSize,
    int? fetchingSize,
    Object? snapshot,
    bool singletonMode = true,
  }) {
    return repository.getByQuery(
      resolveRefs: true,
      params: getParams(uid),
      singletonMode: singletonMode,
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
