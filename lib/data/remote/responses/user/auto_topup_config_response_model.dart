import "package:esim_open_source/utils/parsing_helper.dart";

/// Response model for a single auto top-up configuration.
class AutoTopupConfigResponseModel {
  AutoTopupConfigResponseModel({
    String? id,
    String? userId,
    String? userProfileId,
    String? iccid,
    bool? enabled,
    String? bundleId,
    String? paymentMethodId,
    String? paymentMethodType,
    Map<String, dynamic>? paymentMethodMetadata,
    int? maxAmountCents,
    String? currency,
    String? disabledReason,
    int? monthlyCap,
    Map<String, dynamic>? bundleData,
    String? createdAt,
    String? updatedAt,
  }) {
    _id = id;
    _userId = userId;
    _userProfileId = userProfileId;
    _iccid = iccid;
    _enabled = enabled;
    _bundleId = bundleId;
    _paymentMethodId = paymentMethodId;
    _paymentMethodType = paymentMethodType;
    _paymentMethodMetadata = paymentMethodMetadata;
    _maxAmountCents = maxAmountCents;
    _currency = currency;
    _disabledReason = disabledReason;
    _monthlyCap = monthlyCap;
    _bundleData = bundleData;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
  }

  AutoTopupConfigResponseModel.fromJson({dynamic json}) {
    _id = json["id"];
    _userId = json["user_id"];
    _userProfileId = json["user_profile_id"];
    _iccid = json["iccid"];    _enabled = json["enabled"];
    _bundleId = json["bundle_id"];
    _paymentMethodId = json["payment_method_id"];
    _paymentMethodType = json["payment_method_type"];
    _paymentMethodMetadata = json["payment_method_metadata"] != null
        ? Map<String, dynamic>.from(json["payment_method_metadata"])
        : null;
    _maxAmountCents = json["max_amount_cents"];
    _currency = json["currency"];
    _disabledReason = json["disabled_reason"];
    _monthlyCap = json["monthly_cap"];
    _bundleData = json["bundle_data"] != null
        ? Map<String, dynamic>.from(json["bundle_data"])
        : null;
    _createdAt = json["created_at"];
    _updatedAt = json["updated_at"];
  }

  String? _id;
  String? _userId;
  String? _userProfileId;
  String? _iccid;
  bool? _enabled;
  String? _bundleId;
  String? _paymentMethodId;
  String? _paymentMethodType;
  Map<String, dynamic>? _paymentMethodMetadata;
  int? _maxAmountCents;
  String? _currency;
  String? _disabledReason;
  int? _monthlyCap;
  Map<String, dynamic>? _bundleData;
  String? _createdAt;
  String? _updatedAt;

  String? get id => _id;
  String? get userId => _userId;
  String? get userProfileId => _userProfileId;
  String? get iccid => _iccid;
  bool? get enabled => _enabled;
  String? get bundleId => _bundleId;
  String? get paymentMethodId => _paymentMethodId;
  String? get paymentMethodType => _paymentMethodType;
  Map<String, dynamic>? get paymentMethodMetadata => _paymentMethodMetadata;
  int? get maxAmountCents => _maxAmountCents;
  String? get currency => _currency;
  String? get disabledReason => _disabledReason;
  int? get monthlyCap => _monthlyCap;
  Map<String, dynamic>? get bundleData => _bundleData;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;

  /// Convenience getter to extract bundle name from bundle_data
  String? get bundleName => _bundleData?["name"] ?? _bundleData?["bundle_name"];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = <String, dynamic>{};    map["id"] = _id;
    map["user_id"] = _userId;
    map["user_profile_id"] = _userProfileId;
    map["iccid"] = _iccid;
    map["enabled"] = _enabled;
    map["bundle_id"] = _bundleId;
    map["payment_method_id"] = _paymentMethodId;
    map["payment_method_type"] = _paymentMethodType;
    map["payment_method_metadata"] = _paymentMethodMetadata;
    map["max_amount_cents"] = _maxAmountCents;
    map["currency"] = _currency;
    map["disabled_reason"] = _disabledReason;
    map["monthly_cap"] = _monthlyCap;
    map["bundle_data"] = _bundleData;
    map["created_at"] = _createdAt;
    map["updated_at"] = _updatedAt;
    return map;
  }

  static List<AutoTopupConfigResponseModel> fromJsonList({dynamic json}) {
    return fromJsonListTyped(
      parser: AutoTopupConfigResponseModel.fromJson,
      json: json,
    );
  }
}
