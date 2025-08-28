import "dart:async";

import "package:esim_open_source/data/remote/apis/api_provider.dart";
import "package:esim_open_source/data/remote/apis/auth_apis/auth_apis.dart";
import "package:esim_open_source/data/remote/auth_reload_interface.dart";
import "package:esim_open_source/data/remote/http_request.dart";
import "package:esim_open_source/data/remote/responses/auth/auth_response_model.dart";
import "package:esim_open_source/data/remote/responses/base_response_model.dart";
import "package:esim_open_source/data/remote/responses/empty_response.dart";
import "package:esim_open_source/data/remote/unauthorized_access_interface.dart";
import "package:esim_open_source/domain/data/api_auth.dart";

class APIAuthImpl extends APIService implements APIAuth {
  APIAuthImpl._privateConstructor() : super.privateConstructor();

  static APIAuthImpl? _instance;

  static APIAuthImpl get instance {
    if (_instance == null) {
      _instance = APIAuthImpl._privateConstructor();
      _instance?._initialise();
    }
    return _instance!;
  }

  void _initialise() {}

  @override
  FutureOr<ResponseMain<EmptyResponse?>> login({
    required String? email,
    required String? phoneNumber,
  }) async {
    Map<String, String> params = <String, String>{
      if (email != null) "email": email,
      if (phoneNumber != null) "phone": phoneNumber,
    };

    ResponseMain<EmptyResponse?> loginResponse = await sendRequest(
      endPoint: createAPIEndpoint(
        endPoint: AuthApis.login,
        parameters: params,
      ),
      fromJson: EmptyResponse.fromJson,
    );

    return loginResponse;
  }

  @override
  FutureOr<ResponseMain<EmptyResponse>> logout() async {
    ResponseMain<EmptyResponse> emptyResponse = await sendRequest(
      endPoint: createAPIEndpoint(
        endPoint: AuthApis.logout,
      ),
      fromJson: EmptyResponse.fromJson,
    );

    return emptyResponse;
  }

  @override
  FutureOr<ResponseMain<EmptyResponse?>> resendOtp({
    required String email,
  }) async {
    Map<String, String> params = <String, String>{
      "email": email,
    };

    ResponseMain<EmptyResponse?> resendOtpResponse = await sendRequest(
      endPoint: createAPIEndpoint(
        endPoint: AuthApis.resendOtp,
        parameters: params,
      ),
      fromJson: EmptyResponse.fromJson,
    );

    return resendOtpResponse;
  }

  @override
  FutureOr<ResponseMain<AuthResponseModel>> verifyOtp({
    String? email,
    String? phoneNumber,
    String pinCode = "",
    String providerToken = "",
    String providerType = "",
  }) async {
    Map<String, dynamic> params = <String, dynamic>{
      if (email != null) "user_email": email,
      if (phoneNumber != null) "phone": phoneNumber,
      "verification_pin": pinCode,
      "provider_token": providerToken,
      "provider_type": providerType,
    };

    ResponseMain<AuthResponseModel> authResponse = await sendRequest(
      endPoint: createAPIEndpoint(
        endPoint: AuthApis.verifyOtp,
        parameters: params,
      ),
      fromJson: AuthResponseModel.fromAPIJson,
    );

    return authResponse;
  }

  @override
  FutureOr<ResponseMain<EmptyResponse>> deleteAccount() async {
    ResponseMain<EmptyResponse> emptyResponse = await sendRequest(
      endPoint: createAPIEndpoint(
        endPoint: AuthApis.deleteAccount,
      ),
      fromJson: EmptyResponse.fromJson,
    );

    return emptyResponse;
  }

  @override
  FutureOr<ResponseMain<AuthResponseModel>> updateUserInfo({
    required String? email,
    required String msisdn,
    required String firstName,
    required String lastName,
    required bool isNewsletterSubscribed,
  }) async {
    Map<String, dynamic> params = <String, dynamic>{
      if (email != null) "email": email,
      "msisdn": msisdn,
      "first_name": firstName,
      "last_name": lastName,
      "should_notify": isNewsletterSubscribed,
    };

    ResponseMain<AuthResponseModel> authResponse = await sendRequest(
      endPoint: createAPIEndpoint(
        parameters: params,
        endPoint: AuthApis.updateUserInfo,
      ),
      fromJson: AuthResponseModel.fromAPIJson,
    );

    return authResponse;
  }

  @override
  FutureOr<ResponseMain<AuthResponseModel>> getUserInfo({
    String? bearerToken,
  }) async {
    Map<String, String> headers = <String, String>{
      "Authorization": "Bearer $bearerToken",
    };

    ResponseMain<AuthResponseModel> response = await sendRequest(
      endPoint: createAPIEndpoint(
        endPoint: AuthApis.userInfo,
        additionalHeaders:
            (bearerToken?.isNotEmpty ?? false) ? headers : <String, String>{},
      ),
      fromJson: AuthResponseModel.fromAPIJson,
    );

    return response;
  }

  @override
  FutureOr<dynamic> refreshTokenAPITrigger() async {
    return refreshTokenAPI();
  }

  @override
  void addUnauthorizedAccessListener(
    UnauthorizedAccessListener unauthorizedAccessCallBack,
  ) {
    HttpRequest.addUnauthorizedAccessCallBackListener(
      unauthorizedAccessCallBack,
    );
  }

  @override
  void removeUnauthorizedAccessListener(
    UnauthorizedAccessListener unauthorizedAccessCallBack,
  ) {
    HttpRequest.removeUnauthorizedAccessCallBackListener(
      unauthorizedAccessCallBack,
    );
  }

  @override
  void addAuthReloadListenerCallBack(
    AuthReloadListener authReloadListener,
  ) {
    HttpRequest.addAuthReloadListenerCallBack(
      authReloadListener,
    );
  }

  @override
  void removeAuthReloadListenerCallBack(
    AuthReloadListener authReloadListener,
  ) {
    HttpRequest.removeAuthReloadListenerCallBack(
      authReloadListener,
    );
  }

  @override
  FutureOr<ResponseMain<AuthResponseModel?>> tmpLogin({
    required String email,
  }) async {
    Map<String, String> params = <String, String>{
      "email": email,
    };

    ResponseMain<AuthResponseModel?> tmpLoginResponse = await sendRequest(
      endPoint: createAPIEndpoint(
        endPoint: AuthApis.tmpLogin,
        parameters: params,
      ),
      fromJson: AuthResponseModel.fromAPIJson,
    );

    return tmpLoginResponse;
  }
}
