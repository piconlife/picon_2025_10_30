abstract class ConnectivityDelegate {
  Future<bool> get isConnected;

  Stream<bool> get onChanged;
}
