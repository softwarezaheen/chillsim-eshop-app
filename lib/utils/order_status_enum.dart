enum PaymentStatus {
  pending(status: "PENDING"),
  completed(status: "COMPLETED");

  const PaymentStatus({required this.status});

  final String status;

  static PaymentStatus fromString(String? paymentStatusString) {
    return PaymentStatus.values.firstWhere(
      (PaymentStatus status) => status.status == paymentStatusString,
      orElse: () => PaymentStatus.pending,
    );
  }
}
