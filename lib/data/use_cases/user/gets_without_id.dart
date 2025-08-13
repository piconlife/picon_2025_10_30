import 'package:data_management/core.dart';
import 'package:flutter_entity/entity.dart';

import '../../models/user.dart';
import 'base.dart';

class GetUsersWithoutIdUseCase extends BaseUserUseCase {
  GetUsersWithoutIdUseCase._();

  static GetUsersWithoutIdUseCase? _i;

  static GetUsersWithoutIdUseCase get i => _i ??= GetUsersWithoutIdUseCase._();

  Future<Response<User>> call({
    required String uid,
    bool singletonMode = true,
  }) {
    return repository.getByQuery(
      singletonMode: singletonMode,
      queries: [DataQuery(UserKeys.i.id, isNotEqualTo: uid)],
    );
  }
}
