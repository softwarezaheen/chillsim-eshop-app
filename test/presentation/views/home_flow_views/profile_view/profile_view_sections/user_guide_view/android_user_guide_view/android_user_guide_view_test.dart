import "package:esim_open_source/presentation/views/home_flow_views/profile_view/profile_view_sections/user_guide_view/android_user_guide_view/android_user_guide_view.dart";
import "package:esim_open_source/presentation/widgets/padding_widget.dart";
import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";

import "../../../../../../../helpers/view_helper.dart";
import "../../../../../../../helpers/view_model_helper.dart";

Future<void> main() async {
  await prepareTest();

  setUp(() async {
    await setupTest();
    onViewModelReadyMock(viewName: "AndroidUserGuideView");
    // locator<AndroidUserGuideViewModel>();
  });

  tearDown(() async {
    await tearDownTest();
  });

  group("AndroidUserGuideView Widget Tests", () {
    testWidgets("renders correctly with initial state",
        (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const AndroidUserGuideView(),
        ),
      );
      await tester.pump();

      expect(find.byType(AndroidUserGuideView), findsOneWidget);
      expect(find.byType(SizedBox), findsWidgets);
      expect(find.byType(PaddingWidget), findsWidgets);
      expect(find.byType(Column), findsWidgets);
      expect(find.byType(Text), findsWidgets);
      expect(find.byType(GestureDetector), findsWidgets);
    });

    testWidgets("displays title text correctly", (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const AndroidUserGuideView(),
        ),
      );
      await tester.pump();

      expect(find.byType(Text), findsWidgets);
      final Iterable<Text> textWidgets =
          tester.widgetList<Text>(find.byType(Text));
      expect(textWidgets.length, greaterThanOrEqualTo(3));
    });

    testWidgets("displays both QR scan options", (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const AndroidUserGuideView(),
        ),
      );
      await tester.pump();

      final Finder gestureDetectors = find.byType(GestureDetector);
      expect(gestureDetectors, findsWidgets);

      final Iterable<GestureDetector> gestureWidgets =
          tester.widgetList<GestureDetector>(gestureDetectors);
      expect(gestureWidgets.first.onTap, isNotNull);
      expect(gestureWidgets.last.onTap, isNotNull);
    });

    // testWidgets("handles QR camera scan tap", (WidgetTester tester) async {
    //   await tester.pumpWidget(
    //     createTestableWidget(
    //       const AndroidUserGuideView(),
    //     ),
    //   );
    //   await tester.pump();
    //
    //   final firstGestureDetector = find.byType(GestureDetector).first;
    //   await tester.tap(firstGestureDetector);
    //   await tester.pump();
    //
    //   expect(tester.takeException(), isNull);
    // });
    //
    // testWidgets("handles gallery scan tap", (WidgetTester tester) async {
    //   await tester.pumpWidget(
    //     createTestableWidget(
    //       const AndroidUserGuideView(),
    //     ),
    //   );
    //   await tester.pump();
    //
    //   final lastGestureDetector = find.byType(GestureDetector).last;
    //   await tester.tap(lastGestureDetector);
    //   await tester.pump();
    //
    //   expect(tester.takeException(), isNull);
    // });

    testWidgets("displays images correctly", (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const AndroidUserGuideView(),
        ),
      );
      await tester.pump();

      expect(find.byType(Image), findsWidgets);
      final Iterable<Image> images =
          tester.widgetList<Image>(find.byType(Image));
      expect(images.length, greaterThanOrEqualTo(3));
    });

    testWidgets("userGuideBubbleView renders correctly",
        (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const AndroidUserGuideView(),
        ),
      );
      await tester.pump();

      expect(find.byType(DecoratedBox), findsWidgets);
      expect(find.byType(Row), findsWidgets);
      expect(find.byType(Expanded), findsWidgets);
    });

    testWidgets("bubble decoration has correct properties",
        (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const AndroidUserGuideView(),
        ),
      );
      await tester.pump();

      final Iterable<DecoratedBox> decoratedBoxes =
          tester.widgetList<DecoratedBox>(find.byType(DecoratedBox));
      expect(decoratedBoxes.length, greaterThanOrEqualTo(1));

      for (final DecoratedBox decoratedBox in decoratedBoxes) {
        final BoxDecoration decoration =
            decoratedBox.decoration as BoxDecoration;
        expect(decoration.borderRadius, isA<BorderRadius>());
      }
    });

    testWidgets("route name is correct", (WidgetTester tester) async {
      expect(AndroidUserGuideView.routeName, equals("AndroidUserGuideView"));
    });

    testWidgets("widget key is properly set", (WidgetTester tester) async {
      const Key testKey = Key("test_key");
      await tester.pumpWidget(
        createTestableWidget(
          const AndroidUserGuideView(key: testKey),
        ),
      );
      await tester.pump();

      expect(find.byKey(testKey), findsOneWidget);
    });

    // testWidgets("debug properties", (WidgetTester tester) async {
    //   const widget = AndroidUserGuideView();
    //
    //   final builder = DiagnosticPropertiesBuilder();
    //   widget.debugFillProperties(builder);
    //
    //   final props = builder.properties;
    //   expect(props, isNotEmpty);
    // });

    testWidgets("images have correct dimensions", (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const AndroidUserGuideView(),
        ),
      );
      await tester.pump();

      final Iterable<Image> images =
          tester.widgetList<Image>(find.byType(Image));

      bool found40x40Images = false;
      bool found15x15Images = false;

      for (final Image image in images) {
        if (image.width == 40 && image.height == 40) {
          found40x40Images = true;
        }
        if (image.width == 15 && image.height == 15) {
          found15x15Images = true;
        }
      }

      expect(found40x40Images, isTrue);
      expect(found15x15Images, isTrue);
    });

    testWidgets("padding widget applies correct padding",
        (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const AndroidUserGuideView(),
        ),
      );
      await tester.pump();

      expect(find.byType(PaddingWidget), findsWidgets);
      final Iterable<PaddingWidget> paddingWidgets =
          tester.widgetList<PaddingWidget>(find.byType(PaddingWidget));
      expect(paddingWidgets.length, greaterThanOrEqualTo(1));
    });

    testWidgets("column layout structure", (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const AndroidUserGuideView(),
        ),
      );
      await tester.pump();

      expect(find.byType(Column), findsWidgets);
      final Iterable<Column> columns =
          tester.widgetList<Column>(find.byType(Column));
      expect(columns.length, greaterThanOrEqualTo(1));
    });

    testWidgets("horizontal spacing elements exist",
        (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const AndroidUserGuideView(),
        ),
      );
      await tester.pump();

      expect(find.byType(SizedBox), findsWidgets);
    });

    testWidgets("expanded widgets maintain layout",
        (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const AndroidUserGuideView(),
        ),
      );
      await tester.pump();

      expect(find.byType(Expanded), findsWidgets);
      final Iterable<Expanded> expandedWidgets =
          tester.widgetList<Expanded>(find.byType(Expanded));
      expect(expandedWidgets.length, greaterThanOrEqualTo(1));
    });

    testWidgets("row main axis alignment", (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const AndroidUserGuideView(),
        ),
      );
      await tester.pump();

      final Iterable<Row> rows = tester.widgetList<Row>(find.byType(Row));
      for (final Row row in rows) {
        expect(row.mainAxisAlignment, isNotNull);
      }
    });
  });
}
