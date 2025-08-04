import 'package:data_management/core.dart';
import 'package:flutter_entity/entity.dart';

import '../../constants/keys.dart';
import '../../models/business.dart';
import 'base.dart';

class GetBusinessesByPaginationUseCase extends BaseBusinessUseCase {
  GetBusinessesByPaginationUseCase._();

  static GetBusinessesByPaginationUseCase? _i;

  static GetBusinessesByPaginationUseCase get i {
    return _i ??= GetBusinessesByPaginationUseCase._();
  }

  Future<Response<Business>> call({
    int? initialSize,
    int? fetchingSize,
    Object? snapshot,
  }) {
    return repository.getByQuery(
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
