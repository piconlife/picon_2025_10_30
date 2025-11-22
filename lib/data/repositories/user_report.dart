import 'package:data_management/data_management.dart';
import 'package:flutter_entity/entity.dart';

import '../../roots/helpers/connectivity.dart';
import '../models/user_report.dart';
import '../sources/local/user_report.dart';
import '../sources/remote/user_report.dart';

class UserReportRepository extends RemoteDataRepository<ReportModel> {
  UserReportRepository({
    required super.source,
    super.backup,
    super.connectivity = ConnectivityHelper.connected,
  });

  static UserReportRepository? _i;

  static UserReportRepository get i =>
      _i ??= UserReportRepository(
        source: RemoteUserReportDataSource(),
        backup: LocalUserReportDataSource(),
      );

  @override
  Future<Response<ReportModel>> modifier(
    Response<ReportModel> value,
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
      case DataModifiers.count:
        // TODO: Handle this case.
        throw UnimplementedError();
      case DataModifiers.listenCount:
        // TODO: Handle this case.
        throw UnimplementedError();
    }
  }

  Future<Response<ReportModel>> _modify(Response<ReportModel> value) async {
    if (value.isValid) {
      if (value.result.length == 1) {
        return value.copyWith(data: await _value(value.data));
      } else {
        List<ReportModel> list = [];
        for (var i in value.result) {
          final data = await _value(i);
          if (data != null) list.add(data);
        }
        return value.copyWith(result: list);
      }
    } else {
      return value;
    }
  }

  Future<ReportModel?> _value(ReportModel? i) async {
    return i;
  }
}
