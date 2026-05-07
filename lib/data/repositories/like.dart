import '../../app/imports/data_management.dart' show RemoteDataRepository;
import '../../roots/helpers/connectivity.dart';
import '../models/like.dart';
import '../sources/local/like.dart';
import '../sources/remote/like.dart';

class LikeRepository extends RemoteDataRepository<LikeModel> {
  LikeRepository({
    required super.source,
    super.backup,
    super.connectivity = ConnectivityHelper.connected,
  });

  static LikeRepository? _i;

  static LikeRepository get i =>
      _i ??= LikeRepository(
        source: RemoteLikeDataSource(),
        backup: LocalLikeDataSource(),
      );
}
