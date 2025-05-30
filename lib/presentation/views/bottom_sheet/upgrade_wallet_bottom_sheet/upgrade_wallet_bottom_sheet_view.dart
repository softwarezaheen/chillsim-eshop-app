import "package:easy_localization/easy_localization.dart";
import "package:esim_open_source/presentation/setup_bottom_sheet_ui.dart";
import "package:esim_open_source/presentation/shared/shared_styles.dart";
import "package:esim_open_source/presentation/shared/ui_helpers.dart";
import "package:esim_open_source/presentation/views/base/base_view.dart";
import "package:esim_open_source/presentation/views/bottom_sheet/upgrade_wallet_bottom_sheet/upgrade_wallet_bottom_sheet_view_model.dart";
import "package:esim_open_source/presentation/widgets/bottom_sheet_close_button.dart";
import "package:esim_open_source/presentation/widgets/main_button.dart";
import "package:esim_open_source/presentation/widgets/main_input_field.dart";
import "package:esim_open_source/presentation/widgets/padding_widget.dart";
import "package:esim_open_source/translations/locale_keys.g.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart";
import "package:stacked_services/stacked_services.dart";

class UpgradeWalletBottomSheetView extends StatelessWidget {
  const UpgradeWalletBottomSheetView({
    required this.completer,
    required this.requestBase,
    super.key,
  });
  final SheetRequest<dynamic> requestBase;
  final Function(SheetResponse<EmptyBottomSheetResponse>) completer;

  @override
  Widget build(BuildContext context) {
    return BaseView.bottomSheetBuilder(
      viewModel: UpgradeWalletBottomSheetViewModel(
        completer: completer,
      ),
      builder: (
        BuildContext context,
        UpgradeWalletBottomSheetViewModel viewModel,
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
                            SheetResponse<EmptyBottomSheetResponse>(),
                          ),
                        ),
                        Text(
                          LocaleKeys.myWallet_upgradeSectionText.tr(),
                          style: headerThreeMediumTextStyle(
                            context: context,
                            fontColor: mainDarkTextColor(context: context),
                          ),
                        ),
                        verticalSpaceSmallMedium,
                        Text(
                          LocaleKeys.upgradeWallet_contentText.tr(),
                          textAlign: TextAlign.center,
                          style: bodyNormalTextStyle(
                            context: context,
                            fontColor: secondaryTextColor(context: context),
                          ),
                        ),
                        verticalSpaceMedium,
                        MainInputField.formField(
                          themeColor: themeColor,
                          labelTitleText:
                              LocaleKeys.upgradeWallet_hintText.tr(),
                          controller: viewModel.amountController,
                          textInputType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          backGroundColor: mainWhiteTextColor(context: context),
                          labelStyle: bodyNormalTextStyle(
                            context: context,
                            fontColor: mainDarkTextColor(context: context),
                          ),
                        ),
                        verticalSpaceMediumLarge,
                        MainButton(
                          title: LocaleKeys.upgradeWallet_buttonTextText.tr(),
                          titleTextStyle: bodyBoldTextStyle(context: context),
                          onPressed: () async {
                            await viewModel.upgradeButtonTapped();
                          },
                          themeColor: themeColor,
                          isEnabled: viewModel.upgradeButtonEnabled,
                          height: 53,
                          hideShadows: true,
                          enabledTextColor:
                              enabledMainButtonTextColor(context: context),
                          disabledTextColor:
                              disabledMainButtonTextColor(context: context),
                          disabledBackgroundColor:
                              disabledMainButtonColor(context: context),
                        ),
                        verticalSpaceMedium,
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
