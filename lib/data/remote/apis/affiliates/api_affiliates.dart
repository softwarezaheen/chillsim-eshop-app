import "package:esim_open_source/data/remote/api_end_point.dart";
import "package:esim_open_source/data/remote/http_methods.dart";

enum AffiliateApis implements URlRequestBuilder {
  trackAffiliateClick;

  @override
  String get baseURL => "";

  @override
  String get path {
    switch (this) {
      case AffiliateApis.trackAffiliateClick:
        return "/api/v1/affiliates/track";
    }
  }

  @override
  HttpMethod get method {
    switch (this) {
      case AffiliateApis.trackAffiliateClick:
        return HttpMethod.POST;
    }
  }

  @override
  bool get hasAuthorization {
    switch (this) {
      case AffiliateApis.trackAffiliateClick:
        return true;
    }
  }

  @override
  bool get isRefreshToken => false;

  @override
  Map<String, String> get headers => const <String, String>{};
}
