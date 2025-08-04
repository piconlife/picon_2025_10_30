import '../../constants/paths.dart';
import '../../delegates/local.dart';
import '../../models/user_report.dart';

class LocalUserReportDataSource extends InAppDataSource<Report> {
  const LocalUserReportDataSource({
    super.path = Paths.userReports,
    required super.database,
  });

  @override
  Report build(Object? source) => Report.from(source);
}
