import "dart:async";
import "dart:developer";

import "package:esim_open_source/app/environment/app_environment.dart";
import "package:esim_open_source/data/remote/request/device/device_info_request_model.dart";
import "package:esim_open_source/data/remote/responses/empty_response.dart";
import "package:esim_open_source/di/locator.dart";
import "package:esim_open_source/domain/repository/api_app_repository.dart";
import "package:esim_open_source/domain/repository/api_device_repository.dart";
import "package:esim_open_source/domain/repository/services/device_info_service.dart";
import "package:esim_open_source/domain/repository/services/local_storage_service.dart";
import "package:esim_open_source/domain/repository/services/secure_storage_service.dart";
import "package:esim_open_source/domain/use_case/base_use_case.dart";
import "package:esim_open_source/domain/util/resource.dart";
import "package:esim_open_source/utils/generation_helper.dart";

class AddDeviceParams {
  AddDeviceParams({
    required this.fcmToken,
    required this.manufacturer,
    required this.deviceModel,
    required this.deviceOs,
    required this.deviceOsVersion,
    required this.appVersion,
    required this.ramSize,
    required this.screenResolution,
    required this.isRooted,
  });

  String fcmToken;
  final String manufacturer;
  final String deviceModel;
  final String deviceOs;
  final String deviceOsVersion;
  String appVersion;
  final String ramSize;
  final String screenResolution;
  bool isRooted;
}

class AddDeviceUseCase implements UseCase<Resource<EmptyResponse?>, NoParams> {
  AddDeviceUseCase(
    this.repository,
    this.deviceRepository,
  );

  final ApiAppRepository repository;
  final ApiDeviceRepository deviceRepository;

  @override
  FutureOr<Resource<EmptyResponse?>> execute(NoParams params) async {
    String fcmToken =
        locator<LocalStorageService>().getString(LocalStorageKeys.fcmToken) ??
            "";
    AddDeviceParams deviceParams =
        await locator<DeviceInfoService>().addDeviceParams
          ..fcmToken = fcmToken;

    String uniqueDeviceID = await getUniqueDeviceID(
      locator<DeviceInfoService>(),
      locator<SecureStorageService>(),
    );

    try {
      unawaited(
        await deviceRepository.registerDevice(
          fcmToken: fcmToken,
          deviceId: uniqueDeviceID,
          platformTag: DeviceInfoRequestModel.platformTag,
          osTag: DeviceInfoRequestModel.osTag,
          appGuid: AppEnvironment.appEnvironmentHelper.omniConfigAppGuid,
          version: deviceParams.appVersion,
          userGuid: locator<LocalStorageService>()
                  .authResponse
                  ?.userInfo
                  ?.userToken ??
              "",
          deviceInfo: DeviceInfoRequestModel(
            deviceName: deviceParams.deviceModel,
          ),
        ),
      );
    } on Object catch (ex) {
      log(ex.toString());
    }

    return await repository.addDevice(
      fcmToken: deviceParams.fcmToken,
      manufacturer: deviceParams.manufacturer,
      deviceModel: deviceParams.deviceModel,
      deviceOs: deviceParams.deviceOs,
      deviceOsVersion: deviceParams.deviceOsVersion,
      appVersion: deviceParams.appVersion,
      ramSize: deviceParams.ramSize,
      screenResolution: deviceParams.screenResolution,
      isRooted: deviceParams.isRooted,
    );
  }
}
