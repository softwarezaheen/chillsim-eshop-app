import "package:esim_open_source/data/remote/responses/device/device_info_details_response_model.dart";

class DeviceInfoResponseModel {
  DeviceInfoResponseModel({this.device});

  factory DeviceInfoResponseModel.fromJson({dynamic json}) {
    return DeviceInfoResponseModel(
      device: json["device"] != null
          ? DeviceInfoDetailsResponseModel.fromJson(json["device"])
          : null,
    );
  }

  DeviceInfoDetailsResponseModel? device;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      "device": device?.toJson(),
    };
  }
}
