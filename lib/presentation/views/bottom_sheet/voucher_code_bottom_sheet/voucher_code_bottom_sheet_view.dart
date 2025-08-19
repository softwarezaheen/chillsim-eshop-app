import "package:easy_localization/easy_localization.dart";
import "package:esim_open_source/app/environment/environment_images.dart";
import "package:esim_open_source/presentation/setup_bottom_sheet_ui.dart";
import "package:esim_open_source/presentation/shared/shared_styles.dart";
import "package:esim_open_source/presentation/shared/ui_helpers.dart";
import "package:esim_open_source/presentation/views/base/base_view.dart";
import "package:esim_open_source/presentation/views/bottom_sheet/voucher_code_bottom_sheet/voucher_code_bottom_sheet_view_model.dart";
import "package:esim_open_source/presentation/widgets/bottom_sheet_close_button.dart";
import "package:esim_open_source/presentation/widgets/main_button.dart";
import "package:esim_open_source/presentation/widgets/main_input_field.dart";
import "package:esim_open_source/presentation/widgets/padding_widget.dart";
import "package:esim_open_source/translations/locale_keys.g.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:stacked_services/stacked_services.dart";

class VoucherCodeBottomSheetView extends StatelessWidget {
  const VoucherCodeBottomSheetView({
    required this.completer,
    required this.requestBase,
    super.key,
  });

  final SheetRequest<dynamic> requestBase;
  final Function(SheetResponse<EmptyBottomSheetResponse>) completer;

  @override
  Widget build(BuildContext context) {
    return BaseView.bottomSheetBuilder(
      viewModel: VoucherCodeBottomSheetViewModel(
        completer: completer,
      ),
      builder: (
        BuildContext context,
        VoucherCodeBottomSheetViewModel viewModel,
        Widget? childWidget,
        double screenHeight,
      ) =>
          SizedBox(
        width: screenWidth(context),
        child: PaddingWidget.applySymmetricPadding(
          vertical: 15,
          horizontal: 25,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              BottomSheetCloseButton(
                onTap: () => completer(
                  SheetResponse<EmptyBottomSheetResponse>(),
                ),
              ),
              Text(
                LocaleKeys.voucherCode_titleText.tr(),
                style: headerThreeMediumTextStyle(
                  context: context,
                  fontColor: titleTextColor(context: context),
                ),
              ),
              verticalSpaceSmallMedium,
              Text(
                LocaleKeys.voucherCode_contentText.tr(),
                textAlign: TextAlign.center,
                style: bodyNormalTextStyle(
                  context: context,
                  fontColor: contentTextColor(context: context),
                ),
              ),
              verticalSpaceMedium,
              MainInputField(
                themeColor: themeColor,
                controller: viewModel.voucherCodeController,
                labelTitleText: LocaleKeys.voucherCode_placeHolderText.tr(),
                textInputType: TextInputType.emailAddress,
                backgroundColor: mainWhiteTextColor(context: context),
                suffixIcon: GestureDetector(
                  onTap: () async {
                    viewModel.scanVoucherCode();
                  },
                  child: Image.asset(
                    EnvironmentImages.scanPromoCode.fullImagePath,
                    width: 24,
                    height: 24,
                  ),
                ),
              ),
              verticalSpaceMediumLarge,
              MainButton(
                title: LocaleKeys.voucherCode_buttonText.tr(),
                onPressed: () async => viewModel.redeemVoucher(),
                height: 53,
                hideShadows: true,
                themeColor: themeColor,
                isEnabled: viewModel.isButtonEnabled,
                enabledTextColor: enabledMainButtonTextColor(context: context),
                disabledTextColor:
                    disabledMainButtonTextColor(context: context),
                enabledBackgroundColor:
                    enabledMainButtonColor(context: context),
                disabledBackgroundColor:
                    disabledMainButtonColor(context: context),
              ),
              verticalSpaceMedium,
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
        ObjectFlagProperty<
            Function(SheetResponse<EmptyBottomSheetResponse> p1)>.has(
          "completer",
          completer,
        ),
      );
  }
}
