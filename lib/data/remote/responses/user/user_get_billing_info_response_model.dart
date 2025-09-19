import "dart:convert";

UserGetBillingInfoResponseModel userGetBillingInfoResponseModelFromJson(String str) =>
    UserGetBillingInfoResponseModel.fromJson(json: json.decode(str));

String userGetBillingInfoResponseModelToJson(UserGetBillingInfoResponseModel data) =>
    json.encode(data.toJson());

class UserGetBillingInfoResponseModel {
  UserGetBillingInfoResponseModel({
    this.email,
    this.firstName,
    this.lastName,
    this.country,
    this.city,
    this.phone,
    this.state,
    this.billingAddress,
    this.companyName,
    this.vatCode,
    this.tradeRegistry,
    this.confirm,
    this.verifyBy,
  });

  factory UserGetBillingInfoResponseModel.fromJson({dynamic json}) {
    return UserGetBillingInfoResponseModel(
      email: json["email"],
      phone: json["phone"],
      firstName: json["firstName"],
      lastName: json["lastName"],
      country: json["country"],
      city: json["city"],
      state: json["state"],
      billingAddress: json["billingAddress"],
      companyName: json["companyName"],
      vatCode: json["vatCode"],
      tradeRegistry: json["tradeRegistry"],
      confirm: json["confirm"],
      verifyBy: json["verify_by"],
    );
  }

  final String? email;
  final String? phone;
  final String? firstName;
  final String? lastName;
  final String? country;
  final String? city;
  final String? state;
  final String? billingAddress;
  final String? companyName;
  final String? vatCode;
  final String? tradeRegistry;
  final bool? confirm;
  final String? verifyBy;

  Map<String, dynamic> toJson() => <String, dynamic>{
        "email": email,
        "phone": phone,
        "firstName": firstName,
        "lastName": lastName,
        "country": country,
        "city": city,
        "state": state,
        "billingAddress": billingAddress,
        "companyName": companyName,
        "vatCode": vatCode,
        "tradeRegistry": tradeRegistry,
        "confirm": confirm,
        "verify_by": verifyBy,
      };
}
