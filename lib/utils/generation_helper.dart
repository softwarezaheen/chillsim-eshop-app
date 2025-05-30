import "dart:async";
import "dart:developer" as dev;
import "dart:math";

import "package:esim_open_source/app/app.locator.dart";
import "package:esim_open_source/domain/repository/services/app_configuration_service.dart";
import "package:esim_open_source/domain/repository/services/device_info_service.dart";
import "package:esim_open_source/domain/repository/services/local_storage_service.dart";
import "package:esim_open_source/domain/repository/services/secure_storage_service.dart";

Future<String> getUniqueDeviceID(
  DeviceInfoService? deviceInfoService,
  SecureStorageService? secureStorageService,
) async {
  String deviceID =
      await secureStorageService?.getString(SecureStorageKeys.deviceID) ?? "";

  if (deviceID.isEmpty) {
    deviceID = await deviceInfoService?.deviceID ?? "";
    if (deviceID.isEmpty) {
      deviceID = generateRandomString(16);
    }
    secureStorageService?.setString(SecureStorageKeys.deviceID, deviceID);
  }
  return deviceID;
}

String getSelectedCurrencyCode() {
  String? currencyCode = locator<LocalStorageService>().currencyCode;
  if (currencyCode != null && currencyCode.isNotEmpty) {
    dev.log("Selected currency from storage: $currencyCode");
    return currencyCode;
  }
  String defaultCurrency =
      locator<AppConfigurationService>().getDefaultCurrency;
  if (defaultCurrency.isNotEmpty) {
    unawaited(
      locator<LocalStorageService>().setString(
        LocalStorageKeys.appCurrency,
        defaultCurrency,
      ),
    );
    dev.log("Selected currency from configs: $currencyCode");
    return locator<AppConfigurationService>().getDefaultCurrency;
  }
  dev.log("Selected currency empty: $currencyCode");
  return "";
}

String generateRandomString(int length) {
  Random random = Random();
  const String chars =
      "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";

  return String.fromCharCodes(
    List<int>.generate(
      length,
      (int index) => chars.codeUnitAt(
        random.nextInt(chars.length),
      ),
    ),
  );
}
