import "package:easy_localization/easy_localization.dart";
import "package:esim_open_source/app/environment/app_environment.dart";
import "package:esim_open_source/app/environment/environment_images.dart";
import "package:esim_open_source/domain/repository/services/analytics_service.dart";
import "package:esim_open_source/presentation/views/home_flow_views/profile_view/profile_view_model.dart";
import "package:esim_open_source/presentation/views/home_flow_views/profile_view/profile_view_sections/account_view/account_view.dart";
import "package:esim_open_source/presentation/views/home_flow_views/profile_view/profile_view_sections/dynamic_data_view/dynamic_data_view.dart";
import "package:esim_open_source/presentation/views/home_flow_views/profile_view/profile_view_sections/dynamic_data_view/dynamic_data_view_model.dart";
import "package:esim_open_source/presentation/views/home_flow_views/profile_view/profile_view_sections/dynamic_selection_view/dynamic_selection_view.dart";
import "package:esim_open_source/presentation/views/home_flow_views/profile_view/profile_view_sections/dynamic_selection_view/dynamic_selection_view_model.dart";
import "package:esim_open_source/presentation/views/home_flow_views/profile_view/profile_view_sections/help_view/help_view.dart";
import "package:esim_open_source/presentation/views/home_flow_views/profile_view/profile_view_sections/my_wallet_view/my_wallet_view.dart";
import "package:esim_open_source/presentation/views/home_flow_views/profile_view/profile_view_sections/order_history_view/order_history_view.dart";
import "package:esim_open_source/presentation/views/home_flow_views/profile_view/profile_view_sections/payment_methods_view/payment_methods_view.dart";
import "package:esim_open_source/presentation/views/home_flow_views/profile_view/profile_view_sections/rewards_view/rewards_view.dart";
import "package:esim_open_source/presentation/views/home_flow_views/profile_view/profile_view_sections/user_guide_view/user_guide_view.dart";
import "package:esim_open_source/translations/locale_keys.g.dart";
import "package:flutter/material.dart";

enum ProfileViewSections {
  // Main grid items (9 items max, some hidden when not logged in)
  account,
  installationGuide,
  orderHistory,
  rewards,
  myWallet,
  paymentMethods,
  language,
  currency,
  help,
  termsAndConditions;

  bool isViewHidden(ProfileViewModel viewModel) {
    switch (this) {
      case ProfileViewSections.currency:
        return !AppEnvironment.appEnvironmentHelper.enableCurrencySelection;
      case ProfileViewSections.myWallet:
        return !viewModel.isUserLoggedIn ||
            !AppEnvironment.appEnvironmentHelper.enableWalletView;
      case ProfileViewSections.paymentMethods:
        return !viewModel.isUserLoggedIn;
      case ProfileViewSections.orderHistory:
        return !viewModel.isUserLoggedIn;
      case ProfileViewSections.account:
        return !viewModel.isUserLoggedIn;
      case ProfileViewSections.rewards:
        return !viewModel.isUserLoggedIn ||
            (!AppEnvironment.appEnvironmentHelper.enableReferral &&
             !AppEnvironment.appEnvironmentHelper.enableCashBack &&
             !AppEnvironment.appEnvironmentHelper.enableRewardsHistory);
      case ProfileViewSections.language:
        return !AppEnvironment.appEnvironmentHelper.enableLanguageSelection;
      default:
        return false;
    }
  }

  bool get isHeaderTitle => false;

  String get sectionTitle {
    switch (this) {
      case ProfileViewSections.account:
        return LocaleKeys.profile_account.tr();
      case ProfileViewSections.installationGuide:
        return LocaleKeys.profile_userGuide.tr();
      case ProfileViewSections.orderHistory:
        return LocaleKeys.profile_orderHistory.tr();
      case ProfileViewSections.rewards:
        return LocaleKeys.profile_rewards.tr();
      case ProfileViewSections.myWallet:
        return LocaleKeys.profile_myWallet.tr();
      case ProfileViewSections.paymentMethods:
        return LocaleKeys.payment_methods_title.tr();
      case ProfileViewSections.language:
        return LocaleKeys.profile_language.tr();
      case ProfileViewSections.currency:
        return LocaleKeys.profile_currency.tr();
      case ProfileViewSections.help:
        return LocaleKeys.profile_help.tr();
      case ProfileViewSections.termsAndConditions:
        return LocaleKeys.profile_termsConditions.tr();
    }
  }

  String get sectionImagePath => EnvironmentImages.values
      .firstWhere(
        (EnvironmentImages e) => e.name == _sectionImage,
        orElse: () => EnvironmentImages.wallet,
      )
      .fullImagePath;

  double get sectionImageSize => 32;

  String get _sectionImage {
    switch (this) {
      case ProfileViewSections.account:
        return "account";
      case ProfileViewSections.installationGuide:
        return "userGuide";
      case ProfileViewSections.orderHistory:
        return "orderHistory";
      case ProfileViewSections.rewards:
        return "rewards";
      case ProfileViewSections.myWallet:
        return "wallet";
      case ProfileViewSections.paymentMethods:
        return "payByCardIcon";
      case ProfileViewSections.language:
        return "language";
      case ProfileViewSections.currency:
        return "currency";
      case ProfileViewSections.help:
        return "faq";
      case ProfileViewSections.termsAndConditions:
        return "termsAndConditions";
    }
  }

  Future<void> tapAction(BuildContext context, ProfileViewModel viewModel) async {
    switch (this) {
      case ProfileViewSections.account:
        viewModel.navigationService.navigateTo(AccountView.routeName);
      case ProfileViewSections.installationGuide:
        viewModel.analyticsService
            .logEvent(event: AnalyticEvent.userGuideOpened());
        viewModel.navigationService.navigateTo(
          UserGuideView.routeName,
        );
      case ProfileViewSections.orderHistory:
        viewModel.navigationService.navigateTo(OrderHistoryView.routeName);
      case ProfileViewSections.rewards:
        viewModel.navigationService.navigateTo(RewardsView.routeName);
      case ProfileViewSections.myWallet:
        viewModel.navigationService.navigateTo(MyWalletView.routeName);
      case ProfileViewSections.paymentMethods:
        viewModel.navigationService.navigateTo(PaymentMethodsView.routeName);
      case ProfileViewSections.language:
        viewModel.navigationService.navigateTo(
          DynamicSelectionView.routeName,
          arguments: LanguagesDataSource(),
        );
      case ProfileViewSections.currency:
        viewModel.navigationService.navigateTo(
          DynamicSelectionView.routeName,
          arguments: CurrenciesDataSource(),
        );
      case ProfileViewSections.help:
        viewModel.navigationService.navigateTo(HelpView.routeName);
      case ProfileViewSections.termsAndConditions:
        viewModel.navigationService.navigateTo(
          DynamicDataView.routeName,
          arguments: DynamicDataViewType.termsConditions,
        );
    }
  }
}
