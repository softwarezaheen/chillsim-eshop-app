import "dart:io";

import "package:easy_localization/easy_localization.dart";
import "package:esim_open_source/app/app.locator.dart";
import "package:esim_open_source/domain/repository/services/device_info_service.dart";
import "package:esim_open_source/presentation/utils/extensions.dart";
import "package:esim_open_source/translations/locale_keys.g.dart";
import "package:flutter_esim/flutter_esim.dart";

Future<bool> isInstallButtonEnabled() async {
  if (Platform.isIOS) {
    Map<String, dynamic> deviceData =
        await locator<DeviceInfoService>().deviceData;
    String currentOSVersion = deviceData["systemVersion"];
    if (currentOSVersion.compareTo("17.4.1") >= 0) {
      return true;
    }
  } else if (Platform.isAndroid) {
    Map<String, dynamic> deviceData =
        await locator<DeviceInfoService>().deviceData;
    bool supportsEsim = await FlutterEsim().isSupportESim(null);
    String currentOSVersion = deviceData["version.release"];
    if (currentOSVersion.compareTo("15") >= 0 && supportsEsim) {
      return true;
    }
  }
  return false;
}

bool isNumeric(String? s) {
  if (s == null) {
    return false;
  }
  return double.tryParse(s) != null;
}

String? validateNumber(String number) {
  if (number.trim().isEmpty) {
    return LocaleKeys.invalidNumberMessage.tr();
  }

  if (!isNumeric(number.trim().replaceAll("+", "")) ||
      number.trim().replaceAll("+", "").length < 9) {
    return LocaleKeys.invalidNumberMessage.tr();
  }

  return null;
}

String? validateOTP({required String otp, int length = 6}) {
  if (otp.trim().isEmpty) {
    return LocaleKeys.please_fill_all_required_fields.tr();
  }

  if (otp.trim().length < length) {
    return LocaleKeys.otp_validation_message.tr() +
        length.toString() +
        LocaleKeys.otp_validation_message_numbers.tr();
  }

  return null;
}

String? validateUsername({required String username, int minLength = 4}) {
  if (username.trim().isEmpty) {
    return LocaleKeys.please_fill_all_required_fields.tr();
  }

  if (username.trim().isLettersOnly()) {
    return "Client Name must contain only letters and spaces";
  }

  if (username.trim().length < minLength) {
    return "Client Name ${LocaleKeys.length_validation_message.tr()}$minLength";
  }

  return null;
}

String? validateText(String text) {
  if (text.trim().isEmpty) {
    return LocaleKeys.please_fill_all_required_fields.tr();
  }
  return null;
}

String? validateTextRequiredWithTag(String text, String? tag) {
  if (text.trim().isEmpty) {
    return tag != null
        ? "$tag ${LocaleKeys.is_required_field.tr()}"
        : LocaleKeys.is_required_field.tr();
  }
  return null;
}

String? validateEmailWithTag(String text, String? tag) {
  if (text.trim().isEmpty) {
    return tag != null
        ? "$tag ${LocaleKeys.is_required_field.tr()}"
        : LocaleKeys.is_required_field.tr();
  }

  const String pattern = r"(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'"
      r'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-'
      r'\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*'
      r"[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:(2(5[0-5]|[0-4]"
      r"[0-9])|1[0-9][0-9]|[1-9]?[0-9]))\.){3}(?:(2(5[0-5]|[0-4][0-9])|1[0-9]"
      r"[0-9]|[1-9]?[0-9])|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\"
      r"x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])";
  final RegExp regex = RegExp(pattern);

  return !regex.hasMatch(text.trim())
      ? LocaleKeys.enter_a_valid_email_address.tr()
      : null;
}

String? validateWebsiteWithTag(String text, String? tag) {
  if (text.trim().isEmpty) {
    return null;
    // return tag != null
    //     ? "$tag ${LocaleKeys.is_required_field.tr()}"
    //     : LocaleKeys.is_required_field.tr();
  }

  const String urlPattern = r"^(https?:\/\/)" // protocol
      r"((([a-z\d]([a-z\d-]*[a-z\d])*)\.)+[a-z]{2,}|" // domain name
      r"((\d{1,3}\.){3}\d{1,3}))" // OR ip (v4) address
      r"(\:\d+)?(\/[-a-z\d%_.~+]*)*" // port and path
      r"(\?[;&a-z\d%_.~+=-]*)?" // query string
      r"(\#[-a-z\d_]*)?$"; // fragment locator

  final RegExp regex = RegExp(urlPattern, caseSensitive: false);

  return !regex.hasMatch(text.trim())
      ? LocaleKeys.enter_a_valid_website_address.tr()
      : null;
}

// String? validateAmount(String text) {
//   if (text.trim().isEmpty) {
//     return LocaleKeys.please_fill_all_required_fields.tr();
//   }
//   if (!isNumeric(text)) {
//     return LocaleKeys.please_enter_a_valid_amount.tr();
//   }
//
//   return null;
// }
