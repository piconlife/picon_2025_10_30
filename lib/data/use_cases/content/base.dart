import 'package:data_management/core.dart';

import '../../repositories/content.dart';

class ContentBaseUseCase {
  final ContentRepository repository;

  ContentBaseUseCase() : repository = ContentRepository.i;

  IterableParams getParams(String path) {
    return IterableParams([path]);
  }
}
