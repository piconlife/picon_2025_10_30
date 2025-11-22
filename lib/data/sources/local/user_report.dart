import '../../base/in_app_data_source.dart';
import '../../constants/paths.dart';
import '../../models/user_report.dart';

class LocalUserReportDataSource extends InAppDataSource<ReportModel> {
  LocalUserReportDataSource() : super(Paths.userReports);

  @override
  ReportModel build(Object? source) => ReportModel.from(source);
}
