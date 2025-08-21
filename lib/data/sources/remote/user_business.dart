import 'package:data_management/core.dart';

import '../../constants/paths.dart';
import '../../delegates/firestore.dart';
import '../../models/user_business.dart';

class RemoteUserBusinessDataSource extends RemoteDataSource<UserBusiness> {
  RemoteUserBusinessDataSource()
    : super(delegate: FirestoreDataDelegate.i, path: Paths.userBusiness);

  @override
  UserBusiness build(Object? source) => UserBusiness.from(source);
}
