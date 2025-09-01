import "package:easy_localization/easy_localization.dart";
import "package:esim_open_source/app/environment/app_environment.dart";
import "package:esim_open_source/di/locator.dart";
import "package:esim_open_source/presentation/enums/login_type.dart";
import "package:esim_open_source/presentation/extensions/context_extension.dart";
import "package:esim_open_source/presentation/shared/shared_styles.dart";
import "package:esim_open_source/presentation/shared/ui_helpers.dart";
import "package:esim_open_source/presentation/views/base/base_view.dart";
import "package:esim_open_source/presentation/views/home_flow_views/profile_view/profile_view_sections/account_information_view/account_information_view_model.dart";
import "package:esim_open_source/presentation/widgets/common_navigation_title.dart";
import "package:esim_open_source/presentation/widgets/main_button.dart";
import "package:esim_open_source/presentation/widgets/main_input_field.dart";
import "package:esim_open_source/presentation/widgets/my_phone_input.dart";
import "package:esim_open_source/presentation/widgets/padding_widget.dart";
import "package:esim_open_source/translations/locale_keys.g.dart";
import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart";

class AccountInformationView extends StatelessWidget {
  const AccountInformationView({super.key});

  static const String routeName = "AccountInformationView";

  @override
  Widget build(BuildContext context) {
    return BaseView<AccountInformationViewModel>(
      hideAppBar: true,
      routeName: routeName,
      viewModel: locator<AccountInformationViewModel>(),
      builder: (
        BuildContext context,
        AccountInformationViewModel viewModel,
        Widget? childWidget,
        double screenHeight,
      ) =>
          PaddingWidget.applyPadding(
        top: 20,
        child: Column(
          children: <Widget>[
            CommonNavigationTitle(
              navigationTitle: LocaleKeys.accountInformation_titleText.tr(),
              textStyle: headerTwoBoldTextStyle(
                context: context,
                fontColor: titleTextColor(context: context),
              ),
            ),
            Expanded(
              child: KeyboardDismissOnTap(
                dismissOnCapturedTaps: true,
                child: SingleChildScrollView(
                  child: SizedBox(
                    height: screenHeight + 50,
                    child: Column(
                      children: <Widget>[
                        PaddingWidget.applySymmetricPadding(
                          horizontal: 15,
                          child: Column(
                            children: <Widget>[
                              verticalSpaceMedium,
                              MainInputField.formField(
                                themeColor: themeColor,
                                hintText: LocaleKeys
                                    .accountInformation_namePlaceHolderText
                                    .tr(),
                                hintLabelStyle: captionOneNormalTextStyle(
                                  context: context,
                                  fontColor:
                                      secondaryTextColor(context: context),
                                ),
                                controller: viewModel.nameController,
                                backGroundColor:
                                    whiteBackGroundColor(context: context),
                                labelStyle: bodyNormalTextStyle(
                                  context: context,
                                  fontColor:
                                      mainDarkTextColor(context: context),
                                ),
                              ),
                              getSpacersWidgets(context),
                              MainInputField.formField(
                                themeColor: themeColor,
                                hintText: LocaleKeys
                                    .accountInformation_familyNamePlaceHolderText
                                    .tr(),
                                hintLabelStyle: captionOneNormalTextStyle(
                                  context: context,
                                  fontColor:
                                      secondaryTextColor(context: context),
                                ),
                                controller: viewModel.familyNameController,
                                backGroundColor:
                                    whiteBackGroundColor(context: context),
                                labelStyle: bodyNormalTextStyle(
                                  context: context,
                                  fontColor:
                                      mainDarkTextColor(context: context),
                                ),
                              ),
                              getSpacersWidgets(context),
                              MyPhoneInput(
                                enabled: AppEnvironment
                                            .appEnvironmentHelper.loginType ==
                                        LoginType.phoneNumber
                                    ? false
                                    : true,
                                onChanged: viewModel.validateNumber,
                                phoneController: viewModel.phoneController,
                                validateRequired: true,
                              ),
                              getSpacersWidgets(context),
                              AppEnvironment.appEnvironmentHelper.loginType ==
                                      LoginType.phoneNumber
                                  ? MainInputField.formField(
                                      themeColor: themeColor,
                                      hintText: LocaleKeys.email.tr(),
                                      hintLabelStyle: captionOneNormalTextStyle(
                                        context: context,
                                        fontColor: secondaryTextColor(
                                          context: context,
                                        ),
                                      ),
                                      errorMessage: viewModel.emailErrorMessage,
                                      controller: viewModel.emailController,
                                      backGroundColor: whiteBackGroundColor(
                                        context: context,
                                      ),
                                      labelStyle: bodyNormalTextStyle(
                                        context: context,
                                        fontColor:
                                            mainDarkTextColor(context: context),
                                      ),
                                    )
                                  : Container(
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        color: greyBackGroundColor(
                                          context: context,
                                        ),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child:
                                            PaddingWidget.applySymmetricPadding(
                                          vertical: 15,
                                          horizontal: 20,
                                          child: Text(
                                            viewModel.userEmail,
                                            style: bodyNormalTextStyle(
                                              context: context,
                                              fontColor: secondaryTextColor(
                                                context: context,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                              verticalSpaceSmallMedium,
                              Row(
                                children: <Widget>[
                                  CupertinoSwitch(
                                    value: viewModel.receiveUpdated,
                                    activeTrackColor:
                                        enabledSwitchColor(context: context),
                                    thumbColor:
                                        switchThumbColor(context: context),
                                    onChanged: (bool newValue) {
                                      viewModel.updateSwitch(
                                        newValue: newValue,
                                      );
                                    },
                                  ),
                                  horizontalSpaceSmall,
                                  Expanded(
                                    child: Text(
                                      LocaleKeys.accountInformation_contentText
                                          .tr(),
                                      style: captionTwoNormalTextStyle(
                                        context: context,
                                        fontColor: secondaryTextColor(
                                          context: context,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        viewModel.isKeyboardVisible(context)
                            ? const SizedBox.shrink()
                            : const Spacer(),
                        PaddingWidget.applySymmetricPadding(
                          vertical: 20,
                          horizontal: 20,
                          child: MainButton(
                            title: LocaleKeys.accountInformation_saveText.tr(),
                            onPressed: () async {
                              await viewModel.saveButtonTapped();
                            },
                            height: 53,
                            hideShadows: true,
                            themeColor: themeColor,
                            isEnabled: viewModel.saveButtonEnabled,
                            enabledTextColor:
                                enabledMainButtonTextColor(context: context),
                            disabledTextColor:
                                disabledMainButtonTextColor(context: context),
                            enabledBackgroundColor:
                                enabledMainButtonColor(context: context),
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
          ],
        ),
      ),
    );
  }

  Widget getSpacersWidgets(BuildContext context) {
    List<Widget> widgets = <Widget>[
      verticalSpaceSmallMedium,
      Divider(
        color: context.appColors.grey_200,
      ),
      verticalSpaceSmallMedium,
    ];
    return Column(
      children: widgets,
    );
  }
}
