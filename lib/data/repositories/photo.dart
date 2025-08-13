import 'package:data_management/data_management.dart';
import 'package:in_app_database/in_app_database.dart';

import '../../roots/helpers/connectivity.dart';
import '../models/photo.dart';
import '../sources/local/photo.dart';
import '../sources/remote/photo.dart';

class PhotoRepository extends RemoteDataRepository<Photo> {
  PhotoRepository({
    required super.source,
    super.backup,
    super.connectivity = ConnectivityHelper.connection,
  });

  static PhotoRepository? _i;

  static PhotoRepository get i => _i ??= PhotoRepository(
    source: RemotePhotoDataSource(),
    backup: LocalPhotoDataSource(database: InAppDatabase.i),
  );
}
