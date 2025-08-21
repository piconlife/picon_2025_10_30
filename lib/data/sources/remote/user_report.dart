import 'package:data_management/core.dart';

import '../../constants/paths.dart';
import '../../delegates/firestore.dart';
import '../../models/user_report.dart';

class RemoteUserReportDataSource extends RemoteDataSource<UserReport> {
  RemoteUserReportDataSource()
    : super(delegate: FirestoreDataDelegate.i, path: Paths.userReports);

  @override
  UserReport build(Object? source) => UserReport.from(source);
}
