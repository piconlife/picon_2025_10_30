import 'package:flutter_entity/entity.dart' show Entity;

import 'base.dart' show DataRepository;

class LocalDataRepository<T extends Entity> extends DataRepository<T> {
  const LocalDataRepository({
    super.id,
    required super.source,
    super.backup,
    super.connectivity,
    super.lazyMode,
    super.backupMode,
    super.restoreMode,
    super.singletonMode,
  }) : super.local();
}
