import "dart:async";

import "package:esim_open_source/app/app.locator.dart";
import "package:esim_open_source/app/environment/app_environment.dart";
import "package:esim_open_source/data/remote/request/device/device_info_request_model.dart";
import "package:esim_open_source/data/remote/responses/device/device_info_response_model.dart";
import "package:esim_open_source/domain/repository/api_device_repository.dart";
import "package:esim_open_source/domain/repository/services/device_info_service.dart";
import "package:esim_open_source/domain/repository/services/secure_storage_service.dart";
import "package:esim_open_source/domain/use_case/app/add_device_use_case.dart";
import "package:esim_open_source/domain/use_case/base_use_case.dart";
import "package:esim_open_source/domain/util/resource.dart";
import "package:esim_open_source/utils/generation_helper.dart";

class RegisterDeviceParams {
  RegisterDeviceParams({required this.fcmToken, required this.userGuid});
  final String fcmToken;
  final String userGuid;
}

class RegisterDeviceUseCase
    implements
        UseCase<Resource<DeviceInfoResponseModel?>, RegisterDeviceParams> {
  RegisterDeviceUseCase(this.repository);
  final ApiDeviceRepository repository;

  @override
  FutureOr<Resource<DeviceInfoResponseModel?>> execute(
    RegisterDeviceParams params,
  ) async {
    AddDeviceParams deviceParams =
        await locator<DeviceInfoService>().addDeviceParams;
    String uniqueDeviceID = await getUniqueDeviceID(
      locator<DeviceInfoService>(),
      locator<SecureStorageService>(),
    );

    return await repository.registerDevice(
      fcmToken: params.fcmToken,
      deviceId: uniqueDeviceID,
      platformTag: DeviceInfoRequestModel.platformTag,
      osTag: DeviceInfoRequestModel.osTag,
      appGuid: AppEnvironment.appEnvironmentHelper.omniConfigAppGuid,
      version: deviceParams.appVersion,
      userGuid: params.userGuid,
      deviceInfo: DeviceInfoRequestModel(
        deviceName: deviceParams.deviceModel,
      ),
    );
  }
}
