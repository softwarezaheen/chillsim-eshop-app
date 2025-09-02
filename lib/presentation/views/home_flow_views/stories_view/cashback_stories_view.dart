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
      StoryItem(
        content: DecoratedBox(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                EnvironmentImages.storyCar.fullImagePath,
              ),
              fit: BoxFit.cover, // Cover, contain, etc.
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
                      LocaleKeys.storiesView_cashbackTitle.tr(),
                      style: headerOneBoldTextStyle(
                        context: StackedService.navigatorKey!.currentContext!,
                        fontColor: mainWhiteTextColor(
                          context: StackedService.navigatorKey!.currentContext!,
                        ),
                      ),
                    ),
                    verticalSpaceSmallMedium,
                    Text(
                      LocaleKeys.storiesView_cashbackContent.tr(
                        namedArgs: <String, String>{
                          "CashbackDiscount":
                          locator<AppConfigurationService>().getCashbackDiscount,
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
    ],
  );
}
