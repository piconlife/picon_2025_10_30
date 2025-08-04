import 'package:data_management/core.dart';

import '../../../app/helpers/user.dart';
import '../../repositories/business_ad.dart';

class BaseBusinessAdUseCase {
  final BusinessAdRepository repository;

  BaseBusinessAdUseCase() : repository = BusinessAdRepository.i;

  IterableParams get params => getParams();

  IterableParams getParams([String? uid]) {
    return IterableParams([uid ?? UserHelper.uid]);
  }
}
