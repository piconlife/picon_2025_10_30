import '../../constants/paths.dart';
import '../../models/user.dart';
import '../../services/firestore.dart';

class RemoteUserDataSource extends FirestoreDataSource<User> {
  RemoteUserDataSource._({super.path = Paths.users});

  static RemoteUserDataSource? _i;

  static RemoteUserDataSource get i {
    return _i ??= RemoteUserDataSource._();
  }

  @override
  User build(Object? source) => User.from(source);
}
