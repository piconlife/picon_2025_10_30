import '../../base/firestore_data_source.dart';
import '../../constants/paths.dart';
import '../../models/user_report.dart';

class RemoteUserReportDataSource extends FirestoreDataSource<ReportModel> {
  RemoteUserReportDataSource() : super(Paths.userReports);

  @override
  ReportModel build(Object? source) => ReportModel.from(source);
}
