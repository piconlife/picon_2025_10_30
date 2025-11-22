import '../../base/in_app_data_source.dart';
import '../../constants/paths.dart';
import '../../models/user.dart';

class LocalUserDataSource extends InAppDataSource<UserModel> {
  LocalUserDataSource() : super(Paths.users);

  @override
  UserModel build(Object? source) => UserModel.parse(source);
}
