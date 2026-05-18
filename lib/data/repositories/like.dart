import '../../packages/data_management.dart' show RemoteDataRepository;
import '../models/like.dart' show LikeModel;
import '../sources/local/like.dart' show LocalLikeDataSource;
import '../sources/remote/like.dart' show RemoteLikeDataSource;

class LikeRepository extends RemoteDataRepository<LikeModel> {
  LikeRepository({required super.source, super.backup});

  static LikeRepository? _i;

  static LikeRepository get i =>
      _i ??= LikeRepository(
        source: RemoteLikeDataSource(),
        backup: LocalLikeDataSource(),
      );
}
