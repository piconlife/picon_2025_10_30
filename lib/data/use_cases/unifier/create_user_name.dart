import 'package:flutter_entity/entity.dart';

import '../../models/unifier.dart';
import '../../parsers/error_parser.dart';
import 'username.dart';

class CreateUserNameUseCase extends BaseUserNameUnifierUseCase {
  CreateUserNameUseCase._();

  static CreateUserNameUseCase? _i;

  static CreateUserNameUseCase get i => _i ??= CreateUserNameUseCase._();

  Future<Response<NameUnifier>> call(String username) async {
    try {
      final value = await repository
          .getById(Unifier.identifier(username))
          .onError(exception)
          .catchError(exception);
      if (value.status.isResultNotFound) {
        return repository
            .create(NameUnifier(value: username))
            .onError(exception)
            .catchError(exception);
      }
      return value;
    } catch (error) {
      return Response(status: Status.failure, error: parseError(error));
    }
  }
}
