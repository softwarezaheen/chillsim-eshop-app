import "package:esim_open_source/data/remote/unauthorized_access_interface.dart";
import "package:esim_open_source/domain/repository/api_auth_repository.dart";
import "package:esim_open_source/domain/use_case/base_use_case.dart";

class AddUnauthorizedAccessCallBackUseCase
    implements UseCase<void, UnauthorizedAccessCallBackParams> {
  AddUnauthorizedAccessCallBackUseCase(this.repository);
  final ApiAuthRepository repository;

  @override
  void execute(UnauthorizedAccessCallBackParams params) {
    return repository
        .addUnauthorizedAccessListener(params.unauthorizedAccessCallBack);
  }
}

class UnauthorizedAccessCallBackParams {
  UnauthorizedAccessCallBackParams(this.unauthorizedAccessCallBack);
  final UnauthorizedAccessListener unauthorizedAccessCallBack;
}
