import 'package:data_management/core.dart';
import 'package:flutter_entity/entity.dart';

import '../../constants/keys.dart';
import '../../models/view.dart';
import 'base.dart';

class GetViewsByPaginationUseCase extends BaseViewUseCase {
  GetViewsByPaginationUseCase._();

  static GetViewsByPaginationUseCase? _i;

  static GetViewsByPaginationUseCase get i {
    return _i ??= GetViewsByPaginationUseCase._();
  }

  Future<Response<ViewModel>> call(
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
