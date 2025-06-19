import "package:easy_localization/easy_localization.dart";
import "package:esim_open_source/app/environment/environment_images.dart";
import "package:esim_open_source/presentation/extensions/context_extension.dart";
import "package:esim_open_source/presentation/shared/shared_styles.dart";
import "package:esim_open_source/presentation/shared/ui_helpers.dart";
import "package:esim_open_source/presentation/views/base/base_view.dart";
import "package:esim_open_source/presentation/views/pre_sign_in/continue_with_email_view/continue_with_email_view_model.dart";
import "package:esim_open_source/presentation/widgets/main_button.dart";
import "package:esim_open_source/presentation/widgets/main_input_field.dart";
import "package:esim_open_source/presentation/widgets/padding_widget.dart";
import "package:esim_open_source/translations/locale_keys.g.dart";
import "package:flutter/foundation.dart";
import "package:flutter/gestures.dart";
import "package:flutter/material.dart";
import "package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart";

class ContinueWithEmailView extends StatelessWidget {
  const ContinueWithEmailView({super.key, this.overrideViewModel});

  final ContinueWithEmailViewModel? overrideViewModel;

  static const String routeName = "ContinueWithEmailView";

  @override
  Widget build(BuildContext context) {
    return BaseView<ContinueWithEmailViewModel>(
      routeName: routeName,
      hideAppBar: true,
      viewModel: overrideViewModel ?? ContinueWithEmailViewModel(),
      builder: (
        BuildContext context,
        ContinueWithEmailViewModel viewModel,
        Widget? child,
        double screenHeight,
      ) =>
          KeyboardDismissOnTap(
        child: SingleChildScrollView(
          child: PaddingWidget.applySymmetricPadding(
            vertical: 10,
            horizontal: 20,
            child: SizedBox(
              height: screenHeight,
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: viewModel.backButtonTapped,
                      child: Image.asset(
                        EnvironmentImages.navBackIcon.fullImagePath,
                        width: 25,
                        height: 25,
                      ),
                    ),
                  ),
                  Image.asset(
                    EnvironmentImages.darkAppIcon.fullImagePath,
                    width: screenWidth(context) / 2,
                    fit: BoxFit.fitWidth,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        LocaleKeys.continueWithEmailView_titleText.tr(),
                        style: headerTwoMediumTextStyle(
                          context: context,
                          fontColor: titleTextColor(context: context),
                        ),
                      ),
                      verticalSpaceSmall,
                      Text(
                        LocaleKeys.continueWithEmailView_SubTitleText.tr(),
                        style: bodyNormalTextStyle(
                          context: context,
                          fontColor: secondaryTextColor(context: context),
                        ),
                      ),
                      verticalSpace(90),
                      MainInputField.formField(
                        themeColor: themeColor,
                        labelTitleText: LocaleKeys
                            .continueWithEmailView_emailTitleField
                            .tr(),
                        hintText: LocaleKeys
                            .continueWithEmailView_emailPlaceholder
                            .tr(),
                        controller: viewModel.state?.emailController ??
                            TextEditingController(),
                        textInputType: TextInputType.emailAddress,
                        errorMessage: viewModel.state?.emailErrorMessage,
                        backGroundColor: context.appColors.baseWhite,
                        labelStyle: bodyNormalTextStyle(
                          context: context,
                          fontColor: secondaryTextColor(context: context),
                        ),
                      ),
                      verticalSpaceMediumLarge,
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
                                  (viewModel.state?.isTermsChecked ?? false)
                                      ? EnvironmentImages
                                          .checkBoxSelected.fullImagePath
                                      : EnvironmentImages
                                          .checkBoxUnselected.fullImagePath,
                                ),
                              ),
                            ),
                            //horizontalSpaceSmall,
                            Expanded(
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: termsAndConditionTappableWidget(
                                  context,
                                  viewModel,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      verticalSpaceLarge,
                      MainButton(
                        title: LocaleKeys.continueWithEmailView_titleText.tr(),
                        onPressed: () async {
                          viewModel.loginButtonTapped();
                        },
                        themeColor: themeColor,
                        height: 53,
                        hideShadows: true,
                        isEnabled: viewModel.state?.isLoginEnabled ?? false,
                        enabledTextColor:
                            enabledMainButtonTextColor(context: context),
                        disabledTextColor:
                            disabledMainButtonTextColor(context: context),
                        disabledBackgroundColor:
                            disabledMainButtonColor(context: context),
                        enabledBackgroundColor:
                            enabledMainButtonColor(context: context),
                      ),
                    ],
                  ),
                  const SizedBox.shrink(),
                  const SizedBox.shrink(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget termsAndConditionTappableWidget(
    BuildContext context,
    ContinueWithEmailViewModel viewModel,
  ) {
    return Text.rich(
      textAlign: TextAlign.center,
      TextSpan(
        text: LocaleKeys.continueWithEmailView_acceptTerms.tr(),
        style: captionOneMediumTextStyle(
          context: context,
          fontColor: titleTextColor(context: context),
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
    properties.add(
      DiagnosticsProperty<ContinueWithEmailViewModel?>(
        "overrideViewModel",
        overrideViewModel,
      ),
    );
  }
}
