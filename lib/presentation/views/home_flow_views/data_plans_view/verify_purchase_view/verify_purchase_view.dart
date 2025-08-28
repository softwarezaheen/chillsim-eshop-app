import "package:easy_localization/easy_localization.dart" as loc;
import "package:esim_open_source/app/app.locator.dart";
import "package:esim_open_source/app/environment/app_environment.dart";
import "package:esim_open_source/app/environment/environment_images.dart";
import "package:esim_open_source/presentation/enums/login_type.dart";
import "package:esim_open_source/presentation/extensions/context_extension.dart";
import "package:esim_open_source/presentation/extensions/helper_extensions.dart";
import "package:esim_open_source/presentation/shared/shared_styles.dart";
import "package:esim_open_source/presentation/shared/ui_helpers.dart";
import "package:esim_open_source/presentation/views/base/base_view.dart";
import "package:esim_open_source/presentation/views/home_flow_views/data_plans_view/verify_purchase_view/verify_purchase_view_model.dart";
import "package:esim_open_source/presentation/widgets/main_button.dart";
import "package:esim_open_source/presentation/widgets/otp_text_field.dart";
import "package:esim_open_source/presentation/widgets/padding_widget.dart";
import "package:esim_open_source/translations/locale_keys.g.dart";
import "package:flutter/foundation.dart";
import "package:flutter/gestures.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";

class VerifyPurchaseViewArgs {
  VerifyPurchaseViewArgs({
    required this.iccid,
    required this.orderID,
  });
  final String iccid;
  final String orderID;
}

class VerifyPurchaseView extends StatelessWidget {
  const VerifyPurchaseView({
    required this.args,
    super.key,
  });
  final VerifyPurchaseViewArgs args;

  static const String routeName = "VerifyPurchaseView";

  double calculateFieldWidth({
    required BuildContext context,
    double maximumSize = 60,
  }) {
    double availableSpace =
        MediaQuery.of(context).size.width - (2 * 15) - (6 * 10);
    double singleSize = availableSpace / 6;
    if (singleSize > maximumSize) {
      return maximumSize;
    }
    return singleSize;
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<VerifyPurchaseViewModel>(
      routeName: routeName,
      hideAppBar: true,
      viewModel: locator<VerifyPurchaseViewModel>()
        ..iccid = args.iccid
        ..orderID = args.orderID,
      builder: (
        BuildContext context,
        VerifyPurchaseViewModel viewModel,
        Widget? childWidget,
        double screenHeight,
      ) =>
          PaddingWidget.applySymmetricPadding(
        horizontal: 15,
        child: SizedBox.expand(
          child: Column(
            children: <Widget>[
              Align(
                alignment: Alignment.centerLeft,
                child: GestureDetector(
                  onTap: () => viewModel.navigationService.back(result: false),
                  child: Image.asset(
                    EnvironmentImages.navBackIcon.fullImagePath,
                    width: 25,
                    height: 25,
                  ),
                ).imageSupportsRTL(context).textSupportsRTL(context),
              ),
              verticalSpaceMediumLarge,
              Text(
                LocaleKeys.verifyOrderOtp_titleText.tr(),
                style: headerTwoMediumTextStyle(
                  context: context,
                  fontColor: mainDarkTextColor(context: context),
                ),
              ),
              verticalSpaceSmall,
              Text(
                LocaleKeys.verifyOrderOtp_contentText.tr(),
                textAlign: TextAlign.center,
                style: bodyNormalTextStyle(
                  context: context,
                  fontColor: secondaryTextColor(context: context),
                ),
              ),
              verticalSpaceLarge,
              Column(
                children: <Widget>[
                  Directionality(
                    textDirection: TextDirection.ltr,
                    child: OtpTextField(
                      borderWidth: 1,
                      numberOfFields: 6,
                      showFieldAsBox: true,
                      contentPadding: EdgeInsets.zero,
                      borderRadius: BorderRadius.circular(8),
                      fieldWidth: calculateFieldWidth(context: context),
                      focusedBorderColor: viewModel.errorMessage.isEmpty
                          ? context.appColors.grey_200!
                          : context.appColors.error_500!,
                      enabledBorderColor: viewModel.errorMessage.isEmpty
                          ? context.appColors.grey_200!
                          : context.appColors.error_500!,
                      textStyle:
                          headerZeroMediumTextStyle(context: context).copyWith(
                        color: viewModel.errorMessage.isEmpty
                            ? context.appColors.baseBlack
                            : context.appColors.error_500,
                      ),
                      onCodeChanged: viewModel.otpFieldChanged,
                      onSubmit: (String verificationCode) async {
                        viewModel.otpFieldSubmitted(verificationCode);
                      },
                      initialCode: viewModel.initialVerificationCode,
                    ),
                  ),
                  verticalSpaceSmall,
                  Text(
                    viewModel.errorMessage,
                    style: captionOneNormalTextStyle(
                      context: context,
                      fontColor: errorTextColor(context: context),
                    ),
                  ),
                ],
              ),
              verticalSpaceLarge,
              MainButton(
                title: LocaleKeys.verifyLogin_buttonTitleTextPhone.tr(),
                onPressed: () async {
                  viewModel.verifyButtonTapped();
                },
                themeColor: themeColor,
                height: 53,
                hideShadows: true,
                isEnabled: viewModel.isVerifyButtonEnabled,
                enabledTextColor: enabledMainButtonTextColor(context: context),
                disabledTextColor:
                    disabledMainButtonTextColor(context: context),
                enabledBackgroundColor:
                    enabledMainButtonColor(context: context),
                disabledBackgroundColor:
                    disabledMainButtonColor(context: context),
              ),
              verticalSpaceMediumLarge,
              resendCodeTappableWidget(
                context,
                viewModel,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget resendCodeTappableWidget(
    BuildContext context,
    VerifyPurchaseViewModel viewModel,
  ) {
    return Text.rich(
      textAlign: TextAlign.center,
      TextSpan(
        text: AppEnvironment.appEnvironmentHelper.loginType ==
                LoginType.phoneNumber
            ? LocaleKeys.verifyLogin_checkPhone.tr()
            : LocaleKeys.verifyLogin_checkEmail.tr(),
        style: captionOneNormalTextStyle(
          context: context,
          fontColor: secondaryTextColor(context: context),
        ),
        children: <TextSpan>[
          TextSpan(
            text: LocaleKeys.verifyLogin_resendCode.tr(),
            style: captionOneMediumTextStyle(
              context: context,
              fontColor: hyperLinkColor(context: context),
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () async {
                viewModel.resendCodeButtonTapped();
              },
          ),
        ],
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<VerifyPurchaseViewArgs>("args", args));
  }
}
