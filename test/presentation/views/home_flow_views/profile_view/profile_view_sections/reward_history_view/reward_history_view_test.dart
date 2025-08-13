import "package:esim_open_source/data/remote/responses/promotion/reward_history_response_model.dart";
import "package:esim_open_source/presentation/views/home_flow_views/profile_view/profile_view_sections/rewards_history_view/reward_history_view.dart";
import "package:esim_open_source/presentation/widgets/padding_widget.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";

import "../../../../../../helpers/view_helper.dart";

Future<void> main() async {
  await prepareTest();

  setUp(() async {
    await setupTest();
  });

  tearDown(() async {
    await tearDownTest();
  });

  test("debugFillProperties", () {
    final RewardHistoryResponseModel mockModel =
        createTestRewardHistoryResponseModel(
      isReferral: false,
      name: "Cashback Reward",
      amount: r"$10.00",
      promotionName: "Special Offer",
    );
    final RewardHistoryView widget =
        RewardHistoryView(rewardHistoryModel: mockModel);
    final DiagnosticPropertiesBuilder builder = DiagnosticPropertiesBuilder();
    widget.debugFillProperties(builder);
    expect(builder.properties, isNotNull);
  });

  testWidgets("renders basic structure with cashback type",
      (WidgetTester tester) async {
    final RewardHistoryResponseModel mockModel =
        createTestRewardHistoryResponseModel(
      isReferral: false,
      name: "Cashback Reward",
      amount: r"$10.00",
      promotionName: "Special Offer",
    );

    await tester.pumpWidget(
      createTestableWidget(
        RewardHistoryView(
          rewardHistoryModel: mockModel,
        ),
      ),
    );
    await tester.pump();

    expect(find.byType(RewardHistoryView), findsOneWidget);
    expect(find.byType(DecoratedBox), findsWidgets);
    expect(find.byType(PaddingWidget), findsWidgets);
    // expect(find.byType(Column), findsWidgets);
  });

  testWidgets("renders basic structure with referral type",
      (WidgetTester tester) async {
    final RewardHistoryResponseModel mockModel =
        createTestRewardHistoryResponseModel(
      isReferral: true,
      name: "Cashback Reward",
      amount: r"$10.00",
      promotionName: "Special Offer",
    );

    await tester.pumpWidget(
      createTestableWidget(
        RewardHistoryView(
          rewardHistoryModel: mockModel,
        ),
      ),
    );
    await tester.pump();

    expect(find.byType(RewardHistoryView), findsOneWidget);
    expect(find.byType(DecoratedBox), findsWidgets);
    expect(find.byType(PaddingWidget), findsWidgets);
    // expect(find.byType(Column), findsWidgets);
  });
}

// Helper method to create RewardHistoryResponseModel for testing
RewardHistoryResponseModel createTestRewardHistoryResponseModel({
  bool? isReferral,
  String? amount,
  String? name,
  String? promotionName,
  String? date,
}) {
  return RewardHistoryResponseModel(
    isReferral: isReferral ?? false,
    amount: amount ?? r"$10.00",
    name: name ?? "Test Reward",
    promotionName: promotionName ?? "Test Promotion",
    date: date ?? "1747125626",
  );
}
