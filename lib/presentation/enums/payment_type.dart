import "package:easy_localization/easy_localization.dart";
import "package:esim_open_source/app/environment/environment_images.dart";
import "package:esim_open_source/translations/locale_keys.g.dart";

enum PaymentType {
  wallet("Wallet"),
  dcb("DCB"),
  card("Card");

  const PaymentType(this.type);

  final String type;

  String get titleText {
    switch (this) {
      case card:
        return LocaleKeys.paymentSelection_cardText.tr();
      case dcb:
        return LocaleKeys.paymentSelection_dcbText.tr();
      case wallet:
        return LocaleKeys.paymentSelection_walletText.tr();
    }
  }

  String get _imageName {
    switch (this) {
      case card:
        return "payByCard";
      case wallet:
        return "payByWallet";
      case dcb:
        return "payByDcb";
    }
  }

  String get sectionImagePath => EnvironmentImages.values
      .firstWhere(
        (EnvironmentImages e) => e.name == _imageName,
        orElse: () => EnvironmentImages.language,
      )
      .fullImagePath;

  static List<PaymentType> getListFromValues(String? paymentTypeString) {
    if (paymentTypeString == null || paymentTypeString.isEmpty) {
      return <PaymentType>[];
    }
    return paymentTypeString
        .split(",")
        .map((String e) => PaymentType.values.firstWhere(
              (PaymentType type) =>
                  type.name.toLowerCase() == e.trim().toLowerCase(),
              orElse: () => PaymentType.card, // fallback if not found
            ),)
        .toList();
    // List<String> values =
    //     paymentTypeString.split(",").map((String e) => e.trim()).toList();

    // return PaymentType.values.where((PaymentType paymentType) {
    //   return values.contains(paymentType.type);
    // }).toList();
  }
}

enum PaymentResult {
  completed,
  canceled,
  otpRequested,
}
