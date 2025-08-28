import "package:esim_open_source/presentation/views/home_flow_views/profile_view/profile_view_sections/user_guide_view/android_user_guide_view/android_gallery_user_guide_view.dart";
import "package:esim_open_source/presentation/views/home_flow_views/profile_view/profile_view_sections/user_guide_view/android_user_guide_view/android_user_guide_view_model.dart";
import "package:esim_open_source/presentation/views/home_flow_views/profile_view/profile_view_sections/user_guide_view/user_guide_detailed_view/user_guide_detailed_view.dart";
import "package:flutter_test/flutter_test.dart";
import "package:mockito/mockito.dart";
import "package:stacked_services/stacked_services.dart";

import "../../../../../../../helpers/view_helper.dart";
import "../../../../../../../helpers/view_model_helper.dart";
import "../../../../../../../locator_test.dart";
import "../../../../../../../locator_test.mocks.dart";

Future<void> main() async {
  await prepareTest();
  late AndroidUserGuideViewModel viewModel;
  late MockNavigationService mockNavigationService;

  setUp(() async {
    await setupTest();
    onViewModelReadyMock(viewName: "AndroidUserGuideView");
    viewModel = AndroidUserGuideViewModel();
    mockNavigationService =
        locator<NavigationService>() as MockNavigationService;
  });

  tearDown(() async {
    await tearDownTest();
  });

  group("AndroidUserGuideViewModel Tests", () {
    test("initialization", () {
      expect(viewModel, isA<AndroidUserGuideViewModel>());
      expect(viewModel.navigationService, isNotNull);
    });

    test("scanFromQr navigates to UserGuideDetailedView", () async {
      when(
        mockNavigationService.navigateTo(
          UserGuideDetailedView.routeName,
        ),
      ).thenAnswer((_) async => true);

      await viewModel.scanFromQr();

      verify(
        mockNavigationService.navigateTo(
          UserGuideDetailedView.routeName,
        ),
      ).called(1);
    });

    test("scanFromGallery navigates to AndroidGalleryUserGuideView", () async {
      when(
        mockNavigationService.navigateTo(
          AndroidGalleryUserGuideView.routeName,
        ),
      ).thenAnswer((_) async => true);

      await viewModel.scanFromGallery();

      verify(
        mockNavigationService.navigateTo(
          AndroidGalleryUserGuideView.routeName,
        ),
      ).called(1);
    });

    test("scanFromQr handles navigation success", () async {
      when(mockNavigationService.navigateTo(any)).thenAnswer((_) async => true);

      await viewModel.scanFromQr();

      verify(
        mockNavigationService.navigateTo(
          UserGuideDetailedView.routeName,
        ),
      ).called(1);
    });

    test("scanFromGallery handles navigation success", () async {
      when(mockNavigationService.navigateTo(any)).thenAnswer((_) async => true);

      await viewModel.scanFromGallery();

      verify(
        mockNavigationService.navigateTo(
          AndroidGalleryUserGuideView.routeName,
        ),
      ).called(1);
    });

    test("multiple scanFromQr calls work correctly", () async {
      when(mockNavigationService.navigateTo(any)).thenAnswer((_) async => true);

      await viewModel.scanFromQr();
      await viewModel.scanFromQr();

      verify(
        mockNavigationService.navigateTo(
          UserGuideDetailedView.routeName,
        ),
      ).called(2);
    });

    test("multiple scanFromGallery calls work correctly", () async {
      when(mockNavigationService.navigateTo(any)).thenAnswer((_) async => true);

      await viewModel.scanFromGallery();
      await viewModel.scanFromGallery();

      verify(
        mockNavigationService.navigateTo(
          AndroidGalleryUserGuideView.routeName,
        ),
      ).called(2);
    });

    test("scanFromQr returns Future<void>", () {
      when(mockNavigationService.navigateTo(any)).thenAnswer((_) async => true);

      final Future<void> result = viewModel.scanFromQr();
      expect(result, isA<Future<void>>());
    });

    test("scanFromGallery returns Future<void>", () {
      when(mockNavigationService.navigateTo(any)).thenAnswer((_) async => true);

      final Future<void> result = viewModel.scanFromGallery();
      expect(result, isA<Future<void>>());
    });

    test("viewModel has access to navigationService", () {
      expect(viewModel.navigationService, isNotNull);
      expect(viewModel.navigationService, equals(mockNavigationService));
    });

    test("scanFromQr navigates to correct route name", () async {
      when(mockNavigationService.navigateTo(any)).thenAnswer((_) async => true);

      await viewModel.scanFromQr();

      verify(
        mockNavigationService.navigateTo(
          argThat(equals("UserGuideDetailedView")),
        ),
      ).called(1);
    });

    test("scanFromGallery navigates to correct route name", () async {
      when(mockNavigationService.navigateTo(any)).thenAnswer((_) async => true);

      await viewModel.scanFromGallery();

      verify(
        mockNavigationService.navigateTo(
          argThat(equals("AndroidGalleryUserGuideView")),
        ),
      ).called(1);
    });

    test("navigation calls are async", () async {
      when(mockNavigationService.navigateTo(any)).thenAnswer((_) async {
        await Future<void>.delayed(const Duration(milliseconds: 50));
        return true;
      });

      await viewModel.scanFromQr();

      verify(mockNavigationService.navigateTo(any)).called(1);
    });

    test("handles concurrent navigation calls", () async {
      when(mockNavigationService.navigateTo(any)).thenAnswer((_) async => true);

      final List<Future<void>> futures = <Future<void>>[
        viewModel.scanFromQr(),
        viewModel.scanFromGallery(),
      ];

      await Future.wait(futures);

      verify(
        mockNavigationService.navigateTo(
          UserGuideDetailedView.routeName,
        ),
      ).called(1);
      verify(
        mockNavigationService.navigateTo(
          AndroidGalleryUserGuideView.routeName,
        ),
      ).called(1);
    });

    test("navigation service calls have no additional arguments", () async {
      when(
        mockNavigationService.navigateTo(
          any,
          arguments: anyNamed("arguments"),
          id: anyNamed("id"),
          preventDuplicates: anyNamed("preventDuplicates"),
          parameters: anyNamed("parameters"),
          transition: anyNamed("transition"),
        ),
      ).thenAnswer((_) async => true);

      await viewModel.scanFromQr();

      verify(
        mockNavigationService.navigateTo(
          UserGuideDetailedView.routeName,
        ),
      ).called(1);

      verifyNever(
        mockNavigationService.navigateTo(
          any,
          arguments: anyNamed("arguments"),
          id: anyNamed("id"),
          preventDuplicates: anyNamed("preventDuplicates"),
          parameters: anyNamed("parameters"),
          transition: anyNamed("transition"),
        ),
      );
    });

    test("viewModel methods complete successfully", () async {
      when(mockNavigationService.navigateTo(any)).thenAnswer((_) async => true);

      await expectLater(viewModel.scanFromQr(), completes);
      await expectLater(viewModel.scanFromGallery(), completes);
    });
  });
}
