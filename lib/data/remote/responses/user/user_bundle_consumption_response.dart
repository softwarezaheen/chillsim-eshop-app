import "dart:convert";

UserBundleConsumptionResponse userBundleConsumptionResponseFromJson(
  String str,
) =>
    UserBundleConsumptionResponse.fromJson(json: json.decode(str));
String userBundleConsumptionResponseToJson(
  UserBundleConsumptionResponse data,
) =>
    json.encode(data.toJson());

class UserBundleConsumptionResponse {
  UserBundleConsumptionResponse({
    num? dataAllocated,
    num? dataUsed,
    num? dataRemaining,
    String? dataAllocatedDisplay,
    String? dataUsedDisplay,
    String? dataRemainingDisplay,
    String? planStatus,
  }) {
    _dataAllocated = dataAllocated;
    _dataUsed = dataUsed;
    _dataRemaining = dataRemaining;
    _dataAllocatedDisplay = dataAllocatedDisplay;
    _dataUsedDisplay = dataUsedDisplay;
    _dataRemainingDisplay = dataRemainingDisplay;
    _planStatus = planStatus;
  }

  UserBundleConsumptionResponse.fromJson({dynamic json}) {
    _dataAllocated = json["data_allocated"];
    _dataUsed = json["data_used"];
    _dataRemaining = json["data_remaining"];
    _dataAllocatedDisplay = json["data_allocated_display"];
    _dataUsedDisplay = json["data_used_display"];
    _dataRemainingDisplay = json["data_remaining_display"];
    _planStatus = json["plan_status"];
  }
  num? _dataAllocated;
  num? _dataUsed;
  num? _dataRemaining;
  String? _dataAllocatedDisplay;
  String? _dataUsedDisplay;
  String? _dataRemainingDisplay;
  String? _planStatus;
  UserBundleConsumptionResponse copyWith({
    num? dataAllocated,
    num? dataUsed,
    num? dataRemaining,
    String? dataAllocatedDisplay,
    String? dataUsedDisplay,
    String? dataRemainingDisplay,
    String? planStatus,
  }) =>
      UserBundleConsumptionResponse(
        dataAllocated: dataAllocated ?? _dataAllocated,
        dataUsed: dataUsed ?? _dataUsed,
        dataRemaining: dataRemaining ?? _dataRemaining,
        dataAllocatedDisplay: dataAllocatedDisplay ?? _dataAllocatedDisplay,
        dataUsedDisplay: dataUsedDisplay ?? _dataUsedDisplay,
        dataRemainingDisplay: dataRemainingDisplay ?? _dataRemainingDisplay,
        planStatus: planStatus ?? _planStatus,
      );
  num? get dataAllocated => _dataAllocated;
  num? get dataUsed => _dataUsed;
  num? get dataRemaining => _dataRemaining;
  String? get dataAllocatedDisplay => _dataAllocatedDisplay;
  String? get dataUsedDisplay => _dataUsedDisplay;
  String? get dataRemainingDisplay => _dataRemainingDisplay;
  String? get planStatus => _planStatus;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = <String, dynamic>{};
    map["data_allocated"] = _dataAllocated;
    map["data_used"] = _dataUsed;
    map["data_remaining"] = _dataRemaining;
    map["data_allocated_display"] = _dataAllocatedDisplay;
    map["data_used_display"] = _dataUsedDisplay;
    map["data_remaining_display"] = _dataRemainingDisplay;
    map["plan_status"] = _planStatus;
    return map;
  }
}
