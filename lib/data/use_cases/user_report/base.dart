import '../../../app/helpers/user.dart';
import '../../../app/imports/data_management.dart' show IterableParams;
import '../../repositories/user_report.dart';

class BaseUserReportUseCase {
  final UserReportRepository repository;

  BaseUserReportUseCase() : repository = UserReportRepository.i;

  IterableParams get params => getParams();

  IterableParams getParams([String? uid]) {
    return IterableParams([uid ?? UserHelper.uid]);
  }
}
