import "package:esim_open_source/data/remote/responses/device/device_info_action_data_response_model.dart";

class DeviceInfoVersionResponseModel {
  DeviceInfoVersionResponseModel({
    this.action,
    this.version,
    this.recordGuid,
    this.name,
    this.description,
    this.buttonAccept,
    this.buttonDenied,
    this.createdDate,
  });

  factory DeviceInfoVersionResponseModel.fromJson(Map<String, dynamic> json) {
    return DeviceInfoVersionResponseModel(
      action: json["action"] != null
          ? DeviceInfoActionDataResponseModel.fromJson(json["action"])
          : null,
      version: json["version"],
      recordGuid: json["recordGuid"],
      name: json["name"],
      description: json["description"],
      buttonAccept: json["buttonAccept"],
      buttonDenied: json["buttonDenied"],
      createdDate: json["createdDate"],
    );
  }
  DeviceInfoActionDataResponseModel? action;
  String? version;
  String? recordGuid;
  String? name;
  String? description;
  String? buttonAccept;
  String? buttonDenied;
  String? createdDate;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      "action": action?.toJson(),
      "version": version,
      "recordGuid": recordGuid,
      "name": name,
      "description": description,
      "buttonAccept": buttonAccept,
      "buttonDenied": buttonDenied,
      "createdDate": createdDate,
    };
  }
}
