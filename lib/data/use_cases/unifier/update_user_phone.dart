import 'package:flutter_entity/entity.dart';

import '../../models/unifier.dart';
import '../../parsers/error_parser.dart';
import 'phone.dart';

class UpdateUserPhoneUseCase extends BaseUserPhoneUnifierUseCase {
  UpdateUserPhoneUseCase._();

  static UpdateUserPhoneUseCase? _i;

  static UpdateUserPhoneUseCase get i => _i ??= UpdateUserPhoneUseCase._();

  Future<Response<PhoneUnifier>> call(String phone) async {
    try {
      final data = <String, dynamic>{
        UnifierKeys.i.timeMills: Entity.generateTimeMills,
        UnifierKeys.i.verified: true,
      };
      final value = await repository
          .updateById(Unifier.identifier(phone), data)
          .onError(exception)
          .catchError(exception);
      return value;
    } catch (error) {
      return Response(status: Status.failure, error: parseError(error));
    }
  }
}
