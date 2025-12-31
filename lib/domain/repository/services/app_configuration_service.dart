abstract class AppConfigurationService {
  Future<void> getAppConfigurations();

  Future<String> get getSupabaseUrl;
  Future<String> get getSupabaseAnon;
  Future<String> get getWhatsAppNumber;
  Future<String> get getCatalogVersion;
  String get getDefaultCurrency;
  String get getPaymentTypes;
  String get getLoginType;
  String get referAndEarnAmount;
  String get referredDiscountPercentage;
  String get cashbackOrdersThreshold;
  String get cashbackPercentage;
  String get clickIdExpiry;
  String get getZenminutesUrl;
  String get taxMode;
  bool get feeEnabled;
}
