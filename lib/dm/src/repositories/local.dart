import 'package:flutter_entity/entity.dart' show Entity;

import 'base.dart' show DataRepository;

class LocalDataRepository<T extends Entity> extends DataRepository<T> {
  LocalDataRepository({
    super.id,
    required super.source,
    super.backup,
    super.errorDelegate,
    super.lazyMode,
    super.backupMode,
    super.restoreMode,
    super.cacheMode,
    super.backupFlushInterval,
    super.backupFlushSize,
  }) : super.local();
}
