import "dart:convert";

import "package:esim_open_source/utils/parsing_helper.dart";

AccountModel accountModelFromJson(String str) =>
    AccountModel.fromJson(json: json.decode(str));
String accountModelToJson(AccountModel data) => json.encode(data.toJson());

enum AccountsType {
  unknown(""),
  prepaid("PREPAID"), // "PREPAID",
  postpaid("POSTPAID"); // "POSTPAID",

  const AccountsType(this.value);

  final String value;
}

class AccountModel {
  AccountModel({
    String? recordGuid,
    String? accountNumber,
    num? currentBalance,
    num? previousBalance,
    num? lockedBalance,
    num? previousLockedBalance,
    String? currencyCode,
    String? accountTypeTag,
    bool? isPrimary,
  }) {
    _recordGuid = recordGuid;
    _accountNumber = accountNumber;
    _currentBalance = currentBalance;
    _previousBalance = previousBalance;
    _lockedBalance = lockedBalance;
    _previousLockedBalance = previousLockedBalance;
    _currencyCode = currencyCode;
    _accountTypeTag = accountTypeTag;
    _isPrimary = isPrimary;
  }

  AccountModel.fromJson({dynamic json}) {
    _recordGuid = json["recordGuid"];
    _accountNumber = json["accountNumber"];
    _currentBalance = json["currentBalance"];
    _previousBalance = json["previousBalance"];
    _lockedBalance = json["lockedBalance"];
    _previousLockedBalance = json["previousLockedBalance"];
    _currencyCode = json["currencyCode"];
    _accountTypeTag = json["accountTypeTag"];
    _isPrimary = json["isPrimary"];
  }
  String? _recordGuid;
  String? _accountNumber;
  num? _currentBalance;
  num? _previousBalance;
  num? _lockedBalance;
  num? _previousLockedBalance;
  String? _currencyCode;
  String? _accountTypeTag;
  bool? _isPrimary;
  AccountModel copyWith({
    String? recordGuid,
    String? accountNumber,
    num? currentBalance,
    num? previousBalance,
    num? lockedBalance,
    num? previousLockedBalance,
    String? currencyCode,
    String? accountTypeTag,
    bool? isPrimary,
  }) =>
      AccountModel(
        recordGuid: recordGuid ?? _recordGuid,
        accountNumber: accountNumber ?? _accountNumber,
        currentBalance: currentBalance ?? _currentBalance,
        previousBalance: previousBalance ?? _previousBalance,
        lockedBalance: lockedBalance ?? _lockedBalance,
        previousLockedBalance: previousLockedBalance ?? _previousLockedBalance,
        currencyCode: currencyCode ?? _currencyCode,
        accountTypeTag: accountTypeTag ?? _accountTypeTag,
        isPrimary: isPrimary ?? _isPrimary,
      );
  String? get recordGuid => _recordGuid;
  String? get accountNumber => _accountNumber;
  num? get currentBalance => _currentBalance;
  num? get previousBalance => _previousBalance;
  num? get lockedBalance => _lockedBalance;
  num? get previousLockedBalance => _previousLockedBalance;
  String? get currencyCode => _currencyCode;
  String? get accountTypeTag => _accountTypeTag;
  bool? get isPrimary => _isPrimary;

  AccountsType get accountType {
    if (AccountsType.prepaid.value == accountTypeTag?.toUpperCase()) {
      return AccountsType.prepaid;
    }
    if (AccountsType.postpaid.value == accountTypeTag?.toUpperCase()) {
      return AccountsType.postpaid;
    }
    return AccountsType.unknown;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = <String, dynamic>{};
    map["recordGuid"] = _recordGuid;
    map["accountNumber"] = _accountNumber;
    map["currentBalance"] = _currentBalance;
    map["previousBalance"] = _previousBalance;
    map["lockedBalance"] = _lockedBalance;
    map["previousLockedBalance"] = _previousLockedBalance;
    map["currencyCode"] = _currencyCode;
    map["accountTypeTag"] = _accountTypeTag;
    map["isPrimary"] = _isPrimary;
    return map;
  }

  static List<AccountModel> fromJsonList({dynamic json}) {
    return fromJsonListTyped(parser: AccountModel.fromJson, json: json);
  }
}
