import 'package:data_management/core.dart';
import 'package:in_app_database/in_app_database.dart';

import '../../roots/helpers/connectivity.dart';
import '../models/unifier.dart';
import '../sources/local/unifier.dart';
import '../sources/remote/unifier.dart';

class NameUnifierRepository extends RemoteDataRepository<NameUnifier> {
  NameUnifierRepository({
    required super.source,
    super.backup,
    super.connectivity = ConnectivityHelper.connection,
  });

  static NameUnifierRepository? _i;

  static NameUnifierRepository get i => _i ??= NameUnifierRepository(
    source: RemoteNameUnifierDataSource(),
    backup: LocalNameUnifierDataSource(database: InAppDatabase.i),
  );
}

class PhoneUnifierRepository extends RemoteDataRepository<PhoneUnifier> {
  PhoneUnifierRepository({
    required super.source,
    super.backup,
    super.connectivity = ConnectivityHelper.connection,
  });

  static PhoneUnifierRepository? _i;

  static PhoneUnifierRepository get i => _i ??= PhoneUnifierRepository(
    source: RemotePhoneUnifierDataSource(),
    backup: LocalPhoneUnifierDataSource(database: InAppDatabase.i),
  );
}

class PrefixUnifierRepository extends RemoteDataRepository<PrefixUnifier> {
  PrefixUnifierRepository({
    required super.source,
    super.backup,
    super.connectivity = ConnectivityHelper.connection,
  });

  static PrefixUnifierRepository? _i;

  static PrefixUnifierRepository get i => _i ??= PrefixUnifierRepository(
    source: RemotePrefixUnifierDataSource(),
    backup: LocalPrefixUnifierDataSource(database: InAppDatabase.i),
  );
}
