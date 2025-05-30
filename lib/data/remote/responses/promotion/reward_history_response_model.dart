import "package:esim_open_source/presentation/views/home_flow_views/profile_view/profile_view_sections/rewards_history_view/rewards_history_view_model.dart";
import "package:esim_open_source/utils/date_time_utils.dart";
import "package:esim_open_source/utils/parsing_helper.dart";

class RewardHistoryResponseModel {
  RewardHistoryResponseModel({
    this.isReferral,
    this.amount,
    this.name,
    this.promotionName,
    this.date,
  });

  factory RewardHistoryResponseModel.fromJson({dynamic json}) {
    return RewardHistoryResponseModel(
      isReferral: json["is_referral"],
      amount: json["amount"],
      name: json["name"],
      promotionName: json["promotion_name"],
      date: json["date"],
    );
  }
  final bool? isReferral;
  final String? amount;
  final String? name;
  final String? promotionName;
  final String? date;

  RewardHistoryType get type {
    if (isReferral ?? true) {
      return RewardHistoryType.referEarn;
    }
    return RewardHistoryType.cashback;
  }

  String get dateDisplayed => DateTimeUtils.formatTimestampToDate(
        timestamp: int.parse(date ?? "0"),
        format: DateTimeUtils.ddMmYyyy,
      );

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      "is_referral": isReferral,
      "amount": amount,
      "name": name,
      "promotion_name": promotionName,
      "date": date,
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
    ),
    RewardHistoryResponseModel(
      isReferral: true,
      name: "kareem_chaheen123@yahoo.com",
      promotionName: "",
      amount: r"$5.00",
      date: "1747125626",
    ),
  ];
}
