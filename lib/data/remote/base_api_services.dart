import "package:esim_open_source/app/environment/app_environment.dart";

class BaseApiService {
  static String get baseURL {
    return AppEnvironment.appEnvironmentHelper.baseApiUrl;
  }
}
