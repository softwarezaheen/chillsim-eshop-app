import "package:easy_localization/easy_localization.dart";
import "package:esim_open_source/app/app.locator.dart";
import "package:esim_open_source/app/environment/environment_images.dart";
import "package:esim_open_source/domain/repository/services/app_configuration_service.dart";
import "package:esim_open_source/presentation/extensions/helper_extensions.dart";
import "package:esim_open_source/presentation/shared/shared_styles.dart";
import "package:esim_open_source/presentation/shared/ui_helpers.dart";
import "package:esim_open_source/presentation/views/base/base_view.dart";
import "package:esim_open_source/presentation/views/home_flow_views/profile_view/profile_view_sections/help_view/help_view_model.dart";
import "package:esim_open_source/presentation/widgets/common_navigation_title.dart";
import "package:esim_open_source/presentation/widgets/padding_widget.dart";
import "package:esim_open_source/translations/locale_keys.g.dart";
import "package:flutter/material.dart";

class HelpView extends StatelessWidget {
  const HelpView({super.key});
  static const String routeName = "HelpView";

  @override
  Widget build(BuildContext context) {
    return BaseView<HelpViewModel>(
      hideAppBar: true,
      routeName: routeName,
      viewModel: HelpViewModel(locator<AppConfigurationService>()),
      builder: (
        BuildContext context,
        HelpViewModel viewModel,
        Widget? childWidget,
        double screenHeight,
      ) =>
          PaddingWidget.applyPadding(
        top: 20,
        child: Column(
          children: <Widget>[
            CommonNavigationTitle(
              navigationTitle: LocaleKeys.profile_help.tr(),
              textStyle: headerTwoBoldTextStyle(
                context: context,
                fontColor: titleTextColor(context: context),
              ),
            ),
            verticalSpaceMedium,
            Expanded(
              child: PaddingWidget.applySymmetricPadding(
                horizontal: 20,
                child: ListView.separated(
                  itemCount: viewModel.helpSections.length,
                  separatorBuilder: (
                    BuildContext context,
                    int index,
                  ) =>
                      Divider(
                    color: greyBackGroundColor(context: context),
                  ),
                  itemBuilder: (
                    BuildContext context,
                    int index,
                  ) =>
                      GestureDetector(
                    onTap: () async {
                      viewModel.helpSections[index]
                          .tapAction(context, viewModel);
                    },
                    child: ColoredBox(
                      color: Colors.transparent,
                      child: PaddingWidget.applySymmetricPadding(
                        vertical: 15,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Image.asset(
                                  viewModel
                                      .helpSections[index].sectionImagePath,
                                  width: 15,
                                  height: 15,
                                ),
                                horizontalSpaceSmall,
                                Text(
                                  viewModel
                                      .helpSections[index].sectionTitle,
                                  style: bodyMediumTextStyle(
                                    context: context,
                                    fontColor: bubbleCountryTextColor(
                                        context: context,),
                                  ),
                                ),
                              ],
                            ),
                            Image.asset(
                              EnvironmentImages.darkArrowRight.fullImagePath,
                              width: 15,
                              height: 15,
                            ).imageSupportsRTL(context),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
