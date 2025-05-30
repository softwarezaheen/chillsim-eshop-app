import "package:esim_open_source/data/remote/responses/bundles/bundle_response_model.dart";

class TransactionHistoryResponseModel {
  TransactionHistoryResponseModel({
    this.userOrderId,
    this.iccid,
    this.bundleType,
    this.planStarted,
    this.bundleExpired,
    this.createdAt,
    this.bundle,
  });

  factory TransactionHistoryResponseModel.fromJson(Map<String, dynamic> json) {
    return TransactionHistoryResponseModel(
      userOrderId: json["user_order_id"],
      iccid: json["iccid"],
      bundleType: json["bundle_type"],
      planStarted: json["plan_started"],
      bundleExpired: json["bundle_expired"],
      createdAt: json["created_at"],
      bundle: json["bundle"] != null
          ? BundleResponseModel.fromJson(json: json["bundle"])
          : null,
    );
  }

  String? userOrderId;
  String? iccid;
  String? bundleType;
  bool? planStarted;
  bool? bundleExpired;
  String? createdAt;
  BundleResponseModel? bundle;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      "user_order_id": userOrderId,
      "iccid": iccid,
      "bundle_type": bundleType,
      "plan_started": planStarted,
      "bundle_expired": bundleExpired,
      "created_at": createdAt,
      "bundle": bundle?.toJson(),
    };
  }
}
