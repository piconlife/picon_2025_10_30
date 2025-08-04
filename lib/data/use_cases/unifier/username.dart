import 'package:flutter/foundation.dart';
import 'package:flutter_entity/entity.dart';

import '../../models/unifier.dart';
import '../../parsers/error_parser.dart';
import '../../repositories/unifier.dart';

class BaseUserNameUnifierUseCase {
  final NameUnifierRepository repository;

  BaseUserNameUnifierUseCase() : repository = NameUnifierRepository.i;

  @protected
  Response<NameUnifier> exception(Object? error, _) {
    return Response<NameUnifier>(
      error: parseError(error),
      status: Status.failure,
    );
  }
}
