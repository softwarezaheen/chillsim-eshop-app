import "package:esim_open_source/presentation/views/home_flow_views/profile_view/profile_view_sections/user_guide_view/android_user_guide_view/android_gallery_user_guide_view.dart";
import "package:esim_open_source/presentation/widgets/common_navigation_title.dart";
import "package:esim_open_source/presentation/widgets/padding_widget.dart";
import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";

import "../../../../../../../helpers/view_helper.dart";

Future<void> main() async {
  await prepareTest();

  setUp(() async {
    await setupTest();
  });

  tearDown(() async {
    await tearDownTest();
  });

  group("AndroidGalleryUserGuideView Widget Tests", () {
    testWidgets("renders correctly with initial state",
        (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const AndroidGalleryUserGuideView(),
        ),
      );
      await tester.pump();

      expect(find.byType(AndroidGalleryUserGuideView), findsOneWidget);
      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(SafeArea), findsOneWidget);
      expect(find.byType(SizedBox), findsWidgets);
      expect(find.byType(PaddingWidget), findsWidgets);
      expect(find.byType(Column), findsWidgets);
    });

    testWidgets("displays CommonNavigationTitle", (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const AndroidGalleryUserGuideView(),
        ),
      );
      await tester.pump();

      expect(find.byType(CommonNavigationTitle), findsOneWidget);
    });

    testWidgets("displays SingleChildScrollView", (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const AndroidGalleryUserGuideView(),
        ),
      );
      await tester.pump();

      expect(find.byType(SingleChildScrollView), findsOneWidget);
      expect(find.byType(Expanded), findsWidgets);
    });

    testWidgets("displays multiple Text widgets", (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const AndroidGalleryUserGuideView(),
        ),
      );
      await tester.pump();

      expect(find.byType(Text), findsWidgets);
      final Iterable<Text> textWidgets =
          tester.widgetList<Text>(find.byType(Text));
      expect(textWidgets.length, greaterThanOrEqualTo(5));
    });

    testWidgets("displays ListView components", (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const AndroidGalleryUserGuideView(),
        ),
      );
      await tester.pump();

      expect(find.byType(ListView), findsWidgets);
      final Iterable<ListView> listViews =
          tester.widgetList<ListView>(find.byType(ListView));
      expect(listViews.length, greaterThanOrEqualTo(3));
    });

    testWidgets("displays Icons in list items", (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const AndroidGalleryUserGuideView(),
        ),
      );
      await tester.pump();

      expect(find.byType(Icon), findsWidgets);
      expect(find.byIcon(Icons.play_arrow), findsWidgets);
    });

    testWidgets("displays Row widgets for list items",
        (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const AndroidGalleryUserGuideView(),
        ),
      );
      await tester.pump();

      expect(find.byType(Row), findsWidgets);
      final Iterable<Row> rows = tester.widgetList<Row>(find.byType(Row));
      expect(rows.length, greaterThanOrEqualTo(5));
    });

    testWidgets("route name is correct", (WidgetTester tester) async {
      expect(
        AndroidGalleryUserGuideView.routeName,
        equals("AndroidGalleryUserGuideView"),
      );
    });

    testWidgets("widget key is properly set", (WidgetTester tester) async {
      const Key testKey = Key("test_key");
      await tester.pumpWidget(
        createTestableWidget(
          const AndroidGalleryUserGuideView(key: testKey),
        ),
      );
      await tester.pump();

      expect(find.byKey(testKey), findsOneWidget);
    });

    testWidgets("headerTitleText method coverage", (WidgetTester tester) async {
      const AndroidGalleryUserGuideView widget = AndroidGalleryUserGuideView();

      await tester.pumpWidget(
        createTestableWidget(
          Builder(
            builder: (BuildContext context) =>
                widget.headerTitleText(context, "Test Header"),
          ),
        ),
      );
      await tester.pump();

      expect(find.byType(PaddingWidget), findsOneWidget);
      expect(find.byType(Text), findsOneWidget);
      expect(find.text("Test Header"), findsOneWidget);
    });

    testWidgets("pointTitleText method coverage", (WidgetTester tester) async {
      const AndroidGalleryUserGuideView widget = AndroidGalleryUserGuideView();
      final List<String> testTexts = <String>["Point 1", "Point 2", "Point 3"];

      await tester.pumpWidget(
        createTestableWidget(
          Builder(
            builder: (BuildContext context) =>
                widget.pointTitleText(context, testTexts),
          ),
        ),
      );
      await tester.pump();

      expect(find.byType(ListView), findsOneWidget);
      expect(find.byType(Icon), findsWidgets);
      expect(find.text("Point 1"), findsOneWidget);
      expect(find.text("Point 2"), findsOneWidget);
      expect(find.text("Point 3"), findsOneWidget);
    });

    testWidgets("pointTitleText handles empty list",
        (WidgetTester tester) async {
      const AndroidGalleryUserGuideView widget = AndroidGalleryUserGuideView();
      final List<String> testTexts = <String>[];

      await tester.pumpWidget(
        createTestableWidget(
          Builder(
            builder: (BuildContext context) =>
                widget.pointTitleText(context, testTexts),
          ),
        ),
      );
      await tester.pump();

      expect(find.byType(ListView), findsOneWidget);
      expect(find.byType(Icon), findsNothing);
    });

    testWidgets("pointTitleText handles single item",
        (WidgetTester tester) async {
      const AndroidGalleryUserGuideView widget = AndroidGalleryUserGuideView();
      final List<String> testTexts = <String>["Single Point"];

      await tester.pumpWidget(
        createTestableWidget(
          Builder(
            builder: (BuildContext context) =>
                widget.pointTitleText(context, testTexts),
          ),
        ),
      );
      await tester.pump();

      expect(find.byType(ListView), findsOneWidget);
      expect(find.byType(Icon), findsOneWidget);
      expect(find.text("Single Point"), findsOneWidget);
    });

    testWidgets("layout structure validation", (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const AndroidGalleryUserGuideView(),
        ),
      );
      await tester.pump();

      final Scaffold scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
      expect(scaffold.body, isNotNull);

      final Iterable<Column> columns =
          tester.widgetList<Column>(find.byType(Column));
      expect(columns.length, greaterThanOrEqualTo(2));
    });

    testWidgets("ListView physics and shrinkWrap properties",
        (WidgetTester tester) async {
      const AndroidGalleryUserGuideView widget = AndroidGalleryUserGuideView();
      final List<String> testTexts = <String>["Test 1", "Test 2"];

      await tester.pumpWidget(
        createTestableWidget(
          Builder(
            builder: (BuildContext context) =>
                widget.pointTitleText(context, testTexts),
          ),
        ),
      );
      await tester.pump();

      final ListView listView = tester.widget<ListView>(find.byType(ListView));
      expect(listView.shrinkWrap, isTrue);
      expect(listView.physics, isA<NeverScrollableScrollPhysics>());
    });

    testWidgets("Icon properties in point list", (WidgetTester tester) async {
      const AndroidGalleryUserGuideView widget = AndroidGalleryUserGuideView();
      final List<String> testTexts = <String>["Test Point"];

      await tester.pumpWidget(
        createTestableWidget(
          Builder(
            builder: (BuildContext context) =>
                widget.pointTitleText(context, testTexts),
          ),
        ),
      );
      await tester.pump();

      final Icon icon = tester.widget<Icon>(find.byType(Icon));
      expect(icon.icon, equals(Icons.play_arrow));
      expect(icon.size, equals(20));
    });

    testWidgets("Row alignment in point list", (WidgetTester tester) async {
      const AndroidGalleryUserGuideView widget = AndroidGalleryUserGuideView();
      final List<String> testTexts = <String>["Test Point"];

      await tester.pumpWidget(
        createTestableWidget(
          Builder(
            builder: (BuildContext context) =>
                widget.pointTitleText(context, testTexts),
          ),
        ),
      );
      await tester.pump();

      final Row row = tester.widget<Row>(find.byType(Row).first);
      expect(row.crossAxisAlignment, equals(CrossAxisAlignment.start));
    });

    testWidgets("SizedBox spacing in point list", (WidgetTester tester) async {
      const AndroidGalleryUserGuideView widget = AndroidGalleryUserGuideView();
      final List<String> testTexts = <String>["Test Point"];

      await tester.pumpWidget(
        createTestableWidget(
          Builder(
            builder: (BuildContext context) =>
                widget.pointTitleText(context, testTexts),
          ),
        ),
      );
      await tester.pump();

      final Iterable<SizedBox> sizedBoxes =
          tester.widgetList<SizedBox>(find.byType(SizedBox));
      bool foundCorrectWidth = false;
      for (final SizedBox sizedBox in sizedBoxes) {
        if (sizedBox.width == 6) {
          foundCorrectWidth = true;
          break;
        }
      }
      expect(foundCorrectWidth, isTrue);
    });

    testWidgets("Expanded widget in point list", (WidgetTester tester) async {
      const AndroidGalleryUserGuideView widget = AndroidGalleryUserGuideView();
      final List<String> testTexts = <String>["Test Point"];

      await tester.pumpWidget(
        createTestableWidget(
          Builder(
            builder: (BuildContext context) =>
                widget.pointTitleText(context, testTexts),
          ),
        ),
      );
      await tester.pump();

      expect(find.byType(Expanded), findsWidgets);
    });
  });
}
