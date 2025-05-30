import "dart:async";

import "package:esim_open_source/data/remote/request/device/device_info_request_model.dart";

abstract interface class ApiDeviceRepository {
  FutureOr<dynamic> registerDevice({
    required String fcmToken,
    required String deviceId,
    required String platformTag,
    required String osTag,
    required String appGuid,
    required String version,
    required String userGuid,
    required DeviceInfoRequestModel deviceInfo,
  });
}
