import "dart:async";

import "package:esim_open_source/app/environment/app_environment.dart";
import "package:esim_open_source/data/remote/responses/empty_response.dart";
import "package:esim_open_source/domain/repository/api_auth_repository.dart";
import "package:esim_open_source/domain/use_case/base_use_case.dart";
import "package:esim_open_source/domain/util/resource.dart";
import "package:esim_open_source/presentation/enums/login_type.dart";

class LoginParams {
  LoginParams({
    required this.username,
  });
  final String username;
}

class LoginUseCase implements UseCase<Resource<EmptyResponse?>, LoginParams> {
  LoginUseCase(this.repository);
  final ApiAuthRepository repository;

  @override
  FutureOr<Resource<EmptyResponse?>> execute(LoginParams params) async {
    return await repository.login(
      email:
          AppEnvironment.appEnvironmentHelper.loginType == LoginType.phoneNumber
              ? null
              : params.username,
      phoneNumber:
          AppEnvironment.appEnvironmentHelper.loginType == LoginType.phoneNumber
              ? params.username
              : null,
    );
  }
}
