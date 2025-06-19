import "package:easy_localization/easy_localization.dart";
import "package:esim_open_source/app/environment/app_environment.dart";
import "package:esim_open_source/app/environment/environment_images.dart";
import "package:esim_open_source/data/remote/responses/bundles/bundle_response_model.dart";
import "package:esim_open_source/data/remote/responses/bundles/country_response_model.dart";
import "package:esim_open_source/presentation/setup_bottom_sheet_ui.dart";
import "package:esim_open_source/presentation/shared/shared_styles.dart";
import "package:esim_open_source/presentation/shared/ui_helpers.dart";
import "package:esim_open_source/presentation/views/base/base_view.dart";
import "package:esim_open_source/presentation/views/bottom_sheet/bundle_details_bottom_sheet/bundle_detail_bottom_sheet_view_model.dart";
import "package:esim_open_source/presentation/widgets/apply_promo_code_view.dart";
import "package:esim_open_source/presentation/widgets/bottom_sheet_close_button.dart";
import "package:esim_open_source/presentation/widgets/bundle_header_view.dart";
import "package:esim_open_source/presentation/widgets/bundle_title_content_view.dart";
import "package:esim_open_source/presentation/widgets/bundle_validity_view.dart";
import "package:esim_open_source/presentation/widgets/divider_line.dart";
import "package:esim_open_source/presentation/widgets/main_button.dart";
import "package:esim_open_source/presentation/widgets/main_input_field.dart";
import "package:esim_open_source/presentation/widgets/padding_widget.dart";
import "package:esim_open_source/presentation/widgets/supported_countries_card.dart";
import "package:esim_open_source/presentation/widgets/unlimited_data_widget.dart";
import "package:esim_open_source/translations/locale_keys.g.dart";
import "package:flutter/foundation.dart";
import "package:flutter/gestures.dart";
import "package:flutter/material.dart";
import "package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart";
import "package:stacked_services/stacked_services.dart";

class BundleDetailBottomSheetView extends StatelessWidget {
  const BundleDetailBottomSheetView({
    required this.requestBase,
    required this.completer,
    super.key,
  });

  final SheetRequest<PurchaseBundleBottomSheetArgs> requestBase;
  final Function(SheetResponse<EmptyBottomSheetResponse>) completer;

  @override
  Widget build(BuildContext context) {
    return BaseView.bottomSheetBuilder(
      viewModel: BundleDetailBottomSheetViewModel(
        region: requestBase.data?.region,
        countries: requestBase.data?.countries,
        bundle: requestBase.data?.bundleResponseModel,
      ),
      builder: (
        BuildContext context,
        BundleDetailBottomSheetViewModel viewModel,
        Widget? childWidget,
        double screenHeight,
      ) {
        final BundleResponseModel? bundle = viewModel.bundle;
        return KeyboardDismissOnTap(
          child: PaddingWidget.applySymmetricPadding(
            vertical: 15,
            horizontal: 15,
            child: SizedBox(
              height: screenHeight,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  BottomSheetCloseButton(
                    onTap: () => completer(
                      SheetResponse<EmptyBottomSheetResponse>(),
                    ),
                  ),
                  SizedBox(
                    height: screenHeight -
                        100 -
                        (viewModel.isKeyboardVisible(context) ? 250 : 0),
                    child: SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          BundleHeaderView(
                            imagePath: bundle?.icon,
                            title: bundle?.displayTitle ?? "",
                            subTitle: bundle?.displaySubtitle ?? "",
                            dataValue: "",
                            countryPrice: "",
                            hasNavArrow: false,
                            isLoading: false,
                            showUnlimitedData: false,
                          ),
                          const DividerLine(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              (bundle?.unlimited ?? false)
                                  ? const UnlimitedDataWidget()
                                  : Text(
                                      bundle?.gprsLimitDisplay ?? "",
                                      style: headerTwoMediumTextStyle(
                                        context: context,
                                        fontColor: bundleDataPriceTextColor(
                                          context: context,
                                        ),
                                      ),
                                    ),
                              Text(
                                bundle?.priceDisplay ?? "",
                                style: headerTwoMediumTextStyle(
                                  context: context,
                                  fontColor: bundleDataPriceTextColor(
                                    context: context,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const DividerLine(),
                          BundleValidityView(
                            bundleValidity: bundle?.validityDisplay ?? "",
                            bundleExpiryDate: "",
                          ),
                          verticalSpaceSmall,
                          if (bundle?.bundleCategory?.type?.toLowerCase() !=
                                  AppEnvironment
                                      .appEnvironmentHelper.cruiseIdentifier &&
                              (bundle?.countries?.isNotEmpty ?? false))
                            SupportedCountriesCard(
                              countries:
                                  bundle?.countries ?? <CountryResponseModel>[],
                            ),
                          if (viewModel.isPromoCodeEnabled &&
                              viewModel.isUserLoggedIn)
                            PaddingWidget.applySymmetricPadding(
                              vertical: 10,
                              child: ApplyPromoCode(
                                callback: viewModel.validatePromoCode,
                                message: viewModel.promoCodeMessage,
                                isFieldEnabled: viewModel.promoCodeFieldEnabled,
                                textFieldBorderColor:
                                    viewModel.promoCodeFieldColor ??
                                        greyBackGroundColor(context: context),
                                textFieldIcon: viewModel.promoCodeFieldIcon,
                                buttonText: viewModel.promoCodeButtonText,
                                controller: viewModel.promoCodeController,
                                isExpanded: viewModel.isPromoCodeExpanded,
                                expandedCallBack: viewModel.expandedCallBack,
                              ),
                            ),
                          BundleTitleContentView(
                            titleText:
                                LocaleKeys.bundleDetails_planTypeText.tr(),
                            contentText: bundle?.planType ?? "",
                          ),
                          const DividerLine(
                            verticalPadding: 0,
                          ),
                          BundleTitleContentView(
                            titleText: LocaleKeys
                                .bundleDetails_activationPolicyText
                                .tr(),
                            contentText: bundle?.activityPolicy ?? "",
                          ),
                          if (!viewModel.isUserLoggedIn)
                            PaddingWidget.applySymmetricPadding(
                              horizontal: 5,
                              child: Column(
                                children: <Widget>[
                                  MainInputField.formField(
                                    textFieldHeight: 50,
                                    themeColor: themeColor,
                                    labelTitleText: LocaleKeys
                                        .continueWithEmailView_emailTitleField
                                        .tr(),
                                    hintText: LocaleKeys
                                        .continueWithEmailView_emailPlaceholder
                                        .tr(),
                                    controller: viewModel.emailController,
                                    textInputType: TextInputType.emailAddress,
                                    errorMessage: viewModel.emailErrorMessage,
                                    backGroundColor:
                                        whiteBackGroundColor(context: context),
                                    labelStyle: bodyNormalTextStyle(
                                      context: context,
                                      fontColor:
                                          secondaryTextColor(context: context),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      viewModel.updateTermsSelections();
                                    },
                                    child: Row(
                                      children: <Widget>[
                                        Align(
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                              right: 10,
                                              bottom: 10,
                                              top: 10,
                                            ),
                                            child: Image.asset(
                                              width: 17,
                                              viewModel.isTermsChecked
                                                  ? EnvironmentImages
                                                      .checkBoxSelected
                                                      .fullImagePath
                                                  : EnvironmentImages
                                                      .checkBoxUnselected
                                                      .fullImagePath,
                                            ),
                                          ),
                                        ),
                                        horizontalSpaceSmall,
                                        termsAndConditionTappableWidget(
                                          context,
                                          viewModel,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          verticalSpaceSmallMedium,
                        ],
                      ),
                    ),
                  ),
                  viewModel.isKeyboardVisible(context)
                      ? const SizedBox.shrink()
                      : const Spacer(),
                  MainButton(
                    hideShadows: true,
                    themeColor: themeColor,
                    onPressed: () async => viewModel.buyNowPressed(context),
                    isEnabled: viewModel.isPurchaseButtonEnabled,
                    title: LocaleKeys.bundleInfo_priceText.tr(
                      namedArgs: <String, String>{
                        "price": viewModel.bundle?.priceDisplay ?? "",
                      },
                    ),
                    enabledTextColor:
                        enabledMainButtonTextColor(context: context),
                    enabledBackgroundColor:
                        enabledMainButtonColor(context: context),
                    disabledTextColor:
                        disabledMainButtonTextColor(context: context),
                    disabledBackgroundColor:
                        disabledMainButtonColor(context: context),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget termsAndConditionTappableWidget(
    BuildContext context,
    BundleDetailBottomSheetViewModel viewModel,
  ) {
    return Text.rich(
      textAlign: TextAlign.center,
      TextSpan(
        text: LocaleKeys.continueWithEmailView_acceptTerms.tr(),
        style: captionOneMediumTextStyle(
          context: context,
          fontColor: mainDarkTextColor(context: context),
        ),
        children: <TextSpan>[
          TextSpan(
            text: LocaleKeys.continueWithEmailView_termsText.tr(),
            style: captionOneMediumTextStyle(context: context).copyWith(
              fontSize: 14,
              color: hyperLinkColor(context: context),
              decoration: TextDecoration.underline,
              decorationColor: hyperLinkColor(context: context),
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () async {
                viewModel.showTermsSheet();
              },
          ),
        ],
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(
        ObjectFlagProperty<
            Function(SheetResponse<EmptyBottomSheetResponse> p1)>.has(
          "completer",
          completer,
        ),
      )
      ..add(
        DiagnosticsProperty<SheetRequest<PurchaseBundleBottomSheetArgs>>(
          "requestBase",
          requestBase,
        ),
      );
  }
}
