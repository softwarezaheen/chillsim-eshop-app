import "dart:async";
import "dart:developer";

import "package:esim_open_source/domain/repository/services/remote_config_service.dart";
import "package:firebase_remote_config/firebase_remote_config.dart";

class RemoteConfigServiceImpl implements RemoteConfigService {
  RemoteConfigServiceImpl._privateConstructor();

  static RemoteConfigServiceImpl? _instance;

  static RemoteConfigServiceImpl get instance {
    if (_instance == null) {
      _instance = RemoteConfigServiceImpl._privateConstructor();
      log("Initialize Remote Configuration Service");
      unawaited(_instance?.initializeRemoteConfig());
    }
    return _instance!;
  }

  FirebaseRemoteConfig? remoteConfig;
  Completer<void>? _remoteConfigCompleter;

  @override
  Future<bool> get isPromoCodeFieldVisible async {
    await _remoteConfigCompleter?.future;
    await remoteConfig?.fetchAndActivate();
    return remoteConfig?.getBool(RemoteConfigKey.promoCodeEnabled.name) ??
        false;
  }

  Future<void> initializeRemoteConfig() async {
    _remoteConfigCompleter = Completer<void>();

    remoteConfig = FirebaseRemoteConfig.instance;

    // Optional: set minimum fetch interval for dev testing
    await remoteConfig?.setConfigSettings(
      RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 3),
        minimumFetchInterval: Duration.zero,
      ),
    );

    if (!(_remoteConfigCompleter?.isCompleted ?? true)) {
      _remoteConfigCompleter?.complete();
    }
  }
}
