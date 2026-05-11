import '../../app/imports/data_management.dart' show RemoteDataRepository;
import '../models/view.dart';
import '../sources/local/view.dart';
import '../sources/remote/view.dart';

class ViewRepository extends RemoteDataRepository<ViewModel> {
  ViewRepository({required super.source, super.backup});

  static ViewRepository? _i;

  static ViewRepository get i =>
      _i ??= ViewRepository(
        source: RemoteViewDataSource(),
        backup: LocalViewDataSource(),
      );
}
