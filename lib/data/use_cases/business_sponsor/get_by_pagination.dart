import 'package:data_management/core.dart';
import 'package:flutter_entity/entity.dart';

import '../../constants/keys.dart';
import '../../models/business_sponsor.dart';
import 'base.dart';

class GetBusinessSponsorsByPaginationUseCase
    extends BaseBusinessSponsorUseCase {
  GetBusinessSponsorsByPaginationUseCase._();

  static GetBusinessSponsorsByPaginationUseCase? _i;

  static GetBusinessSponsorsByPaginationUseCase get i {
    return _i ??= GetBusinessSponsorsByPaginationUseCase._();
  }

  Future<Response<BusinessSponsor>> call({
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
