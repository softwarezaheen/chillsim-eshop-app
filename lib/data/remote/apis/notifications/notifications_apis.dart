import "package:esim_open_source/data/remote/api_end_point.dart";
import "package:esim_open_source/data/remote/http_methods.dart";

enum NotificationsApis implements URlRequestBuilder {
  consumptionLimit;

  @override
  String get baseURL => "";

  @override
  String get path {
    switch (this) {
      case NotificationsApis.consumptionLimit:
        return "/api/v1/notifications/consumption-limit";
    }
  }

  @override
  HttpMethod get method {
    switch (this) {
      case NotificationsApis.consumptionLimit:
        return HttpMethod.POST;
    }
  }

  @override
  bool get hasAuthorization {
    switch (this) {
      case NotificationsApis.consumptionLimit:
        return true;
    }
  }

  @override
  bool get isRefreshToken => false;

  @override
  Map<String, String> get headers => const <String, String>{};
}
