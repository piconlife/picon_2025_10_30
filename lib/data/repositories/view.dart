import '../../app/imports/data_management.dart' show RemoteDataRepository;
import '../../roots/helpers/connectivity.dart';
import '../models/view.dart';
import '../sources/local/view.dart';
import '../sources/remote/view.dart';

class ViewRepository extends RemoteDataRepository<ViewModel> {
  ViewRepository({
    required super.source,
    super.backup,
    super.connectivity = ConnectivityHelper.connected,
  });

  static ViewRepository? _i;

  static ViewRepository get i =>
      _i ??= ViewRepository(
        source: RemoteViewDataSource(),
        backup: LocalViewDataSource(),
      );
}
