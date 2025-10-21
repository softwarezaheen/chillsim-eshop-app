/// How the reward was applied
enum RewardApplicationType {
  walletCredit("wallet_credit"),
  orderDiscount("order_discount");

  const RewardApplicationType(this.value);

  final String value;

  static RewardApplicationType? fromString(String? value) {
    if (value == null) {
      return null;
    }
    try {
      return RewardApplicationType.values
          .firstWhere((RewardApplicationType e) => e.value == value);
    } on StateError {
      return null;
    }
  }

  String toJson() => value;
}
