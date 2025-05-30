import "package:esim_open_source/data/remote/api_end_point.dart";
import "package:esim_open_source/data/remote/http_methods.dart";

enum AppApis implements URlRequestBuilder {
  addDevice,
  aboutUS,
  termsConditions,
  faq,
  contactUs,
  configurations,
  getCurrencies;

  @override
  String get baseURL => "";

  @override
  String get path {
    switch (this) {
      case AppApis.addDevice:
        return "/api/v1/app/device";
      case AppApis.faq:
        return "/api/v1/app/faq";
      case AppApis.contactUs:
        return "/api/v1/app/contact";
      case AppApis.aboutUS:
        return "/api/v1/app/about_us";
      case AppApis.termsConditions:
        return "/api/v1/app/terms-and-conditions";
      case AppApis.configurations:
        return "/api/v1/app/configurations";
      case AppApis.getCurrencies:
        return "/api/v1/app/currency";
    }
  }

  @override
  HttpMethod get method {
    switch (this) {
      case AppApis.addDevice:
        return HttpMethod.POST;
      case AppApis.contactUs:
        return HttpMethod.POST;
      case AppApis.faq:
      case AppApis.aboutUS:
      case AppApis.termsConditions:
      case AppApis.configurations:
      case AppApis.getCurrencies:
        return HttpMethod.GET;
    }
  }

  @override
  bool get hasAuthorization {
    switch (this) {
      case AppApis.addDevice:
        return true;
      case AppApis.faq:
        return true;
      case AppApis.contactUs:
        return true;
      default:
        return false;
    }
  }

  @override
  bool get isRefreshToken => false;

  @override
  Map<String, String> get headers => const <String, String>{};
}
