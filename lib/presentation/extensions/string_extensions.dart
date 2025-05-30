import "package:esim_open_source/app/app.locator.dart";
import "package:esim_open_source/domain/repository/services/local_storage_service.dart";
import "package:esim_open_source/utils/generation_helper.dart";

extension StringExtensions on String {
  String get appendAppCurrency => "${this}_${getSelectedCurrencyCode()}";

  String get appendAppLanguage =>
      "${this}_${locator<LocalStorageService>().languageCode}";
}
