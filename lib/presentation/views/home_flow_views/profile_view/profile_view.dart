import "package:easy_localization/easy_localization.dart";
import "package:esim_open_source/app/app.locator.dart";
import "package:esim_open_source/app/environment/environment_images.dart";
import "package:esim_open_source/presentation/extensions/helper_extensions.dart";
import "package:esim_open_source/presentation/shared/shared_styles.dart";
import "package:esim_open_source/presentation/shared/ui_helpers.dart";
import "package:esim_open_source/presentation/views/base/base_view.dart";
import "package:esim_open_source/presentation/views/home_flow_views/profile_view/profile_view_model.dart";
import "package:esim_open_source/presentation/views/home_flow_views/profile_view/profile_view_sections.dart";
import "package:esim_open_source/presentation/widgets/main_button.dart";
import "package:esim_open_source/presentation/widgets/padding_widget.dart";
import "package:esim_open_source/translations/locale_keys.g.dart";
import "package:flutter/material.dart";

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});
  static String routeName = "ProfileView";

  @override
  Widget build(BuildContext context) {
    return BaseView<ProfileViewModel>(
      hideAppBar: true,
      routeName: routeName,
      enableBottomSafeArea: false,
      fireOnViewModelReadyOnce: true,
      viewModel: locator<ProfileViewModel>(),
      builder: (
        BuildContext context,
        ProfileViewModel viewModel,
        Widget? childWidget,
        double screenHeight,
      ) =>
          PaddingWidget.applySymmetricPadding(
        horizontal: 15,
        child: SizedBox.expand(
          child: Column(
            children: <Widget>[
              Image.asset(
                EnvironmentImages.profilePerson.fullImagePath,
                width: 80,
                height: 80,
              ),
              verticalSpaceSmall,
              getTopTrialingWidget(
                context: context,
                viewModel: viewModel,
              ),
              verticalSpaceMediumLarge,
              Expanded(
                child: GridView.builder(
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 1,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: ProfileViewSections.values
                      .where((section) => !section.isViewHidden(viewModel))
                      .length,
                  itemBuilder: (
                    BuildContext context,
                    int index,
                  ) {
                    final visibleSections = ProfileViewSections.values
                        .where((section) => !section.isViewHidden(viewModel))
                        .toList();
                    return profileSectionView(
                      context,
                      viewModel,
                      visibleSections[index],
                    );
                  },
                ),
              ),
              PaddingWidget.applySymmetricPadding(
                vertical: 5,
                child: Text(
                  LocaleKeys.profile_version.tr(
                    namedArgs: <String, String>{
                      "version": viewModel.appVersion,
                      "buildNumber": viewModel.buildNumber,
                    },
                  ),
                  style: captionTwoNormalTextStyle(
                    context: context,
                    fontColor: contentTextColor(context: context),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget profileSectionView(
    BuildContext context,
    ProfileViewModel viewModel,
    ProfileViewSections section,
  ) {
    return GestureDetector(
      onTap: () async {
        section.tapAction(context, viewModel);
      },
      child: Container(
        decoration: BoxDecoration(
          color: whiteBackGroundColor(context: context),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: greyBackGroundColor(context: context),
            width: 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              section.sectionImagePath,
              width: 32,
              height: 32,
            ),
            verticalSpaceTiny,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                section.sectionTitle,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: captionOneNormalTextStyle(
                  context: context,
                  fontColor: bubbleCountryTextColor(context: context),
                ).copyWith(fontSize: 11),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget getTopTrialingWidget({
    required BuildContext context,
    required ProfileViewModel viewModel,
  }) {
    return Column(
      children: <Widget>[
        Text(
          viewModel.isUserLoggedIn
              ? viewModel.getUserName()
              : LocaleKeys.profile_guest.tr(),
          textAlign: TextAlign.center,
          style: headerThreeBoldTextStyle(
            context: context,
            fontColor: titleTextColor(
              context: context,
            ),
          ),
        ),
        viewModel.isUserLoggedIn
            ? const SizedBox.shrink()
            : Column(
                children: <Widget>[
                  verticalSpaceTiny,
                  MainButton.bannerButton(
                    title: LocaleKeys.profile_login.tr(),
                    action: () async {
                      viewModel.loginButtonTapped();
                    },
                    themeColor: themeColor,
                    titleHorizontalPadding: 15,
                    textColor: enabledMainButtonTextColor(context: context),
                    buttonColor: enabledMainButtonColor(context: context),
                    titleTextStyle: bodyBoldTextStyle(
                      context: context,
                      fontColor: mainWhiteTextColor(context: context),
                    ).copyWith(fontWeight: FontWeight.w600),
                  ),
                ],
              ),
      ],
    );
  }
}
