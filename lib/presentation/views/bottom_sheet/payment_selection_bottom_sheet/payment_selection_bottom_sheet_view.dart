import "package:easy_localization/easy_localization.dart";
import "package:esim_open_source/presentation/enums/payment_type.dart";
import "package:esim_open_source/presentation/setup_bottom_sheet_ui.dart";
import "package:esim_open_source/presentation/shared/shared_styles.dart";
import "package:esim_open_source/presentation/shared/ui_helpers.dart";
import "package:esim_open_source/presentation/views/base/base_view.dart";
import "package:esim_open_source/presentation/views/bottom_sheet/payment_selection_bottom_sheet/payment_selection_bottom_sheet_view_model.dart";
import "package:esim_open_source/presentation/widgets/bottom_sheet_close_button.dart";
import "package:esim_open_source/presentation/widgets/padding_widget.dart";
import "package:esim_open_source/translations/locale_keys.g.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart";
import "package:stacked_services/stacked_services.dart";

class PaymentSelectionBottomSheetView extends StatelessWidget {
  const PaymentSelectionBottomSheetView({
    required this.completer,
    required this.requestBase,
    super.key,
  });
  final SheetRequest<PaymentSelectionBottomRequest> requestBase;
  final Function(SheetResponse<PaymentType>) completer;

  @override
  Widget build(BuildContext context) {
    return BaseView.bottomSheetBuilder(
      viewModel: PaymentSelectionBottomSheetViewModel(
        completer: completer,
        request: requestBase,
      ),
      builder: (
        BuildContext context,
        PaymentSelectionBottomSheetViewModel viewModel,
        Widget? child,
        double screenHeight,
      ) =>
          KeyboardDismissOnTap(
        dismissOnCapturedTaps: true,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              DecoratedBox(
                decoration: const ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                      width: 0,
                      color: Colors.transparent,
                    ),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                ),
                child: SizedBox(
                  width: screenWidth(context),
                  child: PaddingWidget.applySymmetricPadding(
                    vertical: 15,
                    horizontal: 25,
                    child: Column(
                      children: <Widget>[
                        BottomSheetCloseButton(
                          onTap: () => viewModel.onCloseClick(),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            LocaleKeys.paymentSelection_titleText.tr(),
                            style: headerThreeMediumTextStyle(
                              context: context,
                              fontColor: titleTextColor(context: context),
                            ),
                          ),
                        ),
                        verticalSpaceMedium,
                        ListView.separated(
                          shrinkWrap: true,
                          itemCount: viewModel.paymentTypeList.length,
                          separatorBuilder: (
                            BuildContext context,
                            int index,
                          ) =>
                              verticalSpaceSmallMedium,
                          itemBuilder: (
                            BuildContext context,
                            int index,
                          ) =>
                              buildPaymentSelectionView(
                            context,
                            viewModel.paymentTypeList[index],
                            viewModel,
                          ),
                        ),
                        
                        // Stripe Security Message - Show if Card payment is available
                        if (viewModel.paymentTypeList.contains(PaymentType.card)) ...<Widget>[
                          verticalSpaceMedium,
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.blue.shade50,
                              border: Border.all(color: Colors.blue.shade200),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Icon(
                                  Icons.info_outline,
                                  color: Colors.blue.shade700,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    LocaleKeys.stripe_security_message.tr(),
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.blue.shade900,
                                      height: 1.4,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildPaymentSelectionView(
    BuildContext context,
    PaymentType paymentType,
    PaymentSelectionBottomSheetViewModel viewModel,
  ) {
    final bool isWallet = paymentType == PaymentType.wallet;
    final double balance = viewModel.userAuthenticationService.walletAvailableBalance;
    final String currency = viewModel.userAuthenticationService.walletCurrencyCode;
    final double amount = viewModel.request.data?.amount ?? 0;
    final bool hasSufficientBalance = !isWallet || balance >= amount;

    return GestureDetector(
      onTap: () => viewModel.onPaymentTypeClick(paymentType),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: hasSufficientBalance ? greyBackGroundColor(context: context) : Colors.grey.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(10),
        ),
        child: PaddingWidget.applySymmetricPadding(
          vertical: 15,
          horizontal: 20,
          child: Row(
            children: <Widget>[
              Image.asset(
                paymentType.sectionImagePath,
                width: 50,
                height: 50,
              ),
              horizontalSpaceSmall,
              Expanded(
                child: Text(
                  isWallet ? "${paymentType.titleText} (${balance.toStringAsFixed(2)} $currency)" : paymentType.titleText,
                  style: bodyNormalTextStyle(
                    context: context,
                    fontColor: hasSufficientBalance ? bubbleCountryTextColor(context: context) : Colors.grey,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(
        DiagnosticsProperty<SheetRequest<dynamic>>(
          "requestBase",
          requestBase,
        ),
      )
      ..add(
        ObjectFlagProperty<Function(SheetResponse<PaymentType> p1)>.has(
          "completer",
          completer,
        ),
      );
  }
}
