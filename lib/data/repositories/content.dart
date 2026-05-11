import '../../app/imports/data_management.dart' show RemoteDataRepository;
import '../models/content.dart' show ContentModel;
import '../sources/local/content.dart' show LocalContentDataSource;
import '../sources/remote/content.dart' show RemoteContentDataSource;

class ContentRepository extends RemoteDataRepository<ContentModel> {
  ContentRepository({required super.source, super.backup});

  static ContentRepository? _i;

  static ContentRepository get i =>
      _i ??= ContentRepository(
        source: RemoteContentDataSource(),
        backup: LocalContentDataSource(),
      );
}
