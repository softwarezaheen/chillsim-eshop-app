import "dart:async";

import "package:esim_open_source/app/app.locator.dart";
import "package:esim_open_source/data/remote/responses/auth/auth_response_model.dart";
import "package:esim_open_source/domain/repository/api_app_repository.dart";
import "package:esim_open_source/domain/repository/api_auth_repository.dart";
import "package:esim_open_source/domain/repository/api_device_repository.dart";
import "package:esim_open_source/domain/use_case/app/add_device_use_case.dart";
import "package:esim_open_source/domain/use_case/base_use_case.dart";
import "package:esim_open_source/domain/util/resource.dart";
import "package:esim_open_source/presentation/reactive_service/user_authentication_service.dart";

class UpdateUserInfoParams {
  UpdateUserInfoParams({
    required this.msisdn,
    required this.firstName,
    required this.lastName,
    required this.isNewsletterSubscribed,
  });
  final String msisdn;
  final String firstName;
  final String lastName;
  final bool isNewsletterSubscribed;
}

class UpdateUserInfoUseCase
    implements UseCase<Resource<AuthResponseModel>, UpdateUserInfoParams> {
  UpdateUserInfoUseCase(this.repository);
  final ApiAuthRepository repository;

  final UserAuthenticationService userAuthenticationService =
      locator<UserAuthenticationService>();

  final AddDeviceUseCase addDeviceUseCase = AddDeviceUseCase(
    locator<ApiAppRepository>(),
    locator<ApiDeviceRepository>(),
  );

  @override
  FutureOr<Resource<AuthResponseModel>> execute(
    UpdateUserInfoParams params,
  ) async {
    Resource<AuthResponseModel> response = await repository.updateUserInfo(
      msisdn: params.msisdn,
      firstName: params.firstName,
      lastName: params.lastName,
      isNewsletterSubscribed: params.isNewsletterSubscribed,
    );

    await userAuthenticationService.updateUserResponse(response.data);

    return response;
  }
}
