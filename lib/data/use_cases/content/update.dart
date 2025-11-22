import 'package:flutter_entity/entity.dart';

import '../../models/content.dart';
import 'base.dart';

class ContentUpdateUseCase extends ContentBaseUseCase {
  ContentUpdateUseCase._();

  static ContentUpdateUseCase? _i;

  static ContentUpdateUseCase get i => _i ??= ContentUpdateUseCase._();

  Future<Response<ContentModel>> call(
    String path,
    Map<String, dynamic> data,
  ) async {
    final pair = getPair(path);
    if (pair == null) return Response(status: Status.invalid);
    return repository.updateById(pair.a, data, params: pair.b);
  }
}
