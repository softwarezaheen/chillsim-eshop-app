import "package:easy_localization/easy_localization.dart";
import "package:esim_open_source/presentation/extensions/context_extension.dart";
import "package:esim_open_source/presentation/setup_bottom_sheet_ui.dart";
import "package:esim_open_source/presentation/views/base/base_view.dart";
import "package:esim_open_source/presentation/views/bottom_sheet/payment_method_bottom_sheet/payment_method_bottom_sheet_view_model.dart";
import "package:esim_open_source/presentation/widgets/payment_methods_list.dart";
import "package:esim_open_source/translations/locale_keys.g.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:stacked_services/stacked_services.dart";

class PaymentMethodBottomSheetView extends StatelessWidget {
  const PaymentMethodBottomSheetView({
    required this.completer,
    super.key,
  });

  final Function(SheetResponse<EmptyBottomSheetResponse>) completer;

  @override
  Widget build(BuildContext context) {
    return BaseView.bottomSheetBuilder(
      viewModel: PaymentMethodBottomSheetViewModel(),
      builder: (
        BuildContext context,
        PaymentMethodBottomSheetViewModel viewModel,
        Widget? childWidget,
        double screenHeight,
      ) =>
          Padding(
        padding: const EdgeInsets.only(top: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              alignment: Alignment.bottomRight,
              child: CloseButton(
                onPressed: () =>
                    completer(SheetResponse<EmptyBottomSheetResponse>()),
              ),
            ),
            PaymentMethodsList(
              title: LocaleKeys.choose_payment_method.tr(),
              items: <PaymentCardData>[
                PaymentCardData(
                  backgroundColor: context.appColors.grey_100!,
                  icon: Icons.credit_card,
                  text: LocaleKeys.credit_debit_card.tr(),
                ),
                PaymentCardData(
                  backgroundColor: context.appColors.grey_100!,
                  icon: Icons.account_balance_wallet_outlined,
                  text: LocaleKeys.profile_myWallet.tr(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
      ObjectFlagProperty<
          Function(SheetResponse<EmptyBottomSheetResponse> p1)>.has(
        "completer",
        completer,
      ),
    );
  }
}
