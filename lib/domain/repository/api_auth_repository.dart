import "dart:async";

import "package:esim_open_source/data/remote/auth_reload_interface.dart";
import "package:esim_open_source/data/remote/responses/auth/auth_response_model.dart";
import "package:esim_open_source/data/remote/unauthorized_access_interface.dart";
import "package:esim_open_source/domain/util/resource.dart";

abstract interface class ApiAuthRepository {
  FutureOr<dynamic> login({
    required String email,
  });

  FutureOr<dynamic> logout();

  FutureOr<dynamic> resendOtp({
    required String email,
  });

  FutureOr<dynamic> verifyOtp({
    String email = "",
    String pinCode = "",
    String providerToken = "",
    String providerType = "",
  });

  FutureOr<dynamic> deleteAccount();

  FutureOr<dynamic> updateUserInfo({
    required String msisdn,
    required String firstName,
    required String lastName,
    required bool isNewsletterSubscribed,
  });

  FutureOr<dynamic> getUserInfo({
    String? bearerToken,
  });

  FutureOr<Resource<AuthResponseModel>> refreshTokenAPITrigger();

  void addUnauthorizedAccessListener(
    UnauthorizedAccessListener unauthorizedAccessCallBack,
  );

  void removeUnauthorizedAccessListener(
    UnauthorizedAccessListener unauthorizedAccessCallBack,
  );

  void addAuthReloadListenerCallBack(
    AuthReloadListener authReloadListener,
  );

  void removeAuthReloadListenerCallBack(
    AuthReloadListener authReloadListener,
  );

  FutureOr<dynamic> tmpLogin({
    required String email,
  });
}
