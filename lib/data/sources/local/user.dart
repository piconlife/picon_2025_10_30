import '../../constants/paths.dart';
import '../../delegates/local.dart';
import '../../models/user.dart';

class LocalUserDataSource extends InAppDataSource<User> {
  const LocalUserDataSource({
    super.path = Paths.users,
    required super.database,
  });

  @override
  User build(Object? source) => User.parse(source);
}
