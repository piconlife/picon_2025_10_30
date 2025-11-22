import 'package:flutter_entity/entity.dart';

import '../../models/content.dart';
import 'base.dart';

class ContentGetsUseCase extends ContentBaseUseCase {
  ContentGetsUseCase._();

  static ContentGetsUseCase? _i;

  static ContentGetsUseCase get i => _i ??= ContentGetsUseCase._();

  Future<Response<ContentModel>> call(
    String path, {
    bool singletonMode = true,
  }) {
    return repository.get(
      singletonMode: singletonMode,
      params: getParams(path),
    );
  }
}
