import "package:esim_open_source/data/remote/api_end_point.dart";
import "package:esim_open_source/data/remote/http_methods.dart";

enum BundlesApis implements URlRequestBuilder {
  getAllData,
  getBundle,
  getBundles,
  getBundlesByRegion,
  getBundleConsumption,
  getBundlesByCountries;

  @override
  String get baseURL => "";

  @override
  String get path {
    switch (this) {
      case BundlesApis.getBundleConsumption:
        return "/api/v1/bundles/consumption";
      case BundlesApis.getAllData:
        return "/api/v1/home/";
      case BundlesApis.getBundle:
        return "/api/v1/bundles";
      case BundlesApis.getBundles:
        return "/api/v1/bundles";
      case BundlesApis.getBundlesByRegion:
        return "/api/v1/bundles/by-region";
      case BundlesApis.getBundlesByCountries:
        return "/api/v1/bundles/by-country";
    }
  }

  @override
  HttpMethod get method {
    switch (this) {
      case BundlesApis.getBundleConsumption:
      case BundlesApis.getAllData:
      case BundlesApis.getBundle:
      case BundlesApis.getBundlesByRegion:
      case BundlesApis.getBundles:
      case BundlesApis.getBundlesByCountries:
        return HttpMethod.GET;
    }
  }

  @override
  bool get hasAuthorization => true;

  @override
  bool get isRefreshToken => false;

  @override
  Map<String, String> get headers => const <String, String>{};
}
