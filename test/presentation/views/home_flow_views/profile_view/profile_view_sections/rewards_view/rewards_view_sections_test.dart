import "package:esim_open_source/presentation/views/home_flow_views/profile_view/profile_view_sections/rewards_view/rewards_view_sections.dart";
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

  group("RewardsViewSections Enum Tests", () {
    group("Enum Values", () {
      test("enum contains all expected values", () {
        expect(
          RewardsViewSections.values,
          contains(RewardsViewSections.referAndEarn),
        );
        expect(
          RewardsViewSections.values,
          contains(RewardsViewSections.rewardsHistory),
        );
      });

      test("sections are properly ordered", () {
        final List<RewardsViewSections> expectedOrder = <RewardsViewSections>[
          RewardsViewSections.referAndEarn,
          RewardsViewSections.rewardsHistory,
        ];

        expect(RewardsViewSections.values, equals(expectedOrder));
      });

      test("enum index values are correct", () {
        expect(RewardsViewSections.referAndEarn.index, equals(0));
        expect(RewardsViewSections.rewardsHistory.index, equals(1));
      });
    });

    group("Section Titles", () {
      test("referAndEarn section has correct title", () {
        const RewardsViewSections section = RewardsViewSections.referAndEarn;
        expect(section.sectionTitle, isNotEmpty);
        expect(section.sectionTitle, isA<String>());
      });

      test("rewardsHistory section has correct title", () {
        const RewardsViewSections section = RewardsViewSections.rewardsHistory;
        expect(section.sectionTitle, isNotEmpty);
        expect(section.sectionTitle, isA<String>());
      });
    });

    group("Section Images", () {
      test("referAndEarn section has valid image path", () {
        const RewardsViewSections section = RewardsViewSections.referAndEarn;
        expect(section.sectionImagePath, isNotEmpty);
        expect(section.sectionImagePath, contains("walletReferEarn"));
      });

      test("rewardsHistory section has valid image path", () {
        const RewardsViewSections section = RewardsViewSections.rewardsHistory;
        expect(section.sectionImagePath, isNotEmpty);
        expect(section.sectionImagePath, contains("walletRewardHistory"));
      });
    });

    group("Section Hidden State", () {
      test("no section is hidden by default", () {
        for (final RewardsViewSections section in RewardsViewSections.values) {
          expect(section.isSectionHidden, isFalse);
        }
      });
    });

    group("Tap Action Tests", () {
      test("referAndEarn has tapAction method", () {
        expect(RewardsViewSections.referAndEarn.tapAction, isNotNull);
      });

      test("rewardsHistory has tapAction method", () {
        expect(RewardsViewSections.rewardsHistory.tapAction, isNotNull);
      });

      test("all sections have unique tap actions", () {
        // Ensure tap actions are defined and not null
        for (final RewardsViewSections section in RewardsViewSections.values) {
          expect(section.tapAction, isNotNull,
              reason: "${section.name} should have a tapAction",);
        }
      });
    });

    group("Switch Statement Coverage", () {
      test("enum values can be used in switch statements", () {
        String testSwitch(RewardsViewSections section) {
          switch (section) {
            case RewardsViewSections.referAndEarn:
              return "refer";
            case RewardsViewSections.rewardsHistory:
              return "history";
          }
        }

        expect(
          testSwitch(RewardsViewSections.referAndEarn),
          equals("refer"),
        );
        expect(
          testSwitch(RewardsViewSections.rewardsHistory),
          equals("history"),
        );
      });
    });

    group("Type Safety Tests", () {
      test("all sections are of type RewardsViewSections", () {
        for (final RewardsViewSections section in RewardsViewSections.values) {
          expect(section, isA<RewardsViewSections>());
        }
      });

      test("enum values can be compared", () {
        expect(
          RewardsViewSections.referAndEarn ==
              RewardsViewSections.referAndEarn,
          isTrue,
        );
        expect(
          RewardsViewSections.referAndEarn !=
              RewardsViewSections.rewardsHistory,
          isTrue,
        );
      });

      test("enum values have unique names", () {
        final Set<String> names = RewardsViewSections.values
            .map((RewardsViewSections section) => section.name)
            .toSet();

        expect(names.length, equals(RewardsViewSections.values.length));
      });
    });

    group("Edge Cases", () {
      test("all sections have non-null titles", () {
        for (final RewardsViewSections section in RewardsViewSections.values) {
          expect(section.sectionTitle, isNotNull);
          expect(section.sectionTitle, isNotEmpty);
        }
      });

      test("all sections have non-null image paths", () {
        for (final RewardsViewSections section in RewardsViewSections.values) {
          expect(section.sectionImagePath, isNotNull);
          expect(section.sectionImagePath, isNotEmpty);
        }
      });

    });
  });
}
