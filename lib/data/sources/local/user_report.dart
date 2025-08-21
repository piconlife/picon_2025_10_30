import 'package:data_management/core.dart';

import '../../constants/paths.dart';
import '../../delegates/local.dart';
import '../../models/user_report.dart';

class LocalUserReportDataSource extends LocalDataSource<UserReport> {
  LocalUserReportDataSource()
    : super(delegate: LocalDataDelegate.i, path: Paths.userReports);

  @override
  UserReport build(Object? source) => UserReport.from(source);
}
