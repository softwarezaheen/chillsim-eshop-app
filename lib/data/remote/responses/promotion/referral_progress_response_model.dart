class ReferralMilestoneModel {
  ReferralMilestoneModel({
    this.type,
    this.target,
    this.bonus,
    this.reached,
  });

  factory ReferralMilestoneModel.fromJson({dynamic json}) {
    return ReferralMilestoneModel(
      type: json["type"],
      target: json["target"] is int
          ? json["target"]
          : int.tryParse(json["target"]?.toString() ?? ""),
      bonus: json["bonus"] is num
          ? (json["bonus"] as num).toDouble()
          : double.tryParse(json["bonus"]?.toString() ?? ""),
      reached: json["reached"] ?? false,
    );
  }

  final String? type;
  final int? target;
  final double? bonus;
  final bool? reached;
}

class ReferralProgressResponseModel {
  ReferralProgressResponseModel({
    this.totalReferrals,
    this.currentCycle,
    this.positionInCycle,
    this.cycleSize,
    this.milestones,
    this.totalEarned,
    this.referralAmount,
    this.referredDiscountPercentage,
  });

  factory ReferralProgressResponseModel.fromJson({dynamic json}) {
    final List<dynamic>? rawMilestones = json["milestones"];
    return ReferralProgressResponseModel(
      totalReferrals: json["total_referrals"],
      currentCycle: json["current_cycle"],
      positionInCycle: json["position_in_cycle"],
      cycleSize: json["cycle_size"],
      milestones: rawMilestones
          ?.map(
            (dynamic m) => ReferralMilestoneModel.fromJson(json: m),
          )
          .toList(),
      totalEarned: json["total_earned"] is num
          ? (json["total_earned"] as num).toDouble()
          : double.tryParse(json["total_earned"]?.toString() ?? ""),
      referralAmount: json["referral_amount"]?.toString(),
      referredDiscountPercentage:
          json["referred_discount_percentage"]?.toString(),
    );
  }

  final int? totalReferrals;
  final int? currentCycle;
  final int? positionInCycle;
  final int? cycleSize;
  final List<ReferralMilestoneModel>? milestones;
  final double? totalEarned;
  final String? referralAmount;
  final String? referredDiscountPercentage;
}
