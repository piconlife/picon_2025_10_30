import 'package:flutter_entity/entity.dart';

import 'base.dart';

class GetStarsCountUseCase extends BaseFeedStarUseCase {
  GetStarsCountUseCase._();

  static GetStarsCountUseCase? _i;

  static GetStarsCountUseCase get i => _i ??= GetStarsCountUseCase._();

  Future<Response<int>> call(String parentPath) {
    return repository.count(params: getParams(parentPath));
  }
}
