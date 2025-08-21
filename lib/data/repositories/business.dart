import 'package:data_management/data_management.dart';

import '../../roots/helpers/connectivity.dart';
import '../models/business.dart';
import '../sources/local/business.dart';
import '../sources/remote/business.dart';

class BusinessRepository extends RemoteDataRepository<Business> {
  BusinessRepository({
    required super.source,
    super.backup,
    super.connectivity = ConnectivityHelper.connection,
  });

  static BusinessRepository? _i;

  static BusinessRepository get i => _i ??= BusinessRepository(
    source: RemoteBusinessDataSource(),
    backup: LocalBusinessDataSource(),
  );
}
