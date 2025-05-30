import "package:esim_open_source/data/remote/responses/base_response_model.dart";
import "package:http/http.dart";

typedef AuthReloadListenerCallBack = void Function(BaseResponse?);

abstract interface class AuthReloadListener {
  void onAuthReloadListenerCallBackUseCase(
    ResponseMain<dynamic>? response,
  );
}
