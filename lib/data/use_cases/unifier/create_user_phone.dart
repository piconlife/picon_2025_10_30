import 'package:flutter_entity/entity.dart';

import '../../models/unifier.dart';
import '../../parsers/error_parser.dart';
import 'phone.dart';

class CreateUserPhoneUseCase extends BaseUserPhoneUnifierUseCase {
  CreateUserPhoneUseCase._();

  static CreateUserPhoneUseCase? _i;

  static CreateUserPhoneUseCase get i => _i ??= CreateUserPhoneUseCase._();

  Future<Response<PhoneUnifier>> call(String phone) async {
    try {
      final value = await repository
          .getById(Unifier.identifier(phone))
          .onError(exception)
          .catchError(exception);
      if (value.status.isResultNotFound) {
        return repository
            .create(PhoneUnifier(value: phone))
            .onError(exception)
            .catchError(exception);
      }
      return value;
    } catch (error) {
      return Response(status: Status.failure, error: parseError(error));
    }
  }
}
