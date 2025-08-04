import '../../constants/paths.dart';
import '../../delegates/firestore.dart';
import '../../models/user_business.dart';

class RemoteUserBusinessDataSource extends FirestoreDataSource<UserBusiness> {
  RemoteUserBusinessDataSource({super.path = Paths.userBusiness});

  @override
  UserBusiness build(Object? source) => UserBusiness.from(source);
}
