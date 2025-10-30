import 'package:flutter_entity/entity.dart';

import '../../models/star.dart';
import 'base.dart';

class CreateStarUseCase extends BaseFeedStarUseCase {
  CreateStarUseCase._();

  static CreateStarUseCase? _i;

  static CreateStarUseCase get i => _i ??= CreateStarUseCase._();

  Future<Response<StarModel>> call(StarModel data) async {
    if (data.parentPath == null) {
      return Response.failure("Parent path required!");
    }
    return repository.create(data, params: getParams(data.parentPath!));
  }
}
