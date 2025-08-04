import 'package:data_management/core.dart';

import '../../../app/helpers/user.dart';
import '../../repositories/user_business.dart';

class BaseUserBusinessUseCase {
  final UserBusinessRepository repository;

  BaseUserBusinessUseCase() : repository = UserBusinessRepository.i;

  IterableParams get params => getParams();

  IterableParams getParams([String? uid]) {
    return IterableParams([uid ?? UserHelper.uid]);
  }
}
