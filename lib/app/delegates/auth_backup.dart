import 'package:auth_management/auth_management.dart';

import '../../../data/models/user.dart';
import '../../../data/use_cases/user/create.dart';
import '../../../data/use_cases/user/delete.dart';
import '../../../data/use_cases/user/get.dart';
import '../../../data/use_cases/user/update.dart';

class InAppAuthBackupDelegate extends BackupDelegate<User> {
  const InAppAuthBackupDelegate({
    super.key,
    required super.reader,
    required super.writer,
  });

  @override
  Future<void> onCreateUser(User data) async {
    await CreateUserUseCase.i(user: data);
  }

  @override
  Future<void> onDeleteUser(String id) async {
    await DeleteUserUseCase.i(uid: id);
  }

  @override
  Future<User?> onFetchUser(String id) async {
    final response = await GetUserUseCase.i(uid: id);
    if (!response.isValid) return null;
    return response.data;
  }

  @override
  Future<void> onUpdateUser(String id, Map<String, dynamic> data) async {
    await UpdateUserUseCase.i(uid: id, data: data);
  }

  @override
  User build(Map<String, dynamic> source) => User.from(source);
}
