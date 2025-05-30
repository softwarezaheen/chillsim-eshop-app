import "dart:async";

import "package:esim_open_source/data/remote/request/device/device_info_request_model.dart";
import "package:esim_open_source/data/remote/responses/device/device_info_response_model.dart";
import "package:esim_open_source/domain/data/api_device.dart";
import "package:esim_open_source/domain/repository/api_device_repository.dart";
import "package:esim_open_source/domain/util/resource.dart";

class ApiDeviceRepositoryImpl implements ApiDeviceRepository {
  ApiDeviceRepositoryImpl(this.apiDevice);
  final APIDevice apiDevice;

  @override
  FutureOr<Resource<DeviceInfoResponseModel?>> registerDevice({
    required String fcmToken,
    required String deviceId,
    required String platformTag,
    required String osTag,
    required String appGuid,
    required String version,
    required String userGuid,
    required DeviceInfoRequestModel deviceInfo,
  }) {
    return responseToResource(
      apiDevice.registerDevice(
        fcmToken: fcmToken,
        deviceId: deviceId,
        platformTag: platformTag,
        osTag: osTag,
        appGuid: appGuid,
        version: version,
        userGuid: userGuid,
        deviceInfo: deviceInfo,
      ),
    );
  }
}
