import 'package:flutter_entity/entity.dart';

import '../../models/unifier.dart';
import '../../parsers/error_parser.dart';
import 'email.dart';

class CreateUserPrefixUseCase extends BaseUserPrefixUnifierUseCase {
  CreateUserPrefixUseCase._();

  static CreateUserPrefixUseCase? _i;

  static CreateUserPrefixUseCase get i => _i ??= CreateUserPrefixUseCase._();

  Future<Response<PrefixUnifier>> call(String prefix) async {
    try {
      final value = await repository
          .getById(Unifier.identifier(prefix))
          .onError(exception)
          .catchError(exception);
      if (value.status.isResultNotFound) {
        return repository
            .create(PrefixUnifier(value: prefix))
            .onError(exception)
            .catchError(exception);
      }
      return value;
    } catch (error) {
      return Response(status: Status.failure, error: parseError(error));
    }
  }
}
