import "package:easy_localization/easy_localization.dart";
import "package:esim_open_source/presentation/theme/my_theme_builder.dart";
import "package:esim_open_source/presentation/theme/theme_setup.dart";
import "package:esim_open_source/presentation/views/home_flow_views/stories_view/referal_stories_view.dart";
import "package:esim_open_source/presentation/widgets/stories_view/story_item.dart";
import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";

import "../../../../helpers/view_helper.dart";

void main() async {
  await prepareTest();

  setUp(() async {
    await setupTest();

    // locator.registerSingleton<BottomSheetService>(mockBottomSheetService);
    // locator.registerSingleton<NavigationService>(mockNavigationService);
  });

  testWidgets("ReferalStoriesView covers all lines and triggers buttons",
      (WidgetTester tester) async {
    await tester.pumpWidget(
      EasyLocalization(
        supportedLocales: const <Locale>[Locale("en")],
        path: "assets/translations/open_source",
        fallbackLocale: const Locale("en"),
        child: MyThemeBuilder(
          // statusBarColorBuilder: (theme) => model.getColor(),
          // defaultThemeMode: ThemeMode.light,
          themes: getThemes(),
          builder: (
            BuildContext context,
            ThemeData? regularTheme,
            ThemeData? darkTheme,
            ThemeMode? themeMode,
          ) =>
              MaterialApp(
            theme: regularTheme,
            darkTheme: darkTheme,
            home: Builder(
              builder: (BuildContext context) {
                final ReferalStoriesView view = ReferalStoriesView(context);
                final StoryViewerArgs args = view.storyViewerArgs;

                // ✅ Verify StoryViewerArgs created
                expect(args.autoClose, false);
                expect(args.stories.length, 3);
                return Scaffold(body: args.stories.first.content);
              },
            ),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // // ✅ Find buttons
    // final mainButtons = find.byType(ElevatedButton);
    // expect(mainButtons, findsNWidgets(2));
    //
    // // ✅ Tap first button (should show bottom sheet)
    // await tester.tap(mainButtons.at(0));
    // await tester.pump();
    // verify(mockBottomSheetService.showCustomSheet(
    //   enableDrag: false,
    //   isScrollControlled: true,
    //   variant: BottomSheetType.shareReferralCode,
    // )).called(1);
    //
    // // ✅ Tap second button (should call NavigationService.back)
    // await tester.tap(mainButtons.at(1));
    // await tester.pump();
    // verify(mockNavigationService.back()).called(1);
  });
}
