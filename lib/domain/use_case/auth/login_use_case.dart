import "dart:async";

import "package:esim_open_source/data/remote/responses/empty_response.dart";
import "package:esim_open_source/domain/repository/api_auth_repository.dart";
import "package:esim_open_source/domain/use_case/base_use_case.dart";
import "package:esim_open_source/domain/util/resource.dart";

class LoginParams {
  LoginParams({
    required this.email,
  });
  final String email;
}

class LoginUseCase implements UseCase<Resource<EmptyResponse?>, LoginParams> {
  LoginUseCase(this.repository);
  final ApiAuthRepository repository;

  @override
  FutureOr<Resource<EmptyResponse?>> execute(LoginParams params) async {
    return await repository.login(
      email: params.email,
    );
  }
}
