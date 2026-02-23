import "package:esim_open_source/utils/parsing_helper.dart";

enum WalletTransactionType {
  topUp("top_up"),
  voucherRedeem("voucher_redeem"),
  referralReward("referral_reward"),
  cashback("cashback"),
  purchase("purchase"),
  refund("refund");

  const WalletTransactionType(this.value);
  final String value;

  static WalletTransactionType fromString(String value) {
    return WalletTransactionType.values.firstWhere(
      (WalletTransactionType type) => type.value == value,
      orElse: () => WalletTransactionType.topUp,
    );
  }
}

/// Response model for wallet transaction history item
class WalletTransactionResponse {
  WalletTransactionResponse({
    String? id,
    String? transactionType,
    String? amount,
    String? title,
    String? description,
    String? date,
    String? status,
    String? voucherCode,
    String? orderId,
    String? sourceDetail,
  }) {
    _id = id;
    _transactionType = transactionType;
    _amount = amount;
    _title = title;
    _description = description;
    _date = date;
    _status = status;
    _voucherCode = voucherCode;
    _orderId = orderId;
    _sourceDetail = sourceDetail;
  }

  WalletTransactionResponse.fromJson({dynamic json}) {
    _id = json["id"];
    _transactionType = json["transaction_type"];
    _amount = json["amount"];
    _title = json["title"];
    _description = json["description"];
    _date = json["date"];
    _status = json["status"];
    _voucherCode = json["voucher_code"];
    _orderId = json["order_id"];
    _sourceDetail = json["source_detail"];
  }

  String? _id;
  String? _transactionType;
  String? _amount;
  String? _title;
  String? _description;
  String? _date;
  String? _status;
  String? _voucherCode;
  String? _orderId;
  String? _sourceDetail;

  WalletTransactionResponse copyWith({
    String? id,
    String? transactionType,
    String? amount,
    String? title,
    String? description,
    String? date,
    String? status,
    String? voucherCode,
    String? orderId,
    String? sourceDetail,
  }) =>
      WalletTransactionResponse(
        id: id ?? _id,
        transactionType: transactionType ?? _transactionType,
        amount: amount ?? _amount,
        title: title ?? _title,
        description: description ?? _description,
        date: date ?? _date,
        status: status ?? _status,
        voucherCode: voucherCode ?? _voucherCode,
        orderId: orderId ?? _orderId,
        sourceDetail: sourceDetail ?? _sourceDetail,
      );

  String? get id => _id;
  String? get transactionType => _transactionType;
  String? get amount => _amount;
  String? get title => _title;
  String? get description => _description;
  String? get date => _date;
  String? get status => _status;
  String? get voucherCode => _voucherCode;
  String? get orderId => _orderId;
  String? get sourceDetail => _sourceDetail;

  WalletTransactionType get transactionTypeEnum => 
      WalletTransactionType.fromString(_transactionType ?? "top_up");

  bool get isPositive => _amount?.startsWith("+") ?? false;
  bool get isNegative => _amount?.startsWith("-") ?? false;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = <String, dynamic>{};
    map["id"] = _id;
    map["transaction_type"] = _transactionType;
    map["amount"] = _amount;
    map["title"] = _title;
    map["description"] = _description;
    map["date"] = _date;
    map["status"] = _status;
    map["voucher_code"] = _voucherCode;
    map["order_id"] = _orderId;
    map["source_detail"] = _sourceDetail;
    return map;
  }

  static List<WalletTransactionResponse> fromJsonList({dynamic json}) {
    return fromJsonListTyped(parser: WalletTransactionResponse.fromJson, json: json);
  }

  // Mock data for testing
  static List<WalletTransactionResponse> get mockData => <WalletTransactionResponse>[
    WalletTransactionResponse(
      id: "1",
      transactionType: "top_up",
      amount: "+25.00 EUR",
      title: "Wallet Top-up",
      description: "Added funds via card payment",
      date: "1705313400000", // Jan 15, 2024 10:30 AM (timestamp in milliseconds)
      status: "success",
    ),
    WalletTransactionResponse(
      id: "2",
      transactionType: "voucher_redeem",
      amount: "+10.00 EUR",
      title: "Voucher Redeemed",
      description: "Welcome bonus voucher",
      date: "1705246500000", // Jan 14, 2024 3:45 PM (timestamp in milliseconds)
      status: "success",
      voucherCode: "WELCOME10",
    ),
    WalletTransactionResponse(
      id: "3",
      transactionType: "purchase",
      amount: "-15.50 EUR",
      title: "Bundle Purchase",
      description: "Europe 5GB - 30 Days",
      date: "1705148400000", // Jan 13, 2024 12:20 PM (timestamp in milliseconds)
      status: "success",
      orderId: "ORD-123456",
    ),
    WalletTransactionResponse(
      id: "4",
      transactionType: "top_up",
      amount: "-5.00 EUR",
      title: "Balance Adjustment",
      description: "System balance correction",
      date: "1705051700000", // Jan 12, 2024 9:15 AM (timestamp in milliseconds)
      status: "success",
    ),
  ];
}
