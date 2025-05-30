import "dart:async";
import "dart:developer";

import "package:connectivity_plus/connectivity_plus.dart";
import "package:esim_open_source/domain/repository/services/connectivity_service.dart";
import "package:flutter/services.dart";

class ConnectivityServiceImpl implements ConnectivityService {
  List<ConnectivityResult> _connectionStatus = <ConnectivityResult>[
    ConnectivityResult.none,
  ];
  final Connectivity _connectivity = Connectivity();

  final List<ConnectionListener> _listeners = <ConnectionListener>[];

  static ConnectivityServiceImpl? _instance;

  StreamSubscription<List<ConnectivityResult>>? _subscription;

  Completer<void>? _completer;

  static ConnectivityServiceImpl get instance {
    if (_instance == null) {
      _instance = ConnectivityServiceImpl();
      unawaited(_instance?._initialise());
    }
    return _instance!;
  }

  @override
  Future<bool> isConnected() async {
    await _completer?.future;
    if (_connectionStatus.isEmpty) {
      return false;
    }
    if (_connectionStatus.contains(ConnectivityResult.none)) {
      return false;
    }
    return true;
  }

  Future<void> _initialise() async {
    _completer = Completer<void>();
    _subscription =
        Connectivity().onConnectivityChanged.listen(_updateConnectionStatus);
    late List<ConnectivityResult> result;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      log("Main: Could not check connectivity status: ${e.message}");
      return;
    }
    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(List<ConnectivityResult> result) async {
    log("Main:Connectivity changed: $_connectionStatus");
    _connectionStatus = result;
    if (!(_completer?.isCompleted ?? true)) {
      _completer?.complete();
    }

    bool connected = await isConnected();
    for (ConnectionListener listener in _listeners) {
      listener.onConnectivityChanged(connected: connected);
    }
  }

  //notifier pattern
  @override
  void addListener(ConnectionListener listener) {
    if (!_listeners.contains(listener)) {
      _listeners.add(listener);
    }
  }

  @override
  void removeListener(ConnectionListener listener) {
    _listeners.remove(listener);
  }

  Future<void> dispose() async {
    _subscription?.cancel(); // Clean up listener
    _subscription = null;
  }
}

abstract interface class ConnectionListener {
  void onConnectivityChanged({required bool connected});
}
