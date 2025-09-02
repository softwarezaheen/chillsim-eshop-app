import "dart:convert";

class ReferralInfoResponseModel {
  ReferralInfoResponseModel({
    num? amount,
    String? currency,
    String? type,
    String? message,
  }) {
    _amount = amount;
    _currency = currency;
    _type = type;
    _message = message;
  }

  ReferralInfoResponseModel.fromJson({dynamic json}) {
    _amount = json["amount"];
    _currency = json["currency"];
    _type = json["type"];
    _message = json["message"];
  }

  num? _amount;
  String? _currency;
  String? _type;
  String? _message;

  ReferralInfoResponseModel copyWith({
    num? amount,
    String? currency,
    String? type,
    String? message,
  }) =>
      ReferralInfoResponseModel(
        amount: amount ?? _amount,
        currency: currency ?? _currency,
        type: type ?? _type,
        message: message ?? _message,
      );

  num? get amount => _amount;

  String? get currency => _currency;

  String? get type => _type;

  String? get message => _message;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = <String, dynamic>{};
    map["amount"] = _amount;
    map["currency"] = _currency;
    map["type"] = _type;
    map["message"] = _message;
    return map;
  }

  String toJsonString() {
    return jsonEncode(toJson());
  }

  // Function to decode JSON string to ReferralInfoResponseModel
  static ReferralInfoResponseModel referralInfoFromJsonString(
      String jsonString,) {
    try {
      final Map<String, dynamic> jsonMap = jsonDecode(jsonString);
      return ReferralInfoResponseModel.fromJson(json: jsonMap);
    } catch (e) {
      throw FormatException(
          "Invalid JSON string for ReferralInfoResponseModel: $e",);
    }
  }
}
