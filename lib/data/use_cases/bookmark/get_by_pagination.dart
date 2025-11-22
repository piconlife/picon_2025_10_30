import 'package:data_management/core.dart';
import 'package:flutter_entity/entity.dart';

import '../../constants/keys.dart';
import '../../models/like.dart';
import 'base.dart';

class GetLikesByPaginationUseCase extends BaseFeedLikeUseCase {
  GetLikesByPaginationUseCase._();

  static GetLikesByPaginationUseCase? _i;

  static GetLikesByPaginationUseCase get i {
    return _i ??= GetLikesByPaginationUseCase._();
  }

  Future<Response<LikeModel>> call(
    String parentPath, {
    int? initialSize,
    int? fetchingSize,
    Object? snapshot,
  }) {
    return repository.getByQuery(
      params: getParams(parentPath),
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
