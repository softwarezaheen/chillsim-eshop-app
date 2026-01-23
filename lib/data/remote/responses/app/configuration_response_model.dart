import "dart:convert";

import "package:esim_open_source/utils/parsing_helper.dart";

enum ConfigurationResponseKeys {
  catalogBundleCashVersion,
  whatsAppNumber,
  supabaseBaseUrl,
  supabaseAnonKey,
  defaultCurrency,
  paymentTypes,
  loginType,
  referAndEarnAmount,
  referredDiscountPercentage,
  cashbackOrdersThreshold,
  cashbackPercentage,
  clickIdExpiry,
  zenminutesUrl,
  taxMode,
  feeEnabled,
  priorityCountries;

  String get configurationKeyValue {
    switch (this) {
      case ConfigurationResponseKeys.catalogBundleCashVersion:
        return "CATALOG.BUNDLES_CACHE_VERSION";
      case ConfigurationResponseKeys.whatsAppNumber:
        return "WHATSAPP_NUMBER";
      case ConfigurationResponseKeys.supabaseBaseUrl:
        return "SUPABASE_BASE_URL";
      case ConfigurationResponseKeys.supabaseAnonKey:
        return "SUPABASE_BASE_ANON_KEY";
      case ConfigurationResponseKeys.defaultCurrency:
        return "default_currency";
      case ConfigurationResponseKeys.paymentTypes:
        return "allowed_payment_types";
      case ConfigurationResponseKeys.loginType:
        return "login_type";
      case ConfigurationResponseKeys.referAndEarnAmount:
        return "REFERRAL_CODE_AMOUNT";
      case ConfigurationResponseKeys.referredDiscountPercentage:
        return "REFERRED_DISCOUNT_PERCENTAGE";
      case ConfigurationResponseKeys.cashbackOrdersThreshold:
        return "CASHBACK_ORDERS_THRESHOLD";
      case ConfigurationResponseKeys.cashbackPercentage:
        return "CASHBACK_PERCENTAGE";
      case ConfigurationResponseKeys.clickIdExpiry:
        return "click_id_expiry";
      case ConfigurationResponseKeys.zenminutesUrl:
        return "zenminutes_landing";
      case ConfigurationResponseKeys.taxMode:
        return "tax_mode";
      case ConfigurationResponseKeys.feeEnabled:
        return "fee_enabled";
      case ConfigurationResponseKeys.priorityCountries:
        return "PRIORITY_COUNTRIES";
    }
  }
}

class ConfigurationResponseModel {
  ConfigurationResponseModel({
    String? key,
    String? value,
  }) {
    _key = key;
    _value = value;
  }

  ConfigurationResponseModel.fromJson({dynamic json}) {
    _key = json["key"];
    _value = json["value"];
  }

  String? _key;
  String? _value;

  ConfigurationResponseModel copyWith({
    String? key,
    String? value,
  }) =>
      ConfigurationResponseModel(
        key: key ?? _key,
        value: value ?? _value,
      );

  String? get key => _key;

  String? get value => _value;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = <String, dynamic>{};
    map["key"] = _key;
    map["value"] = _value;
    return map;
  }

  static List<ConfigurationResponseModel> fromJsonList({dynamic json}) {
    return fromJsonListTyped(
      parser: ConfigurationResponseModel.fromJson,
      json: json,
    );
  }

  static String toJsonListString(List<ConfigurationResponseModel> models) {
    final List<Map<String, dynamic>> jsonList = models
        .map((ConfigurationResponseModel model) => model.toJson())
        .toList();
    return jsonEncode(jsonList);
  }

  static List<ConfigurationResponseModel> fromJsonListString(
    String jsonString,
  ) {
    final List<dynamic> jsonList = jsonDecode(jsonString) as List<dynamic>;
    return jsonList
        .map((dynamic json) => ConfigurationResponseModel.fromJson(json: json))
        .toList();
  }
}
