import "dart:developer";
import "package:phone_input/phone_input_package.dart";

/// A utility class for safe phone number operations
class PhoneNumberUtils {
  /// Validates if the MSISDN is in the correct international format
  /// Returns true if the phone number starts with + and has at least 8 digits after country code
  static bool isValidMsisdn(String msisdn) {
    if (msisdn.isEmpty) return false;
    // Basic validation: starts with + and has at least 8 digits after country code
    final RegExp regex = RegExp(r"^\+\d{8,}$");
    return regex.hasMatch(msisdn);
  }

  /// Safely parses a phone number string with comprehensive error handling
  /// Returns null if parsing fails or the input is invalid
  static PhoneNumber? safeParse(String phoneNumberString) {
    try {
      if (!isValidMsisdn(phoneNumberString)) {
        log("Invalid MSISDN format: $phoneNumberString");
        return null;
      }
      return PhoneNumber.parse(phoneNumberString);
    } catch (e) {
      log("Error parsing phone number: $phoneNumberString, Error: $e");
      return null;
    }
  }

  /// Creates a safe PhoneNumber object with fallback values
  /// Uses the provided fallback country code if parsing fails
  static PhoneNumber createSafePhoneNumber({
    required String phoneNumberString,
    IsoCode fallbackCountry = IsoCode.RO,
  }) {
    final PhoneNumber? parsed = safeParse(phoneNumberString);
    if (parsed != null) {
      return PhoneNumber(
        isoCode: parsed.isoCode,
        nsn: "",
      );
    }
    
    // Return fallback
    return PhoneNumber(
      isoCode: fallbackCountry,
      nsn: "",
    );
  }

  /// Formats a phone number safely, returning the original string if formatting fails
  static String safeFormat(String phoneNumberString) {
    final PhoneNumber? parsed = safeParse(phoneNumberString);
    if (parsed != null) {
      return "+${parsed.countryCode}${parsed.nsn}";
    }
    return phoneNumberString; // Return original if parsing fails
  }

  /// Validates if two phone numbers match, handling parsing errors gracefully
  static bool phoneNumbersMatch(String phoneNumber1, String phoneNumber2) {
    try {
      if (!isValidMsisdn(phoneNumber1) || !isValidMsisdn(phoneNumber2)) {
        // If either is invalid, do a simple string comparison
        return phoneNumber1 == phoneNumber2;
      }
      
      final PhoneNumber? parsed1 = safeParse(phoneNumber1);
      final PhoneNumber? parsed2 = safeParse(phoneNumber2);
      
      if (parsed1 == null || parsed2 == null) {
        // Fallback to string comparison if parsing fails
        return phoneNumber1 == phoneNumber2;
      }
      
      return parsed1.countryCode == parsed2.countryCode && 
             parsed1.nsn == parsed2.nsn;
    } catch (e) {
      log("Error comparing phone numbers: $e");
      // Fallback to string comparison
      return phoneNumber1 == phoneNumber2;
    }
  }

  /// Extracts country code and national number from a PhoneController safely
  static String getFullPhoneNumber(PhoneController? controller) {
    if (controller?.value == null) {
      return "";
    }
    
    try {
      final String countryCode = controller!.value!.countryCode;
      final String nsn = controller.value!.nsn;
      
      if (countryCode.isEmpty || nsn.isEmpty) {
        return "";
      }
      
      return "+$countryCode$nsn";
    } catch (e) {
      log("Error extracting phone number from controller: $e");
      return "";
    }
  }
}