import 'package:flutter_entity/entity.dart' show Entity;

import 'base.dart' show DataRepository;

class RemoteDataRepository<T extends Entity> extends DataRepository<T> {
  RemoteDataRepository({
    super.id,
    required super.source,
    super.backup,
    super.errorDelegate,
    super.backupMode,
    super.lazyMode,
    super.restoreMode,
    super.cacheMode,
    super.queueMode,
    super.backupFlushInterval,
    super.backupFlushSize,
  }) : super.remote();
}
