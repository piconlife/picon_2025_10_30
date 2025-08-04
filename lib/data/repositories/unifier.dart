import 'package:data_management/core.dart';

import '../../roots/helpers/connectivity.dart';
import '../models/unifier.dart';
import '../sources/remote/unifier.dart';

class NameUnifierRepository extends RemoteDataRepository<NameUnifier> {
  NameUnifierRepository({
    required super.source,
    super.backup,
    super.connectivity = ConnectivityHelper.connection,
  });

  static NameUnifierRepository? _i;

  static NameUnifierRepository get i =>
      _i ??= NameUnifierRepository(source: RemoteNameUnifierDataSource());
}

class PhoneUnifierRepository extends RemoteDataRepository<PhoneUnifier> {
  PhoneUnifierRepository({
    required super.source,
    super.backup,
    super.connectivity = ConnectivityHelper.connection,
  });

  static PhoneUnifierRepository? _i;

  static PhoneUnifierRepository get i =>
      _i ??= PhoneUnifierRepository(source: RemotePhoneUnifierDataSource());
}

class PrefixUnifierRepository extends RemoteDataRepository<PrefixUnifier> {
  PrefixUnifierRepository({
    required super.source,
    super.backup,
    super.connectivity = ConnectivityHelper.connection,
  });

  static PrefixUnifierRepository? _i;

  static PrefixUnifierRepository get i =>
      _i ??= PrefixUnifierRepository(source: RemotePrefixUnifierDataSource());
}
