import "package:esim_open_source/data/services/connectivity_service_impl.dart";

abstract interface class ConnectivityService {
  void addListener(ConnectionListener listener);

  void removeListener(ConnectionListener listener);

  Future<bool> isConnected();
}
