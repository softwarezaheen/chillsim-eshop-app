import "package:easy_localization/easy_localization.dart";
import "package:esim_open_source/app/app.locator.dart";
import "package:esim_open_source/app/environment/environment_images.dart";
import "package:esim_open_source/domain/repository/services/app_configuration_service.dart";
import "package:esim_open_source/presentation/shared/shared_styles.dart";
import "package:esim_open_source/presentation/shared/ui_helpers.dart";
import "package:esim_open_source/presentation/views/home_flow_views/main_page/home_pager.dart";
import "package:esim_open_source/presentation/views/home_flow_views/main_page/home_pager_view_model.dart";
import "package:esim_open_source/presentation/widgets/main_button.dart";
import "package:esim_open_source/presentation/widgets/padding_widget.dart";
import "package:esim_open_source/presentation/widgets/stories_view/story_item.dart";
import "package:esim_open_source/translations/locale_keys.g.dart";
import "package:flutter/cupertino.dart";
import "package:stacked_services/stacked_services.dart";

class CashbackStoriesView {
  StoryViewerArgs storyViewerArgs = StoryViewerArgs(
    autoClose: false,
    indicatorHeight: 4,
    stories: <StoryItem>[
      // Page 1: Unlock Cashback
      StoryItem(
        content: DecoratedBox(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                EnvironmentImages.storyCar.fullImagePath,
              ),
              fit: BoxFit.cover,
            ),
          ),
          child: PaddingWidget.applySymmetricPadding(
            vertical: 120,
            horizontal: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      LocaleKeys.storiesView_cashbackTitle1.tr(),
                      style: headerOneBoldTextStyle(
                        context: StackedService.navigatorKey!.currentContext!,
                        fontColor: mainWhiteTextColor(
                          context: StackedService.navigatorKey!.currentContext!,
                        ),
                      ),
                    ),
                    verticalSpaceSmallMedium,
                    Text(
                      LocaleKeys.storiesView_cashbackContent1.tr(
                        namedArgs: <String, String>{
                          "threshold": locator<AppConfigurationService>().cashbackOrdersThreshold,
                          "percentage": locator<AppConfigurationService>().cashbackPercentage,
                        },
                      ),
                      style: bodyNormalTextStyle(
                        context: StackedService.navigatorKey!.currentContext!,
                        fontColor: mainWhiteTextColor(
                          context: StackedService.navigatorKey!.currentContext!,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        duration: const Duration(seconds: 5),
        buttons: PaddingWidget.applyPadding(
          end: 20,
          start: 20,
          bottom: 70,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              MainButton(
                onPressed: () async {
                  await locator<NavigationService>().clearTillFirstAndShow(
                    HomePager.routeName,
                  );
                  locator<HomePagerViewModel>()
                      .changeSelectedTabIndex(index: 0);
                },
                themeColor: themeColor,
                title: LocaleKeys.storiesView_purchaseNow.tr(),
                hideShadows: true,
                height: 55,
                enabledTextColor: enabledMainButtonTextColor(
                  context: StackedService.navigatorKey!.currentContext!,
                ),
                enabledBackgroundColor: enabledMainButtonColor(
                  context: StackedService.navigatorKey!.currentContext!,
                ),
              ),
              verticalSpaceSmall,
              MainButton(
                onPressed: () => locator<NavigationService>().back(),
                themeColor: themeColor,
                title: LocaleKeys.storiesView_notNow.tr(),
                hideShadows: true,
                height: 55,
                enabledTextColor: enabledMainButtonColor(
                  context: StackedService.navigatorKey!.currentContext!,
                ),
                enabledBackgroundColor: enabledMainButtonTextColor(
                  context: StackedService.navigatorKey!.currentContext!,
                ),
              ),
            ],
          ),
        ),
      ),
      // Page 2: Use Your Cashback
      StoryItem(
        content: DecoratedBox(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                EnvironmentImages.storyCar.fullImagePath,
              ),
              fit: BoxFit.cover,
            ),
          ),
          child: PaddingWidget.applySymmetricPadding(
            vertical: 120,
            horizontal: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      LocaleKeys.storiesView_cashbackTitle2.tr(),
                      style: headerOneBoldTextStyle(
                        context: StackedService.navigatorKey!.currentContext!,
                        fontColor: mainWhiteTextColor(
                          context: StackedService.navigatorKey!.currentContext!,
                        ),
                      ),
                    ),
                    verticalSpaceSmallMedium,
                    Text(
                      LocaleKeys.storiesView_cashbackContent2.tr(),
                      style: bodyNormalTextStyle(
                        context: StackedService.navigatorKey!.currentContext!,
                        fontColor: mainWhiteTextColor(
                          context: StackedService.navigatorKey!.currentContext!,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        duration: const Duration(seconds: 5),
        buttons: PaddingWidget.applyPadding(
          end: 20,
          start: 20,
          bottom: 70,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              MainButton(
                onPressed: () async {
                  await locator<NavigationService>().clearTillFirstAndShow(
                    HomePager.routeName,
                  );
                  locator<HomePagerViewModel>()
                      .changeSelectedTabIndex(index: 0);
                },
                themeColor: themeColor,
                title: LocaleKeys.storiesView_purchaseNow.tr(),
                hideShadows: true,
                height: 55,
                enabledTextColor: enabledMainButtonTextColor(
                  context: StackedService.navigatorKey!.currentContext!,
                ),
                enabledBackgroundColor: enabledMainButtonColor(
                  context: StackedService.navigatorKey!.currentContext!,
                ),
              ),
              verticalSpaceSmall,
              MainButton(
                onPressed: () => locator<NavigationService>().back(),
                themeColor: themeColor,
                title: LocaleKeys.storiesView_notNow.tr(),
                hideShadows: true,
                height: 55,
                enabledTextColor: enabledMainButtonColor(
                  context: StackedService.navigatorKey!.currentContext!,
                ),
                enabledBackgroundColor: enabledMainButtonTextColor(
                  context: StackedService.navigatorKey!.currentContext!,
                ),
              ),
            ],
          ),
        ),
      ),
      // Page 3: Terms & Conditions
      StoryItem(
        content: DecoratedBox(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                EnvironmentImages.storyCar.fullImagePath,
              ),
              fit: BoxFit.cover,
            ),
          ),
          child: PaddingWidget.applySymmetricPadding(
            vertical: 120,
            horizontal: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      LocaleKeys.storiesView_cashbackTitle3.tr(),
                      style: headerOneBoldTextStyle(
                        context: StackedService.navigatorKey!.currentContext!,
                        fontColor: mainWhiteTextColor(
                          context: StackedService.navigatorKey!.currentContext!,
                        ),
                      ),
                    ),
                    verticalSpaceSmallMedium,
                    Text(
                      LocaleKeys.storiesView_cashbackContent3.tr(),
                      style: bodyNormalTextStyle(
                        context: StackedService.navigatorKey!.currentContext!,
                        fontColor: mainWhiteTextColor(
                          context: StackedService.navigatorKey!.currentContext!,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        duration: const Duration(seconds: 5),
        buttons: PaddingWidget.applyPadding(
          end: 20,
          start: 20,
          bottom: 70,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              MainButton(
                onPressed: () async {
                  await locator<NavigationService>().clearTillFirstAndShow(
                    HomePager.routeName,
                  );
                  locator<HomePagerViewModel>()
                      .changeSelectedTabIndex(index: 0);
                },
                themeColor: themeColor,
                title: LocaleKeys.storiesView_purchaseNow.tr(),
                hideShadows: true,
                height: 55,
                enabledTextColor: enabledMainButtonTextColor(
                  context: StackedService.navigatorKey!.currentContext!,
                ),
                enabledBackgroundColor: enabledMainButtonColor(
                  context: StackedService.navigatorKey!.currentContext!,
                ),
              ),
              verticalSpaceSmall,
              MainButton(
                onPressed: () => locator<NavigationService>().back(),
                themeColor: themeColor,
                title: LocaleKeys.storiesView_notNow.tr(),
                hideShadows: true,
                height: 55,
                enabledTextColor: enabledMainButtonColor(
                  context: StackedService.navigatorKey!.currentContext!,
                ),
                enabledBackgroundColor: enabledMainButtonTextColor(
                  context: StackedService.navigatorKey!.currentContext!,
                ),
              ),
            ],
          ),
        ),
      ),
    ],
  );
}
