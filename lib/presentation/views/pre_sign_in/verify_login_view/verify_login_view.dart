import "package:easy_localization/easy_localization.dart";
import "package:esim_open_source/app/environment/environment_images.dart";
import "package:esim_open_source/presentation/extensions/context_extension.dart";
import "package:esim_open_source/presentation/shared/shared_styles.dart";
import "package:esim_open_source/presentation/shared/ui_helpers.dart";
import "package:esim_open_source/presentation/views/base/base_view.dart";
import "package:esim_open_source/presentation/views/pre_sign_in/verify_login_view/verify_login_view_model.dart";
import "package:esim_open_source/presentation/widgets/main_button.dart";
import "package:esim_open_source/presentation/widgets/otp_text_field.dart";
import "package:esim_open_source/presentation/widgets/padding_widget.dart";
import "package:esim_open_source/translations/locale_keys.g.dart";
import "package:flutter/foundation.dart";
import "package:flutter/gestures.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";

class VerifyLoginView extends StatelessWidget {
  const VerifyLoginView({
    required this.emailAddress,
    super.key,
  });
  final String emailAddress;
  static const String routeName = "VerifyLoginView";

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
    return BaseView<VerifyLoginViewModel>(
      routeName: routeName,
      hideAppBar: true,
      viewModel: VerifyLoginViewModel(
        emailAddress: emailAddress,
      ),
      builder: (
        BuildContext context,
        VerifyLoginViewModel viewModel,
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
                  onTap: viewModel.navigationService.back,
                  child: Image.asset(
                    EnvironmentImages.navBackIcon.fullImagePath,
                    width: 25,
                    height: 25,
                  ),
                ),
              ),
              verticalSpaceMediumLarge,
              Text(
                LocaleKeys.verifyLogin_titleText.tr(),
                style: headerTwoMediumTextStyle(
                  context: context,
                  fontColor: titleTextColor(context: context),
                ),
              ),
              verticalSpaceSmall,
              Text(
                LocaleKeys.verifyLogin_contentText.tr(),
                textAlign: TextAlign.center,
                style: bodyNormalTextStyle(
                  context: context,
                  fontColor: secondaryTextColor(context: context),
                ),
              ),
              verticalSpaceLarge,
              Column(
                children: <Widget>[
                  OtpTextField(
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
                title: LocaleKeys.verifyLogin_buttonTitleText.tr(),
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
    VerifyLoginViewModel viewModel,
  ) {
    return Text.rich(
      textAlign: TextAlign.center,
      TextSpan(
        text: LocaleKeys.verifyLogin_checkEmail.tr(),
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
    properties.add(StringProperty("emailAddress", emailAddress));
  }
}
