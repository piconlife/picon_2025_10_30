import 'package:flutter_entity/entity.dart';

import '../../../packages/data_management.dart'
    show DataSorting, DataSelection, DataFetchOptions;
import '../../constants/keys.dart';
import '../../models/star.dart';
import 'base.dart';

class GetStarsByPaginationUseCase extends BaseFeedStarUseCase {
  GetStarsByPaginationUseCase._();

  static GetStarsByPaginationUseCase? _i;

  static GetStarsByPaginationUseCase get i {
    return _i ??= GetStarsByPaginationUseCase._();
  }

  Future<Response<StarModel>> call(
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
      options: DataFetchOptions(
        initialFetchSize: initialSize,
        fetchingSize: fetchingSize,
      ),
    );
  }
}
