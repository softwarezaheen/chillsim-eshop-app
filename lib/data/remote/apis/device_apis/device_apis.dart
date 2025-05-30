import "package:esim_open_source/app/environment/app_environment.dart";
import "package:esim_open_source/data/remote/api_end_point.dart";
import "package:esim_open_source/data/remote/http_methods.dart";

enum DeviceApis implements URlRequestBuilder {
  registerDevice;

  @override
  String get baseURL => AppEnvironment.appEnvironmentHelper.omniConfigBaseUrl;

  @override
  String get path {
    switch (this) {
      case DeviceApis.registerDevice:
        return "/notification/api/v1/Subscriber/register";
    }
  }

  @override
  HttpMethod get method {
    switch (this) {
      case DeviceApis.registerDevice:
        return HttpMethod.POST;
    }
  }

  @override
  bool get isRefreshToken => false;

  @override
  bool get hasAuthorization => false;

  @override
  Map<String, String> get headers {
    return <String, String>{
      "LanguageCode": "en",
      "Tenant": AppEnvironment.appEnvironmentHelper.omniConfigTenant,
      "api-key": AppEnvironment.appEnvironmentHelper.omniConfigApiKey,
    };
  }
}
