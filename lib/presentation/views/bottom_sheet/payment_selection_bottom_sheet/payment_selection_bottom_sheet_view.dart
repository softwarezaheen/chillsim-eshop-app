import "package:easy_localization/easy_localization.dart";
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
  final SheetRequest<dynamic> requestBase;
  final Function(SheetResponse<PaymentSelection>) completer;

  @override
  Widget build(BuildContext context) {
    return BaseView.bottomSheetBuilder(
      viewModel: PaymentSelectionBottomSheetViewModel(
        completer: completer,
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
                          onTap: () => completer(
                            SheetResponse<PaymentSelection>(),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            LocaleKeys.paymentSelection_titleText.tr(),
                            style: headerThreeMediumTextStyle(
                              context: context,
                              fontColor: mainDarkTextColor(context: context),
                            ),
                          ),
                        ),
                        verticalSpaceMedium,
                        ListView.separated(
                          shrinkWrap: true,
                          itemCount: PaymentSelection.values.length,
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
                            PaymentSelection.values[index],
                          ),
                        ),
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
    PaymentSelection selection,
  ) =>
      GestureDetector(
        onTap: () => completer(
          SheetResponse<PaymentSelection>(
            confirmed: true,
            data: selection,
          ),
        ),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: greyBackGroundColor(context: context),
            borderRadius: BorderRadius.circular(10),
          ),
          child: PaddingWidget.applySymmetricPadding(
            vertical: 15,
            horizontal: 20,
            child: Row(
              children: <Widget>[
                Image.asset(
                  selection.sectionImagePath,
                  width: 50,
                  height: 50,
                ),
                horizontalSpaceSmall,
                Text(
                  selection.titleText,
                  style: bodyNormalTextStyle(
                    context: context,
                    fontColor: titleTextColor(context: context),
                  ),
                ),
              ],
            ),
          ),
        ),
      );

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
        ObjectFlagProperty<Function(SheetResponse<PaymentSelection> p1)>.has(
          "completer",
          completer,
        ),
      );
  }
}
