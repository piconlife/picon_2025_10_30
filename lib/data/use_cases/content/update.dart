import 'package:flutter_entity/entity.dart';

import '../../models/content.dart';
import 'base.dart';

class UpdateUseCase extends ContentBaseUseCase {
  UpdateUseCase._();

  static UpdateUseCase? _i;

  static UpdateUseCase get i => _i ??= UpdateUseCase._();

  Future<Response<ContentModel>> call(
    String path,
    Map<String, dynamic> data,
  ) async {
    final pair = getPair(path);
    if (pair == null) return Response(status: Status.invalid);
    return repository.updateById(pair.a, data, params: pair.b);
  }
}
