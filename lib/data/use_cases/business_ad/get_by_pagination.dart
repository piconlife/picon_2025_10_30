import 'package:data_management/core.dart';
import 'package:flutter_entity/entity.dart';

import '../../constants/keys.dart';
import '../../models/business_ad.dart';
import 'base.dart';

class GetBusinessAdsByPaginationUseCase extends BaseBusinessAdUseCase {
  GetBusinessAdsByPaginationUseCase._();

  static GetBusinessAdsByPaginationUseCase? _i;

  static GetBusinessAdsByPaginationUseCase get i {
    return _i ??= GetBusinessAdsByPaginationUseCase._();
  }

  Future<Response<BusinessAd>> call({
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
