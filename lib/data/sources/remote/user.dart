import 'package:data_management/core.dart';

import '../../constants/paths.dart';
import '../../delegates/firestore.dart';
import '../../models/user.dart';

class RemoteUserDataSource extends RemoteDataSource<User> {
  RemoteUserDataSource()
    : super(delegate: FirestoreDataDelegate.i, path: Paths.users);

  @override
  User build(Object? source) => User.parse(source);
}
