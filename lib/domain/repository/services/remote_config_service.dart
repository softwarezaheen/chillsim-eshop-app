enum RemoteConfigKey {
  promoCodeEnabled,
  minimumVersion,
  minimumBuildNumber,
}

abstract class RemoteConfigService {
  Future<bool> get isPromoCodeFieldVisible;

  /// Returns the minimum app version name required to run (e.g. "1.2.0").
  /// An empty string means no force update is enforced via version name.
  Future<String> get minimumRequiredVersion;

  /// Returns the minimum build number required to run (e.g. 47).
  /// Returns 0 if not set — meaning no force update via build number.
  Future<int> get minimumRequiredBuildNumber;
}
