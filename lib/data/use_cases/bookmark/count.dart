import 'package:flutter_entity/entity.dart';

import 'base.dart';

class BookmarkCountUseCase extends BookmarkBaseUseCase {
  BookmarkCountUseCase._();

  static BookmarkCountUseCase? _i;

  static BookmarkCountUseCase get i => _i ??= BookmarkCountUseCase._();

  Future<Response<int>> call() {
    return repository.count(params: params);
  }
}
