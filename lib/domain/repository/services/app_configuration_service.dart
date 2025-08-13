abstract class AppConfigurationService {
  Future<void> getAppConfigurations();

  Future<String> get getSupabaseUrl;
  Future<String> get getSupabaseAnon;
  Future<String> get getWhatsAppNumber;
  Future<String> get getCatalogVersion;
  String get getDefaultCurrency;
  String get getPaymentTypes;
  String get getLoginType;
}
