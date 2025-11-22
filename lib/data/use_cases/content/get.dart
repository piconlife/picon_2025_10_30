import 'package:flutter_entity/entity.dart';

import '../../models/content.dart';
import 'base.dart';

class GetsUseCase extends ContentBaseUseCase {
  GetsUseCase._();

  static GetsUseCase? _i;

  static GetsUseCase get i => _i ??= GetsUseCase._();

  Future<Response<Content>> call(String path, {bool singletonMode = true}) {
    return repository.get(
      singletonMode: singletonMode,
      params: getParams(path),
    );
  }
}
