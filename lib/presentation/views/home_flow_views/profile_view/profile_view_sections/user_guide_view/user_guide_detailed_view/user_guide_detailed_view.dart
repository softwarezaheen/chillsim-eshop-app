import "package:esim_open_source/app/environment/environment_images.dart";
import "package:esim_open_source/presentation/extensions/context_extension.dart";
import "package:esim_open_source/presentation/extensions/helper_extensions.dart";
import "package:esim_open_source/presentation/shared/shared_styles.dart";
import "package:esim_open_source/presentation/shared/ui_helpers.dart";
import "package:esim_open_source/presentation/views/base/base_view.dart";
import "package:esim_open_source/presentation/views/home_flow_views/profile_view/profile_view_sections/user_guide_view/user_guide_data_source/user_guide_view_data_source.dart";
import "package:esim_open_source/presentation/views/home_flow_views/profile_view/profile_view_sections/user_guide_view/user_guide_detailed_view/user_guide_detailed_view_model.dart";
import "package:esim_open_source/presentation/widgets/common_navigation_title.dart";
import "package:esim_open_source/presentation/widgets/padding_widget.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";

class UserGuideDetailedView extends StatelessWidget {
  const UserGuideDetailedView({
    required this.userGuideViewDataSource,
    super.key,
  });
  final UserGuideViewDataSource userGuideViewDataSource;
  static const String routeName = "UserGuideDetailedView";

  @override
  Widget build(BuildContext context) {
    return BaseView<UserGuideDetailedViewModel>(
      hideAppBar: true,
      routeName: routeName,
      viewModel: UserGuideDetailedViewModel(
        userGuideViewDataSource: userGuideViewDataSource,
      ),
      builder: (
        BuildContext context,
        UserGuideDetailedViewModel viewModel,
        Widget? childWidget,
        double screenHeight,
      ) =>
          SizedBox.expand(
        child: PaddingWidget.applyPadding(
          top: viewModel.isFromAndroidScreen ? 15 : 30,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              viewModel.isFromAndroidScreen
                  ? CommonNavigationTitle(
                      navigationTitle: "",
                      textStyle: headerTwoBoldTextStyle(
                        context: context,
                        fontColor: mainDarkTextColor(context: context),
                      ),
                    )
                  : const SizedBox.shrink(),
              PaddingWidget.applySymmetricPadding(
                horizontal: viewModel.isFromAndroidScreen ? 15 : 0,
                child: Text(
                  viewModel.userGuideViewDataSource.title,
                  style: headerTwoMediumTextStyle(
                    context: context,
                    fontColor: titleTextColor(context: context),
                  ),
                ),
              ),
              verticalSpaceTiny,
              Expanded(
                child: SingleChildScrollView(
                  controller: viewModel.scrollController,
                  child: PaddingWidget.applySymmetricPadding(
                    horizontal: viewModel.isFromAndroidScreen ? 15 : 0,
                    child: Column(
                      children: <Widget>[
                        verticalSpaceMedium,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            GestureDetector(
                              onTap: () async {
                                viewModel.previousStepTapped();
                              },
                              child: Image.asset(
                                EnvironmentImages
                                    .userGuidePreviousIcon.fullImagePath,
                                width: 25,
                                height: 25,
                                color: viewModel.userGuideViewDataSource
                                        .isPreviousEnabled()
                                    ? context.appColors.baseBlack
                                    : context.appColors.grey_400,
                              ).imageSupportsRTL,
                            ),
                            Image.asset(
                              viewModel.userGuideViewDataSource.fullImagePath,
                              height: screenHeight - 300,
                              fit: BoxFit.fill,
                              //height: 280,
                            ),
                            GestureDetector(
                              onTap: () async {
                                viewModel.nextStepTapped();
                              },
                              child: Image.asset(
                                EnvironmentImages
                                    .userGuideNextIcon.fullImagePath,
                                width: 25,
                                height: 25,
                                color: viewModel.userGuideViewDataSource
                                        .isNextEnabled()
                                    ? context.appColors.baseBlack
                                    : context.appColors.grey_400,
                              ).imageSupportsRTL,
                            ),
                          ],
                        ),
                        verticalSpaceMedium,
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            viewModel.userGuideViewDataSource.stepNumberLabel,
                            style: headerThreeMediumTextStyle(
                              context: context,
                              fontColor: titleTextColor(context: context),
                            ),
                          ),
                        ),
                        // verticalSpaceSmall,
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            viewModel.userGuideViewDataSource.description,
                            style: bodyMediumTextStyle(
                              context: context,
                              fontColor: secondaryTextColor(context: context),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
      DiagnosticsProperty<UserGuideViewDataSource>(
        "userGuideViewDataSource",
        userGuideViewDataSource,
      ),
    );
  }
}
