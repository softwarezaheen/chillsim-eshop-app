import "dart:async";

abstract interface class APIApp {
  FutureOr<dynamic> addDevice({
    required String fcmToken,
    required String manufacturer,
    required String deviceModel,
    required String deviceOs,
    required String deviceOsVersion,
    required String appVersion,
    required String ramSize,
    required String screenResolution,
    required bool isRooted,
  });

  FutureOr<dynamic> getFaq();

  FutureOr<dynamic> contactUs({
    required String email,
    required String message,
  });

  FutureOr<dynamic> getAboutUs();

  FutureOr<dynamic> getTermsConditions();

  FutureOr<dynamic> getConfigurations();

  FutureOr<dynamic> getCurrencies();
}
