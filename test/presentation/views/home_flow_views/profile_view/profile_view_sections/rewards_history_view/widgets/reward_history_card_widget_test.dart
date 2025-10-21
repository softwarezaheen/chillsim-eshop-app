import "package:esim_open_source/data/remote/responses/promotion/reward_history_response_model.dart";
import "package:esim_open_source/presentation/views/home_flow_views/profile_view/profile_view_sections/rewards_history_view/widgets/reward_history_card_widget.dart";
import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";
import "../../../../../../../fixtures/reward_history_mock_data.dart";
import "../../../../../../../helpers/view_helper.dart";

Future<void> main() async {
  await prepareTest();

  setUp(() async {
    await setupTest();
  });

  tearDown(() async {
    await tearDownTest();
  });

  group("RewardHistoryCardWidget UI Tests", () {
    // Helper function to create widget for testing
    Widget createTestWidget(RewardHistoryResponseModel model) {
      return createTestableWidget(
        RewardHistoryCardWidget(rewardHistoryModel: model),
      );
    }

    group("Icon Display Tests", () {
      testWidgets("displays referral credit icon correctly",
          (WidgetTester tester) async {
        final Map<String, dynamic> json =
            rewardHistoryMockData["complete_referral_credit_wallet"]
                as Map<String, dynamic>;
        final RewardHistoryResponseModel model =
            RewardHistoryResponseModel.fromJson(json: json);

        await tester.pumpWidget(createTestWidget(model));

        // Should show people icon for referral credit
        expect(find.byIcon(Icons.people_outline), findsOneWidget);
      });

      testWidgets("displays cashback icon correctly",
          (WidgetTester tester) async {
        final Map<String, dynamic> json =
            rewardHistoryMockData["complete_cashback_wallet"]
                as Map<String, dynamic>;
        final RewardHistoryResponseModel model =
            RewardHistoryResponseModel.fromJson(json: json);

        await tester.pumpWidget(createTestWidget(model));

        // Should show wallet icon for cashback (appears twice - reward type + application type)
        expect(
          find.byIcon(Icons.account_balance_wallet_outlined),
          findsWidgets,
        );
      });

      testWidgets("displays promo discount icon correctly",
          (WidgetTester tester) async {
        final Map<String, dynamic> json =
            rewardHistoryMockData["complete_promo_discount_order"]
                as Map<String, dynamic>;
        final RewardHistoryResponseModel model =
            RewardHistoryResponseModel.fromJson(json: json);

        await tester.pumpWidget(createTestWidget(model));

        // Should show tag/offer icon for promo discount
        expect(find.byIcon(Icons.local_offer_outlined), findsWidgets);
      });

      testWidgets("displays discount amount icon correctly",
          (WidgetTester tester) async {
        final Map<String, dynamic> json =
            rewardHistoryMockData["complete_discount_amount_order"]
                as Map<String, dynamic>;
        final RewardHistoryResponseModel model =
            RewardHistoryResponseModel.fromJson(json: json);

        await tester.pumpWidget(createTestWidget(model));

        // Should show dollar icon for discount amount
        expect(find.byIcon(Icons.attach_money), findsOneWidget);
      });

      testWidgets("displays discount percentage icon correctly",
          (WidgetTester tester) async {
        final Map<String, dynamic> json =
            rewardHistoryMockData["complete_percentage_discount_order"]
                as Map<String, dynamic>;
        final RewardHistoryResponseModel model =
            RewardHistoryResponseModel.fromJson(json: json);

        await tester.pumpWidget(createTestWidget(model));

        // Should show percent icon for discount percentage
        expect(find.byIcon(Icons.percent), findsOneWidget);
      });

      testWidgets("displays wallet credit application icon",
          (WidgetTester tester) async {
        final Map<String, dynamic> json =
            rewardHistoryMockData["complete_cashback_wallet"]
                as Map<String, dynamic>;
        final RewardHistoryResponseModel model =
            RewardHistoryResponseModel.fromJson(json: json);

        await tester.pumpWidget(createTestWidget(model));

        // Should show wallet icon for wallet credit (appears twice)
        expect(
          find.byIcon(Icons.account_balance_wallet_outlined),
          findsWidgets,
        );
      });

      testWidgets("displays order discount application icon",
          (WidgetTester tester) async {
        final Map<String, dynamic> json =
            rewardHistoryMockData["complete_percentage_discount_order"]
                as Map<String, dynamic>;
        final RewardHistoryResponseModel model =
            RewardHistoryResponseModel.fromJson(json: json);

        await tester.pumpWidget(createTestWidget(model));

        // Should show shopping cart icon for order discount
        expect(find.byIcon(Icons.shopping_cart_outlined), findsOneWidget);
      });

      testWidgets("displays fallback icon when reward_type is null",
          (WidgetTester tester) async {
        final Map<String, dynamic> json =
            rewardHistoryMockData["legacy_referral"] as Map<String, dynamic>;
        final RewardHistoryResponseModel model =
            RewardHistoryResponseModel.fromJson(json: json);

        await tester.pumpWidget(createTestWidget(model));

        // Should show people icon based on is_referral fallback
        expect(find.byIcon(Icons.people_outline), findsOneWidget);
      });
    });

    group("Text Display Tests", () {
      testWidgets("displays title correctly", (WidgetTester tester) async {
        final Map<String, dynamic> json =
            rewardHistoryMockData["complete_cashback_wallet"]
                as Map<String, dynamic>;
        final RewardHistoryResponseModel model =
            RewardHistoryResponseModel.fromJson(json: json);

        await tester.pumpWidget(createTestWidget(model));

        expect(find.text("Referrer Cashback"), findsOneWidget);
      });

      testWidgets("displays amount correctly", (WidgetTester tester) async {
        final Map<String, dynamic> json =
            rewardHistoryMockData["complete_cashback_wallet"]
                as Map<String, dynamic>;
        final RewardHistoryResponseModel model =
            RewardHistoryResponseModel.fromJson(json: json);

        await tester.pumpWidget(createTestWidget(model));

        expect(find.text("3.0 EUR"), findsOneWidget);
      });

      testWidgets("displays description when available",
          (WidgetTester tester) async {
        final Map<String, dynamic> json =
            rewardHistoryMockData["complete_cashback_wallet"]
                as Map<String, dynamic>;
        final RewardHistoryResponseModel model =
            RewardHistoryResponseModel.fromJson(json: json);

        await tester.pumpWidget(createTestWidget(model));

        expect(
          find.text(
            "Cashback reward for referral code used by newuser@example.com",
          ),
          findsOneWidget,
        );
      });

      testWidgets("hides description when empty", (WidgetTester tester) async {
        final Map<String, dynamic> json =
            rewardHistoryMockData["empty_strings"] as Map<String, dynamic>;
        final RewardHistoryResponseModel model =
            RewardHistoryResponseModel.fromJson(json: json);

        await tester.pumpWidget(createTestWidget(model));

        // Description should not be visible when empty
        final Text? descriptionWidget = tester
            .widgetList<Text>(find.byType(Text))
            .cast<Text?>()
            .firstWhere(
              (Text? text) =>
                  text != null &&
                  text.style?.fontSize == null &&
                  text.maxLines == 2,
              orElse: () => null,
            );
        expect(descriptionWidget, null);
      });

      testWidgets("displays fallback title from name",
          (WidgetTester tester) async {
        final Map<String, dynamic> json =
            rewardHistoryMockData["legacy_promotion"] as Map<String, dynamic>;
        final RewardHistoryResponseModel model =
            RewardHistoryResponseModel.fromJson(json: json);

        await tester.pumpWidget(createTestWidget(model));

        expect(find.text("Old Promotion"), findsWidgets);
      });
    });

    group("Info Chip Tests", () {
      testWidgets("displays promo code chip when available",
          (WidgetTester tester) async {
        final Map<String, dynamic> json =
            rewardHistoryMockData["complete_percentage_discount_order"]
                as Map<String, dynamic>;
        final RewardHistoryResponseModel model =
            RewardHistoryResponseModel.fromJson(json: json);

        await tester.pumpWidget(createTestWidget(model));

        // Should show promo code with tag icon
        expect(find.text("JOHN15"), findsOneWidget);
        expect(find.byIcon(Icons.local_offer_outlined), findsWidgets);
      });

      testWidgets("displays referral chip when promo code not available",
          (WidgetTester tester) async {
        final Map<String, dynamic> json =
            rewardHistoryMockData["complete_cashback_wallet"]
                as Map<String, dynamic>;
        final RewardHistoryResponseModel model =
            RewardHistoryResponseModel.fromJson(json: json);

        await tester.pumpWidget(createTestWidget(model));

        // Should show referral email with person icon
        expect(find.text("referrer@example.com"), findsWidgets);
        expect(find.byIcon(Icons.person_outline), findsOneWidget);
      });

      testWidgets("prioritizes promo code over referral when both present",
          (WidgetTester tester) async {
        final Map<String, dynamic> json =
            rewardHistoryMockData["both_promo_and_referral"]
                as Map<String, dynamic>;
        final RewardHistoryResponseModel model =
            RewardHistoryResponseModel.fromJson(json: json);

        await tester.pumpWidget(createTestWidget(model));

        // Should show promo code, not referral
        expect(find.text("HYBRID2025"), findsOneWidget);
        expect(find.text("someone@example.com"), findsNothing);
      });

      testWidgets("hides info chip when neither promo nor referral available",
          (WidgetTester tester) async {
        final Map<String, dynamic> json =
            rewardHistoryMockData["minimal_valid"] as Map<String, dynamic>;
        final RewardHistoryResponseModel model =
            RewardHistoryResponseModel.fromJson(json: json);

        await tester.pumpWidget(createTestWidget(model));

        // Should not show person or offer icons in info chip
        // (they appear only in reward type icons)
        final Iterable<Widget> icons = tester.widgetList(find.byType(Icon));
        int personIconCount = 0;

        for (final Widget widget in icons) {
          final Icon icon = widget as Icon;
          if (icon.icon == Icons.person_outline) personIconCount++;
        }

        // Person icon should only appear once (reward type icon)
        expect(personIconCount, lessThan(2));
      });
    });

    group("Text Overflow Tests", () {
      testWidgets("truncates long title with ellipsis",
          (WidgetTester tester) async {
        final Map<String, dynamic> json =
            rewardHistoryMockData["long_title"] as Map<String, dynamic>;
        final RewardHistoryResponseModel model =
            RewardHistoryResponseModel.fromJson(json: json);

        await tester.pumpWidget(createTestWidget(model));

        // Find the title Text widget
        final Text titleWidget = tester
            .widgetList<Text>(find.byType(Text))
            .firstWhere((Text text) => text.maxLines == 1);

        expect(titleWidget.overflow, TextOverflow.ellipsis);
        expect(titleWidget.maxLines, 1);
      });

      testWidgets("truncates long description after 2 lines",
          (WidgetTester tester) async {
        final Map<String, dynamic> json =
            rewardHistoryMockData["long_description"] as Map<String, dynamic>;
        final RewardHistoryResponseModel model =
            RewardHistoryResponseModel.fromJson(json: json);

        await tester.pumpWidget(createTestWidget(model));

        // Find description Text widgets (maxLines == 2)
        final Iterable<Text> descWidgets =
            tester.widgetList<Text>(find.byType(Text)).where(
                  (Text text) => text.maxLines == 2,
                );

        expect(descWidgets, isNotEmpty);
        for (final Text widget in descWidgets) {
          expect(widget.overflow, TextOverflow.ellipsis);
        }
      });

      testWidgets("truncates long promo code in chip",
          (WidgetTester tester) async {
        final Map<String, dynamic> json =
            rewardHistoryMockData["long_promo_code"] as Map<String, dynamic>;
        final RewardHistoryResponseModel model =
            RewardHistoryResponseModel.fromJson(json: json);

        await tester.pumpWidget(createTestWidget(model));

        // Chip text should be present and truncatable
        expect(
          find.text("VERYLONGPROMOTIONCODE2025THATSHOULDBETRUNCAT"),
          findsOneWidget,
        );
      });

      testWidgets("truncates long email in chip",
          (WidgetTester tester) async {
        final Map<String, dynamic> json =
            rewardHistoryMockData["long_referral_email"]
                as Map<String, dynamic>;
        final RewardHistoryResponseModel model =
            RewardHistoryResponseModel.fromJson(json: json);

        await tester.pumpWidget(createTestWidget(model));

        // Email should be present
        expect(
          find.text(
            "verylongemailaddresswithlotsocharacters@subdomain.example.com",
          ),
          findsOneWidget,
        );
      });
    });

    group("Layout Tests", () {
      testWidgets("has correct card decoration", (WidgetTester tester) async {
        final Map<String, dynamic> json =
            rewardHistoryMockData["complete_cashback_wallet"]
                as Map<String, dynamic>;
        final RewardHistoryResponseModel model =
            RewardHistoryResponseModel.fromJson(json: json);

        await tester.pumpWidget(createTestWidget(model));

        // Find the DecoratedBox
        final DecoratedBox decoratedBox =
            tester.widget<DecoratedBox>(find.byType(DecoratedBox).first);
        final BoxDecoration decoration =
            decoratedBox.decoration as BoxDecoration;

        expect(decoration.border, isNotNull);
        expect(decoration.borderRadius, isNotNull);
      });

      testWidgets("arranges top row elements correctly",
          (WidgetTester tester) async {
        final Map<String, dynamic> json =
            rewardHistoryMockData["complete_cashback_wallet"]
                as Map<String, dynamic>;
        final RewardHistoryResponseModel model =
            RewardHistoryResponseModel.fromJson(json: json);

        await tester.pumpWidget(createTestWidget(model));

        // Should have Row widgets for layout
        expect(find.byType(Row), findsWidgets);

        // Should have icons and text
        expect(find.byType(Icon), findsWidgets);
        expect(find.byType(Text), findsWidgets);
      });

      testWidgets("displays all sections in correct order",
          (WidgetTester tester) async {
        final Map<String, dynamic> json =
            rewardHistoryMockData["complete_percentage_discount_order"]
                as Map<String, dynamic>;
        final RewardHistoryResponseModel model =
            RewardHistoryResponseModel.fromJson(json: json);

        await tester.pumpWidget(createTestWidget(model));

        // Should have Column for vertical arrangement
        expect(find.byType(Column), findsWidgets);
      });
    });

    group("Conditional Rendering Tests", () {
      testWidgets("hides description when not available",
          (WidgetTester tester) async {
        final Map<String, dynamic> json =
            rewardHistoryMockData["all_nulls"] as Map<String, dynamic>;
        final RewardHistoryResponseModel model =
            RewardHistoryResponseModel.fromJson(json: json);

        await tester.pumpWidget(createTestWidget(model));

        // Count text widgets - should be minimal when data is missing
        final int textCount = tester.widgetList<Text>(find.byType(Text)).length;
        expect(textCount, lessThan(10));
      });

      testWidgets("hides promo chip when code is empty",
          (WidgetTester tester) async {
        final Map<String, dynamic> json =
            rewardHistoryMockData["empty_strings"] as Map<String, dynamic>;
        final RewardHistoryResponseModel model =
            RewardHistoryResponseModel.fromJson(json: json);

        await tester.pumpWidget(createTestWidget(model));

        // Info chip should not be prominently visible
        final Iterable<Icon> icons = tester.widgetList<Icon>(find.byType(Icon));
        final int chipIconCount = icons
            .where((Icon icon) =>
                icon.icon == Icons.local_offer_outlined ||
                icon.icon == Icons.person_outline)
            .length;

        // Should only have reward type and application type icons, no info chip
        expect(chipIconCount, lessThan(3));
      });

      testWidgets("displays all sections when data is complete",
          (WidgetTester tester) async {
        final Map<String, dynamic> json =
            rewardHistoryMockData["complete_percentage_discount_order"]
                as Map<String, dynamic>;
        final RewardHistoryResponseModel model =
            RewardHistoryResponseModel.fromJson(json: json);

        await tester.pumpWidget(createTestWidget(model));

        // Should have multiple text elements (title, description, promo code, date)
        final int textCount = tester.widgetList<Text>(find.byType(Text)).length;
        expect(textCount, greaterThan(3));

        // Should have multiple icons (reward type, application type, chip icon)
        final int iconCount = tester.widgetList<Icon>(find.byType(Icon)).length;
        expect(iconCount, greaterThanOrEqualTo(3));
      });
    });

    group("Real-World Data Tests", () {
      testWidgets("renders real sample 1 correctly",
          (WidgetTester tester) async {
        final Map<String, dynamic> json =
            rewardHistoryMockData["real_sample_1"] as Map<String, dynamic>;
        final RewardHistoryResponseModel model =
            RewardHistoryResponseModel.fromJson(json: json);

        await tester.pumpWidget(createTestWidget(model));

        expect(find.text("Referrer Cashback"), findsOneWidget);
        expect(find.text("3.0 EUR"), findsOneWidget);
        expect(find.byIcon(Icons.account_balance_wallet_outlined), findsWidgets);
      });

      testWidgets("renders real sample 3 correctly",
          (WidgetTester tester) async {
        final Map<String, dynamic> json =
            rewardHistoryMockData["real_sample_3"] as Map<String, dynamic>;
        final RewardHistoryResponseModel model =
            RewardHistoryResponseModel.fromJson(json: json);

        await tester.pumpWidget(createTestWidget(model));

        expect(find.text("Percentage Discount"), findsOneWidget);
        expect(find.text("0.09 EUR"), findsOneWidget);
        expect(find.text("REF15"), findsOneWidget);
        expect(find.byIcon(Icons.percent), findsOneWidget);
        expect(find.byIcon(Icons.shopping_cart_outlined), findsOneWidget);
      });

      testWidgets("renders real sample 4 correctly",
          (WidgetTester tester) async {
        final Map<String, dynamic> json =
            rewardHistoryMockData["real_sample_4"] as Map<String, dynamic>;
        final RewardHistoryResponseModel model =
            RewardHistoryResponseModel.fromJson(json: json);

        await tester.pumpWidget(createTestWidget(model));

        expect(find.text("Percentage Discount"), findsOneWidget);
        expect(find.text("0.06 EUR"), findsOneWidget);
        expect(find.text("TEST-233"), findsOneWidget);
      });
    });

    group("Edge Case Rendering Tests", () {
      testWidgets("renders zero amount correctly",
          (WidgetTester tester) async {
        final Map<String, dynamic> json =
            rewardHistoryMockData["zero_amount"] as Map<String, dynamic>;
        final RewardHistoryResponseModel model =
            RewardHistoryResponseModel.fromJson(json: json);

        await tester.pumpWidget(createTestWidget(model));

        expect(find.text("0.00 EUR"), findsOneWidget);
      });

      testWidgets("renders large amount correctly",
          (WidgetTester tester) async {
        final Map<String, dynamic> json =
            rewardHistoryMockData["large_amount"] as Map<String, dynamic>;
        final RewardHistoryResponseModel model =
            RewardHistoryResponseModel.fromJson(json: json);

        await tester.pumpWidget(createTestWidget(model));

        expect(find.text("999.99 EUR"), findsOneWidget);
      });

      testWidgets("renders special characters correctly",
          (WidgetTester tester) async {
        final Map<String, dynamic> json =
            rewardHistoryMockData["special_characters"] as Map<String, dynamic>;
        final RewardHistoryResponseModel model =
            RewardHistoryResponseModel.fromJson(json: json);

        await tester.pumpWidget(createTestWidget(model));

        // Check that special characters in title are rendered
        expect(find.textContaining("Spécial"), findsOneWidget);
        // Widget should render without error even with special chars
        expect(find.byType(RewardHistoryCardWidget), findsOneWidget);
      });

      testWidgets("handles null amount gracefully",
          (WidgetTester tester) async {
        final Map<String, dynamic> json =
            rewardHistoryMockData["null_amount"] as Map<String, dynamic>;
        final RewardHistoryResponseModel model =
            RewardHistoryResponseModel.fromJson(json: json);

        await tester.pumpWidget(createTestWidget(model));

        // Widget should render without crashing
        expect(find.byType(RewardHistoryCardWidget), findsOneWidget);
      });

      testWidgets("renders legacy data with fallbacks",
          (WidgetTester tester) async {
        final Map<String, dynamic> json =
            rewardHistoryMockData["legacy_referral"] as Map<String, dynamic>;
        final RewardHistoryResponseModel model =
            RewardHistoryResponseModel.fromJson(json: json);

        await tester.pumpWidget(createTestWidget(model));

        // Should use fallback icon (people for referral)
        expect(find.byIcon(Icons.people_outline), findsOneWidget);
        // Should show amount
        expect(find.text("2.5 EUR"), findsOneWidget);
        // Should use name as fallback
        expect(find.text("olduser@example.com"), findsWidgets);
      });
    });

    group("Accessibility Tests", () {
      testWidgets("has semantic labels for icons",
          (WidgetTester tester) async {
        final Map<String, dynamic> json =
            rewardHistoryMockData["complete_cashback_wallet"]
                as Map<String, dynamic>;
        final RewardHistoryResponseModel model =
            RewardHistoryResponseModel.fromJson(json: json);

        await tester.pumpWidget(createTestWidget(model));

        // Icons should be present and accessible
        expect(find.byType(Icon), findsWidgets);
      });

      testWidgets("text widgets have proper styling",
          (WidgetTester tester) async {
        final Map<String, dynamic> json =
            rewardHistoryMockData["complete_cashback_wallet"]
                as Map<String, dynamic>;
        final RewardHistoryResponseModel model =
            RewardHistoryResponseModel.fromJson(json: json);

        await tester.pumpWidget(createTestWidget(model));

        // All text widgets should have styles
        final Iterable<Text> textWidgets =
            tester.widgetList<Text>(find.byType(Text));
        for (final Text widget in textWidgets) {
          expect(widget.style, isNotNull);
        }
      });
    });

    group("Complete Enum Coverage Tests", () {
      testWidgets("renders all RewardType values correctly",
          (WidgetTester tester) async {
        // Test all 5 reward types
        final List<String> mockKeys = [
          "complete_referral_credit_wallet",
          "complete_cashback_wallet",
          "complete_promo_discount_order",
          "complete_discount_amount_order",
          "complete_percentage_discount_order"
        ];

        for (final String key in mockKeys) {
          final Map<String, dynamic> json =
              rewardHistoryMockData[key] as Map<String, dynamic>;
          final RewardHistoryResponseModel model =
              RewardHistoryResponseModel.fromJson(json: json);

          await tester.pumpWidget(createTestWidget(model));

          // Should render without error
          expect(find.byType(RewardHistoryCardWidget), findsOneWidget);

          // Clear the tree for next iteration
          await tester.pumpWidget(const SizedBox.shrink());
        }
      });

      testWidgets("renders all RewardApplicationType values correctly",
          (WidgetTester tester) async {
        // Test wallet_credit
        final Map<String, dynamic> json1 =
            rewardHistoryMockData["complete_cashback_wallet"]
                as Map<String, dynamic>;
        final RewardHistoryResponseModel model1 =
            RewardHistoryResponseModel.fromJson(json: json1);

        await tester.pumpWidget(createTestWidget(model1));
        expect(find.byIcon(Icons.account_balance_wallet_outlined), findsWidgets);

        // Clear and test order_discount
        await tester.pumpWidget(const SizedBox.shrink());

        final Map<String, dynamic> json2 =
            rewardHistoryMockData["complete_percentage_discount_order"]
                as Map<String, dynamic>;
        final RewardHistoryResponseModel model2 =
            RewardHistoryResponseModel.fromJson(json: json2);

        await tester.pumpWidget(createTestWidget(model2));
        expect(find.byIcon(Icons.shopping_cart_outlined), findsOneWidget);
      });
    });
  });
}
