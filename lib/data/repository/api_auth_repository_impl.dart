import "dart:async";

import "package:esim_open_source/data/remote/auth_reload_interface.dart";
import "package:esim_open_source/data/remote/responses/auth/auth_response_model.dart";
import "package:esim_open_source/data/remote/responses/empty_response.dart";
import "package:esim_open_source/data/remote/unauthorized_access_interface.dart";
import "package:esim_open_source/domain/data/api_auth.dart";
import "package:esim_open_source/domain/repository/api_auth_repository.dart";
import "package:esim_open_source/domain/util/resource.dart";

class ApiAuthRepositoryImpl implements ApiAuthRepository {
  ApiAuthRepositoryImpl(this.apiAuth);

  final APIAuth apiAuth;

  @override
  FutureOr<Resource<EmptyResponse?>> login({
    required String? email,
    required String? phoneNumber,
  }) async {
    return responseToResource(
      apiAuth.login(email: email, phoneNumber: phoneNumber),
    );
  }

  @override
  FutureOr<Resource<EmptyResponse>> logout() async {
    return responseToResource(
      apiAuth.logout(),
    );
  }

  @override
  FutureOr<Resource<EmptyResponse?>> resendOtp({
    required String email,
  }) async {
    return responseToResource(
      apiAuth.resendOtp(email: email),
    );
  }

  @override
  FutureOr<Resource<AuthResponseModel>> verifyOtp({
    String? email,
    String? phoneNumber,
    String pinCode = "",
    String providerToken = "",
    String providerType = "",
  }) async {
    return responseToResource(
      apiAuth.verifyOtp(
        email: email,
        phoneNumber: phoneNumber,
        pinCode: pinCode,
        providerToken: providerToken,
        providerType: providerType,
      ),
    );
  }

  @override
  FutureOr<Resource<EmptyResponse>> deleteAccount() async {
    return responseToResource(
      apiAuth.deleteAccount(),
    );
  }

  @override
  FutureOr<Resource<AuthResponseModel>> updateUserInfo({
    required String? email,
    required String msisdn,
    required String firstName,
    required String lastName,
    required bool isNewsletterSubscribed,
  }) async {
    return responseToResource(
      apiAuth.updateUserInfo(
        email: email,
        msisdn: msisdn,
        firstName: firstName,
        lastName: lastName,
        isNewsletterSubscribed: isNewsletterSubscribed,
      ),
    );
  }

  @override
  FutureOr<Resource<AuthResponseModel>> getUserInfo({
    String? bearerToken,
  }) async {
    return responseToResource(apiAuth.getUserInfo(bearerToken: bearerToken));
  }

  @override
  FutureOr<Resource<AuthResponseModel>> refreshTokenAPITrigger() async {
    return responseToResource(apiAuth.refreshTokenAPITrigger());
  }

  @override
  void addUnauthorizedAccessListener(
    UnauthorizedAccessListener unauthorizedAccessCallBack,
  ) {
    apiAuth.addUnauthorizedAccessListener(unauthorizedAccessCallBack);
  }

  @override
  void removeUnauthorizedAccessListener(
    UnauthorizedAccessListener unauthorizedAccessCallBack,
  ) {
    apiAuth.removeUnauthorizedAccessListener(unauthorizedAccessCallBack);
  }

  @override
  void addAuthReloadListenerCallBack(AuthReloadListener authReloadListener) {
    apiAuth.addAuthReloadListenerCallBack(authReloadListener);
  }

  @override
  void removeAuthReloadListenerCallBack(AuthReloadListener authReloadListener) {
    apiAuth.removeAuthReloadListenerCallBack(authReloadListener);
  }

  @override
  FutureOr<Resource<AuthResponseModel?>> tmpLogin({
    required String email,
  }) async {
    return responseToResource(
      apiAuth.tmpLogin(
        email: email,
      ),
    );
  }
}
