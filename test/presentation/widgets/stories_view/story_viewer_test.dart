import "package:esim_open_source/presentation/widgets/stories_view/story_item.dart";
import "package:esim_open_source/presentation/widgets/stories_view/story_viewer.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";

import "../../../helpers/view_helper.dart";
import "../../../helpers/view_model_helper.dart";

Future<void> main() async {
  await prepareTest();

  group("StoryViewer Widget Tests", () {
    late List<StoryItem> testStories;
    late StoryViewerArgs testArgs;

    setUp(() async {
      await setupTest();
      onViewModelReadyMock();

      testStories = <StoryItem>[
        StoryItem(
          content: Container(key: const Key("story_1")),
          buttons: Container(),
          duration: const Duration(seconds: 1),
        ),
        StoryItem(
          content: Container(key: const Key("story_2")),
          buttons: Container(),
          duration: const Duration(seconds: 1),
          useSplitTransition: true,
        ),
      ];

      testArgs = StoryViewerArgs(
        stories: testStories,
        onComplete: () {},
        indicatorHeight: 8,
        indicatorBorderRadius: 12,
        indicatorBackgroundColor: Colors.white38,
      );
    });

    tearDown(() async {
      await tearDownTest();
    });

    testWidgets("renders basic structure", (WidgetTester tester) async {
      await tester.pumpWidget(createTestableWidget(
        StoryViewer(storyViewerArgs: testArgs),
      ),);
      await tester.pump();

      expect(find.byType(StoryViewer), findsOneWidget);
      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(PageView), findsOneWidget);
      expect(find.byType(LinearProgressIndicator), findsNWidgets(testStories.length));
      expect(find.byType(GestureDetector), findsWidgets);
    });

    testWidgets("progress indicators styled correctly", (WidgetTester tester) async {
      await tester.pumpWidget(createTestableWidget(
        StoryViewer(storyViewerArgs: testArgs),
      ),);
      await tester.pump();

      final Iterable<LinearProgressIndicator> indicators = tester.widgetList<LinearProgressIndicator>(
        find.byType(LinearProgressIndicator),
      );

      for (final LinearProgressIndicator indicator in indicators) {
        expect(indicator.backgroundColor, equals(testArgs.indicatorBackgroundColor));
        expect(indicator.valueColor?.value, equals(testArgs.indicatorColor));
        expect(indicator.minHeight, equals(testArgs.indicatorHeight));
      }
    });

    testWidgets("PageView configured correctly", (WidgetTester tester) async {
      await tester.pumpWidget(createTestableWidget(
        StoryViewer(storyViewerArgs: testArgs),
      ),);
      await tester.pump();

      final PageView pageView = tester.widget<PageView>(find.byType(PageView));
      expect(pageView.physics, isA<NeverScrollableScrollPhysics>());
    });

    testWidgets("handles gestures", (WidgetTester tester) async {
      await tester.pumpWidget(createTestableWidget(
        StoryViewer(storyViewerArgs: testArgs),
      ),);
      await tester.pump();

      await tester.tap(find.byType(GestureDetector).first);
      await tester.pump();

      await tester.longPress(find.byType(GestureDetector).first);
      await tester.pump();

      await tester.drag(find.byType(GestureDetector).first, const Offset(0, 100));
      await tester.pump();

      expect(tester.takeException(), isNull);
    });

    testWidgets("debugFillProperties works", (WidgetTester tester) async {
      final StoryViewer widget = StoryViewer(storyViewerArgs: testArgs);
      final DiagnosticPropertiesBuilder builder = DiagnosticPropertiesBuilder();
      widget.debugFillProperties(builder);

      final List<DiagnosticsNode> props = builder.properties;
      final DiagnosticsProperty<StoryViewerArgs> argsProp = props.firstWhere(
        (DiagnosticsNode p) => p.name == "storyViewerArgs",
      ) as DiagnosticsProperty<StoryViewerArgs>;

      expect(argsProp.value, equals(testArgs));
    });

    testWidgets("handles different configurations", (WidgetTester tester) async {
      final StoryViewerArgs customArgs = StoryViewerArgs(
        stories: <StoryItem>[
          StoryItem(
            content: const Text("Test"),
            buttons: Container(),
            duration: const Duration(seconds: 1),
          ),
        ],
        indicatorHeight: 10,
        indicatorBorderRadius: 20,
        indicatorColor: Colors.red,
        indicatorBackgroundColor: Colors.blue,
      );

      await tester.pumpWidget(createTestableWidget(
        StoryViewer(storyViewerArgs: customArgs),
      ),);
      await tester.pump();

      expect(find.byType(StoryViewer), findsOneWidget);
      expect(find.text("Test"), findsOneWidget);
    });

    testWidgets("layout structure correct", (WidgetTester tester) async {
      await tester.pumpWidget(createTestableWidget(
        StoryViewer(storyViewerArgs: testArgs),
      ),);
      await tester.pump();

      expect(find.byType(SafeArea), findsOneWidget);
      expect(find.byType(Padding), findsWidgets);
      expect(find.byType(Row), findsOneWidget);
      expect(find.byType(Stack), findsWidgets);
      expect(find.byType(Align), findsOneWidget);

      final Align align = tester.widget<Align>(find.byType(Align));
      expect(align.alignment, equals(Alignment.bottomCenter));
    });

    testWidgets("handles edge cases", (WidgetTester tester) async {
      final StoryItem edgeCaseStory = StoryItem(
        content: Container(),
        buttons: Container(),
        duration: Duration.zero,
      );
      
      final StoryViewerArgs edgeArgs = StoryViewerArgs(stories: <StoryItem>[edgeCaseStory]);
      
      await tester.pumpWidget(createTestableWidget(
        StoryViewer(storyViewerArgs: edgeArgs),
      ),);
      await tester.pump();
      
      expect(find.byType(StoryViewer), findsOneWidget);
    });
  });
}
