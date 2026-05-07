import '../../app/imports/data_management.dart' show RemoteDataRepository;
import '../../roots/helpers/connectivity.dart';
import '../models/star.dart';
import '../sources/local/star.dart';
import '../sources/remote/star.dart';

class StarRepository extends RemoteDataRepository<StarModel> {
  StarRepository({
    required super.source,
    super.backup,
    super.connectivity = ConnectivityHelper.connected,
  });

  static StarRepository? _i;

  static StarRepository get i =>
      _i ??= StarRepository(
        source: RemoteStarDataSource(),
        backup: LocalStarDataSource(),
      );
}
