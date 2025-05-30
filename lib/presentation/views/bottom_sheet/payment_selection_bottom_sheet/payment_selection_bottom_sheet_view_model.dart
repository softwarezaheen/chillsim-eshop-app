import "package:easy_localization/easy_localization.dart";
import "package:esim_open_source/app/environment/environment_images.dart";
import "package:esim_open_source/presentation/views/base/base_model.dart";
import "package:esim_open_source/translations/locale_keys.g.dart";
import "package:stacked_services/stacked_services.dart";

enum PaymentSelection {
  card,
  wallet;

  String get apiKey {
    switch (this) {
      case PaymentSelection.card:
        return "Card";
      case PaymentSelection.wallet:
        return "Wallet";
    }
  }

  String get titleText {
    switch (this) {
      case PaymentSelection.card:
        return LocaleKeys.paymentSelection_cardText.tr();
      case PaymentSelection.wallet:
        return LocaleKeys.paymentSelection_walletText.tr();
    }
  }

  String get _imageName {
    switch (this) {
      case PaymentSelection.card:
        return "payByCard";
      case PaymentSelection.wallet:
        return "payByWallet";
    }
  }

  String get sectionImagePath => EnvironmentImages.values
      .firstWhere(
        (EnvironmentImages e) => e.name == _imageName,
        orElse: () => EnvironmentImages.language,
      )
      .fullImagePath;
}

class PaymentSelectionBottomSheetViewModel extends BaseModel {
  PaymentSelectionBottomSheetViewModel({required this.completer});
  final Function(SheetResponse<PaymentSelection>) completer;
}
