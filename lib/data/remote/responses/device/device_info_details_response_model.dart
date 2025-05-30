import "package:esim_open_source/data/remote/responses/device/device_info_version_response_model.dart";

class DeviceInfoDetailsResponseModel {
  DeviceInfoDetailsResponseModel({
    this.recordGuid,
    this.deviceId,
    this.token,
    this.platformTag,
    this.osTag,
    this.appGuid,
    this.appSettings,
    this.version,
  });

  factory DeviceInfoDetailsResponseModel.fromJson(Map<String, dynamic> json) {
    return DeviceInfoDetailsResponseModel(
      recordGuid: json["recordGuid"],
      deviceId: json["deviceId"],
      token: json["token"],
      platformTag: json["platformTag"],
      osTag: json["osTag"],
      appGuid: json["appGuid"],
      appSettings: json["appSettings"],
      version: json["version"] != null
          ? DeviceInfoVersionResponseModel.fromJson(json["version"])
          : null,
    );
  }

  String? recordGuid;
  String? deviceId;
  String? token;
  String? platformTag;
  String? osTag;
  String? appGuid;
  dynamic appSettings;
  DeviceInfoVersionResponseModel? version;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      "recordGuid": recordGuid,
      "deviceId": deviceId,
      "token": token,
      "platformTag": platformTag,
      "osTag": osTag,
      "appGuid": appGuid,
      "appSettings": appSettings,
      "version": version?.toJson(),
    };
  }
}
