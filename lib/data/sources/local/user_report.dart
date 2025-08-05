import '../../constants/paths.dart';
import '../../delegates/local.dart';
import '../../models/user_report.dart';

class LocalUserReportDataSource extends InAppDataSource<UserReport> {
  const LocalUserReportDataSource({
    super.path = Paths.userReports,
    required super.database,
  });

  @override
  UserReport build(Object? source) => UserReport.from(source);
}
