import "package:esim_open_source/data/remote/auth_reload_interface.dart";
import "package:esim_open_source/domain/repository/api_auth_repository.dart";
import "package:esim_open_source/domain/use_case/base_use_case.dart";

class AddAuthReloadCallBackUseCase
    implements UseCase<void, AuthReloadAccessCallBackParams> {
  AddAuthReloadCallBackUseCase(this.repository);
  final ApiAuthRepository repository;

  @override
  void execute(AuthReloadAccessCallBackParams params) {
    return repository.addAuthReloadListenerCallBack(params.authReloadListener);
  }
}

class AuthReloadAccessCallBackParams {
  AuthReloadAccessCallBackParams(this.authReloadListener);
  final AuthReloadListener authReloadListener;
}
