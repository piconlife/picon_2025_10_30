import 'package:flutter_entity/entity.dart';

import '../../models/unifier.dart';
import '../../parsers/error_parser.dart';
import 'username.dart';

class UpdateUserNameUseCase extends BaseUserNameUnifierUseCase {
  UpdateUserNameUseCase._();

  static UpdateUserNameUseCase? _i;

  static UpdateUserNameUseCase get i => _i ??= UpdateUserNameUseCase._();

  Future<Response<NameUnifier>> call(String username) async {
    try {
      final data = <String, dynamic>{
        UnifierKeys.i.timeMills: Entity.generateTimeMills,
        UnifierKeys.i.verified: true,
      };
      final value = await repository
          .updateById(Unifier.identifier(username), data)
          .onError(exception)
          .catchError(exception);
      return value;
    } catch (error) {
      return Response(status: Status.failure, error: parseError(error));
    }
  }
}
