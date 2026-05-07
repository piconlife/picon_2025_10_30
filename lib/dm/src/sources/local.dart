import 'package:flutter_entity/entity.dart' show Entity;

import 'base.dart' show DataSource;

abstract class LocalDataSource<T extends Entity> extends DataSource<T> {
  const LocalDataSource({
    required super.path,
    required super.delegate,
    super.encryptor,
    super.limitations,
  });
}
