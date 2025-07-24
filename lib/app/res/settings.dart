import '../../roots/helpers/user.dart';
import '../../roots/services/zotlo_subscription.dart';

class InAppSettings {
  const InAppSettings._();

  static bool get authorized => UserHelper.isActiveUser;

  static bool get premium => ZotloService.i.isPremium;
}
