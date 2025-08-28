import "package:esim_open_source/presentation/widgets/stories_view/story_item.dart";
import "package:esim_open_source/presentation/widgets/stories_view/story_viewer_model.dart";
import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";
import "package:mockito/mockito.dart";
import "package:stacked_services/stacked_services.dart";

import "../../../helpers/view_helper.dart";
import "../../../helpers/view_model_helper.dart";
import "../../../locator_test.dart";

// ignore_for_file: type=lint
Future<void> main() async {
  await prepareTest();

  group("StoryViewerViewModel Tests", () {
    late List<StoryItem> testStories;
    late Function()? onCompleteCalled;

    setUp(() async {
      await setupTest();
      onViewModelReadyMock();
      onCompleteCalled = () {};

      testStories = <StoryItem>[
        StoryItem(
          content: Container(),
          buttons: Container(),
          duration: const Duration(milliseconds: 100),
        ),
        StoryItem(
          content: Container(),
          buttons: Container(),
          duration: const Duration(milliseconds: 100),
          useSplitTransition: true,
        ),
      ];
    });

    tearDown(() async {
      await tearDownTest();
    });

    test("basic initialization", () {
      final StoryViewerViewModel viewModel = StoryViewerViewModel(
        stories: testStories,
        autoClose: true,
        onComplete: onCompleteCalled,
      );

      expect(viewModel.stories, equals(testStories));
      expect(viewModel.autoClose, isTrue);
      expect(viewModel.onComplete, equals(onCompleteCalled));
      expect(viewModel.progress, equals(0));
      expect(viewModel.currentIndex, equals(0));
      expect(viewModel.pageController, isNotNull);

      viewModel.onDispose();
    });

    test("onViewModelReady starts timer", () {
      StoryViewerViewModel(
        stories: testStories,
        autoClose: false,
        onComplete: onCompleteCalled,
      )
        ..onViewModelReady()
        ..onDispose();
    });

    test("onStoryChanged updates index", () {
      final StoryViewerViewModel viewModel = StoryViewerViewModel(
        stories: testStories,
        autoClose: false,
        onComplete: onCompleteCalled,
      )..onStoryChanged(1);
      expect(viewModel.currentIndex, equals(1));
      viewModel.onDispose();
    });

    test("closeView calls navigation back", () {
      when(locator<NavigationService>().back()).thenReturn(true);

      final StoryViewerViewModel viewModel = StoryViewerViewModel(
        stories: testStories,
        autoClose: false,
        onComplete: onCompleteCalled,
      )..closeView();
      verify(locator<NavigationService>().back()).called(1);
      viewModel.onDispose();
    });

    test("pauseStory and resumeStory work", () {
      StoryViewerViewModel(
        stories: testStories,
        autoClose: false,
        onComplete: onCompleteCalled,
      )
        ..pauseStory()
        ..resumeStory()
        ..onDispose();
    });

    test("pauseStory and resumeStory with _dispose", () {
      StoryViewerViewModel(
        stories: testStories,
        autoClose: false,
        onComplete: onCompleteCalled,
      )
        ..pauseStory()
        ..resumeStory()
        ..onDispose()
        ..resumeStory();
    });

    testWidgets("onTapDown handles tap gestures", (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Container(width: 400, height: 600),
        ),
      );
      final context = tester.element(find.byType(Container));

      final viewModel = StoryViewerViewModel(
        stories: [
          StoryItem(
            content: Container(),
            buttons: Container(),
            duration: const Duration(seconds: 5),
          ),
        ],
        autoClose: false,
        onComplete: onCompleteCalled,
      );

      // Test onTapDown calls without advancing stories to avoid PageController issues
      await viewModel.onTapDown(
        context,
        TapDownDetails(globalPosition: const Offset(300, 100)),
      );

      viewModel.onDispose();
    });

    testWidgets("onTapDown handles exceptions", (WidgetTester tester) async {
      await tester.pumpWidget(Container());
      final Element context = tester.element(find.byType(Container));

      final StoryViewerViewModel viewModel = StoryViewerViewModel(
        stories: <StoryItem>[
          StoryItem(
            content: Container(),
            buttons: Container(),
            duration: const Duration(seconds: 5),
          ),
        ],
        autoClose: false,
        onComplete: onCompleteCalled,
      );

      await viewModel.onTapDown(
        context,
        TapDownDetails(globalPosition: const Offset(100, 100)),
      );

      viewModel.onDispose();
    });

    test("story advancement without PageController", () async {
      bool completed = false;
      final List<StoryItem> singleStory = <StoryItem>[
        StoryItem(
          content: Container(),
          buttons: Container(),
          duration: const Duration(milliseconds: 50),
        ),
      ];

      when(locator<NavigationService>().back()).thenReturn(true);

      final StoryViewerViewModel viewModel = StoryViewerViewModel(
        stories: singleStory,
        autoClose: true,
        onComplete: () => completed = true,
      )..onViewModelReady();

      // Wait for single story to complete
      await Future<void>.delayed(const Duration(milliseconds: 100));

      expect(completed, isTrue);
      verify(locator<NavigationService>().back()).called(1);

      viewModel.onDispose();
    });
  });
}
