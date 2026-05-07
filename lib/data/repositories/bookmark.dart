import '../../app/imports/data_management.dart' show RemoteDataRepository;
import '../../roots/helpers/connectivity.dart';
import '../models/bookmark.dart';
import '../sources/local/bookmark.dart';
import '../sources/remote/bookmark.dart';

class BookmarkRepository extends RemoteDataRepository<BookmarkModel> {
  BookmarkRepository({
    required super.source,
    super.backup,
    super.connectivity = ConnectivityHelper.connected,
  });

  static BookmarkRepository? _i;

  static BookmarkRepository get i =>
      _i ??= BookmarkRepository(
        source: RemoteBookmarkDataSource(),
        backup: LocalBookmarkDataSource(),
      );
}
