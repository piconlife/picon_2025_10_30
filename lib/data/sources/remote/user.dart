import '../../base/firestore_data_source.dart';
import '../../constants/paths.dart';
import '../../models/user.dart';

class RemoteUserDataSource extends FirestoreDataSource<UserModel> {
  RemoteUserDataSource() : super(Paths.users);

  @override
  UserModel build(Object? source) => UserModel.parse(source);
}
