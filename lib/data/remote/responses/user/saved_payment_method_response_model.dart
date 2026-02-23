import "package:esim_open_source/utils/parsing_helper.dart";

/// Response model for a saved payment method.
class SavedPaymentMethodResponseModel {
  SavedPaymentMethodResponseModel({
    String? id,
    String? userId,
    String? stripePaymentMethodId,
    String? type,
    Map<String, dynamic>? metadata,
    bool? isDefault,
    String? label,
    String? createdAt,
  }) {
    _id = id;
    _userId = userId;
    _stripePaymentMethodId = stripePaymentMethodId;
    _type = type;
    _metadata = metadata;
    _isDefault = isDefault;
    _label = label;
    _createdAt = createdAt;
  }

  SavedPaymentMethodResponseModel.fromJson({dynamic json}) {
    _id = json["id"];
    _userId = json["user_id"];
    _stripePaymentMethodId = json["stripe_payment_method_id"];
    _type = json["type"];
    _metadata = json["metadata"] != null
        ? Map<String, dynamic>.from(json["metadata"])
        : null;
    _isDefault = json["is_default"];
    _label = json["label"];
    _createdAt = json["created_at"];
  }

  String? _id;
  String? _userId;
  String? _stripePaymentMethodId;
  String? _type;
  Map<String, dynamic>? _metadata;
  bool? _isDefault;
  String? _label;
  String? _createdAt;

  String? get id => _id;
  String? get userId => _userId;
  String? get stripePaymentMethodId => _stripePaymentMethodId;
  String? get type => _type;
  Map<String, dynamic>? get metadata => _metadata;
  bool? get isDefault => _isDefault;
  String? get label => _label;
  String? get createdAt => _createdAt;

  /// Convenience getters for common metadata fields
  String? get brand => _metadata?["brand"];
  String? get last4 => _metadata?["last4"];
  int? get expMonth => _metadata?["exp_month"];
  int? get expYear => _metadata?["exp_year"];
  String? get email => _metadata?["email"];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = <String, dynamic>{};
    map["id"] = _id;
    map["user_id"] = _userId;
    map["stripe_payment_method_id"] = _stripePaymentMethodId;
    map["type"] = _type;
    map["metadata"] = _metadata;
    map["is_default"] = _isDefault;
    map["label"] = _label;
    map["created_at"] = _createdAt;
    return map;
  }

  static List<SavedPaymentMethodResponseModel> fromJsonList({dynamic json}) {
    return fromJsonListTyped(
      parser: SavedPaymentMethodResponseModel.fromJson,
      json: json,
    );
  }
}
