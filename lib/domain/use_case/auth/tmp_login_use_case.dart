import "dart:async";

import "package:esim_open_source/data/remote/responses/auth/auth_response_model.dart";
import "package:esim_open_source/domain/repository/api_auth_repository.dart";
import "package:esim_open_source/domain/use_case/base_use_case.dart";
import "package:esim_open_source/domain/util/resource.dart";

class TmpLoginParams {
  TmpLoginParams({
    required this.email,
  });
  final String email;
}

class TmpLoginUseCase
    implements UseCase<Resource<AuthResponseModel?>, TmpLoginParams> {
  TmpLoginUseCase(this.repository);
  final ApiAuthRepository repository;

  @override
  FutureOr<Resource<AuthResponseModel?>> execute(TmpLoginParams params) async {
    return await repository.tmpLogin(
      email: params.email,
    );
  }
}
