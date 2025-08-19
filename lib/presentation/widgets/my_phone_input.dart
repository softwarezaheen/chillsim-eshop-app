import "package:easy_localization/easy_localization.dart";
import "package:esim_open_source/presentation/extensions/context_extension.dart";
import "package:esim_open_source/presentation/shared/shared_styles.dart";
import "package:esim_open_source/translations/locale_keys.g.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:phone_input/phone_input_package.dart";

class MyPhoneInput extends StatelessWidget {
  const MyPhoneInput({
    required this.onChanged,
    required this.phoneController,
    this.validateRequired = false,
    this.validateEmpty = false,
    super.key,
  });
  final Function(
    String countryCode,
    String phoneNumber, {
    required bool isValid,
  }) onChanged;

  final PhoneController phoneController;
  final bool validateRequired;
  final bool validateEmpty;

  @override
  Widget build(BuildContext context) {
    return PhoneInput(
      controller: phoneController,
      style: bodyNormalTextStyle(
        context: context,
      ).copyWith(
        color: context.appColors.grey_900,
      ),
      countryCodeStyle: bodyNormalTextStyle(context: context).copyWith(
        color: context.appColors.grey_900,
      ),
      defaultCountry: phoneController.value?.isoCode ?? IsoCode.RO,
      autovalidateMode: AutovalidateMode.always,
      validator: PhoneValidator.compose(
        <PhoneNumberInputValidator>[
          validateEmpty ? PhoneValidator.required() : PhoneValidator.none,
          validateRequired ? PhoneValidator.valid() : PhoneValidator.none,
        ],
      ),
      flagShape: BoxShape.rectangle,
      decoration: InputDecoration(
        focusColor: Colors.transparent,
        labelText: "",
        hintText: LocaleKeys.phoneInput_placeHolder.tr(),
        hintStyle: captionOneNormalTextStyle(
          context: context,
          fontColor: secondaryTextColor(context: context),
        ),
        labelStyle: const TextStyle(color: Colors.red),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: context.appColors.grey_200!),
          borderRadius: BorderRadius.circular(12),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: context.appColors.grey_200!),
          borderRadius: BorderRadius.circular(12),
        ),
        disabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: context.appColors.grey_200!),
          borderRadius: BorderRadius.circular(12),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: context.appColors.grey_200!),
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: context.appColors.grey_200!),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      onChanged: (PhoneNumber? p) => onChanged(
        p?.countryCode ?? phoneController.value?.isoCode.name ?? "RO",
        p?.nsn ?? "",
        isValid: p?.isValid(type: PhoneNumberType.mobile) ?? false,
      ),
      countrySelectorNavigator: CountrySelectorNavigator.bottomSheet(
        searchInputDecoration: InputDecoration(
          focusColor: Colors.green,
          labelText: LocaleKeys.phoneInput_countryPlaceHolder.tr(),
          labelStyle: const TextStyle(color: Colors.grey),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: context.appColors.grey_200!),
            borderRadius: BorderRadius.circular(12),
          ),
          disabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: context.appColors.grey_200!),
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        searchInputTextStyle: const TextStyle(color: Colors.black),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(
        ObjectFlagProperty<
            Function(
              String countryCode,
              String phoneNumber, {
              required bool isValid,
            })>.has("onChanged", onChanged),
      )
      ..add(
        DiagnosticsProperty<PhoneController>(
          "phoneController",
          phoneController,
        ),
      )
      ..add(DiagnosticsProperty<bool>("validateRequired", validateRequired))
      ..add(DiagnosticsProperty<bool>("validateEmpty", validateEmpty));
  }
}
