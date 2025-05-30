import "package:easy_localization/easy_localization.dart";
import "package:esim_open_source/app/environment/environment_images.dart";
import "package:esim_open_source/domain/repository/services/local_storage_service.dart";
import "package:esim_open_source/presentation/views/base/base_model.dart";
import "package:esim_open_source/translations/locale_keys.g.dart";
import "package:flutter_esim/flutter_esim.dart";

enum DeviceCompatibleType {
  loading,
  compatible,
  incompatible;

  String get contentText {
    switch (this) {
      case DeviceCompatibleType.loading:
        return LocaleKeys.compatibleView_contentText.tr();
      case DeviceCompatibleType.compatible:
        return LocaleKeys.compatibleView_compatibleText.tr();
      case DeviceCompatibleType.incompatible:
        return LocaleKeys.compatibleView_inCompatibleText.tr();
    }
  }

  String get contentImagePath {
    switch (this) {
      case DeviceCompatibleType.loading:
        return "";
      case DeviceCompatibleType.compatible:
        return EnvironmentImages.compatibleIcon.fullImagePath;
      case DeviceCompatibleType.incompatible:
        return EnvironmentImages.inCompatibleIcon.fullImagePath;
    }
  }
}

class DeviceCompabilityCheckViewModel extends BaseModel {
  final FlutterEsim _flutterEsimPlugin = FlutterEsim();
  DeviceCompatibleType deviceCompatibleType = DeviceCompatibleType.loading;

  @override
  Future<void> onViewModelReady() async {
    super.onViewModelReady();

    startChecking();
  }

  Future<void> startChecking() async {
    await Future<void>.delayed(const Duration(seconds: 3));
    bool isSupportESim = await _flutterEsimPlugin.isSupportESim(null);
    deviceCompatibleType = isSupportESim
        ? DeviceCompatibleType.compatible
        : DeviceCompatibleType.incompatible;

    localStorageService.setBool(
      LocalStorageKeys.hasPreviouslyStarted,
      value: true,
    );

    notifyListeners();

    await Future<void>.delayed(const Duration(seconds: 2));

    navigateToHomePager();
  }
}
