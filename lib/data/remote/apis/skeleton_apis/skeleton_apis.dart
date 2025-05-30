import "package:esim_open_source/data/remote/api_end_point.dart";
import "package:esim_open_source/data/remote/http_methods.dart";

enum SkeletonApis implements URlRequestBuilder {
  fact,
  coins,
  refreshToken,
  login;

  @override
  String get baseURL {
    switch (this) {
      case SkeletonApis.fact:
      case SkeletonApis.coins:
      case SkeletonApis.refreshToken:
        return "https://api.mockfly.dev/mocks/c6baa353-20f5-4af2-8097-3298fcf526b2";
      case SkeletonApis.login:
        return "https://mm-omni-api-software-qa.montylocal.net";
    }
  }

  @override
  bool get hasAuthorization => true;

  @override
  bool get isRefreshToken {
    switch (this) {
      case SkeletonApis.refreshToken:
        return true;
      default:
        return false;
    }
  }

  @override
  HttpMethod get method {
    switch (this) {
      case SkeletonApis.fact:
        return HttpMethod.GET;
      case SkeletonApis.coins:
        return HttpMethod.GET;
      case SkeletonApis.refreshToken:
        return HttpMethod.POST;
      case SkeletonApis.login:
        return HttpMethod.POST;
    }
  }

  @override
  String get path {
    switch (this) {
      case SkeletonApis.fact:
        return "/fact";
      case SkeletonApis.coins:
        return "/api/v3/coins/markets";
      case SkeletonApis.refreshToken:
        return "/refreshToken";
      case SkeletonApis.login:
        return "/member/api/v1/auth/login-with-url";
    }
  }

  @override
  Map<String, String> get headers => const <String, String>{};
}
