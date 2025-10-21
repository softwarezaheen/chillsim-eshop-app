/// Types of rewards a user can receive
enum RewardType {
  referralCredit("referral_credit"),
  promoDiscount("promo_discount"),
  cashback("cashback"),
  discountAmount("discount_amount"),
  discountPercentage("discount_percentage");

  const RewardType(this.value);

  final String value;

  static RewardType? fromString(String? value) {
    if (value == null) {
      return null;
    }
    try {
      return RewardType.values.firstWhere((RewardType e) => e.value == value);
    } on StateError {
      return null;
    }
  }

  String toJson() => value;
}
