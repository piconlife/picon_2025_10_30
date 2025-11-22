import 'package:data_management/data_management.dart';

import '../../roots/helpers/connectivity.dart';
import '../models/content.dart';
import '../sources/local/content.dart';
import '../sources/remote/content.dart';

class ContentRepository extends RemoteDataRepository<ContentModel> {
  ContentRepository({
    required super.source,
    super.backup,
    super.connectivity = ConnectivityHelper.connected,
  });

  static ContentRepository? _i;

  static ContentRepository get i =>
      _i ??= ContentRepository(
        source: RemoteContentDataSource(),
        backup: LocalContentDataSource(),
      );
}
