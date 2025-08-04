import '../../constants/paths.dart';
import '../../delegates/firestore.dart';
import '../../models/user.dart';

class RemoteUserDataSource extends FirestoreDataSource<User> {
  RemoteUserDataSource({super.path = Paths.users});

  @override
  User build(Object? source) => User.from(source);
}
