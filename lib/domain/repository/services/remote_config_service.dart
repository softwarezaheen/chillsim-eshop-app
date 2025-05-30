enum RemoteConfigKey {
  promoCodeEnabled;
}

abstract class RemoteConfigService {
  Future<bool> get isPromoCodeFieldVisible;
}
