import "package:easy_localization/easy_localization.dart";
import "package:esim_open_source/app/environment/app_environment.dart";
import "package:esim_open_source/app/environment/environment_images.dart";
import "package:esim_open_source/presentation/enums/login_type.dart";
import "package:esim_open_source/presentation/setup_bottom_sheet_ui.dart";
import "package:esim_open_source/presentation/shared/shared_styles.dart";
import "package:esim_open_source/presentation/shared/ui_helpers.dart";
import "package:esim_open_source/presentation/views/base/base_view.dart";
import "package:esim_open_source/presentation/views/bottom_sheet/delete_account_bottom_sheet/delete_account_bottom_sheet_view_model.dart";
import "package:esim_open_source/presentation/widgets/bottom_sheet_close_button.dart";
import "package:esim_open_source/presentation/widgets/main_button.dart";
import "package:esim_open_source/presentation/widgets/main_input_field.dart";
import "package:esim_open_source/presentation/widgets/my_phone_input.dart";
import "package:esim_open_source/presentation/widgets/padding_widget.dart";
import "package:esim_open_source/translations/locale_keys.g.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart";
import "package:stacked_services/stacked_services.dart";

class DeleteAccountBottomSheet extends StatelessWidget {
  const DeleteAccountBottomSheet({
    required this.completer,
    required this.requestBase,
    super.key,
  });
  final SheetRequest<dynamic> requestBase;
  final Function(SheetResponse<EmptyBottomSheetResponse>) completer;

  @override
  Widget build(BuildContext context) {
    return BaseView.bottomSheetBuilder(
      viewModel: DeleteAccountBottomSheetViewModel(),
      builder: (
        BuildContext context,
        DeleteAccountBottomSheetViewModel viewModel,
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
                    horizontal: 15,
                    child: Column(
                      children: <Widget>[
                        BottomSheetCloseButton(
                          onTap: () => completer(
                            SheetResponse<EmptyBottomSheetResponse>(),
                          ),
                        ),
                        Image.asset(
                          EnvironmentImages.deleteAccountIcon.fullImagePath,
                          width: 80,
                          height: 80,
                        ),
                        verticalSpaceMediumLarge,
                        Text(
                          LocaleKeys.deleteAccount_titleText.tr(),
                          style: headerThreeMediumTextStyle(
                            context: context,
                            fontColor: mainDarkTextColor(context: context),
                          ),
                        ),
                        verticalSpaceMediumLarge,
                        Text(
                          LocaleKeys.deleteAccount_ContentText.tr(),
                          textAlign: TextAlign.center,
                          style: bodyNormalTextStyle(
                            context: context,
                            fontColor: secondaryTextColor(context: context),
                          ),
                        ),
                        verticalSpaceMediumLarge,
                        Text(
                          AppEnvironment.appEnvironmentHelper.loginType ==
                                  LoginType.phoneNumber
                              ? LocaleKeys.deleteAccount_ConfirmTextPhone.tr()
                              : LocaleKeys.deleteAccount_ConfirmText.tr(),
                          textAlign: TextAlign.center,
                          style: bodyNormalTextStyle(
                            context: context,
                            fontColor: secondaryTextColor(context: context),
                          ),
                        ),
                        verticalSpaceMediumLarge,
                        AppEnvironment.appEnvironmentHelper.loginType ==
                                LoginType.phoneNumber
                            ? MyPhoneInput(
                                onChanged: (
                                  String code,
                                  String phoneNumber, {
                                  required bool isValid,
                                }) {
                                  viewModel.validateNumber(
                                    code: code,
                                    phoneNumber: phoneNumber,
                                    isValid: isValid,
                                  );
                                },
                                phoneController: viewModel.phoneController,
                                validateRequired: true,
                              )
                            : MainInputField.formField(
                                themeColor: themeColor,
                                errorMessage: viewModel.emailErrorMessage,
                                labelTitleText: LocaleKeys
                                    .deleteAccount_placeHolderText
                                    .tr(),
                                controller: viewModel.emailController,
                                textInputType: TextInputType.emailAddress,
                                backGroundColor:
                                    mainWhiteTextColor(context: context),
                                labelStyle: bodyNormalTextStyle(
                                  context: context,
                                  fontColor:
                                      mainDarkTextColor(context: context),
                                ),
                              ),
                        verticalSpaceMediumLarge,
                        MainButton(
                          title: LocaleKeys.deleteAccount_buttonText.tr(),
                          titleTextStyle: bodyBoldTextStyle(context: context),
                          onPressed: () async {
                            await viewModel.deleteAccountButtonTapped();
                            completer(
                              SheetResponse<EmptyBottomSheetResponse>(
                                confirmed: true,
                              ),
                            );
                          },
                          themeColor: themeColor,
                          height: 53,
                          hideShadows: true,
                          isEnabled: viewModel.isButtonEnabled,
                          enabledTextColor:
                              enabledMainButtonTextColor(context: context),
                          disabledTextColor:
                              disabledMainButtonTextColor(context: context),
                          disabledBackgroundColor:
                              disabledMainButtonColor(context: context),
                        ),
                        verticalSpaceSmall,
                        MainButton.onlyText(
                          title: LocaleKeys.common_cancelButtonText.tr(),
                          titleTextStyle: bodyMediumTextStyle(
                            context: context,
                            fontColor: mainDarkTextColor(context: context),
                          ),
                          hideShadows: true,
                          onPressed: () => completer(
                            SheetResponse<EmptyBottomSheetResponse>(),
                          ),
                          themeColor: themeColor,
                          enabledTextColor: mainDarkTextColor(context: context),
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
