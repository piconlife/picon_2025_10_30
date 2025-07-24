import 'package:data_management/core.dart';

import '../../../data/sources/local/user.dart';
import '../../helpers/connectivity.dart';
import '../models/user.dart';

class UserRepository extends LocalDataRepository<User> {
  UserRepository._({required super.source})
    : super(connectivity: ConnectivityHelper.connection);

  static UserRepository? _i;

  static UserRepository get i {
    return _i ??= UserRepository._(source: LocalUserDataSource.i);
  }
}
