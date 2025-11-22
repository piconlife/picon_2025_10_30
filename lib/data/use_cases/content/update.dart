import 'package:flutter_entity/entity.dart';

import '../../models/content.dart';
import 'base.dart';

class UpdateUseCase extends ContentBaseUseCase {
  UpdateUseCase._();

  static UpdateUseCase? _i;

  static UpdateUseCase get i => _i ??= UpdateUseCase._();

  Future<Response<Content>> call({
    required String path,
    required String id,
    required Map<String, dynamic> data,
  }) {
    return repository.updateById(id, data, params: getParams(path));
  }
}
