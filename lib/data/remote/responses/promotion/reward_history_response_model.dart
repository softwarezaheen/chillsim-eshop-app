import "package:esim_open_source/data/remote/responses/promotion/reward_application_type.dart";
import "package:esim_open_source/data/remote/responses/promotion/reward_type.dart";
import "package:esim_open_source/utils/date_time_utils.dart";
import "package:esim_open_source/utils/parsing_helper.dart";

class RewardHistoryResponseModel {
  RewardHistoryResponseModel({
    // OLD FIELDS - Keep for backward compatibility
    this.isReferral,
    this.amount,
    this.name,
    this.promotionName,
    this.date,
    // NEW FIELDS - Enhanced information
    this.rewardType,
    this.applicationType,
    this.originalAmount,
    this.title,
    this.description,
    this.promotionCode,
    this.referralFrom,
    this.orderId,
    this.bundleName,
    this.status,
  });

  factory RewardHistoryResponseModel.fromJson({dynamic json}) {
    return RewardHistoryResponseModel(
      // OLD FIELDS
      isReferral: json["is_referral"],
      amount: json["amount"],
      name: json["name"],
      promotionName: json["promotion_name"],
      date: json["date"],
      // NEW FIELDS
      rewardType: RewardType.fromString(json["reward_type"]),
      applicationType:
          RewardApplicationType.fromString(json["application_type"]),
      originalAmount: json["original_amount"],
      title: json["title"],
      description: json["description"],
      promotionCode: json["promotion_code"],
      referralFrom: json["referral_from"],
      orderId: json["order_id"],
      bundleName: json["bundle_name"],
      status: json["status"] ?? "completed",
    );
  }

  // OLD FIELDS - Keep for backward compatibility
  final bool? isReferral;
  final String? amount;
  final String? name;
  final String? promotionName;
  final String? date;

  // NEW FIELDS - Enhanced information
  final RewardType? rewardType;
  final RewardApplicationType? applicationType;
  final String? originalAmount;
  final String? title;
  final String? description;
  final String? promotionCode;
  final String? referralFrom;
  final String? orderId;
  final String? bundleName;
  final String? status;

  // RewardHistoryType get type {
  //   if (isReferral ?? true) {
  //     return RewardHistoryType.referEarn;
  //   }
  //   return RewardHistoryType.cashback;
  // }

  String get dateDisplayed => DateTimeUtils.formatTimestampToDate(
        timestamp: int.parse(date ?? "0"),
        format: DateTimeUtils.ddMmYyyy,
      );

  /// Get display title (use new title field or fall back to legacy fields)
  String get displayTitle {
    if (title != null && title!.isNotEmpty) {
      return title!;
    }
    // Fallback to legacy behavior
    if (isReferral ?? false) {
      return referralFrom ?? name ?? "Referral Reward";
    }
    return promotionName ?? name ?? "Reward";
  }

  /// Get display description
  String get displayDescription {
    if (description != null && description!.isNotEmpty) {
      return description!;
    }
    // Fallback to legacy behavior
    return name ?? "";
  }

  /// Check if this is a wallet credit (vs order discount)
  bool get isWalletCredit =>
      applicationType == RewardApplicationType.walletCredit ||
      (applicationType == null && (isReferral ?? false));

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      // OLD FIELDS
      "is_referral": isReferral,
      "amount": amount,
      "name": name,
      "promotion_name": promotionName,
      "date": date,
      // NEW FIELDS
      "reward_type": rewardType?.toJson(),
      "application_type": applicationType?.toJson(),
      "original_amount": originalAmount,
      "title": title,
      "description": description,
      "promotion_code": promotionCode,
      "referral_from": referralFrom,
      "order_id": orderId,
      "bundle_name": bundleName,
      "status": status,
    };
  }

  static List<RewardHistoryResponseModel> fromJsonList({
    dynamic json,
  }) {
    return fromJsonListTyped(
      parser: RewardHistoryResponseModel.fromJson,
      json: json,
    );
  }

  static List<RewardHistoryResponseModel> mockData =
      <RewardHistoryResponseModel>[
    RewardHistoryResponseModel(
      isReferral: false,
      name: "Global 1GB 7Days",
      promotionName: "10% Cashback",
      amount: r"$5.00",
      date: "1747125626",
      rewardType: RewardType.cashback,
      applicationType: RewardApplicationType.walletCredit,
      title: "Cashback Reward",
      description: "10% cashback on Global 1GB 7Days bundle",
      status: "completed",
    ),
    RewardHistoryResponseModel(
      isReferral: true,
      name: "kareem_chaheen123@yahoo.com",
      promotionName: "",
      amount: r"$5.00",
      date: "1747125626",
      rewardType: RewardType.referralCredit,
      applicationType: RewardApplicationType.walletCredit,
      title: "Referral Credit",
      description: "Reward for referring kareem_chaheen123@yahoo.com",
      referralFrom: "kareem_chaheen123@yahoo.com",
      status: "completed",
    ),
    RewardHistoryResponseModel(
      isReferral: false,
      name: "15% Discount",
      promotionName: "15% Discount",
      amount: "0.09 EUR",
      date: "1760369123",
      rewardType: RewardType.discountPercentage,
      applicationType: RewardApplicationType.orderDiscount,
      title: "Percentage Discount",
      description: "15% discount applied to order",
      promotionCode: "SAVE15",
      status: "completed",
    ),
  ];
}
