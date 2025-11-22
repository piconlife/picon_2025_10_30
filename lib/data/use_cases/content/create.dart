import 'package:flutter_entity/entity.dart';

import '../../models/content.dart';
import 'base.dart';

class ContentCreateUseCase extends ContentBaseUseCase {
  ContentCreateUseCase._();

  static ContentCreateUseCase? _i;

  static ContentCreateUseCase get i => _i ??= ContentCreateUseCase._();

  Future<Response<ContentModel>> call(ContentModel data) async {
    return repository.create(data, params: getParams(data.contentPath ?? ""));
  }
}
