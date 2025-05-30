import "dart:convert";

/// consumption : 0
/// unit : "string"
/// display_consumption : "string"

BundleConsumptionResponse bundleConsumptionResponseFromJson(String str) =>
    BundleConsumptionResponse.fromJson(json: json.decode(str));
String bundleConsumptionResponseToJson(BundleConsumptionResponse data) =>
    json.encode(data.toJson());

class BundleConsumptionResponse {
  BundleConsumptionResponse({
    num? consumption,
    String? unit,
    String? displayConsumption,
  }) {
    _consumption = consumption;
    _unit = unit;
    _displayConsumption = displayConsumption;
  }

  BundleConsumptionResponse.fromJson({dynamic json}) {
    _consumption = json["consumption"];
    _unit = json["unit"];
    _displayConsumption = json["display_consumption"];
  }
  num? _consumption;
  String? _unit;
  String? _displayConsumption;
  BundleConsumptionResponse copyWith({
    num? consumption,
    String? unit,
    String? displayConsumption,
  }) =>
      BundleConsumptionResponse(
        consumption: consumption ?? _consumption,
        unit: unit ?? _unit,
        displayConsumption: displayConsumption ?? _displayConsumption,
      );
  num? get consumption => _consumption;
  String? get unit => _unit;
  String? get displayConsumption => _displayConsumption;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = <String, dynamic>{};
    map["consumption"] = _consumption;
    map["unit"] = _unit;
    map["display_consumption"] = _displayConsumption;
    return map;
  }
}
