import "package:esim_open_source/presentation/views/home_flow_views/profile_view/profile_view_sections/user_guide_view/user_guide_data_source/android_user_guide_enum.dart";
import "package:esim_open_source/presentation/views/home_flow_views/profile_view/profile_view_sections/user_guide_view/user_guide_detailed_view/user_guide_detailed_view.dart";
import "package:esim_open_source/presentation/views/home_flow_views/profile_view/profile_view_sections/user_guide_view/user_guide_detailed_view/user_guide_detailed_view_model.dart";
import "package:esim_open_source/presentation/widgets/common_navigation_title.dart";
import "package:esim_open_source/presentation/widgets/padding_widget.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";

import "../../../../../../../helpers/view_helper.dart";
import "../../../../../../../helpers/view_model_helper.dart";
import "../../../../../../../locator_test.dart";
// ignore_for_file: type=lint

Future<void> main() async {
  await prepareTest();
  late AndroidUserGuideEnum testDataSource;

  setUp(() async {
    await setupTest();
    testDataSource = AndroidUserGuideEnum.step1;
    onViewModelReadyMock(viewName: "UserGuideDetailedView");
    locator<UserGuideDetailedViewModel>().userGuideViewDataSource =
        testDataSource;
    // when(viewModel.isBusy).thenReturn(false);
    // when(viewModel.viewState).thenReturn(ViewState.idle);
    // setupUserGuideDetailedViewModelMockWithDataSource(testDataSource);
  });

  tearDown(() async {
    await tearDownTest();
  });

  group("UserGuideDetailedView Widget Tests", () {
    testWidgets("renders correctly with initial state",
        (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          UserGuideDetailedView(userGuideViewDataSource: testDataSource),
        ),
      );
      await tester.pump();

      expect(find.byType(UserGuideDetailedView), findsOneWidget);
      expect(find.byType(SizedBox), findsWidgets);
      expect(find.byType(PaddingWidget), findsWidgets);
      expect(find.byType(Column), findsWidgets);
      expect(find.byType(SingleChildScrollView), findsOneWidget);
      expect(find.byType(Row), findsWidgets);
    });

    testWidgets("displays text content correctly", (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          UserGuideDetailedView(userGuideViewDataSource: testDataSource),
        ),
      );
      await tester.pump();

      expect(find.byType(Text), findsWidgets);
      expect(find.text(testDataSource.title), findsOneWidget);
      expect(find.text(testDataSource.stepNumberLabel), findsOneWidget);
      expect(find.text(testDataSource.description), findsOneWidget);
    });

    testWidgets("displays navigation images correctly",
        (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          UserGuideDetailedView(userGuideViewDataSource: testDataSource),
        ),
      );
      await tester.pump();

      expect(find.byType(Image), findsWidgets);
      // expect(find.byType(GestureDetector), findsNWidgets(2));
    });

    testWidgets("previous step tap widget structure",
        (WidgetTester tester) async {
      final AndroidUserGuideEnum dataSource = AndroidUserGuideEnum.step2;
      // setupUserGuideDetailedViewModelMockWithDataSource(dataSource);

      await tester.pumpWidget(
        createTestableWidget(
          UserGuideDetailedView(userGuideViewDataSource: dataSource),
        ),
      );
      await tester.pump();

      // Find and verify the gesture detectors exist (for previous and next buttons)
      final Finder gestureDetectors = find.byType(GestureDetector);
      expect(gestureDetectors, findsWidgets);

      // Verify that at least 2 gesture detectors exist (previous and next buttons)
      final Iterable<GestureDetector> detectorWidgets =
          tester.widgetList<GestureDetector>(gestureDetectors);
      expect(detectorWidgets.length, greaterThanOrEqualTo(2));

      // Verify the first detector has an onTap callback (previous button)
      final GestureDetector firstDetector = detectorWidgets.first;
      expect(firstDetector.onTap, isNotNull);
    });

    testWidgets("previous step tap executes callback",
        (WidgetTester tester) async {
      final AndroidUserGuideEnum dataSource = AndroidUserGuideEnum.step2;
      // setupUserGuideDetailedViewModelMockWithDataSource(dataSource);

      await tester.pumpWidget(
        createTestableWidget(
          UserGuideDetailedView(userGuideViewDataSource: dataSource),
        ),
      );
      await tester.pump();

      // Find the previous button (first GestureDetector)
      final Finder gestureDetectors = find.byType(GestureDetector);
      final Finder firstDetector = gestureDetectors.first;

      // Tap the previous button to execute the onTap callback
      await tester.tap(firstDetector);
      await tester.pump();

      // Verify the tap was handled without exceptions
      expect(tester.takeException(), isNull);
    });

    testWidgets("handles next step tap", (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          UserGuideDetailedView(userGuideViewDataSource: testDataSource),
        ),
      );
      await tester.pump();

      final Finder nextButton = find.byType(GestureDetector).last;
      await tester.tap(nextButton);
      await tester.pump();

      expect(tester.takeException(), isNull);
    });

    testWidgets("next step tap executes callback", (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          UserGuideDetailedView(userGuideViewDataSource: testDataSource),
        ),
      );
      await tester.pump();

      // Find the next button (last GestureDetector)
      final Finder gestureDetectors = find.byType(GestureDetector);
      final Finder lastDetector = gestureDetectors.last;

      // Tap the next button to execute the onTap callback
      await tester.tap(lastDetector);
      await tester.pump();

      // Verify the tap was handled without exceptions
      expect(tester.takeException(), isNull);
    });

    testWidgets("shows CommonNavigationTitle for Android screen",
        (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          UserGuideDetailedView(userGuideViewDataSource: testDataSource),
        ),
      );
      await tester.pump();

      expect(find.byType(CommonNavigationTitle), findsOneWidget);
    });

    testWidgets("handles different data source types",
        (WidgetTester tester) async {
      final AndroidUserGuideEnum androidSource = AndroidUserGuideEnum.step5;
      // setupUserGuideDetailedViewModelMockWithDataSource(androidSource);
      await tester.pumpWidget(
        createTestableWidget(
          UserGuideDetailedView(userGuideViewDataSource: androidSource),
        ),
      );
      await tester.pump();
      expect(find.byType(UserGuideDetailedView), findsOneWidget);
      expect(find.text(androidSource.title), findsOneWidget);
    });

    testWidgets("displays images with correct properties",
        (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          UserGuideDetailedView(userGuideViewDataSource: testDataSource),
        ),
      );
      await tester.pump();

      // Check that images exist
      expect(find.byType(Image), findsWidgets);

      final Iterable<Image> images =
          tester.widgetList<Image>(find.byType(Image));
      expect(images.length, greaterThanOrEqualTo(3));
    });

    testWidgets("scrollController is accessible", (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          UserGuideDetailedView(userGuideViewDataSource: testDataSource),
        ),
      );
      await tester.pump();

      final SingleChildScrollView scrollView =
          tester.widget<SingleChildScrollView>(
        find.byType(SingleChildScrollView),
      );
      expect(scrollView.controller, isNotNull);
    });

    testWidgets("debug properties", (WidgetTester tester) async {
      final UserGuideDetailedView widget =
          UserGuideDetailedView(userGuideViewDataSource: testDataSource);

      final DiagnosticPropertiesBuilder builder = DiagnosticPropertiesBuilder();
      widget.debugFillProperties(builder);

      final List<DiagnosticsNode> props = builder.properties;
      final DiagnosticsProperty dataSourceProp = props.firstWhere(
        (DiagnosticsNode p) => p.name == "userGuideViewDataSource",
      ) as DiagnosticsProperty;

      expect(dataSourceProp.value, equals(testDataSource));
    });

    testWidgets("route name is correct", (WidgetTester tester) async {
      expect(UserGuideDetailedView.routeName, equals("UserGuideDetailedView"));
    });

    testWidgets("handles edge case data sources", (WidgetTester tester) async {
      AndroidUserGuideEnum lastStep = AndroidUserGuideEnum.step18;

      await tester.pumpWidget(
        createTestableWidget(
          UserGuideDetailedView(userGuideViewDataSource: lastStep),
        ),
      );
      await tester.pump();

      expect(find.byType(UserGuideDetailedView), findsOneWidget);
      expect(find.text(lastStep.description), findsOneWidget);
    });

    testWidgets("widget key is properly set", (WidgetTester tester) async {
      const Key testKey = Key("test_key");
      await tester.pumpWidget(
        createTestableWidget(
          UserGuideDetailedView(
            key: testKey,
            userGuideViewDataSource: testDataSource,
          ),
        ),
      );
      await tester.pump();

      expect(find.byKey(testKey), findsOneWidget);
    });

    testWidgets("cover step3", (WidgetTester tester) async {
      final AndroidUserGuideEnum androidSource = AndroidUserGuideEnum.step3;
      await tester.pumpWidget(
        createTestableWidget(
          UserGuideDetailedView(userGuideViewDataSource: androidSource),
        ),
      );
      androidSource.isImageGIF;
    });
    testWidgets("cover step4", (WidgetTester tester) async {
      final AndroidUserGuideEnum androidSource = AndroidUserGuideEnum.step4;
      await tester.pumpWidget(
        createTestableWidget(
          UserGuideDetailedView(userGuideViewDataSource: androidSource),
        ),
      );
    });
    testWidgets("cover step6", (WidgetTester tester) async {
      final AndroidUserGuideEnum androidSource = AndroidUserGuideEnum.step6;
      await tester.pumpWidget(
        createTestableWidget(
          UserGuideDetailedView(userGuideViewDataSource: androidSource),
        ),
      );
    });
    testWidgets("cover step7", (WidgetTester tester) async {
      final AndroidUserGuideEnum androidSource = AndroidUserGuideEnum.step7;
      await tester.pumpWidget(
        createTestableWidget(
          UserGuideDetailedView(userGuideViewDataSource: androidSource),
        ),
      );
    });
    testWidgets("cover step8", (WidgetTester tester) async {
      final AndroidUserGuideEnum androidSource = AndroidUserGuideEnum.step8;
      await tester.pumpWidget(
        createTestableWidget(
          UserGuideDetailedView(userGuideViewDataSource: androidSource),
        ),
      );
    });
    testWidgets("cover step9", (WidgetTester tester) async {
      final AndroidUserGuideEnum androidSource = AndroidUserGuideEnum.step9;
      await tester.pumpWidget(
        createTestableWidget(
          UserGuideDetailedView(userGuideViewDataSource: androidSource),
        ),
      );
    });
    testWidgets("cover step10", (WidgetTester tester) async {
      final AndroidUserGuideEnum androidSource = AndroidUserGuideEnum.step10;
      await tester.pumpWidget(
        createTestableWidget(
          UserGuideDetailedView(userGuideViewDataSource: androidSource),
        ),
      );
    });
    testWidgets("cover step11", (WidgetTester tester) async {
      final AndroidUserGuideEnum androidSource = AndroidUserGuideEnum.step11;
      await tester.pumpWidget(
        createTestableWidget(
          UserGuideDetailedView(userGuideViewDataSource: androidSource),
        ),
      );
    });
    testWidgets("cover step12", (WidgetTester tester) async {
      final AndroidUserGuideEnum androidSource = AndroidUserGuideEnum.step12;
      await tester.pumpWidget(
        createTestableWidget(
          UserGuideDetailedView(userGuideViewDataSource: androidSource),
        ),
      );
    });
    testWidgets("cover step13", (WidgetTester tester) async {
      final AndroidUserGuideEnum androidSource = AndroidUserGuideEnum.step13;
      await tester.pumpWidget(
        createTestableWidget(
          UserGuideDetailedView(userGuideViewDataSource: androidSource),
        ),
      );
    });
    testWidgets("cover step14", (WidgetTester tester) async {
      final AndroidUserGuideEnum androidSource = AndroidUserGuideEnum.step14;
      await tester.pumpWidget(
        createTestableWidget(
          UserGuideDetailedView(userGuideViewDataSource: androidSource),
        ),
      );
      androidSource.isImageGIF;
    });
    testWidgets("cover step15", (WidgetTester tester) async {
      final AndroidUserGuideEnum androidSource = AndroidUserGuideEnum.step15;
      await tester.pumpWidget(
        createTestableWidget(
          UserGuideDetailedView(userGuideViewDataSource: androidSource),
        ),
      );
    });
    testWidgets("cover step16", (WidgetTester tester) async {
      final AndroidUserGuideEnum androidSource = AndroidUserGuideEnum.step16;
      await tester.pumpWidget(
        createTestableWidget(
          UserGuideDetailedView(userGuideViewDataSource: androidSource),
        ),
      );
    });
    testWidgets("cover step17", (WidgetTester tester) async {
      final AndroidUserGuideEnum androidSource = AndroidUserGuideEnum.step17;
      await tester.pumpWidget(
        createTestableWidget(
          UserGuideDetailedView(userGuideViewDataSource: androidSource),
        ),
      );
    });
  });
}
