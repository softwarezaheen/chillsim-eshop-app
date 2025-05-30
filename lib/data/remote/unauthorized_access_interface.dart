import "package:http/http.dart";

typedef UnauthorizedAccessCallBack = void Function(BaseResponse?, Exception?);

abstract interface class UnauthorizedAccessListener {
  void onUnauthorizedAccessCallBackUseCase(
    BaseResponse? response,
    Exception? e,
  );
}
