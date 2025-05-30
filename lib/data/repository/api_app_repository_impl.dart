import "dart:async";

import "package:esim_open_source/data/remote/responses/app/configuration_response_model.dart";
import "package:esim_open_source/data/remote/responses/app/currencies_response_model.dart";
import "package:esim_open_source/data/remote/responses/app/dynamic_page_response.dart";
import "package:esim_open_source/data/remote/responses/app/faq_response.dart";
import "package:esim_open_source/data/remote/responses/core/string_response.dart";
import "package:esim_open_source/data/remote/responses/empty_response.dart";
import "package:esim_open_source/domain/data/api_app.dart";
import "package:esim_open_source/domain/repository/api_app_repository.dart";
import "package:esim_open_source/domain/util/resource.dart";

class ApiAppRepositoryImpl implements ApiAppRepository {
  ApiAppRepositoryImpl(this.apiApp);

  final APIApp apiApp;

  @override
  FutureOr<Resource<EmptyResponse?>> addDevice({
    required String fcmToken,
    required String manufacturer,
    required String deviceModel,
    required String deviceOs,
    required String deviceOsVersion,
    required String appVersion,
    required String ramSize,
    required String screenResolution,
    required bool isRooted,
  }) async {
    return responseToResource(
      apiApp.addDevice(
        fcmToken: fcmToken,
        manufacturer: manufacturer,
        deviceModel: deviceModel,
        deviceOs: deviceOs,
        deviceOsVersion: deviceOsVersion,
        appVersion: appVersion,
        ramSize: ramSize,
        screenResolution: screenResolution,
        isRooted: isRooted,
      ),
    );
  }

  @override
  FutureOr<Resource<List<FaqResponse>?>> getFaq() async {
    return responseToResource(
      apiApp.getFaq(),
    );
  }

  @override
  FutureOr<Resource<StringResponse?>> contactUs({
    required String email,
    required String message,
  }) async {
    return responseToResource(
      apiApp.contactUs(email: email, message: message),
    );
  }

  @override
  FutureOr<Resource<DynamicPageResponse?>> getAboutUs() async {
    return responseToResource(
      apiApp.getAboutUs(),
    );
  }

  @override
  FutureOr<Resource<DynamicPageResponse?>> getTermsConditions() async {
    return responseToResource(
      apiApp.getTermsConditions(),
    );
  }

  @override
  FutureOr<Resource<List<ConfigurationResponseModel>?>>
      getConfigurations() async {
    return responseToResource(
      apiApp.getConfigurations(),
    );
  }

  @override
  FutureOr<Resource<List<CurrenciesResponseModel>?>> getCurrencies() async {
    return responseToResource(
      apiApp.getCurrencies(),
    );
  }
}
