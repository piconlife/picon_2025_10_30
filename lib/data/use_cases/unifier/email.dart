import 'package:flutter/foundation.dart';
import 'package:flutter_entity/entity.dart';

import '../../models/unifier.dart';
import '../../parsers/error_parser.dart';
import '../../repositories/unifier.dart';

class BaseUserPrefixUnifierUseCase {
  final PrefixUnifierRepository repository;

  BaseUserPrefixUnifierUseCase() : repository = PrefixUnifierRepository.i;

  @protected
  Response<PrefixUnifier> exception(Object? error, _) {
    return Response<PrefixUnifier>(
      error: parseError(error),
      status: Status.failure,
    );
  }
}
