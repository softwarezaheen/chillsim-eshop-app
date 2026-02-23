import "package:esim_open_source/data/remote/responses/bundles/bundle_category_response_model.dart";
import "package:esim_open_source/data/remote/responses/bundles/country_response_model.dart";
import "package:esim_open_source/data/remote/responses/bundles/transaction_history_response_model.dart";
import "package:esim_open_source/presentation/extensions/context_extension.dart";
import "package:esim_open_source/utils/parsing_helper.dart";
import "package:flutter/material.dart";

/// is_topup_allowed : true
/// plan_started : false
/// bundle_expired : false
/// label_name : null
/// order_number : "379d20c2-8c55-4b59-ad82-6cd06398ddd0"
/// order_status : ""
/// searched_countries : [""]
/// qr_code_value : "LPA:1$comiumgmb.rsp.instant-connectivity.com$LPA:1$comiumgmb.rsp.instant-connectivity.com$42870-989F4-DF299-26526"
/// activation_code : "LPA:1$comiumgmb.rsp.instant-connectivity.com$42870-989F4-DF299-26526"
/// smdp_address : "comiumgmb.rsp.instant-connectivity.com"
/// validity_date : "2025-03-20T16:05:39.704"
/// iccid : "892200660703814876"
/// payment_date : "2025-02-25T15:19:22.97385+00:00"
/// shared_with : null
/// display_title : "Global 1GB 7Days"
/// display_subtitle : "Global 1GB 7Days"
/// bundle_code : "2ae97223-eee5-4420-80d1-4093eac9ca84"
/// bundle_category : {"type":"GLOBAL","title":"Unknown","code":"fcb21616-daf2-4159-9457-6b27f15a1985"}
/// bundle_marketing_name : "Global 1GB 7Days"
/// bundle_name : "Global 1GB 7Days"
/// count_countries : 0
/// currency_code : "USD"
/// gprs_limit_display : "1 GB"
/// price : 3
/// price_display : "3 USD"
/// unlimited : false
/// validity : 1
/// validity_display : "1 Day"
/// plan_type : "Primary Bundle"
/// activity_policy : ""
/// bundle_message : []
/// countries : []
/// icon : "https://placehold.co/600x400?bundle=None"
/// transaction_history : [{"display_title":"Global 1GB 7Days","display_subtitle":"Global 1GB 7Days","bundle_code":"2ae97223-eee5-4420-80d1-4093eac9ca84","bundle_category":{"type":"GLOBAL","title":"Unknown","code":"fcb21616-daf2-4159-9457-6b27f15a1985"},"bundle_marketing_name":"Global 1GB 7Days","bundle_name":"Global 1GB 7Days","count_countries":0,"currency_code":"USD","gprs_limit_display":"1 GB","price":3,"price_display":"3 USD","unlimited":false,"validity":1,"plan_type":"Data only","activity_policy":"The validity period starts when the eSIM connects to any supported networks.","validity_display":"1 Day","countries":[],"icon":"https://placehold.co/600x400?bundle=None"}]
enum BundleStatus { active, inactive, expired }

class PurchaseEsimBundleResponseModel {
  PurchaseEsimBundleResponseModel({
    bool? isTopupAllowed,
    bool? planStarted,
    bool? bundleExpired,
    String? labelName,
    String? orderNumber,
    String? orderStatus,
    String? qrCodeValue,
    String? activationCode,
    String? smdpAddress,
    String? validityDate,
    String? iccid,
    String? userProfileId,
    String? paymentDate,
    String? sharedWith,
    String? displayTitle,
    String? displaySubtitle,
    String? bundleCode,
    BundleCategoryResponseModel? bundleCategory,
    String? bundleMarketingName,
    String? bundleName,
    num? countCountries,
    String? currencyCode,
    String? gprsLimitDisplay,
    num? price,
    String? priceDisplay,
    bool? unlimited,
    num? validity,
    String? validityDisplay,
    String? planType,
    String? activityPolicy,
    List<String>? bundleMessage,
    List<CountryResponseModel>? countries,
    String? icon,
    List<TransactionHistoryResponseModel>? transactionHistory,
    bool? autoTopupEnabled,
    String? autoTopupBundleName,
  }) {
    _isTopupAllowed = isTopupAllowed;
    _planStarted = planStarted;
    _bundleExpired = bundleExpired;
    _labelName = labelName;
    _orderNumber = orderNumber;
    _orderStatus = orderStatus;
    _qrCodeValue = qrCodeValue;
    _activationCode = activationCode;
    _smdpAddress = smdpAddress;
    _validityDate = validityDate;
    _iccid = iccid;
    _userProfileId = userProfileId;
    _paymentDate = paymentDate;
    _sharedWith = sharedWith;
    _displayTitle = displayTitle;
    _displaySubtitle = displaySubtitle;
    _bundleCode = bundleCode;
    _bundleCategory = bundleCategory;
    _bundleMarketingName = bundleMarketingName;
    _bundleName = bundleName;
    _countCountries = countCountries;
    _currencyCode = currencyCode;
    _gprsLimitDisplay = gprsLimitDisplay;
    _price = price;
    _priceDisplay = priceDisplay;
    _unlimited = unlimited;
    _validity = validity;
    _validityDisplay = validityDisplay;
    _planType = planType;
    _activityPolicy = activityPolicy;
    _bundleMessage = bundleMessage;
    _countries = countries;
    _icon = icon;
    _transactionHistory = transactionHistory;
    _autoTopupEnabled = autoTopupEnabled;
    _autoTopupBundleName = autoTopupBundleName;
  }

  PurchaseEsimBundleResponseModel.fromJson({dynamic json}) {
    _isTopupAllowed = json["is_topup_allowed"];
    _planStarted = json["plan_started"];
    _bundleExpired = json["bundle_expired"];
    _labelName = json["label_name"];
    _orderNumber = json["order_number"];
    _orderStatus = json["order_status"];
    _qrCodeValue = json["qr_code_value"];
    _activationCode = json["activation_code"];
    _smdpAddress = json["smdp_address"];
    _validityDate = json["validity_date"];
    _iccid = json["iccid"];
    _userProfileId = json["user_profile_id"];
    _paymentDate = json["payment_date"];
    _sharedWith = json["shared_with"];
    _displayTitle = json["display_title"];
    _displaySubtitle = json["display_subtitle"];
    _bundleCode = json["bundle_code"];
    _bundleCategory = json["bundle_category"] != null
        ? BundleCategoryResponseModel.fromJson(json["bundle_category"])
        : null;
    _bundleMarketingName = json["bundle_marketing_name"];
    _bundleName = json["bundle_name"];
    _countCountries = json["count_countries"];
    _currencyCode = json["currency_code"];
    _gprsLimitDisplay = json["gprs_limit_display"];
    _price = json["price"];
    _priceDisplay = json["price_display"];
    _unlimited = json["unlimited"];
    _validity = json["validity"];
    _validityDisplay = json["validity_display"];
    _planType = json["plan_type"];
    _activityPolicy = json["activity_policy"];

    _bundleMessage = json["bundle_message"] != null
        ? List<String>.from(json["bundle_message"])
        : <String>[];

    if (json["countries"] != null) {
      _countries = <CountryResponseModel>[];
      json["countries"].forEach((dynamic v) {
        _countries?.add(CountryResponseModel.fromJson(v));
      });
    }

    _icon = json["icon"];
    if (json["transaction_history"] != null) {
      _transactionHistory = <TransactionHistoryResponseModel>[];
      json["transaction_history"].forEach((dynamic v) {
        _transactionHistory?.add(TransactionHistoryResponseModel.fromJson(v));
      });
    }
    _autoTopupEnabled = json["auto_topup_enabled"];
    _autoTopupBundleName = json["auto_topup_bundle_name"];
  }

  bool? _isTopupAllowed;
  bool? _planStarted;
  bool? _bundleExpired;
  String? _labelName;
  String? _orderNumber;
  String? _orderStatus;
  String? _qrCodeValue;
  String? _activationCode;
  String? _smdpAddress;
  String? _validityDate;
  String? _iccid;
  String? _userProfileId;
  String? _paymentDate;
  String? _sharedWith;
  String? _displayTitle;
  String? _displaySubtitle;
  String? _bundleCode;
  BundleCategoryResponseModel? _bundleCategory;
  String? _bundleMarketingName;
  String? _bundleName;
  num? _countCountries;
  String? _currencyCode;
  String? _gprsLimitDisplay;
  num? _price;
  String? _priceDisplay;
  bool? _unlimited;
  num? _validity;
  String? _validityDisplay;
  String? _planType;
  String? _activityPolicy;
  List<String>? _bundleMessage;
  List<CountryResponseModel>? _countries;
  String? _icon;
  List<TransactionHistoryResponseModel>? _transactionHistory;
  bool? _autoTopupEnabled;
  String? _autoTopupBundleName;

  PurchaseEsimBundleResponseModel copyWith({
    bool? isTopupAllowed,
    bool? planStarted,
    bool? bundleExpired,
    String? labelName,
    String? orderNumber,
    String? orderStatus,
    String? qrCodeValue,
    String? activationCode,
    String? smdpAddress,
    String? validityDate,
    String? iccid,
    String? userProfileId,
    String? paymentDate,
    String? sharedWith,
    String? displayTitle,
    String? displaySubtitle,
    String? bundleCode,
    BundleCategoryResponseModel? bundleCategory,
    String? bundleMarketingName,
    String? bundleName,
    num? countCountries,
    String? currencyCode,
    String? gprsLimitDisplay,
    num? price,
    String? priceDisplay,
    bool? unlimited,
    num? validity,
    String? validityDisplay,
    String? planType,
    String? activityPolicy,
    List<String>? bundleMessage,
    List<CountryResponseModel>? countries,
    String? icon,
    List<TransactionHistoryResponseModel>? transactionHistory,
    bool? autoTopupEnabled,
    String? autoTopupBundleName,
  }) =>
      PurchaseEsimBundleResponseModel(
        isTopupAllowed: isTopupAllowed ?? _isTopupAllowed,
        planStarted: planStarted ?? _planStarted,
        bundleExpired: bundleExpired ?? _bundleExpired,
        labelName: labelName ?? _labelName,
        orderNumber: orderNumber ?? _orderNumber,
        orderStatus: orderStatus ?? _orderStatus,
        qrCodeValue: qrCodeValue ?? _qrCodeValue,
        activationCode: activationCode ?? _activationCode,
        smdpAddress: smdpAddress ?? _smdpAddress,
        validityDate: validityDate ?? _validityDate,
        iccid: iccid ?? _iccid,
        userProfileId: userProfileId ?? _userProfileId,
        paymentDate: paymentDate ?? _paymentDate,
        sharedWith: sharedWith ?? _sharedWith,
        displayTitle: displayTitle ?? _displayTitle,
        displaySubtitle: displaySubtitle ?? _displaySubtitle,
        bundleCode: bundleCode ?? _bundleCode,
        bundleCategory: bundleCategory ?? _bundleCategory,
        bundleMarketingName: bundleMarketingName ?? _bundleMarketingName,
        bundleName: bundleName ?? _bundleName,
        countCountries: countCountries ?? _countCountries,
        currencyCode: currencyCode ?? _currencyCode,
        gprsLimitDisplay: gprsLimitDisplay ?? _gprsLimitDisplay,
        price: price ?? _price,
        priceDisplay: priceDisplay ?? _priceDisplay,
        unlimited: unlimited ?? _unlimited,
        validity: validity ?? _validity,
        validityDisplay: validityDisplay ?? _validityDisplay,
        planType: planType ?? _planType,
        activityPolicy: activityPolicy ?? _activityPolicy,
        bundleMessage: bundleMessage ?? _bundleMessage,
        countries: countries ?? _countries,
        icon: icon ?? _icon,
        transactionHistory: transactionHistory ?? _transactionHistory,
        autoTopupEnabled: autoTopupEnabled ?? _autoTopupEnabled,
        autoTopupBundleName: autoTopupBundleName ?? _autoTopupBundleName,
      );

  bool? get isTopupAllowed => _isTopupAllowed;

  bool? get planStarted => _planStarted;

  bool? get bundleExpired => _bundleExpired;

  dynamic get labelName => _labelName;

  String? get orderNumber => _orderNumber;

  String? get orderStatus => _orderStatus;

  String? get qrCodeValue => _qrCodeValue;

  String? get activationCode => _activationCode;

  String? get smdpAddress => _smdpAddress;

  String? get validityDate => _validityDate;

  String? get iccid => _iccid;

  String? get userProfileId => _userProfileId;

  String? get paymentDate => _paymentDate;

  dynamic get sharedWith => _sharedWith;

  String? get displayTitle => _displayTitle;

  String? get displaySubtitle => _displaySubtitle;

  String? get bundleCode => _bundleCode;

  BundleCategoryResponseModel? get bundleCategory => _bundleCategory;

  String? get bundleMarketingName => _bundleMarketingName;

  String? get bundleName => _bundleName;

  num? get countCountries => _countCountries;

  String? get currencyCode => _currencyCode;

  String? get gprsLimitDisplay => _gprsLimitDisplay;

  num? get price => _price;

  String? get priceDisplay => _priceDisplay;

  bool? get unlimited => _unlimited;

  num? get validity => _validity;

  String? get validityDisplay => _validityDisplay;

  String? get planType => _planType;

  String? get activityPolicy => _activityPolicy;

  List<String>? get bundleMessage => _bundleMessage;

  List<CountryResponseModel>? get countries => _countries;

  String? get icon => _icon;

  List<TransactionHistoryResponseModel>? get transactionHistory =>
      _transactionHistory;

  bool? get autoTopupEnabled => _autoTopupEnabled;

  String? get autoTopupBundleName => _autoTopupBundleName;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = <String, dynamic>{};
    map["is_topup_allowed"] = _isTopupAllowed;
    map["plan_started"] = _planStarted;
    map["bundle_expired"] = _bundleExpired;
    map["label_name"] = _labelName;
    map["order_number"] = _orderNumber;
    map["order_status"] = _orderStatus;
    map["qr_code_value"] = _qrCodeValue;
    map["activation_code"] = _activationCode;
    map["smdp_address"] = _smdpAddress;
    map["validity_date"] = _validityDate;
    map["iccid"] = _iccid;
    map["user_profile_id"] = _userProfileId;
    map["payment_date"] = _paymentDate;
    map["shared_with"] = _sharedWith;
    map["display_title"] = _displayTitle;
    map["display_subtitle"] = _displaySubtitle;
    map["bundle_code"] = _bundleCode;
    if (_bundleCategory != null) {
      map["bundle_category"] = _bundleCategory?.toJson();
    }
    map["bundle_marketing_name"] = _bundleMarketingName;
    map["bundle_name"] = _bundleName;
    map["count_countries"] = _countCountries;
    map["currency_code"] = _currencyCode;
    map["gprs_limit_display"] = _gprsLimitDisplay;
    map["price"] = _price;
    map["price_display"] = _priceDisplay;
    map["unlimited"] = _unlimited;
    map["validity"] = _validity;
    map["validity_display"] = _validityDisplay;
    map["plan_type"] = _planType;
    map["activity_policy"] = _activityPolicy;
    map["bundle_message"] = _bundleMessage;
    map["countries"] =
        _countries?.map((CountryResponseModel v) => v.toJson()).toList();
    map["icon"] = _icon;
    if (_transactionHistory != null) {
      map["transaction_history"] = _transactionHistory
          ?.map((TransactionHistoryResponseModel v) => v.toJson())
          .toList();
    }
    map["auto_topup_enabled"] = _autoTopupEnabled;
    map["auto_topup_bundle_name"] = _autoTopupBundleName;
    return map;
  }

  static List<PurchaseEsimBundleResponseModel> fromJsonList({dynamic json}) {
    return fromJsonListTyped(
      parser: PurchaseEsimBundleResponseModel.fromJson,
      json: json,
    );
  }

  // static String? _mapBundleStatusToString(BundleStatus? status) {
  //   switch (status) {
  //     case BundleStatus.active:
  //       return "active";
  //     case BundleStatus.inactive:
  //       return "inactive";
  //     case BundleStatus.expired:
  //       return "expired";
  //     default:
  //       return null;
  //   }
  // }

  static BundleStatus? _mapStringToBundleStatus(String? status) {
    switch ((status ?? "").toLowerCase()) {
      case "active":
        return BundleStatus.active;
      case "inactive":
        return BundleStatus.inactive;
      case "expired":
        return BundleStatus.expired;
      default:
        return null;
    }
  }

  Color getStatusBgColor(BuildContext context) {
    switch (_mapStringToBundleStatus(orderStatus ?? "")) {
      case BundleStatus.active:
        return context.appColors.success_50 ??
            context.appColors.baseWhite ??
            Colors.transparent;
      case BundleStatus.inactive:
        return context.appColors.warning_50 ??
            context.appColors.baseWhite ??
            Colors.transparent;
      case BundleStatus.expired:
        return context.appColors.error_50 ??
            context.appColors.baseWhite ??
            Colors.transparent;
      default:
        return context.appColors.baseWhite ?? Colors.transparent;
    }
  }

  Color getStatusTextColor(BuildContext context) {
    switch (_mapStringToBundleStatus(orderStatus ?? "")) {
      case BundleStatus.active:
        return context.appColors.success_700 ??
            context.appColors.baseWhite ??
            Colors.transparent;
      case BundleStatus.inactive:
        return context.appColors.warning_700 ??
            context.appColors.baseWhite ??
            Colors.transparent;
      case BundleStatus.expired:
        return context.appColors.error_500 ??
            context.appColors.baseWhite ??
            Colors.transparent;
      default:
        return context.appColors.baseWhite ?? Colors.transparent;
    }
  }

  static List<PurchaseEsimBundleResponseModel> mockItems() {
    return <PurchaseEsimBundleResponseModel>[
      PurchaseEsimBundleResponseModel(
        iccid: "123123",
        orderStatus: "active",
        validity: 1740667696,
        paymentDate: "1740667696",
        bundleExpired: false,
        bundleName: "Bundle name",
        displayTitle: "Europe5GB10Days",
        displaySubtitle: "USD",
        validityDisplay: "1 Day",
        gprsLimitDisplay: "5 GB",
        // icon: "https://placehold.co/600x400?bundle=None",
        countries: CountryResponseModel.getMockCountries(),
      ),
      PurchaseEsimBundleResponseModel(
        iccid: "123123",
        orderStatus: "active",
        validity: 1740667696,
        paymentDate: "1740667696",
        bundleExpired: false,
        bundleName: "Bundle name",
        displayTitle: "Europe5GB10Days",
        displaySubtitle: "USD",
        validityDisplay: "1 Day",
        gprsLimitDisplay: "5 GB",
        // icon: "https://placehold.co/600x400?bundle=None",
        countries: CountryResponseModel.getMockCountries(),
      ),
      PurchaseEsimBundleResponseModel(
        iccid: "123123",
        orderStatus: "active",
        validity: 1740667696,
        paymentDate: "1740667696",
        bundleExpired: false,
        bundleName: "Bundle name",
        displayTitle: "Europe5GB10Days",
        displaySubtitle: "USD",
        validityDisplay: "1 Day",
        gprsLimitDisplay: "5 GB",
        // icon: "https://placehold.co/600x400?bundle=None",
        countries: CountryResponseModel.getMockCountries(),
      ),
    ];
  }
}
