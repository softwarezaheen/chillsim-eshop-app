import "package:esim_open_source/presentation/setup_bottom_sheet_ui.dart";
import "package:esim_open_source/presentation/shared/ui_helpers.dart";
import "package:esim_open_source/presentation/views/base/base_view.dart";
import "package:esim_open_source/presentation/widgets/bottom_sheet_close_button.dart";
import "package:esim_open_source/presentation/widgets/main_button.dart";
import "package:esim_open_source/presentation/widgets/main_input_field.dart";
import "package:esim_open_source/presentation/widgets/padding_widget.dart";
import "package:flutter/material.dart";
import "package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart";
import "package:stacked_services/stacked_services.dart";
import "package:esim_open_source/presentation/views/bottom_sheet/billing_information_view/billing_info_bottomsheet_view_model.dart";
import 'package:esim_open_source/translations/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:esim_open_source/presentation/shared/shared_styles.dart';

class BillingInfoBottomSheetView extends StatelessWidget {
  const BillingInfoBottomSheetView({
    required this.completer,
    this.requestBase,
    super.key,
  });

  final dynamic requestBase;
  final Function(SheetResponse<EmptyBottomSheetResponse>) completer;

  @override
  Widget build(BuildContext context) {
    return BaseView.bottomSheetBuilder(
      viewModel: BillingInfoBottomSheetViewModel(),
      builder: (
        BuildContext context,
        BillingInfoBottomSheetViewModel viewModel,
        Widget? childWidget,
        double screenHeight,
      ) {
        // final isKeyboardVisible = MediaQuery.of(context).viewInsets.bottom > 0;
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
                  PaddingWidget.applySymmetricPadding(
                    horizontal: 0,
                    vertical: 0,
                    child: Text(
                      LocaleKeys.billing_details_title.tr(),
                      style: headerThreeBoldTextStyle(
                        context: context,
                        fontColor: titleTextColor(context: context),
                      ),
                    ),
                  ),
                  verticalSpaceSmallMedium,
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          RadioGroup<BillingType>(
                            groupValue: viewModel.billingType,
                            onChanged: (BillingType? type) {
                              if (type != null) {
                                viewModel.setBillingType(type);
                              }
                            },
                            child: Row(
                              children: [
                                Expanded(
                                  child: RadioListTile<BillingType>(
                                    title: Text(LocaleKeys.billing_type_individual.tr(), style: TextStyle(fontSize: 12)),
                                    value: BillingType.individual,
                                  ),
                                ),
                                Expanded(
                                  child: RadioListTile<BillingType>(
                                    title: Text(LocaleKeys.billing_type_company.tr(), style: TextStyle(fontSize: 12)),
                                    value: BillingType.business,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (viewModel.billingType == BillingType.business) ...<Widget>[
                            MainInputField.formField(
                              themeColor: themeColor,
                              hintText: LocaleKeys.company_name_field_label.tr(),
                              hintLabelStyle: captionOneNormalTextStyle(
                                context: context,
                                fontColor: secondaryTextColor(context: context),
                              ),
                              controller: viewModel.companyNameController,
                              backGroundColor: whiteBackGroundColor(context: context),
                              labelStyle: bodyNormalTextStyle(
                                context: context,
                                fontColor: mainDarkTextColor(context: context),
                              ),
                            ),
                            verticalSpaceSmall,
                            MainInputField.formField(
                              themeColor: themeColor,
                              hintText: LocaleKeys.tax_id_field_label.tr(),
                              hintLabelStyle: captionOneNormalTextStyle(
                                context: context,
                                fontColor: secondaryTextColor(context: context),
                              ),
                              controller: viewModel.vatCodeController,
                              backGroundColor: whiteBackGroundColor(context: context),
                              labelStyle: bodyNormalTextStyle(
                                context: context,
                                fontColor: mainDarkTextColor(context: context),
                              ),
                            ),
                            verticalSpaceSmall,
                            MainInputField.formField(
                              themeColor: themeColor,
                              hintText: LocaleKeys.registration_field_label.tr(),
                              hintLabelStyle: captionOneNormalTextStyle(
                                context: context,
                                fontColor: secondaryTextColor(context: context),
                              ),
                              controller: viewModel.registrationController,
                              backGroundColor: whiteBackGroundColor(context: context),
                              labelStyle: bodyNormalTextStyle(
                                context: context,
                                fontColor: mainDarkTextColor(context: context),
                              ),
                            ),
                            verticalSpaceSmall,
                          ],
                          MainInputField.formField(
                            themeColor: themeColor,
                            hintText: LocaleKeys.accountInformation_namePlaceHolderText.tr(),
                            hintLabelStyle: captionOneNormalTextStyle(
                              context: context,
                              fontColor: secondaryTextColor(context: context),
                            ),
                            controller: viewModel.firstNameController,
                            backGroundColor: whiteBackGroundColor(context: context),
                            labelStyle: bodyNormalTextStyle(
                              context: context,
                              fontColor: mainDarkTextColor(context: context),
                            ),
                          ),
                          verticalSpaceSmall,
                          MainInputField.formField(
                            themeColor: themeColor,
                            hintText: LocaleKeys.accountInformation_familyNamePlaceHolderText.tr(),
                            hintLabelStyle: captionOneNormalTextStyle(
                              context: context,
                              fontColor: secondaryTextColor(context: context),
                            ),
                            controller: viewModel.lastNameController,
                            backGroundColor: whiteBackGroundColor(context: context),
                            labelStyle: bodyNormalTextStyle(
                              context: context,
                              fontColor: mainDarkTextColor(context: context),
                            ),
                          ),
                          verticalSpaceSmall,
                          DropdownButtonFormField<Country>(
                            value: viewModel.selectedCountryValue,
                            items: viewModel.countriesList.map((Country country) {
                              return DropdownMenuItem<Country>(
                                value: country,
                                child: Text(country.name),
                              );
                            }).toList(),
                            onChanged: (Country? newCountry) async{
                              await viewModel.onCountryChanged(newCountry);
                            },
                            decoration: InputDecoration(
                              labelText: LocaleKeys.country_field_label.tr(),
                              border: const OutlineInputBorder(),
                              filled: true,
                              fillColor: whiteBackGroundColor(context: context),
                              labelStyle: bodyNormalTextStyle(
                                context: context,
                                fontColor: secondaryTextColor(context: context),
                              ),
                            ),
                          ),
                          verticalSpaceSmall,
                          viewModel.isRomania
                              ? DropdownButtonFormField<County>(
                                  value: viewModel.selectedCounty,
                                  items: viewModel.countiesList.map((County county) {
                                    return DropdownMenuItem<County>(
                                      value: county,
                                      child: Text(county.name),
                                    );
                                  }).toList(),
                                  onChanged: viewModel.isCountyDropdownEnabled
                                      ? (County? newCounty) async {
                                          await viewModel.onCountyChanged(newCounty);
                                        }
                                      : null,
                                  decoration: InputDecoration(
                                    labelText: LocaleKeys.county_field_label.tr(),
                                    border: const OutlineInputBorder(),
                                    filled: true,
                                    fillColor: whiteBackGroundColor(context: context),
                                    labelStyle: captionOneNormalTextStyle(
                                      context: context,
                                      fontColor: secondaryTextColor(context: context),
                                    ),
                                  ),
                                )
                              : MainInputField.formField(
                                  themeColor: themeColor,
                                  hintText: LocaleKeys.county_field_label.tr(),
                                  hintLabelStyle: captionOneNormalTextStyle(
                                    context: context,
                                    fontColor: secondaryTextColor(context: context),
                                  ),
                                  controller: viewModel.stateController,
                                  backGroundColor: whiteBackGroundColor(context: context),
                                  labelStyle: bodyNormalTextStyle(
                                    context: context,
                                    fontColor: mainDarkTextColor(context: context),
                                  ),
                                ),
                          verticalSpaceSmall,
                          viewModel.isRomania
                              ? DropdownButtonFormField<String>(
                                  value: viewModel.selectedCity,
                                  items: viewModel.citiesList.map((String city) {
                                    return DropdownMenuItem<String>(
                                      value: city,
                                      child: Text(city),
                                    );
                                  }).toList(),
                                  onChanged: viewModel.isCityDropdownEnabled
                                      ? (String? newCity) {
                                          viewModel.onCityChanged(newCity);
                                        }
                                      : null,
                                  decoration: InputDecoration(
                                    labelText: LocaleKeys.city_field_label.tr(),
                                    border: const OutlineInputBorder(),
                                    filled: true,
                                    fillColor: whiteBackGroundColor(context: context),
                                    labelStyle: captionOneNormalTextStyle(
                                      context: context,
                                      fontColor: secondaryTextColor(context: context),
                                    ),
                                  ),
                                )
                              : MainInputField.formField(
                                  themeColor: themeColor,
                                  hintText: LocaleKeys.city_field_label.tr(),
                                  hintLabelStyle: captionOneNormalTextStyle(
                                    context: context,
                                    fontColor: secondaryTextColor(context: context),
                                  ),
                                  controller: viewModel.cityController,
                                  backGroundColor: whiteBackGroundColor(context: context),
                                  labelStyle: bodyNormalTextStyle(
                                    context: context,
                                    fontColor: mainDarkTextColor(context: context),
                                  ),
                                ),
                          verticalSpaceSmallMedium,
                          MainInputField.formField(
                            themeColor: themeColor,
                            hintText: LocaleKeys.street_address_field_label.tr(),
                            hintLabelStyle: captionOneNormalTextStyle(
                              context: context,
                              fontColor: secondaryTextColor(context: context),
                            ),
                            controller: viewModel.addressController,
                            backGroundColor: whiteBackGroundColor(context: context),
                            labelStyle: bodyNormalTextStyle(
                              context: context,
                              fontColor: mainDarkTextColor(context: context),
                            ),
                          ),
                          verticalSpaceSmall,
                        ],
                      ),
                    ),
                  ),
                  verticalSpaceSmallMedium,
                  PaddingWidget.applySymmetricPadding(
                    vertical: 20,
                    horizontal: 20,
                    child: MainButton(
                      title: LocaleKeys.accountInformation_saveText.tr(),
                      onPressed: () async {
                        await viewModel.saveBillingInfoAndProceed(context, completer);
                      },
                      height: 53,
                      hideShadows: true,
                      themeColor: themeColor,
                      isEnabled: viewModel.saveButtonEnabled,
                      enabledTextColor: enabledMainButtonTextColor(context: context),
                      disabledTextColor: disabledMainButtonTextColor(context: context),
                      enabledBackgroundColor: enabledMainButtonColor(context: context),
                      disabledBackgroundColor: disabledMainButtonColor(context: context),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

}
