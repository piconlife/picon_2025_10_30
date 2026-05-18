import '../../packages/data_management.dart' show DataConnectivityDelegate;
import '../../roots/helpers/connectivity.dart' show ConnectivityHelper;

class ConnectivityDelegate extends DataConnectivityDelegate {
  @override
  Future<bool> get isConnected => ConnectivityHelper.isConnected;

  @override
  Stream<bool> get onChanged => ConnectivityHelper.changed;
}
