import "package:easy_localization/easy_localization.dart";
import "package:esim_open_source/app/environment/environment_images.dart";
import "package:esim_open_source/presentation/views/home_flow_views/profile_view/profile_view_sections/user_guide_view/user_guide_data_source/user_guide_view_data_source.dart";
import "package:esim_open_source/translations/locale_keys.g.dart";

enum IOSUserGuideEnum implements UserGuideViewDataSource {
  step1,
  step2,
  step3,
  step4,
  step5,
  step6,
  step7,
  step8,
  step9,
  step10,
  step11,
  step12,
  step13,
  step14,
  step15,
  step16,
  step17,
  step18;

  @override
  String get title => LocaleKeys.userGuideView_iosTitle.tr();

  @override
  String get description {
    switch (this) {
      case IOSUserGuideEnum.step1:
        return LocaleKeys.userGuideView_iosStep1.tr();
      case IOSUserGuideEnum.step2:
        return LocaleKeys.userGuideView_iosStep2.tr();
      case IOSUserGuideEnum.step3:
        return LocaleKeys.userGuideView_iosStep3.tr();
      case IOSUserGuideEnum.step4:
        return LocaleKeys.userGuideView_iosStep4.tr();
      case IOSUserGuideEnum.step5:
        return LocaleKeys.userGuideView_iosStep5.tr();
      case IOSUserGuideEnum.step6:
        return LocaleKeys.userGuideView_iosStep6.tr();
      case IOSUserGuideEnum.step7:
        return LocaleKeys.userGuideView_iosStep7.tr();
      case IOSUserGuideEnum.step8:
        return LocaleKeys.userGuideView_iosStep8.tr();
      case IOSUserGuideEnum.step9:
        return LocaleKeys.userGuideView_iosStep9.tr();
      case IOSUserGuideEnum.step10:
        return LocaleKeys.userGuideView_iosStep10.tr();
      case IOSUserGuideEnum.step11:
        return LocaleKeys.userGuideView_iosStep11.tr();
      case IOSUserGuideEnum.step12:
        return LocaleKeys.userGuideView_iosStep12.tr();
      case IOSUserGuideEnum.step13:
        return LocaleKeys.userGuideView_iosStep13.tr();
      case IOSUserGuideEnum.step14:
        return LocaleKeys.userGuideView_iosStep14.tr();
      case IOSUserGuideEnum.step15:
        return LocaleKeys.userGuideView_iosStep15.tr();
      case IOSUserGuideEnum.step16:
        return LocaleKeys.userGuideView_iosStep16.tr();
      case IOSUserGuideEnum.step17:
        return LocaleKeys.userGuideView_iosStep17.tr();
      case IOSUserGuideEnum.step18:
        return LocaleKeys.userGuideView_iosStep18.tr();
    }
  }

  @override
  String get stepNumberLabel => LocaleKeys.userGuideView_stepIndexTitle.tr(
        namedArgs: <String, String>{
          "index": (index + 1).toString(),
        },
      );

  @override
  bool get isImageGIF {
    switch (this) {
      case IOSUserGuideEnum.step1:
      case IOSUserGuideEnum.step5:
      case IOSUserGuideEnum.step12:
      case IOSUserGuideEnum.step13:
        return false;
      default:
        return true;
    }
  }

  @override
  String get imageName => "iosStep${index + 1}";

  @override
  String get fullImagePath => EnvironmentImages.values
      .firstWhere(
        (EnvironmentImages e) => e.name == imageName,
        orElse: () => EnvironmentImages.iosStep1,
      )
      .fullImagePath;

  @override
  IOSUserGuideEnum nextStepTapped() {
    if (index == IOSUserGuideEnum.values.length - 1) {
      return this;
    }
    int nextIndex = index + 1;
    return IOSUserGuideEnum.values[nextIndex];
  }

  @override
  IOSUserGuideEnum previousStepTapped() {
    if (index == 0) {
      return this;
    }
    int previousIndex = index - 1;
    return IOSUserGuideEnum.values[previousIndex];
  }

  @override
  bool isNextEnabled() {
    return index != IOSUserGuideEnum.values.length - 1;
  }

  @override
  bool isPreviousEnabled() {
    return index != 0;
  }
}
