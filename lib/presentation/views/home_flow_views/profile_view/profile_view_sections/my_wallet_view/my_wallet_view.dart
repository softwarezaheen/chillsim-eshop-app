import "package:easy_localization/easy_localization.dart";
import "package:esim_open_source/app/environment/environment_images.dart";
import "package:esim_open_source/presentation/extensions/helper_extensions.dart";
import "package:esim_open_source/presentation/extensions/shimmer_extensions.dart";
import "package:esim_open_source/presentation/shared/shared_styles.dart";
import "package:esim_open_source/presentation/shared/ui_helpers.dart";
import "package:esim_open_source/presentation/views/base/base_view.dart";
import "package:esim_open_source/presentation/views/home_flow_views/profile_view/profile_view_sections/my_wallet_view/my_wallet_view_model.dart";
import "package:esim_open_source/presentation/widgets/common_navigation_title.dart";
import "package:esim_open_source/presentation/widgets/padding_widget.dart";
import "package:esim_open_source/translations/locale_keys.g.dart";
import "package:flutter/material.dart";

class MyWalletView extends StatelessWidget {
  const MyWalletView({super.key});
  static const String routeName = "MyWalletView";

  @override
  Widget build(BuildContext context) {
    return BaseView<MyWalletViewModel>(
      hideAppBar: true,
      routeName: routeName,
      viewModel: MyWalletViewModel(),
      builder: (
        BuildContext context,
        MyWalletViewModel viewModel,
        Widget? childWidget,
        double screenHeight,
      ) =>
          PaddingWidget.applyPadding(
        top: 20,
        child: Column(
          children: <Widget>[
            CommonNavigationTitle(
              navigationTitle: LocaleKeys.profile_myWallet.tr(),
              textStyle: headerTwoBoldTextStyle(
                context: context,
                fontColor: titleTextColor(context: context),
              ),
            ),
            verticalSpaceMedium,
            PaddingWidget.applySymmetricPadding(
              horizontal: 15,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: lightGreyBackGroundColor(context: context),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: PaddingWidget.applySymmetricPadding(
                  vertical: 25,
                  horizontal: 15,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              LocaleKeys.myWallet_availableBalanceText.tr(),
                              style: captionThreeNormalTextStyle(
                                context: context,
                                fontColor: secondaryTextColor(context: context),
                              ),
                            ),
                            Text(
                              "${viewModel.userAuthenticationService.walletCurrencyCode} ${viewModel.userAuthenticationService.walletAvailableBalance}",
                              style: headerZeroBoldTextStyle(
                                context: context,
                                fontColor: titleTextColor(context: context),
                              ),
                            ).applyShimmer(
                              context: context,
                              enable: viewModel.applyShimmer,
                            ),
                          ],
                        ),
                      ),
                      Image.asset(
                        EnvironmentImages.walletIcon.fullImagePath,
                        width: 80,
                        height: 80,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            verticalSpaceMedium,
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  viewModel.refreshUserInfo();
                },
                color: myEsimSecondaryBackGroundColor(context: context),
                child: PaddingWidget.applySymmetricPadding(
                  horizontal: 20,
                  child: ListView.separated(
                    itemCount: viewModel.walletSections.length,
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
                        viewModel.walletSections[index]
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
                                        .walletSections[index].sectionImagePath,
                                    width: 15,
                                    height: 15,
                                  ),
                                  horizontalSpaceSmall,
                                  Text(
                                    viewModel
                                        .walletSections[index].sectionTitle,
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
            ),
          ],
        ),
      ),
    );
  }
}
