import "package:easy_localization/easy_localization.dart";
import "package:esim_open_source/presentation/extensions/context_extension.dart";
import "package:esim_open_source/presentation/extensions/helper_extensions.dart";
import "package:esim_open_source/presentation/shared/shared_styles.dart";
import "package:esim_open_source/presentation/shared/ui_helpers.dart";
import "package:esim_open_source/presentation/widgets/common_navigation_title.dart";
import "package:esim_open_source/presentation/widgets/padding_widget.dart";
import "package:esim_open_source/translations/locale_keys.g.dart";
import "package:flutter/material.dart";

class AndroidGalleryUserGuideView extends StatelessWidget {
  const AndroidGalleryUserGuideView({super.key});
  static const String routeName = "AndroidGalleryUserGuideView";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SizedBox.expand(
          child: PaddingWidget.applyPadding(
            top: 30,
            child: Column(
              children: <Widget>[
                CommonNavigationTitle(
                  navigationTitle: "",
                  textStyle: headerTwoMediumTextStyle(context: context),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        verticalSpaceMedium,
                        headerTitleText(
                          context,
                          LocaleKeys.userGuideView_androidGuideFirstText.tr(),
                        ),
                        verticalSpaceSmallMedium,
                        pointTitleText(
                          context,
                          <String>[
                            LocaleKeys.userGuideView_androidGuideFirstStep.tr(),
                            LocaleKeys.userGuideView_androidGuideSecondStep
                                .tr(),
                            LocaleKeys.userGuideView_androidGuideThirdStep.tr(),
                            LocaleKeys.userGuideView_androidGuideFourthStep
                                .tr(),
                            LocaleKeys.userGuideView_androidGuideFifthStep.tr(),
                            LocaleKeys.userGuideView_androidGuideSixthStep.tr(),
                          ],
                        ),
                        verticalSpaceMedium,
                        headerTitleText(
                          context,
                          LocaleKeys.userGuideView_androidGuideSecondText.tr(),
                        ),
                        verticalSpaceMedium,
                        headerTitleText(
                          context,
                          LocaleKeys.userGuideView_androidGuideThirdText.tr(),
                        ),
                        verticalSpaceMedium,
                        pointTitleText(
                          context,
                          <String>[
                            LocaleKeys.userGuideView_firstDevice.tr(),
                            LocaleKeys.userGuideView_secondDevice.tr(),
                            LocaleKeys.userGuideView_thirdDevice.tr(),
                            LocaleKeys.userGuideView_fourthDevice.tr(),
                            LocaleKeys.userGuideView_fifthDevice.tr(),
                          ],
                        ),
                        verticalSpaceMedium,
                        headerTitleText(
                          context,
                          LocaleKeys.userGuideView_androidGuideFourthText.tr(),
                        ),
                        verticalSpaceMedium,
                        pointTitleText(
                          context,
                          <String>[
                            LocaleKeys.userGuideView_firstAndroidDevice.tr(),
                            LocaleKeys.userGuideView_secondAndroidDevice.tr(),
                            LocaleKeys.userGuideView_thirdAndroidDevice.tr(),
                            LocaleKeys.userGuideView_fourthAndroidDevice.tr(),
                            LocaleKeys.userGuideView_fifthAndroidDevice.tr(),
                            LocaleKeys.userGuideView_sixthAndroidDevice.tr(),
                            LocaleKeys.userGuideView_seventhAndroidDevice.tr(),
                            LocaleKeys.userGuideView_eighthAndroidDevice.tr(),
                          ],
                        ),
                        verticalSpaceMedium,
                        headerTitleText(
                          context,
                          LocaleKeys.userGuideView_androidGuideFifthText.tr(),
                        ),
                        verticalSpaceMedium,
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget headerTitleText(BuildContext context, String text) {
    return PaddingWidget.applySymmetricPadding(
      horizontal: 35,
      child: Text(
        text,
        style: bodyBoldTextStyle(context: context),
      ),
    );
  }

  Widget pointTitleText(BuildContext context, List<String> texts) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: texts.length,
      separatorBuilder: (BuildContext context, int index) =>
          verticalSpaceSmallMedium,
      itemBuilder: (BuildContext context, int index) =>
          PaddingWidget.applySymmetricPadding(
        horizontal: 10,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Icon(
              Icons.play_arrow,
              size: 20,
              color: context.appColors.baseBlack,
            ).imageSupportsRTL(context),
            const SizedBox(
              width: 6,
            ),
            Expanded(
              child: Text(
                texts[index],
                style: captionOneNormalTextStyle(
                  context: context,
                  fontColor: contentTextColor(context: context),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
