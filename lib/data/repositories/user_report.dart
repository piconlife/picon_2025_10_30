import 'package:data_management/data_management.dart';
import 'package:flutter_entity/entity.dart';
import 'package:in_app_database/in_app_database.dart';

import '../../roots/helpers/connectivity.dart';
import '../models/user_report.dart';
import '../sources/local/user_report.dart';
import '../sources/remote/user_report.dart';

class UserReportRepository extends RemoteDataRepository<UserReport> {
  UserReportRepository({
    required super.source,
    super.backup,
    super.connectivity = ConnectivityHelper.connection,
  });

  static UserReportRepository? _i;

  static UserReportRepository get i => _i ??= UserReportRepository(
    source: RemoteUserReportDataSource(),
    backup: LocalUserReportDataSource(database: InAppDatabase.i),
  );

  @override
  Future<Response<UserReport>> modifier(
    Response<UserReport> value,
    DataModifiers modifier,
  ) async {
    switch (modifier) {
      case DataModifiers.get:
      case DataModifiers.getById:
      case DataModifiers.getByIds:
      case DataModifiers.getByQuery:
      case DataModifiers.listen:
      case DataModifiers.listenById:
      case DataModifiers.listenByIds:
      case DataModifiers.listenByQuery:
        return _modify(value);
      case DataModifiers.checkById:
      case DataModifiers.clear:
      case DataModifiers.create:
      case DataModifiers.creates:
      case DataModifiers.deleteById:
      case DataModifiers.deleteByIds:
      case DataModifiers.search:
      case DataModifiers.updateById:
      case DataModifiers.updateByIds:
        return value;
    }
  }

  Future<Response<UserReport>> _modify(Response<UserReport> value) async {
    if (value.isValid) {
      if (value.result.length == 1) {
        return value.copy(data: await _value(value.data));
      } else {
        List<UserReport> list = [];
        for (var i in value.result) {
          final data = await _value(i);
          if (data != null) list.add(data);
        }
        return value.copy(result: list);
      }
    } else {
      return value;
    }
  }

  Future<UserReport?> _value(UserReport? i) async {
    return i;
  }
}
