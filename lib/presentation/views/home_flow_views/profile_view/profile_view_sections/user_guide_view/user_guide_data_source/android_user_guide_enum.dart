import "package:easy_localization/easy_localization.dart";
import "package:esim_open_source/app/environment/environment_images.dart";
import "package:esim_open_source/presentation/views/home_flow_views/profile_view/profile_view_sections/user_guide_view/user_guide_data_source/user_guide_view_data_source.dart";
import "package:esim_open_source/translations/locale_keys.g.dart";

enum AndroidUserGuideEnum implements UserGuideViewDataSource {
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
  String get title => LocaleKeys.userGuideView_androidTitle.tr();

  @override
  String get description {
    switch (this) {
      case AndroidUserGuideEnum.step1:
        return LocaleKeys.userGuideView_androidStep1.tr();
      case AndroidUserGuideEnum.step2:
        return LocaleKeys.userGuideView_androidStep2.tr();
      case AndroidUserGuideEnum.step3:
        return LocaleKeys.userGuideView_androidStep3.tr();
      case AndroidUserGuideEnum.step4:
        return LocaleKeys.userGuideView_androidStep4.tr();
      case AndroidUserGuideEnum.step5:
        return LocaleKeys.userGuideView_androidStep5.tr();
      case AndroidUserGuideEnum.step6:
        return LocaleKeys.userGuideView_androidStep6.tr();
      case AndroidUserGuideEnum.step7:
        return LocaleKeys.userGuideView_androidStep7.tr();
      case AndroidUserGuideEnum.step8:
        return LocaleKeys.userGuideView_androidStep8.tr();
      case AndroidUserGuideEnum.step9:
        return LocaleKeys.userGuideView_androidStep9.tr();
      case AndroidUserGuideEnum.step10:
        return LocaleKeys.userGuideView_androidStep10.tr();
      case AndroidUserGuideEnum.step11:
        return LocaleKeys.userGuideView_androidStep11.tr();
      case AndroidUserGuideEnum.step12:
        return LocaleKeys.userGuideView_androidStep12.tr();
      case AndroidUserGuideEnum.step13:
        return LocaleKeys.userGuideView_androidStep13.tr();
      case AndroidUserGuideEnum.step14:
        return LocaleKeys.userGuideView_androidStep14.tr();
      case AndroidUserGuideEnum.step15:
        return LocaleKeys.userGuideView_androidStep15.tr();
      case AndroidUserGuideEnum.step16:
        return LocaleKeys.userGuideView_androidStep16.tr();
      case AndroidUserGuideEnum.step17:
        return LocaleKeys.userGuideView_androidStep17.tr();
      case AndroidUserGuideEnum.step18:
        return LocaleKeys.userGuideView_androidStep18.tr();
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
      case AndroidUserGuideEnum.step1:
      case AndroidUserGuideEnum.step2:
      case AndroidUserGuideEnum.step8:
      case AndroidUserGuideEnum.step10:
      case AndroidUserGuideEnum.step12:
      case AndroidUserGuideEnum.step13:
        return false;
      default:
        return true;
    }
  }

  @override
  String get imageName => "androidStep${index + 1}";

  @override
  String get fullImagePath => EnvironmentImages.values
      .firstWhere(
        (EnvironmentImages e) => e.name == imageName,
        orElse: () => EnvironmentImages.androidStep1,
      )
      .fullImagePath;

  @override
  AndroidUserGuideEnum nextStepTapped() {
    if (index == AndroidUserGuideEnum.values.length - 1) {
      return this;
    }
    int nextIndex = index + 1;
    return AndroidUserGuideEnum.values[nextIndex];
  }

  @override
  AndroidUserGuideEnum previousStepTapped() {
    if (index == 0) {
      return this;
    }
    int previousIndex = index - 1;
    return AndroidUserGuideEnum.values[previousIndex];
  }

  @override
  bool isNextEnabled() {
    return index != AndroidUserGuideEnum.values.length - 1;
  }

  @override
  bool isPreviousEnabled() {
    return index != 0;
  }
}
