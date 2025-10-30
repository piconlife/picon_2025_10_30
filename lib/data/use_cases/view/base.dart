import 'package:data_management/core.dart';

import '../../repositories/view.dart';

class BaseViewUseCase {
  final ViewRepository repository;

  BaseViewUseCase() : repository = ViewRepository.i;

  IterableParams getParams(String parentPath) {
    return IterableParams([parentPath]);
  }
}
