import "dart:async";

import "package:esim_open_source/data/remote/apis/api_provider.dart";
import "package:esim_open_source/data/remote/apis/device_apis/device_apis.dart";
import "package:esim_open_source/data/remote/request/device/device_info_request_model.dart";
import "package:esim_open_source/data/remote/responses/base_response_model.dart";
import "package:esim_open_source/data/remote/responses/device/device_info_response_model.dart";
import "package:esim_open_source/domain/data/api_device.dart";

class ApiDeviceImpl extends APIService implements APIDevice {
  ApiDeviceImpl._privateConstructor() : super.privateConstructor();

  static ApiDeviceImpl? _instance;

  static ApiDeviceImpl get instance {
    if (_instance == null) {
      _instance = ApiDeviceImpl._privateConstructor();
      _instance?._initialise();
    }
    return _instance!;
  }

  void _initialise() {}

  @override
  FutureOr<ResponseMain<DeviceInfoResponseModel?>> registerDevice({
    required String fcmToken,
    required String deviceId,
    required String platformTag,
    required String osTag,
    required String appGuid,
    required String version,
    required String userGuid,
    required DeviceInfoRequestModel deviceInfo,
  }) async {
    Map<String, dynamic> params = <String, dynamic>{
      "deviceId": deviceId,
      "fcmToken": fcmToken,
      "platformTag": platformTag,
      "osTag": osTag,
      "appGuid": appGuid,
      "Version": version,
      "deviceInfo": deviceInfo.toJson(),
    };

    if (userGuid.isNotEmpty) {
      params["userGuid"] = userGuid;
    }

    ResponseMain<DeviceInfoResponseModel?> registerDeviceResponse =
        await sendRequest(
      endPoint: createAPIEndpoint(
        endPoint: DeviceApis.registerDevice,
        parameters: params,
      ),
      fromJson: DeviceInfoResponseModel.fromJson,
    );

    return registerDeviceResponse;
  }
}
