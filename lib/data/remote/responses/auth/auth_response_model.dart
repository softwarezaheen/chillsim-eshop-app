import "dart:convert";

import "package:esim_open_source/data/remote/responses/auth/user_info_response_model.dart";

class AuthResponseModel {
  AuthResponseModel({
    this.accessToken,
    this.refreshToken,
    this.userInfo,
    this.userToken,
    this.isVerified,
  });

  // Factory constructor for JSON decoding
  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    return AuthResponseModel(
      accessToken: json["access_token"],
      refreshToken: json["refresh_token"],
      userInfo: json["user_info"] != null
          ? UserInfoResponseModel.fromJson(json["user_info"])
          : null,
      userToken: json["user_token"],
      isVerified: json["is_verified"],
    );
  }

  // Factory constructor for JSON decoding
  factory AuthResponseModel.fromAPIJson({dynamic json}) {
    return AuthResponseModel(
      accessToken: json["access_token"],
      refreshToken: json["refresh_token"],
      userInfo: json["user_info"] != null
          ? UserInfoResponseModel.fromJson(json["user_info"])
          : null,
      userToken: json["user_token"],
      isVerified: json["is_verified"],
    );
  }

  final String? accessToken;
  final String? refreshToken;
  final UserInfoResponseModel? userInfo;
  final String? userToken;
  final bool? isVerified;

  // Method for JSON encoding
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      "access_token": accessToken,
      "refresh_token": refreshToken,
      "user_info": userInfo?.toJson(),
      "user_token": userToken,
      "is_verified": isVerified,
    };
  }

  AuthResponseModel copyWith({
    String? accessToken,
    String? refreshToken,
    UserInfoResponseModel? userInfo,
    String? userToken,
    bool? isVerified,
  }) {
    return AuthResponseModel(
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
      userInfo: userInfo ?? this.userInfo,
      userToken: userToken ?? this.userToken,
      isVerified: isVerified ?? this.isVerified,
    );
  }

  // Convert JSON string to AuthModel
  static AuthResponseModel fromJsonString(String jsonString) {
    return AuthResponseModel.fromJson(jsonDecode(jsonString));
  }

  // Convert AuthModel to JSON string
  String toJsonString() {
    return jsonEncode(toJson());
  }
}
