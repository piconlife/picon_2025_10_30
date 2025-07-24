import '../../../../roots/data/constants/paths.dart';
import '../../../../roots/data/models/user.dart';
import '../../services/firestore.dart';

class RemoteUserDataSource extends FirestoreDataSource<User> {
  RemoteUserDataSource._({super.path = RootPaths.users});

  static RemoteUserDataSource? _i;

  static RemoteUserDataSource get i {
    return _i ??= RemoteUserDataSource._();
  }

  @override
  User build(Object? source) => User.from(source);
}
