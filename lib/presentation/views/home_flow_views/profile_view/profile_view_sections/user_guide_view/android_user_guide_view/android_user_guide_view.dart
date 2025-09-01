import "package:easy_localization/easy_localization.dart";
import "package:esim_open_source/app/environment/environment_images.dart";
import "package:esim_open_source/presentation/extensions/helper_extensions.dart";
import "package:esim_open_source/presentation/shared/shared_styles.dart";
import "package:esim_open_source/presentation/shared/ui_helpers.dart";
import "package:esim_open_source/presentation/views/base/base_view.dart";
import "package:esim_open_source/presentation/views/home_flow_views/profile_view/profile_view_sections/user_guide_view/android_user_guide_view/android_user_guide_view_model.dart";
import "package:esim_open_source/presentation/widgets/padding_widget.dart";
import "package:esim_open_source/translations/locale_keys.g.dart";
import "package:flutter/material.dart";

class AndroidUserGuideView extends StatelessWidget {
  const AndroidUserGuideView({super.key});

  static const String routeName = "AndroidUserGuideView";

  @override
  Widget build(BuildContext context) {
    return BaseView<AndroidUserGuideViewModel>(
      hideAppBar: true,
      routeName: routeName,
      viewModel: AndroidUserGuideViewModel(),
      builder: (
        BuildContext context,
        AndroidUserGuideViewModel viewModel,
        Widget? childWidget,
        double screenHeight,
      ) =>
          SizedBox.expand(
        child: PaddingWidget.applyPadding(
          top: 50,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                LocaleKeys.userGuideView_selectMethod.tr(),
                style: captionOneNormalTextStyle(
                  context: context,
                  fontColor: secondaryTextColor(context: context),
                ),
              ),
              verticalSpaceMediumLarge,
              GestureDetector(
                onTap: viewModel.scanFromQr,
                child: userGuideBubbleView(
                  context: context,
                  viewModel: viewModel,
                  imagePath: EnvironmentImages.scanQr.fullImagePath,
                  titleText: LocaleKeys.userGuideView_androidCameraTitle.tr(),
                ),
              ),
              verticalSpaceSmallMedium,
              GestureDetector(
                onTap: viewModel.scanFromGallery,
                child: userGuideBubbleView(
                  context: context,
                  viewModel: viewModel,
                  imagePath: EnvironmentImages.scanGallery.fullImagePath,
                  titleText: LocaleKeys.userGuideView_androidGalleryTitle.tr(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget userGuideBubbleView({
    required BuildContext context,
    required String imagePath,
    required String titleText,
    required AndroidUserGuideViewModel viewModel,
  }) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: greyBackGroundColor(context: context),
        borderRadius: BorderRadius.circular(12),
      ),
      child: PaddingWidget.applySymmetricPadding(
        vertical: 20,
        horizontal: 20,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: Row(
                children: <Widget>[
                  Image.asset(
                    imagePath,
                    width: 40,
                    height: 40,
                  ),
                  horizontalSpaceSmall,
                  Expanded(
                    child: Text(
                      titleText,
                      style: bodyNormalTextStyle(
                        context: context,
                        fontColor: bubbleCountryTextColor(context: context),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Row(
              children: <Widget>[
                horizontalSpaceSmall,
                Image.asset(
                  EnvironmentImages.chevronRight.fullImagePath,
                  width: 15,
                  height: 15,
                ).imageSupportsRTL(context),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
