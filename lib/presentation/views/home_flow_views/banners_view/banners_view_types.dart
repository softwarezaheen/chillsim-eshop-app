import "package:easy_localization/easy_localization.dart";
import "package:esim_open_source/app/app.locator.dart";
import "package:esim_open_source/app/environment/environment_images.dart";
import "package:esim_open_source/domain/repository/services/app_configuration_service.dart";
import "package:esim_open_source/presentation/reactive_service/user_authentication_service.dart";
import "package:esim_open_source/presentation/shared/action_helpers.dart";
import "package:esim_open_source/presentation/shared/in_app_redirection_heper.dart";
import "package:esim_open_source/presentation/views/home_flow_views/stories_view/cashback_stories_view.dart";
import "package:esim_open_source/presentation/views/home_flow_views/stories_view/referal_stories_view.dart";
import "package:esim_open_source/presentation/views/pre_sign_in/login_view/login_view.dart";
import "package:esim_open_source/presentation/widgets/stories_view/story_viewer.dart";
import "package:esim_open_source/translations/locale_keys.g.dart";
import "package:stacked_services/stacked_services.dart";

enum BannersViewTypes { liveChat, referAndEarn, cashBackRewards }

extension BannersViewTypesExtension on BannersViewTypes {
  String get titleText {
    switch (this) {
      case BannersViewTypes.liveChat:
        return LocaleKeys.dataPlans_liveChatBannerTitle.tr();
      case BannersViewTypes.referAndEarn:
        return LocaleKeys.dataPlans_referAndEarnBannerTitle.tr();
      case BannersViewTypes.cashBackRewards:
        return LocaleKeys.dataPlans_cashbackRewardsBannerTitle.tr();
    }
  }

  String get contentText {
    switch (this) {
      case BannersViewTypes.liveChat:
        return LocaleKeys.dataPlans_liveChatBannerContent.tr();
      case BannersViewTypes.referAndEarn:
        return LocaleKeys.dataPlans_referAndEarnBannerContent.tr();
      case BannersViewTypes.cashBackRewards:
        return LocaleKeys.dataPlans_cashbackRewardsBannerContent.tr();
    }
  }

  String get buttonText {
    switch (this) {
      case BannersViewTypes.liveChat:
        return LocaleKeys.dataPlans_liveChatBannerButtonText.tr();
      case BannersViewTypes.referAndEarn:
        return LocaleKeys.dataPlans_referAndEarnBannerButtonText.tr();
      case BannersViewTypes.cashBackRewards:
        return LocaleKeys.dataPlans_cashbackRewardsBannerButtonText.tr();
    }
  }

  String get backGroundImage {
    switch (this) {
      case BannersViewTypes.liveChat:
        return EnvironmentImages.bannersLiveChat.fullImagePath;
      case BannersViewTypes.referAndEarn:
        return EnvironmentImages.bannersReferAndEarn.fullImagePath;
      case BannersViewTypes.cashBackRewards:
        return EnvironmentImages.bannersCashback.fullImagePath;
    }
  }

  Future<void> get onTapGesture async {
    switch (this) {
      case BannersViewTypes.liveChat:
        openWhatsApp(
          phoneNumber:
              await locator<AppConfigurationService>().getWhatsAppNumber,
          message: "",
        );
      case BannersViewTypes.referAndEarn:
        if (locator<UserAuthenticationService>().isUserLoggedIn) {
          locator<NavigationService>().navigateTo(
            StoryViewer.routeName,
            arguments:
                ReferalStoriesView(StackedService.navigatorKey!.currentContext!)
                    .storyViewerArgs,
          );
          return;
        }
        locator<NavigationService>().navigateTo(
          LoginView.routeName,
          arguments: InAppRedirection.referral(),
        );
      case BannersViewTypes.cashBackRewards:
        if (locator<UserAuthenticationService>().isUserLoggedIn) {
          locator<NavigationService>().navigateTo(
            StoryViewer.routeName,
            arguments: CashbackStoriesView().storyViewerArgs,
          );
          return;
        }
        locator<NavigationService>().navigateTo(
          LoginView.routeName,
          arguments: InAppRedirection.cashback(),
        );
    }
  }
}
