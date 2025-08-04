import 'package:data_management/core.dart';
import 'package:flutter_entity/entity.dart';

import '../../constants/keys.dart';
import '../../models/user_business.dart';
import 'base.dart';

class GetUserBusinessesByPaginationUseCase extends BaseUserBusinessUseCase {
  GetUserBusinessesByPaginationUseCase._();

  static GetUserBusinessesByPaginationUseCase? _i;

  static GetUserBusinessesByPaginationUseCase get i {
    return _i ??= GetUserBusinessesByPaginationUseCase._();
  }

  Future<Response<UserBusiness>> call({
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
