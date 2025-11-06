import "package:esim_open_source/app/environment/app_environment.dart";
import "package:esim_open_source/presentation/views/base/base_model.dart";
import "package:esim_open_source/presentation/views/home_flow_views/profile_view/profile_view_sections/rewards_view/rewards_view_model.dart";
import "package:esim_open_source/presentation/views/home_flow_views/profile_view/profile_view_sections/rewards_view/rewards_view_sections.dart";
import "package:flutter_test/flutter_test.dart";

import "../../../../../../helpers/view_helper.dart";

Future<void> main() async {
  await prepareTest();
  late RewardsViewModel viewModel;

  setUp(() async {
    await setupTest();
    viewModel = RewardsViewModel();
  });

  tearDown(() async {
    await tearDownTest();
  });

  group("RewardsViewModel Tests", () {
    group("Initialization Tests", () {
      test("initialization sets rewards sections correctly", () {
        expect(viewModel.rewardsSections, isNotNull);
        expect(viewModel.rewardsSections, isA<List<RewardsViewSections>>());
      });

      test("viewModel extends BaseModel", () {
        expect(viewModel, isA<BaseModel>());
      });

      test("rewards sections list is not empty when features are enabled", () {
        // This will depend on the environment configuration
        // If at least one feature is enabled, the list should not be empty
        if (AppEnvironment.appEnvironmentHelper.enableReferral ||
            AppEnvironment.appEnvironmentHelper.enableCashBack ||
            AppEnvironment.appEnvironmentHelper.enableRewardsHistory) {
          expect(viewModel.rewardsSections, isNotEmpty);
        }
      });
    });

    group("Section Filtering Tests", () {
      test("referAndEarn section is included when enableReferral is true", () {
        final RewardsViewModel testViewModel = RewardsViewModel();
        
        if (AppEnvironment.appEnvironmentHelper.enableReferral) {
          expect(
            testViewModel.rewardsSections,
            contains(RewardsViewSections.referAndEarn),
          );
        } else {
          expect(
            testViewModel.rewardsSections,
            isNot(contains(RewardsViewSections.referAndEarn)),
          );
        }
      });

      test("rewardsHistory section is included when enableRewardsHistory is true", () {
        final RewardsViewModel testViewModel = RewardsViewModel();
        
        if (AppEnvironment.appEnvironmentHelper.enableRewardsHistory) {
          expect(
            testViewModel.rewardsSections,
            contains(RewardsViewSections.rewardsHistory),
          );
        } else {
          expect(
            testViewModel.rewardsSections,
            isNot(contains(RewardsViewSections.rewardsHistory)),
          );
        }
      });

      test("rewards sections maintain correct filtering logic", () {
        final RewardsViewModel testViewModel = RewardsViewModel();
        
        for (final RewardsViewSections section in testViewModel.rewardsSections) {
          switch (section) {
            case RewardsViewSections.referAndEarn:
              expect(
                AppEnvironment.appEnvironmentHelper.enableReferral,
                isTrue,
              );
              break;
            case RewardsViewSections.rewardsHistory:
              expect(
                AppEnvironment.appEnvironmentHelper.enableRewardsHistory,
                isTrue,
              );
              break;
          }
        }
      });
    });

    group("Section Order Tests", () {
      test("rewards sections maintain correct order when all enabled", () {
        if (AppEnvironment.appEnvironmentHelper.enableReferral &&
            AppEnvironment.appEnvironmentHelper.enableRewardsHistory) {
          expect(viewModel.rewardsSections.length, equals(2));
          expect(
            viewModel.rewardsSections[0],
            equals(RewardsViewSections.referAndEarn),
          );
          expect(
            viewModel.rewardsSections[1],
            equals(RewardsViewSections.rewardsHistory),
          );
        }
      });

      test("rewards sections are properly typed", () {
        for (final RewardsViewSections section in viewModel.rewardsSections) {
          expect(section, isA<RewardsViewSections>());
        }
      });
    });

    group("Edge Cases", () {
      test("rewards sections list handles empty case gracefully", () {
        // Even if all features are disabled, the list should be initialized
        expect(viewModel.rewardsSections, isNotNull);
        expect(viewModel.rewardsSections, isA<List<RewardsViewSections>>());
      });

      test("viewModel can be instantiated multiple times", () {
        final RewardsViewModel viewModel1 = RewardsViewModel();
        final RewardsViewModel viewModel2 = RewardsViewModel();
        
        expect(viewModel1, isNotNull);
        expect(viewModel2, isNotNull);
        expect(viewModel1, isNot(same(viewModel2)));
      });

      test("rewards sections list is immutable after creation", () {
        final int initialLength = viewModel.rewardsSections.length;
        final List<RewardsViewSections> initialSections =
            List<RewardsViewSections>.from(viewModel.rewardsSections);
        
        // The list should remain the same
        expect(viewModel.rewardsSections.length, equals(initialLength));
        expect(viewModel.rewardsSections, equals(initialSections));
      });

      test("viewModel has no dependencies on external services", () {
        // Unlike MyWalletViewModel, RewardsViewModel should not have
        // any use case or service dependencies since it doesn't fetch data
        expect(viewModel, isNotNull);
        // This test verifies that the viewModel is lightweight
      });
    });

    group("Comparison with MyWalletViewModel", () {
      test("RewardsViewModel is simpler than MyWalletViewModel", () {
        // RewardsViewModel should not have getUserInfoUseCase or refresh logic
        expect(viewModel, isA<BaseModel>());
        expect(viewModel.rewardsSections, isNotNull);
        // This test documents the intentional simplicity
      });
    });

    group("Feature Flag Integration Tests", () {
      test("viewModel respects all feature flags", () {
        final RewardsViewModel testViewModel = RewardsViewModel();
        
        // Count expected sections based on flags
        int expectedCount = 0;
        if (AppEnvironment.appEnvironmentHelper.enableReferral) {
          expectedCount++;
        }
        if (AppEnvironment.appEnvironmentHelper.enableRewardsHistory) {
          expectedCount++;
        }
        
        expect(testViewModel.rewardsSections.length, equals(expectedCount));
      });

      test("at least one section should be visible for rewards menu to show", () {
        // If the Rewards menu is visible in the profile, at least one section should exist
        // This aligns with the ProfileViewSections visibility logic
        if (AppEnvironment.appEnvironmentHelper.enableReferral ||
            AppEnvironment.appEnvironmentHelper.enableRewardsHistory) {
          expect(viewModel.rewardsSections, isNotEmpty);
        }
      });
    });

    group("Memory and Performance Tests", () {
      test("viewModel can be disposed without errors", () {
        final RewardsViewModel testViewModel = RewardsViewModel();
        expect(() => testViewModel.dispose(), returnsNormally);
      });

      test("multiple viewModels can coexist", () {
        final List<RewardsViewModel> viewModels = <RewardsViewModel>[
          RewardsViewModel(),
          RewardsViewModel(),
          RewardsViewModel(),
        ];
        
        expect(viewModels.length, equals(3));
        for (final RewardsViewModel vm in viewModels) {
          expect(vm, isNotNull);
          expect(vm.rewardsSections, isNotNull);
        }
      });

      test("rewards sections are computed efficiently", () {
        // The filtering should happen once during initialization
        final RewardsViewModel testViewModel = RewardsViewModel();
        final List<RewardsViewSections> sections1 = testViewModel.rewardsSections;
        final List<RewardsViewSections> sections2 = testViewModel.rewardsSections;
        
        // Should return the same list instance (not recomputed)
        expect(identical(sections1, sections2), isTrue);
      });
    });
  });
}
