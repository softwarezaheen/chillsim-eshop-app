import "dart:async";
import "dart:developer";

import "package:esim_open_source/app/app.locator.dart";
import "package:esim_open_source/app/environment/app_environment.dart";
import "package:esim_open_source/data/remote/responses/app/configuration_response_model.dart";
import "package:esim_open_source/domain/repository/services/app_configuration_service.dart";
import "package:esim_open_source/domain/repository/services/local_storage_service.dart";
import "package:esim_open_source/domain/use_case/app/get_configurations_use_case.dart";
import "package:esim_open_source/domain/use_case/base_use_case.dart";
import "package:esim_open_source/domain/util/resource.dart";
import "package:esim_open_source/presentation/enums/login_type.dart";
import "package:esim_open_source/presentation/enums/payment_type.dart";
import "package:esim_open_source/utils/generation_helper.dart";

class AppConfigurationServiceImpl extends AppConfigurationService {
  AppConfigurationServiceImpl._privateConstructor();

  static AppConfigurationServiceImpl? _instance;

  static AppConfigurationServiceImpl get instance {
    if (_instance == null) {
      _instance = AppConfigurationServiceImpl._privateConstructor();
      log("Initialize App Configuration Service");
      unawaited(_instance?.getAppConfigurations());
    }
    return _instance!;
  }

  Completer<void>? _appConfigCompleter;
  List<ConfigurationResponseModel>? _configData;

  @override
  Future<void> getAppConfigurations() async {
    _appConfigCompleter = Completer<void>();

    String? config = locator<LocalStorageService>().getString(
      LocalStorageKeys.appConfigurations,
    );

    if (config != null) {
      try {
        _configData = ConfigurationResponseModel.fromJsonListString(config);
      } on Object catch (e) {
        log(e.toString());
      }
    }
    // if (_configData?.isNotEmpty ?? false) {
    //   _appConfigCompleter?.complete();
    // }

    Resource<List<ConfigurationResponseModel>?> response =
        await GetConfigurationsUseCase(locator()).execute(NoParams());

    if (response.resourceType == ResourceType.success) {
      _configData = response.data;
      log(  "Fetched App Configurations: $_configData");

      locator<LocalStorageService>().setString(
        LocalStorageKeys.appConfigurations,
        ConfigurationResponseModel.toJsonListString(
          _configData ?? <ConfigurationResponseModel>[],
        ),
      );

      //set default login type from api
      String loginTypeString = getLoginType;
      if (loginTypeString.isNotEmpty) {
        LoginType? loginType = LoginType.fromValue(value: loginTypeString);
        AppEnvironment.appEnvironmentHelper.setLoginTypeFromApi = loginType;
      }

      //set default payment type from api
      String paymentTypeString = getPaymentTypes;
      log("Allowed Payment Types from API: $paymentTypeString");
      if (paymentTypeString.isNotEmpty) {
        List<PaymentType> paymentTypeList =
            PaymentType.getListFromValues(paymentTypeString);
        log("Processed Payment Types from API: $paymentTypeList");
        AppEnvironment.appEnvironmentHelper.setPaymentTypeListFromApi =
            paymentTypeList;
      }

      //set other configurations if needed
      String zenminutesUrl = getZenminutesUrl;
      if (zenminutesUrl.isNotEmpty) {
        AppEnvironment.appEnvironmentHelper.zenminutesUrl = zenminutesUrl;
      }

      if (!(_appConfigCompleter?.isCompleted ?? true)) {
        _appConfigCompleter?.complete();
      }
    }
  }

  @override
  Future<String> get getCatalogVersion async {
    await _appConfigCompleter?.future;
    return _getConfigData(
      key: ConfigurationResponseKeys.catalogBundleCashVersion,
    );
  }

  @override
  String get getDefaultCurrency {
    return _getConfigData(
      key: ConfigurationResponseKeys.defaultCurrency,
    );
  }

  @override
  Future<String> get getSupabaseAnon async {
    String temp =
        _getConfigData(key: ConfigurationResponseKeys.supabaseAnonKey);
    if (temp.isEmpty) {
      await _appConfigCompleter?.future;
      return _getConfigData(key: ConfigurationResponseKeys.supabaseAnonKey);
    }
    return temp;
  }

  @override
  Future<String> get getSupabaseUrl async {
    String temp =
        _getConfigData(key: ConfigurationResponseKeys.supabaseBaseUrl);
    if (temp.isEmpty) {
      await _appConfigCompleter?.future;
      return _getConfigData(key: ConfigurationResponseKeys.supabaseBaseUrl);
    }
    return temp;
  }

  @override
  Future<String> get getWhatsAppNumber async {
    String temp = _getConfigData(key: ConfigurationResponseKeys.whatsAppNumber);
    if (temp.isEmpty) {
      await _appConfigCompleter?.future;
      return _getConfigData(key: ConfigurationResponseKeys.whatsAppNumber);
    }
    return temp;
  }

  @override
  String get getLoginType {
    return _getConfigData(
      key: ConfigurationResponseKeys.loginType,
    );
  }

  @override
  String get getPaymentTypes {
    return _getConfigData(
      key: ConfigurationResponseKeys.paymentTypes,
    );
  }

  @override
  String get getZenminutesUrl {
    return _getConfigData(
      key: ConfigurationResponseKeys.zenminutesUrl,
    );
  }

  String _getConfigData({required ConfigurationResponseKeys key}) {
    return _configData
            ?.firstWhere(
              (ConfigurationResponseModel element) =>
                  element.key == key.configurationKeyValue,
              orElse: () => ConfigurationResponseModel(key: "", value: ""),
            )
            .value ??
        "";
  }

  @override
  String get referAndEarnAmount {
    String referralAmount = _getConfigData(
      key: ConfigurationResponseKeys.referAndEarnAmount,
    );
    String currencyCode = getSelectedCurrencyCode();
    return "$referralAmount $currencyCode";
  }

  @override
  String get referredDiscountPercentage {
    return _getConfigData(
      key: ConfigurationResponseKeys.referredDiscountPercentage,
    );
  }
}
