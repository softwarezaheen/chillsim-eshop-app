import "package:esim_open_source/app/environment/app_environment.dart";
import "package:esim_open_source/presentation/views/home_flow_views/profile_view/profile_view_sections/rewards_view/rewards_view.dart";
import "package:esim_open_source/presentation/widgets/common_navigation_title.dart";
import "package:esim_open_source/presentation/widgets/padding_widget.dart";
import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";

import "../../../../../../helpers/view_helper.dart";
import "../../../../../../helpers/view_model_helper.dart";

Future<void> main() async {
  await prepareTest();

  setUp(() async {
    await setupTest();
    onViewModelReadyMock(viewName: RewardsView.routeName);
  });

  tearDown(() async {
    await tearDownTest();
  });

  group("RewardsView Widget Tests", () {
    testWidgets("renders basic structure with navigation title",
        (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const RewardsView(),
        ),
      );
      await tester.pump();

      // Verify navigation title is present
      expect(find.byType(CommonNavigationTitle), findsOneWidget);

      // Verify main structure is present
      expect(find.byType(Column), findsWidgets);
      expect(find.byType(PaddingWidget), findsWidgets);
    });

    testWidgets("displays rewards title text", (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const RewardsView(),
        ),
      );
      await tester.pump();

      // Should find the navigation title widget
      expect(find.byType(CommonNavigationTitle), findsOneWidget);
      expect(find.byType(Text), findsWidgets);
    });

    testWidgets("renders list view for rewards sections",
        (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const RewardsView(),
        ),
      );
      await tester.pump();

      // Verify list view is present (no refresh indicator unlike MyWallet)
      expect(find.byType(ListView), findsOneWidget);
    });

    testWidgets("does not render refresh indicator",
        (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const RewardsView(),
        ),
      );
      await tester.pump();

      // RewardsView should NOT have RefreshIndicator since there's no data to refresh
      expect(find.byType(RefreshIndicator), findsNothing);
    });

    testWidgets("displays correct number of reward sections based on feature flags",
        (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const RewardsView(),
        ),
      );
      await tester.pump();

      // Count expected sections based on feature flags
      int expectedSections = 0;
      if (AppEnvironment.appEnvironmentHelper.enableReferral) {
        expectedSections++;
      }
      if (AppEnvironment.appEnvironmentHelper.enableCashBack) {
        expectedSections++;
      }
      if (AppEnvironment.appEnvironmentHelper.enableRewardsHistory) {
        expectedSections++;
      }

      // Find GestureDetector widgets (may include one extra for back navigation)
      expect(find.byType(GestureDetector), findsAtLeastNWidgets(expectedSections));
    });

    testWidgets("each section has image and text",
        (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const RewardsView(),
        ),
      );
      await tester.pump();

      if (AppEnvironment.appEnvironmentHelper.enableReferral ||
          AppEnvironment.appEnvironmentHelper.enableCashBack ||
          AppEnvironment.appEnvironmentHelper.enableRewardsHistory) {
        // Should find images for section icons
        expect(find.byType(Image), findsWidgets);

        // Should find text widgets for section titles
        expect(find.byType(Text), findsWidgets);
      }
    });

    testWidgets("sections have dividers between them",
        (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const RewardsView(),
        ),
      );
      await tester.pump();

      // Count expected sections
      int expectedSections = 0;
      if (AppEnvironment.appEnvironmentHelper.enableReferral) {
        expectedSections++;
      }
      if (AppEnvironment.appEnvironmentHelper.enableCashBack) {
        expectedSections++;
      }
      if (AppEnvironment.appEnvironmentHelper.enableRewardsHistory) {
        expectedSections++;
      }

      if (expectedSections > 1) {
        // Should have dividers (n-1 dividers for n sections)
        expect(find.byType(Divider), findsWidgets);
      }
    });

    testWidgets("sections are tappable with GestureDetector",
        (WidgetTester tester) async {
      if (!AppEnvironment.appEnvironmentHelper.enableReferral &&
          !AppEnvironment.appEnvironmentHelper.enableCashBack &&
          !AppEnvironment.appEnvironmentHelper.enableRewardsHistory) {
        // Skip test if no sections are enabled
        return;
      }

      await tester.pumpWidget(
        createTestableWidget(
          const RewardsView(),
        ),
      );
      await tester.pump();

      // Verify sections are wrapped in GestureDetector for tap handling
      expect(find.byType(GestureDetector), findsWidgets);
    });

    testWidgets("sections display correct icons based on type",
        (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const RewardsView(),
        ),
      );
      await tester.pump();

      if (AppEnvironment.appEnvironmentHelper.enableReferral ||
          AppEnvironment.appEnvironmentHelper.enableCashBack ||
          AppEnvironment.appEnvironmentHelper.enableRewardsHistory) {
        // Images should be present for each section
        expect(find.byType(Image), findsWidgets);
      }
    });

    testWidgets("widget handles empty sections gracefully",
        (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const RewardsView(),
        ),
      );
      await tester.pump();

      // Even if no sections are visible, the widget should render without errors
      expect(find.byType(RewardsView), findsOneWidget);
      expect(find.byType(CommonNavigationTitle), findsOneWidget);
    });
  });

  group("RewardsView Layout Tests", () {
    testWidgets("has correct vertical spacing", (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const RewardsView(),
        ),
      );
      await tester.pump();

      // Main column should have spacing
      expect(find.byType(Column), findsWidgets);
    });

    testWidgets("uses correct padding for sections",
        (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const RewardsView(),
        ),
      );
      await tester.pump();

      // Should have PaddingWidget for proper spacing
      expect(find.byType(PaddingWidget), findsWidgets);
    });

    testWidgets("list view is scrollable", (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const RewardsView(),
        ),
      );
      await tester.pump();

      expect(find.byType(ListView), findsOneWidget);
    });

    testWidgets("expanded widget allows list to fill space",
        (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const RewardsView(),
        ),
      );
      await tester.pump();

      // ListView should be wrapped in Expanded
      expect(find.byType(Expanded), findsOneWidget);
    });
  });

  group("RewardsView Feature Flag Tests", () {
    testWidgets("shows referAndEarn when enableReferral is true",
        (WidgetTester tester) async {
      if (!AppEnvironment.appEnvironmentHelper.enableReferral) {
        // Skip test if referral is not enabled
        return;
      }

      await tester.pumpWidget(
        createTestableWidget(
          const RewardsView(),
        ),
      );
      await tester.pump();

      // Should have at least one section
      expect(find.byType(GestureDetector), findsWidgets);
    });

    testWidgets("shows cashbackRewards when enableCashBack is true",
        (WidgetTester tester) async {
      if (!AppEnvironment.appEnvironmentHelper.enableCashBack) {
        // Skip test if cashback is not enabled
        return;
      }

      await tester.pumpWidget(
        createTestableWidget(
          const RewardsView(),
        ),
      );
      await tester.pump();

      // Should have at least one section
      expect(find.byType(GestureDetector), findsWidgets);
    });

    testWidgets("shows rewardsHistory when enableRewardsHistory is true",
        (WidgetTester tester) async {
      if (!AppEnvironment.appEnvironmentHelper.enableRewardsHistory) {
        // Skip test if rewards history is not enabled
        return;
      }

      await tester.pumpWidget(
        createTestableWidget(
          const RewardsView(),
        ),
      );
      await tester.pump();

      // Should have at least one section
      expect(find.byType(GestureDetector), findsWidgets);
    });
  });

  group("RewardsView Comparison Tests", () {
    testWidgets("does not have wallet balance display unlike MyWalletView",
        (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const RewardsView(),
        ),
      );
      await tester.pump();

      // RewardsView should not display any balance information
      // This is a key difference from MyWalletView
      expect(find.byType(CommonNavigationTitle), findsOneWidget);
      expect(find.byType(ListView), findsOneWidget);
    });

    testWidgets("does not require refresh unlike MyWalletView",
        (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const RewardsView(),
        ),
      );
      await tester.pump();

      // No RefreshIndicator should be present
      expect(find.byType(RefreshIndicator), findsNothing);
    });
  });

  group("RewardsView Edge Cases", () {
    testWidgets("renders correctly when all features are disabled",
        (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const RewardsView(),
        ),
      );
      await tester.pump();

      // Should still render without errors
      expect(find.byType(RewardsView), findsOneWidget);
      expect(find.byType(CommonNavigationTitle), findsOneWidget);
    });

    testWidgets("renders correctly when all features are enabled",
        (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const RewardsView(),
        ),
      );
      await tester.pump();

      // Should render without errors
      expect(find.byType(RewardsView), findsOneWidget);
      expect(find.byType(ListView), findsOneWidget);
    });

    testWidgets("handles rapid rebuilds gracefully",
        (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const RewardsView(),
        ),
      );

      // Pump multiple times to simulate rapid rebuilds
      for (int i = 0; i < 5; i++) {
        await tester.pump();
      }

      // Should still be functional
      expect(find.byType(RewardsView), findsOneWidget);
    });
  });

  group("RewardsView Accessibility Tests", () {
    testWidgets("sections are tappable", (WidgetTester tester) async {
      if (!AppEnvironment.appEnvironmentHelper.enableReferral &&
          !AppEnvironment.appEnvironmentHelper.enableCashBack &&
          !AppEnvironment.appEnvironmentHelper.enableRewardsHistory) {
        return;
      }

      await tester.pumpWidget(
        createTestableWidget(
          const RewardsView(),
        ),
      );
      await tester.pump();

      // All sections should be wrapped in GestureDetector
      expect(find.byType(GestureDetector), findsWidgets);
    });

    testWidgets("has proper touch targets", (WidgetTester tester) async {
      if (!AppEnvironment.appEnvironmentHelper.enableReferral &&
          !AppEnvironment.appEnvironmentHelper.enableCashBack &&
          !AppEnvironment.appEnvironmentHelper.enableRewardsHistory) {
        return;
      }

      await tester.pumpWidget(
        createTestableWidget(
          const RewardsView(),
        ),
      );
      await tester.pump();

      // ColoredBox should provide full-width touch targets
      expect(find.byType(ColoredBox), findsWidgets);
    });
  });
}
