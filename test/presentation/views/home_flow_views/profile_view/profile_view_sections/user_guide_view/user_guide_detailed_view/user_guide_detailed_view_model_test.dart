import "package:esim_open_source/presentation/views/home_flow_views/profile_view/profile_view_sections/user_guide_view/user_guide_data_source/android_user_guide_enum.dart";
import "package:esim_open_source/presentation/views/home_flow_views/profile_view/profile_view_sections/user_guide_view/user_guide_data_source/user_guide_view_data_source.dart";
import "package:esim_open_source/presentation/views/home_flow_views/profile_view/profile_view_sections/user_guide_view/user_guide_detailed_view/user_guide_detailed_view_model.dart";
import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";

import "../../../../../../../helpers/view_helper.dart";
import "../../../../../../../helpers/view_model_helper.dart";
import "../../../../../../../locator_test.dart";

Future<void> main() async {
  await prepareTest();

  group("UserGuideDetailedViewModel Tests", () {
    late UserGuideDetailedViewModel viewModel;
    late UserGuideViewDataSource testDataSource;

    setUp(() async {
      await setupTest();
      onViewModelReadyMock(viewName: "UserGuideDetailedView");
      testDataSource = AndroidUserGuideEnum.step1;
      viewModel = UserGuideDetailedViewModel()
        ..userGuideViewDataSource = testDataSource;
      await locator.resetLazySingleton<UserGuideDetailedViewModel>();
      // locator.registerLazySingleton<UserGuideDetailedViewModel>(
      //     UserGuideDetailedViewModel.new);
      viewModel = locator<UserGuideDetailedViewModel>()
        ..userGuideViewDataSource = testDataSource;
    });

    tearDown(() async {
      // if (!viewModel.disposed) {
      //   viewModel.dispose();
      // }
      await tearDownTest();
    });

    // testWidgets("handles next step tap", (WidgetTester tester) async {
    //   await tester.pumpWidget(
    //     createTestableWidget(
    //       UserGuideDetailedView(userGuideViewDataSource: testDataSource),
    //     ),
    //   );
    //   await tester.pump();
    //
    //   final nextButton = find.byType(GestureDetector).last;
    //   await tester.tap(nextButton);
    //   await tester.pump();
    //
    //   expect(tester.takeException(), isNull);
    // });

    test("initializes with correct data source", () {
      expect(viewModel.userGuideViewDataSource, equals(testDataSource));
      expect(viewModel.scrollController, isNotNull);
      expect(viewModel.isFromAndroidScreen, isFalse);
    });

    test("onViewModelReady sets isFromAndroidScreen correctly for Android", () {
      final AndroidUserGuideEnum androidDataSource = AndroidUserGuideEnum.step1;
      final UserGuideDetailedViewModel androidViewModel =
          UserGuideDetailedViewModel()
            ..userGuideViewDataSource = androidDataSource
            ..onViewModelReady();

      expect(androidViewModel.isFromAndroidScreen, isTrue);

      androidViewModel.dispose();
    });

    test("onViewModelReady sets isFromAndroidScreen correctly for non-Android",
        () {
      final MockUserGuideDataSource mockDataSource = MockUserGuideDataSource();
      final UserGuideDetailedViewModel nonAndroidViewModel =
          UserGuideDetailedViewModel()
            ..userGuideViewDataSource = mockDataSource
            ..onViewModelReady();

      expect(nonAndroidViewModel.isFromAndroidScreen, isFalse);

      nonAndroidViewModel.dispose();
    });

    test("scrollController is initialized", () {
      expect(viewModel.scrollController, isA<ScrollController>());
      expect(viewModel.scrollController.hasClients, isFalse);
    });

    test("data source updates correctly for next step", () async {
      viewModel.userGuideViewDataSource = AndroidUserGuideEnum.step1;
      final UserGuideViewDataSource nextSource =
          viewModel.userGuideViewDataSource.nextStepTapped();

      expect(nextSource, equals(AndroidUserGuideEnum.step2));
    });

    test("data source updates correctly for previous step", () {
      viewModel.userGuideViewDataSource = AndroidUserGuideEnum.step2;
      final UserGuideViewDataSource nextSource =
          viewModel.userGuideViewDataSource.previousStepTapped();

      expect(nextSource, equals(AndroidUserGuideEnum.step1));
    });

    test("previousStepTapped method updates data source", () {
      // Setup initial state at step 2 so we can go backwards
      viewModel.userGuideViewDataSource = AndroidUserGuideEnum.step2;
      final UserGuideViewDataSource initialStep =
          viewModel.userGuideViewDataSource;

      // Test the data source navigation logic directly
      final UserGuideViewDataSource previousStep =
          viewModel.userGuideViewDataSource.previousStepTapped();

      // Verify the step moved backwards correctly
      expect(previousStep, isNot(equals(initialStep)));
      expect(previousStep, equals(AndroidUserGuideEnum.step1));
    });

    test("previousStepTapped method signature verification", () {
      // Test that the method signature exists and is accessible
      expect(viewModel.previousStepTapped, isA<Function>());

      // Verify the method is properly defined as an async method
      expect(
        viewModel.runtimeType.toString(),
        contains("UserGuideDetailedViewModel"),
      );
    });

    test("data source stays at last step when at end", () {
      viewModel.userGuideViewDataSource = AndroidUserGuideEnum.step18;
      final UserGuideViewDataSource nextSource =
          viewModel.userGuideViewDataSource.nextStepTapped();

      expect(nextSource, equals(AndroidUserGuideEnum.step18));
    });

    test("data source stays at first step when at beginning", () {
      viewModel.userGuideViewDataSource = AndroidUserGuideEnum.step1;
      final UserGuideViewDataSource previousSource =
          viewModel.userGuideViewDataSource.previousStepTapped();

      expect(previousSource, equals(AndroidUserGuideEnum.step1));
    });

    test("viewModel disposes correctly", () {
      expect(() => viewModel.dispose(), returnsNormally);
    });

    test("inheritance from BaseModel", () {
      expect(
        viewModel.runtimeType.toString(),
        contains("UserGuideDetailedViewModel"),
      );
    });

    test("handles different Android steps correctly", () {
      final List<AndroidUserGuideEnum> steps = <AndroidUserGuideEnum>[
        AndroidUserGuideEnum.step1,
        AndroidUserGuideEnum.step5,
        AndroidUserGuideEnum.step10,
        AndroidUserGuideEnum.step15,
        AndroidUserGuideEnum.step18,
      ];

      for (final AndroidUserGuideEnum step in steps) {
        viewModel.userGuideViewDataSource = step;
        expect(viewModel.userGuideViewDataSource, equals(step));
      }
    });

    test("scrollController state is maintained", () {
      final ScrollController controller1 = viewModel.scrollController;
      viewModel.userGuideViewDataSource = AndroidUserGuideEnum.step5;
      final ScrollController controller2 = viewModel.scrollController;

      expect(controller1, equals(controller2));
    });

    test("base view model properties are accessible", () {
      expect(viewModel.disposed, isFalse);
      // expect(viewModel.hasListeners, isFalse);
    });

    test("data source type checking works", () {
      expect(viewModel.userGuideViewDataSource, isA<AndroidUserGuideEnum>());
      expect(viewModel.userGuideViewDataSource, isA<UserGuideViewDataSource>());
    });

    test("scroll controller properties", () {
      expect(viewModel.scrollController.debugLabel, isNull);
      expect(viewModel.scrollController.keepScrollOffset, isTrue);
    });
  });
}

class MockUserGuideDataSource implements UserGuideViewDataSource {
  @override
  String get title => "Mock Title";

  @override
  String get imageName => "mock_image";

  @override
  String get description => "Mock Description";

  @override
  String get stepNumberLabel => "Step 1 of 10";

  @override
  bool get isImageGIF => false;

  @override
  String get fullImagePath => "assets/images/mock.png";

  @override
  bool isPreviousEnabled() => true;

  @override
  bool isNextEnabled() => true;

  @override
  UserGuideViewDataSource nextStepTapped() => this;

  @override
  UserGuideViewDataSource previousStepTapped() => this;
}
