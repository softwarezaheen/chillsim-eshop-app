import "package:esim_open_source/utils/parsing_helper.dart";

enum ApiResponseResultEnum { success, failure }

class BaseAPIResponse<T> {
  BaseAPIResponse.success(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJsonT,
  ) {
    message = json["message"] ?? "";
    code = json["code"] ?? "";
    success = json["success"] ?? false;
    version = json["version"] ?? "";
    data = json["data"] == null
        ? null
        : json["data"] is List
            ? List<T>.from(json["data"].map((dynamic e) => fromJsonT(e)))
            : fromJsonT(json["data"]);
    result = ApiResponseResultEnum.success;
  }

  BaseAPIResponse.failure(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJsonT,
  ) {
    message = json["message"] ?? "";
    code = json["code"] ?? "";
    success = json["success"] ?? false;
    version = json["version"] ?? "";
    data = json["data"] == null
        ? null
        : json["data"] is List
            ? List<T>.from(json["data"].map((dynamic e) => fromJsonT(e)))
            : fromJsonT(json["data"]);
    result = ApiResponseResultEnum.failure;
  }

  BaseAPIResponse.dynamicError({
    required String this.message,
    String responseCode = "",
  }) {
    code = responseCode;
    success = false;
    version = "1";
    data = null;
    result = ApiResponseResultEnum.failure;
  }
  String? message;
  String? code;
  bool? success;
  dynamic data;
  String? version;
  late ApiResponseResultEnum result;
}

class FactModel {
  FactModel(this.fact, this.length);

  FactModel.fromJson(Map<String, dynamic> json) {
    fact = json["fact"] ?? "";
    length = json["length"] ?? 0;
  }

  FactModel.fromJsonDynamic({dynamic json}) {
    fact = json["fact"] ?? "";
    length = json["length"] ?? 0;
  }
  String? fact;
  int? length;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{"fact": fact, "length": length};
  }

  static final FactModel mockData = FactModel("this is a fact", 0);
}

class RefreshTokenModel {
  RefreshTokenModel(this.token, this.refreshToken);

  RefreshTokenModel.fromJson(Map<String, dynamic> json) {
    token = json["token"] ?? "";
    refreshToken = json["refreshToken"] ?? 0;
  }
  String? token;
  String? refreshToken;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{"token": token, "refreshToken": refreshToken};
  }
}

class CoinModel {
  CoinModel(this.coinID, this.coinName, this.coinSymbol);

  CoinModel.fromJson(Map<String, dynamic> json) {
    coinID = json["id"] ?? "";
    coinName = json["name"] ?? "";
    coinSymbol = json["symbol"] ?? "";
  }

  CoinModel.fromJsonDynamic({dynamic json}) {
    coinID = json["id"] ?? "";
    coinName = json["name"] ?? "";
    coinSymbol = json["symbol"] ?? "";
  }
  String? coinID;
  String? coinName;
  String? coinSymbol;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      "id": coinID,
      "name": coinName,
      "symbol": coinSymbol,
    };
  }

  static List<CoinModel> fromJsonList({dynamic json}) {
    return fromJsonListTypedNamed(
      parser: CoinModel.fromJsonDynamic,
      json: json,
    );
  }

  static List<CoinModel> skeleton = <CoinModel>[
    CoinModel("1", "coinName", "coinSymbol"),
    CoinModel("2", "coinName", "coinSymbol"),
  ];
}
