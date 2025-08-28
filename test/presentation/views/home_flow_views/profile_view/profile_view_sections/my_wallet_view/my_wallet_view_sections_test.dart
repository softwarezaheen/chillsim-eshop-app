import "package:esim_open_source/presentation/enums/bottomsheet_type.dart";
import "package:esim_open_source/presentation/setup_bottom_sheet_ui.dart";
import "package:esim_open_source/presentation/views/home_flow_views/profile_view/profile_view_sections/my_wallet_view/my_wallet_view_model.dart";
import "package:esim_open_source/presentation/views/home_flow_views/profile_view/profile_view_sections/my_wallet_view/my_wallet_view_sections.dart";
import "package:esim_open_source/presentation/views/home_flow_views/profile_view/profile_view_sections/rewards_history_view/rewards_history_view.dart";
import "package:flutter_test/flutter_test.dart";
import "package:mockito/mockito.dart";
import "package:stacked_services/stacked_services.dart";

import "../../../../../../helpers/fake_build_context.dart";
import "../../../../../../helpers/view_helper.dart";
import "../../../../../../helpers/view_model_helper.dart";
import "../../../../../../locator_test.dart";
import "../../../../../../locator_test.mocks.dart";

Future<void> main() async {
  await prepareTest();
  late MyWalletViewModel mockViewModel;
  late MockNavigationService mockNavigationService;
  late MockBottomSheetService mockBottomSheetService;

  setUp(() async {
    await setupTest();
    onViewModelReadyMock(viewName: "MyWalletView");

    mockViewModel = MyWalletViewModel();
    mockNavigationService =
        locator<NavigationService>() as MockNavigationService;
    mockBottomSheetService =
        locator<BottomSheetService>() as MockBottomSheetService;
  });

  tearDown(() async {
    await tearDownTest();
  });

  group("MyWalletViewSections Tests", () {
    group("Basic Enum Properties", () {
      test("all sections are not hidden", () {
        for (final MyWalletViewSections section
            in MyWalletViewSections.values) {
          expect(section.isSectionHidden, isFalse);
        }
      });

      test("enum contains all expected sections", () {
        expect(MyWalletViewSections.values.length, equals(5));
        expect(
          MyWalletViewSections.values,
          contains(MyWalletViewSections.voucherCode),
        );
        expect(
          MyWalletViewSections.values,
          contains(MyWalletViewSections.referEarn),
        );
        expect(
          MyWalletViewSections.values,
          contains(MyWalletViewSections.cashbackRewards),
        );
        expect(
          MyWalletViewSections.values,
          contains(MyWalletViewSections.rewardHistory),
        );
        expect(
          MyWalletViewSections.values,
          contains(MyWalletViewSections.upgradeWallet),
        );
      });

      test("sections are properly ordered", () {
        final List<MyWalletViewSections> expectedOrder = <MyWalletViewSections>[
          MyWalletViewSections.voucherCode,
          MyWalletViewSections.referEarn,
          MyWalletViewSections.cashbackRewards,
          MyWalletViewSections.rewardHistory,
          MyWalletViewSections.upgradeWallet,
        ];

        expect(MyWalletViewSections.values, equals(expectedOrder));
      });

      test("enum index values are correct", () {
        expect(MyWalletViewSections.voucherCode.index, equals(0));
        expect(MyWalletViewSections.referEarn.index, equals(1));
        expect(MyWalletViewSections.cashbackRewards.index, equals(2));
        expect(MyWalletViewSections.rewardHistory.index, equals(3));
        expect(MyWalletViewSections.upgradeWallet.index, equals(4));
      });
    });

    group("Section Titles", () {
      test("voucherCode section has correct title", () {
        const MyWalletViewSections section = MyWalletViewSections.voucherCode;
        expect(section.sectionTitle, isNotEmpty);
        expect(section.sectionTitle, isA<String>());
      });

      test("referEarn section has correct title", () {
        const MyWalletViewSections section = MyWalletViewSections.referEarn;
        expect(section.sectionTitle, isNotEmpty);
        expect(section.sectionTitle, isA<String>());
      });

      test("cashbackRewards section has correct title", () {
        const MyWalletViewSections section =
            MyWalletViewSections.cashbackRewards;
        expect(section.sectionTitle, isNotEmpty);
        expect(section.sectionTitle, isA<String>());
      });

      test("rewardHistory section has correct title", () {
        const MyWalletViewSections section = MyWalletViewSections.rewardHistory;
        expect(section.sectionTitle, isNotEmpty);
        expect(section.sectionTitle, isA<String>());
      });

      test("upgradeWallet section has correct title", () {
        const MyWalletViewSections section = MyWalletViewSections.upgradeWallet;
        expect(section.sectionTitle, isNotEmpty);
        expect(section.sectionTitle, isA<String>());
      });

      test("all sections have valid titles", () {
        for (final MyWalletViewSections section
            in MyWalletViewSections.values) {
          expect(section.sectionTitle, isNotEmpty);
          expect(section.sectionTitle, isA<String>());
        }
      });
    });

    group("Tap Action Tests", () {
      test("voucherCode tap action shows voucher code bottom sheet", () async {
        when(
          mockBottomSheetService.showCustomSheet(
            enableDrag: false,
            isScrollControlled: true,
            variant: BottomSheetType.voucherCode,
          ),
        ).thenAnswer(
          (_) async => SheetResponse<EmptyBottomSheetResponse>(confirmed: true),
        );

        await MyWalletViewSections.voucherCode
            .tapAction(FakeContext(), mockViewModel);

        verify(
          mockBottomSheetService.showCustomSheet(
            enableDrag: false,
            isScrollControlled: true,
            variant: BottomSheetType.voucherCode,
          ),
        ).called(1);
      });

      test("voucherCode handles confirmed sheet response", () async {
        when(
          mockBottomSheetService.showCustomSheet(
            enableDrag: false,
            isScrollControlled: true,
            variant: BottomSheetType.voucherCode,
          ),
        ).thenAnswer(
          (_) async => SheetResponse<EmptyBottomSheetResponse>(confirmed: true),
        );

        // This should complete without throwing
        await MyWalletViewSections.voucherCode
            .tapAction(FakeContext(), mockViewModel);

        verify(
          mockBottomSheetService.showCustomSheet(
            enableDrag: false,
            isScrollControlled: true,
            variant: BottomSheetType.voucherCode,
          ),
        ).called(1);
      });

      test("rewardHistory tap action navigates to rewards history view",
          () async {
        when(mockNavigationService.navigateTo(RewardsHistoryView.routeName))
            .thenAnswer((_) async => true);

        await MyWalletViewSections.rewardHistory
            .tapAction(FakeContext(), mockViewModel);

        verify(mockNavigationService.navigateTo(RewardsHistoryView.routeName))
            .called(1);
      });

      test("upgradeWallet tap action shows upgrade wallet bottom sheet",
          () async {
        when(
          mockBottomSheetService.showCustomSheet(
            enableDrag: false,
            isScrollControlled: true,
            variant: BottomSheetType.upgradeWallet,
          ),
        ).thenAnswer(
          (_) async => SheetResponse<EmptyBottomSheetResponse>(confirmed: true),
        );

        await MyWalletViewSections.upgradeWallet
            .tapAction(FakeContext(), mockViewModel);

        verify(
          mockBottomSheetService.showCustomSheet(
            enableDrag: false,
            isScrollControlled: true,
            variant: BottomSheetType.upgradeWallet,
          ),
        ).called(1);
      });

      test("upgradeWallet handles confirmed sheet response", () async {
        when(
          mockBottomSheetService.showCustomSheet(
            enableDrag: false,
            isScrollControlled: true,
            variant: BottomSheetType.upgradeWallet,
          ),
        ).thenAnswer(
          (_) async => SheetResponse<EmptyBottomSheetResponse>(confirmed: true),
        );

        // This should complete without throwing
        await MyWalletViewSections.upgradeWallet
            .tapAction(FakeContext(), mockViewModel);

        verify(
          mockBottomSheetService.showCustomSheet(
            enableDrag: false,
            isScrollControlled: true,
            variant: BottomSheetType.upgradeWallet,
          ),
        ).called(1);
      });
    });

    group("Switch Statement Coverage", () {
      test("enum values can be used in switch statements", () {
        String testSwitch(MyWalletViewSections section) {
          switch (section) {
            case MyWalletViewSections.voucherCode:
              return "voucher";
            case MyWalletViewSections.referEarn:
              return "refer";
            case MyWalletViewSections.cashbackRewards:
              return "cashback";
            case MyWalletViewSections.rewardHistory:
              return "history";
            case MyWalletViewSections.upgradeWallet:
              return "upgrade";
          }
        }

        expect(testSwitch(MyWalletViewSections.voucherCode), equals("voucher"));
        expect(testSwitch(MyWalletViewSections.referEarn), equals("refer"));
        expect(
          testSwitch(MyWalletViewSections.cashbackRewards),
          equals("cashback"),
        );
        expect(
          testSwitch(MyWalletViewSections.rewardHistory),
          equals("history"),
        );
        expect(
          testSwitch(MyWalletViewSections.upgradeWallet),
          equals("upgrade"),
        );
      });
    });

    group("Type Safety Tests", () {
      test("all values are properly typed", () {
        for (final MyWalletViewSections section
            in MyWalletViewSections.values) {
          expect(section, isA<MyWalletViewSections>());
        }
      });

      test("enum values can be compared", () {
        expect(
          MyWalletViewSections.voucherCode == MyWalletViewSections.voucherCode,
          isTrue,
        );
        expect(
          MyWalletViewSections.voucherCode != MyWalletViewSections.referEarn,
          isTrue,
        );
      });

      test("enum values have unique names", () {
        final Set<String> names = MyWalletViewSections.values
            .map((MyWalletViewSections section) => section.name)
            .toSet();
        expect(names.length, equals(MyWalletViewSections.values.length));
      });
    });
  });
}
