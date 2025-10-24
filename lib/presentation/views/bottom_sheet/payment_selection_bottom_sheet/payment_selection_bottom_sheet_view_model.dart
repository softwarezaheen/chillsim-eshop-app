import "package:easy_localization/easy_localization.dart";
import "package:esim_open_source/app/app.locator.dart";
import "package:esim_open_source/presentation/enums/payment_type.dart";
import "package:esim_open_source/presentation/reactive_service/user_authentication_service.dart";
import "package:esim_open_source/presentation/setup_bottom_sheet_ui.dart";
import "package:esim_open_source/presentation/shared/ui_helpers.dart";
import "package:esim_open_source/presentation/views/base/base_model.dart";
import "package:esim_open_source/translations/locale_keys.g.dart";
import "package:esim_open_source/utils/apple_pay_helper.dart";
import "package:stacked_services/stacked_services.dart";

class PaymentSelectionBottomSheetViewModel extends BaseModel {
  PaymentSelectionBottomSheetViewModel({
    required this.completer,
    required this.request,
  });
  final Function(SheetResponse<PaymentType>) completer;
  final SheetRequest<PaymentSelectionBottomRequest> request;

  @override
  final UserAuthenticationService userAuthenticationService =
      locator<UserAuthenticationService>();

  List<PaymentType>? _filteredPaymentTypes;

  /// Returns the payment types list filtered by Apple Pay availability
  List<PaymentType> get paymentTypeList {
    return _filteredPaymentTypes ?? request.data?.paymentTypeList ?? <PaymentType>[];
  }

  @override
  Future<void> onViewModelReady() async {
    super.onViewModelReady();
    await _filterApplePayIfNotAvailable();
  }

  /// Filters out Apple Pay from the list if it's not available on the device
  Future<void> _filterApplePayIfNotAvailable() async {
    final List<PaymentType> originalList = request.data?.paymentTypeList ?? <PaymentType>[];

    // If Apple Pay is not in the list, no filtering needed
    if (!originalList.contains(PaymentType.applePay)) {
      _filteredPaymentTypes = originalList;
      notifyListeners();
      return;
    }

    // Check if Apple Pay is available
    final bool isApplePayAvailable = await ApplePayHelper.isApplePayAvailable();

    if (isApplePayAvailable) {
      // Keep Apple Pay in the list
      _filteredPaymentTypes = originalList;
    } else {
      // Remove Apple Pay from the list
      _filteredPaymentTypes = originalList.where((PaymentType type) => type != PaymentType.applePay).toList();
    }

    notifyListeners();
  }

  void onCloseClick() {
    completer(
      SheetResponse<PaymentType>(),
    );
  }

  Future<void> onPaymentTypeClick(PaymentType paymentType) async {
    if (paymentType == PaymentType.wallet &&
        (request.data?.amount ?? 0) > userAuthenticationService.walletAvailableBalance) {
      await showToast(LocaleKeys.no_sufficient_balance_in_wallet.tr());
      return;
    }
    completer(
      SheetResponse<PaymentType>(
        confirmed: true,
        data: paymentType,
      ),
    );
  }
}
