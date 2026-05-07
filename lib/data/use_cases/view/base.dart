import '../../../app/imports/data_management.dart' show IterableParams;
import '../../repositories/view.dart';

class BaseViewUseCase {
  final ViewRepository repository;

  BaseViewUseCase() : repository = ViewRepository.i;

  IterableParams getParams(String parentPath) {
    return IterableParams([parentPath]);
  }
}
