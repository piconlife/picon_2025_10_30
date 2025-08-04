import 'package:data_management/core.dart';

import '../../../app/helpers/user.dart';
import '../../repositories/business_sponsor.dart';

class BaseBusinessSponsorUseCase {
  final BusinessSponsorRepository repository;

  BaseBusinessSponsorUseCase() : repository = BusinessSponsorRepository.i;

  IterableParams get params => getParams();

  IterableParams getParams([String? uid]) {
    return IterableParams([uid ?? UserHelper.uid]);
  }
}
