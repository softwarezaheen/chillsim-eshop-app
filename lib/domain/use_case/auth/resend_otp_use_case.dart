import "dart:async";

import "package:esim_open_source/app/environment/app_environment.dart";
import "package:esim_open_source/data/remote/responses/empty_response.dart";
import "package:esim_open_source/domain/repository/api_auth_repository.dart";
import "package:esim_open_source/domain/use_case/base_use_case.dart";
import "package:esim_open_source/domain/util/resource.dart";
import "package:esim_open_source/presentation/enums/login_type.dart";

class ResendOtpParams {
  ResendOtpParams({
    required this.username,
  });
  final String username;
}

class ResendOtpUseCase
    implements UseCase<Resource<EmptyResponse?>, ResendOtpParams> {
  ResendOtpUseCase(this.repository);
  final ApiAuthRepository repository;

  @override
  FutureOr<Resource<EmptyResponse?>> execute(ResendOtpParams params) async {
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
