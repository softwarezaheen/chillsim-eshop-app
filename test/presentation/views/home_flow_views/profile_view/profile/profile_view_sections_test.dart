import "package:easy_localization/easy_localization.dart";
import "package:esim_open_source/app/environment/app_environment.dart";
import "package:esim_open_source/app/environment/environment_images.dart";
import "package:esim_open_source/presentation/views/home_flow_views/profile_view/profile_view_model.dart";
import "package:esim_open_source/presentation/views/home_flow_views/profile_view/profile_view_sections.dart";
import "package:esim_open_source/presentation/views/home_flow_views/profile_view/profile_view_sections/account_view/account_view.dart";
import "package:esim_open_source/presentation/views/home_flow_views/profile_view/profile_view_sections/dynamic_data_view/dynamic_data_view.dart";
import "package:esim_open_source/presentation/views/home_flow_views/profile_view/profile_view_sections/dynamic_data_view/dynamic_data_view_model.dart";
import "package:esim_open_source/presentation/views/home_flow_views/profile_view/profile_view_sections/dynamic_selection_view/dynamic_selection_view.dart";
import "package:esim_open_source/presentation/views/home_flow_views/profile_view/profile_view_sections/help_view/help_view.dart";
import "package:esim_open_source/presentation/views/home_flow_views/profile_view/profile_view_sections/my_wallet_view/my_wallet_view.dart";
import "package:esim_open_source/presentation/views/home_flow_views/profile_view/profile_view_sections/order_history_view/order_history_view.dart";
import "package:esim_open_source/presentation/views/home_flow_views/profile_view/profile_view_sections/payment_methods_view/payment_methods_view.dart";
import "package:esim_open_source/presentation/views/home_flow_views/profile_view/profile_view_sections/rewards_view/rewards_view.dart";
import "package:esim_open_source/presentation/views/home_flow_views/profile_view/profile_view_sections/user_guide_view/user_guide_view.dart";
import "package:esim_open_source/translations/locale_keys.g.dart";
import "package:flutter_test/flutter_test.dart";
import "package:mockito/mockito.dart";
import "package:stacked_services/stacked_services.dart";

import "../../../../../helpers/fake_build_context.dart";
import "../../../../../helpers/view_helper.dart";
import "../../../../../helpers/view_model_helper.dart";
import "../../../../../locator_test.dart";

Future<void> main() async {
  await prepareTest();

  setUp(() async {
    await setupTest();
    onViewModelReadyMock(viewName: "ProfileView");
  });

  tearDown(() async {
    await tearDownTest();
  });

  group("ProfileViewSections Tests", () {
    late ProfileViewModel viewModel;

    setUp(() {
      viewModel = ProfileViewModel();
    });

    test("tap action myWallet", () async {
      when(locator<NavigationService>().navigateTo(MyWalletView.routeName))
          .thenAnswer((_) {
        return null;
      });
      await ProfileViewSections.myWallet.tapAction(FakeContext(), viewModel);
    });

    test("tap action orderHistory", () async {
      when(locator<NavigationService>().navigateTo(OrderHistoryView.routeName))
          .thenAnswer((_) {
        return null;
      });
      await ProfileViewSections.orderHistory.tapAction(FakeContext(), viewModel);
    });

    test("tap action termsAndConditions", () async {
      when(
        locator<NavigationService>().navigateTo(
          DynamicDataView.routeName,
          arguments: DynamicDataViewType.termsConditions,
        ),
      ).thenAnswer((_) {
        return null;
      });
      await ProfileViewSections.termsAndConditions.tapAction(FakeContext(), viewModel);
    });

    test("tap action installationGuide", () async {
      when(
        locator<NavigationService>().navigateTo(
          UserGuideView.routeName,
        ),
      ).thenAnswer((_) {
        return null;
      });
      await ProfileViewSections.installationGuide.tapAction(FakeContext(), viewModel);
    });

    test("tap action account", () async {
      when(locator<NavigationService>().navigateTo(AccountView.routeName))
          .thenAnswer((_) {
        return null;
      });
      await ProfileViewSections.account.tapAction(FakeContext(), viewModel);
    });

    test("tap action rewards", () async {
      when(locator<NavigationService>().navigateTo(RewardsView.routeName))
          .thenAnswer((_) {
        return null;
      });
      await ProfileViewSections.rewards.tapAction(FakeContext(), viewModel);
    });

    test("tap action paymentMethods", () async {
      when(locator<NavigationService>().navigateTo(PaymentMethodsView.routeName))
          .thenAnswer((_) {
        return null;
      });
      await ProfileViewSections.paymentMethods.tapAction(FakeContext(), viewModel);
    });

    test("tap action help", () async {
      when(locator<NavigationService>().navigateTo(HelpView.routeName))
          .thenAnswer((_) {
        return null;
      });
      await ProfileViewSections.help.tapAction(FakeContext(), viewModel);
    });

    test("tap action language", () async {
      when(locator<NavigationService>().navigateTo(
        DynamicSelectionView.routeName,
        arguments: anyNamed("arguments"),
      ),).thenAnswer((_) {
        return null;
      });
      await ProfileViewSections.language.tapAction(FakeContext(), viewModel);
    });

    test("tap action currency", () async {
      when(locator<NavigationService>().navigateTo(
        DynamicSelectionView.routeName,
        arguments: anyNamed("arguments"),
      ),).thenAnswer((_) {
        return null;
      });
      await ProfileViewSections.currency.tapAction(FakeContext(), viewModel);
    });

    group("Enum Values", () {
      test("all enum values exist", () {
        const List<ProfileViewSections> expectedSections =
            <ProfileViewSections>[
          ProfileViewSections.account,
          ProfileViewSections.installationGuide,
          ProfileViewSections.orderHistory,
          ProfileViewSections.rewards,
          ProfileViewSections.myWallet,
          ProfileViewSections.paymentMethods,
          ProfileViewSections.language,
          ProfileViewSections.currency,
          ProfileViewSections.help,
          ProfileViewSections.termsAndConditions,
        ];

        expect(ProfileViewSections.values, expectedSections);
      });
    });

    group("isViewHidden Tests", () {
      test("currency section hidden when currency selection disabled", () {
        AppEnvironment.appEnvironmentHelper.enableCurrencySelection = false;

        final bool isHidden =
            ProfileViewSections.currency.isViewHidden(viewModel);

        expect(isHidden, isTrue);
      });

      test("currency section visible when currency selection enabled", () {
        AppEnvironment.appEnvironmentHelper.enableCurrencySelection = true;

        final bool isHidden =
            ProfileViewSections.currency.isViewHidden(viewModel);

        expect(isHidden, isFalse);
      });

      test("user-dependent sections work with different login states", () {
        const List<ProfileViewSections> userDependentSections =
            <ProfileViewSections>[
          ProfileViewSections.myWallet,
          ProfileViewSections.orderHistory,
          ProfileViewSections.account,
          ProfileViewSections.rewards,
          ProfileViewSections.paymentMethods,
        ];

        for (final ProfileViewSections section in userDependentSections) {
          expect(() => section.isViewHidden(viewModel), returnsNormally);
        }
      });

      test("language section hidden when language selection disabled", () {
        AppEnvironment.appEnvironmentHelper.enableLanguageSelection = false;

        final bool isHidden =
            ProfileViewSections.language.isViewHidden(viewModel);

        expect(isHidden, isTrue);
      });

      test("language section visible when language selection enabled", () {
        AppEnvironment.appEnvironmentHelper.enableLanguageSelection = true;

        final bool isHidden =
            ProfileViewSections.language.isViewHidden(viewModel);

        expect(isHidden, isFalse);
      });

      test("default sections are visible", () {
        const List<ProfileViewSections> defaultVisibleSections =
            <ProfileViewSections>[
          ProfileViewSections.help,
          ProfileViewSections.termsAndConditions,
          ProfileViewSections.installationGuide,
        ];

        for (final ProfileViewSections section in defaultVisibleSections) {
          final bool isHidden = section.isViewHidden(viewModel);
          expect(isHidden, isFalse,
              reason: "Section ${section.name} should be visible by default",);
        }
      });
    });

    group("isHeaderTitle Tests", () {
      test("all sections return false for isHeaderTitle", () {
        for (final ProfileViewSections section in ProfileViewSections.values) {
          expect(section.isHeaderTitle, isFalse,
              reason: "Section ${section.name} should not be header title",);
        }
      });
    });

    group("sectionTitle Tests", () {
      test("all sections return correct localized titles", () {
        expect(ProfileViewSections.account.sectionTitle,
            equals(LocaleKeys.profile_account.tr()),);
        expect(ProfileViewSections.myWallet.sectionTitle,
            equals(LocaleKeys.profile_myWallet.tr()),);
        expect(ProfileViewSections.orderHistory.sectionTitle,
            equals(LocaleKeys.profile_orderHistory.tr()),);
        expect(ProfileViewSections.rewards.sectionTitle,
            equals(LocaleKeys.profile_rewards.tr()),);
        expect(ProfileViewSections.paymentMethods.sectionTitle,
            equals(LocaleKeys.payment_methods_title.tr()),);
        expect(ProfileViewSections.help.sectionTitle,
            equals(LocaleKeys.profile_help.tr()),);
        expect(ProfileViewSections.termsAndConditions.sectionTitle,
            equals(LocaleKeys.profile_termsConditions.tr()),);
        expect(ProfileViewSections.installationGuide.sectionTitle,
            equals(LocaleKeys.profile_userGuide.tr()),);
        expect(ProfileViewSections.language.sectionTitle,
            equals(LocaleKeys.profile_language.tr()),);
        expect(ProfileViewSections.currency.sectionTitle,
            equals(LocaleKeys.profile_currency.tr()),);
      });
    });

    group("sectionImagePath Tests", () {
      test("sections return correct image paths", () {
        expect(ProfileViewSections.myWallet.sectionImagePath,
            equals(EnvironmentImages.wallet.fullImagePath),);
        expect(ProfileViewSections.orderHistory.sectionImagePath,
            equals(EnvironmentImages.orderHistory.fullImagePath),);
        expect(ProfileViewSections.termsAndConditions.sectionImagePath,
            equals(EnvironmentImages.termsAndConditions.fullImagePath),);
        expect(ProfileViewSections.installationGuide.sectionImagePath,
            equals(EnvironmentImages.userGuide.fullImagePath),);
        expect(ProfileViewSections.language.sectionImagePath,
            equals(EnvironmentImages.language.fullImagePath),);
        expect(ProfileViewSections.currency.sectionImagePath,
            equals(EnvironmentImages.currency.fullImagePath),);
      });
    });

    group("_sectionImage Tests", () {
      test("sections return correct image names", () {
        expect(
            ProfileViewSections.myWallet.sectionImagePath, contains("wallet"),);
        expect(ProfileViewSections.orderHistory.sectionImagePath,
            contains("orderHistory"),);
        expect(ProfileViewSections.termsAndConditions.sectionImagePath,
            contains("termsAndConditions"),);
        expect(ProfileViewSections.installationGuide.sectionImagePath,
            contains("userGuide"),);
        expect(ProfileViewSections.language.sectionImagePath,
            contains("language"),);
        expect(ProfileViewSections.currency.sectionImagePath,
            contains("currency"),);
        expect(ProfileViewSections.help.sectionImagePath, contains("faq"));
      });
    });
  });
}
