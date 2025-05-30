import "dart:io";

class DeviceInfoRequestModel {
  DeviceInfoRequestModel({
    required this.deviceName,
    this.latitude = 0,
    this.longitude = 0,
    this.mcc = "0",
    this.mnc = "0",
  });

  factory DeviceInfoRequestModel.fromJson(Map<String, dynamic> json) {
    return DeviceInfoRequestModel(
      deviceName: json["deviceName"] as String,
      latitude: (json["latitude"] as num).toDouble(),
      longitude: (json["longitude"] as num).toDouble(),
      mcc: json["mcc"] as String,
      mnc: json["mnc"] as String,
    );
  }

  String deviceName;
  double latitude;
  double longitude;
  String mcc;
  String mnc;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      "deviceName": deviceName,
      "latitude": latitude,
      "longitude": longitude,
      "mcc": mcc,
      "mnc": mnc,
    };
  }

  static String get osTag {
    if (Platform.isIOS) {
      return "IOS";
    }
    return "ANDROID";
  }

  static String get platformTag {
    if (Platform.isIOS) {
      return "MOBILE_IOS";
    }
    return "MOBILE_ANDROID";
  }
}
