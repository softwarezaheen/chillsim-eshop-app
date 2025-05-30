import "package:esim_open_source/utils/parsing_helper.dart";

class CurrenciesResponseModel {
  CurrenciesResponseModel({
    this.currency,
  });

  // Factory constructor for JSON decoding
  factory CurrenciesResponseModel.fromJson(Map<String, dynamic> json) {
    return CurrenciesResponseModel(
      currency: json["currency"],
    );
  }

  // Factory constructor for JSON decoding
  factory CurrenciesResponseModel.fromAPIJson({dynamic json}) {
    return CurrenciesResponseModel(
      currency: json["currency"],
    );
  }

  final String? currency;

  // Method for JSON encoding
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      "currency": currency,
    };
  }

  static List<CurrenciesResponseModel> fromJsonList({dynamic json}) {
    return fromJsonListTyped(
      parser: CurrenciesResponseModel.fromAPIJson,
      json: json,
    );
  }
}
