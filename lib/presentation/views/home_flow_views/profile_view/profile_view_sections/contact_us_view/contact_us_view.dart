import "package:easy_localization/easy_localization.dart";
import "package:esim_open_source/di/locator.dart";
import "package:esim_open_source/presentation/shared/shared_styles.dart";
import "package:esim_open_source/presentation/shared/ui_helpers.dart";
import "package:esim_open_source/presentation/views/base/base_view.dart";
import "package:esim_open_source/presentation/views/home_flow_views/profile_view/profile_view_sections/contact_us_view/contact_us_view_model.dart";
import "package:esim_open_source/presentation/widgets/common_navigation_title.dart";
import "package:esim_open_source/presentation/widgets/main_button.dart";
import "package:esim_open_source/presentation/widgets/main_input_field.dart";
import "package:esim_open_source/presentation/widgets/padding_widget.dart";
import "package:esim_open_source/translations/locale_keys.g.dart";
import "package:flutter/material.dart";
import "package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart";

class ContactUsView extends StatelessWidget {
  const ContactUsView({super.key});
  static const String routeName = "ContactUsView";

  @override
  Widget build(BuildContext context) {
    return BaseView<ContactUsViewModel>(
      hideAppBar: true,
      routeName: routeName,
      viewModel: locator<ContactUsViewModel>(),
      builder: (
        BuildContext context,
        ContactUsViewModel viewModel,
        Widget? childWidget,
        double screenHeight,
      ) =>
          PaddingWidget.applyPadding(
        top: 20,
        child: Column(
          children: <Widget>[
            CommonNavigationTitle(
              navigationTitle: LocaleKeys.contactUs_titleText.tr(),
              textStyle: headerTwoBoldTextStyle(
                context: context,
                fontColor: mainDarkTextColor(context: context),
              ),
            ),
            verticalSpaceSmallMedium,
            Expanded(
              child: KeyboardDismissOnTap(
                child: SingleChildScrollView(
                  child: SizedBox(
                    height: screenHeight + 20,
                    child: PaddingWidget.applySymmetricPadding(
                      horizontal: 15,
                      child: Column(
                        children: <Widget>[
                          Text(
                            LocaleKeys.contactUs_contentText.tr(),
                            style: bodyNormalTextStyle(
                              context: context,
                              fontColor: secondaryTextColor(context: context),
                            ),
                          ),
                          verticalSpaceMedium,
                          MainInputField.formField(
                            errorMessage: viewModel.emailErrorMessage,
                            controller: viewModel.state.emailController,
                            themeColor: themeColor,
                            labelTitleText:
                                LocaleKeys.contactUs_emailPlaceHolderText.tr(),
                            labelStyle: bodyNormalTextStyle(
                              context: context,
                              fontColor: mainDarkTextColor(context: context),
                            ),
                            backGroundColor:
                                whiteBackGroundColor(context: context),
                          ),
                          verticalSpaceMedium,
                          MainInputField.formField(
                            maxLines: 8,
                            errorMessage: viewModel.contentErrorMessage,
                            controller: viewModel.state.messageController,
                            themeColor: themeColor,
                            labelTitleText: LocaleKeys
                                .contactUs_messagePlaceHolderText
                                .tr(),
                            labelStyle: bodyNormalTextStyle(
                              context: context,
                              fontColor: mainDarkTextColor(context: context),
                            ),
                            backGroundColor:
                                whiteBackGroundColor(context: context),
                          ),
                          viewModel.isKeyboardVisible(context)
                              ? const SizedBox.shrink()
                              : const Spacer(),
                          PaddingWidget.applySymmetricPadding(
                            vertical: 20,
                            horizontal: 20,
                            child: MainButton(
                              title: LocaleKeys.contactUs_buttonTitleText.tr(),
                              onPressed: () {
                                viewModel.onSendMessageClicked(context);
                              },
                              height: 53,
                              hideShadows: true,
                              themeColor: themeColor,
                              isEnabled: viewModel.state.isButtonEnabled,
                              enabledTextColor:
                                  enabledMainButtonTextColor(context: context),
                              disabledTextColor:
                                  disabledMainButtonTextColor(context: context),
                              disabledBackgroundColor:
                                  disabledMainButtonColor(context: context),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
