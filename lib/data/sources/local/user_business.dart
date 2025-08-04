import '../../constants/paths.dart';
import '../../delegates/local.dart';
import '../../models/user_business.dart';

class LocalUserBusinessDataSource extends InAppDataSource<UserBusiness> {
  const LocalUserBusinessDataSource({
    super.path = Paths.userBusiness,
    required super.database,
  });

  @override
  UserBusiness build(Object? source) => UserBusiness.from(source);
}
