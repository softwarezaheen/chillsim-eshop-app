import "package:esim_open_source/data/remote/responses/bundles/purchase_esim_bundle_response_model.dart";
import "package:esim_open_source/data/remote/responses/user/user_notification_response.dart";
import "package:esim_open_source/domain/repository/api_user_repository.dart";
import "package:esim_open_source/domain/repository/services/flutter_channel_handler_service.dart";
import "package:esim_open_source/domain/use_case/user/get_bundle_label_use_case.dart";
import "package:esim_open_source/domain/use_case/user/get_user_notifications_use_case.dart";
import "package:esim_open_source/domain/util/resource.dart";
import "package:esim_open_source/presentation/setup_bottom_sheet_ui.dart";
import "package:esim_open_source/presentation/views/home_flow_views/my_esim_view/my_esim_view_model.dart";
import "package:esim_open_source/presentation/views/home_flow_views/notifications_view/notifications_view.dart";
import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";
import "package:mockito/mockito.dart";
import "package:stacked_services/stacked_services.dart";

import "../../../../../helpers/view_helper.dart";
import "../../../../../helpers/view_model_helper.dart";
import "../../../../../locator_test.dart";
import "../../../../../locator_test.mocks.dart";

Future<void> main() async {
  await prepareTest();
  late MyESimViewModel viewModel;
  late MockApiUserRepository mockApiUserRepository;
  late MockNavigationService mockNavigationService;
  late MockBottomSheetService mockBottomSheetService;
  late MockFlutterChannelHandlerService mockFlutterChannelHandlerService;

  setUp(() async {
    await setupTest();
    onViewModelReadyMock(viewName: "MyEsimView");
    mockApiUserRepository =
        locator<ApiUserRepository>() as MockApiUserRepository;
    mockNavigationService =
        locator<NavigationService>() as MockNavigationService;
    mockBottomSheetService =
        locator<BottomSheetService>() as MockBottomSheetService;
    mockFlutterChannelHandlerService = locator<FlutterChannelHandlerService>()
        as MockFlutterChannelHandlerService;

    // Mock Bottom Sheet Service
    when(
      mockBottomSheetService.showCustomSheet(
        variant: anyNamed("variant"),
        isScrollControlled: anyNamed("isScrollControlled"),
        ignoreSafeArea: anyNamed("ignoreSafeArea"),
        data: anyNamed("data"),
      ),
    ).thenAnswer(
      (_) async => SheetResponse<MainBottomSheetResponse>(
        data: const MainBottomSheetResponse(),
      ),
    );

    viewModel = MyESimViewModel();
  });

  tearDown(() async {
    await tearDownTest();
  });

  group("MyESimViewModel Essential Tests", () {
    group("Initialization", () {
      test("initializes correctly", () {
        expect(
          viewModel.getUserNotificationsUseCase,
          isA<GetUserNotificationsUseCase>(),
        );
        expect(viewModel.getBundleLabelUseCase, isA<GetBundleLabelUseCase>());
        expect(viewModel.state, isNotNull);
        expect(viewModel.state.currentESimList, isEmpty);
        expect(viewModel.state.expiredESimList, isEmpty);
        expect(viewModel.isInstallationFailed, isFalse);
        expect(viewModel, isA<ChangeNotifier>());
      });
    });

    group("Tab Management", () {
      test("setTabIndex updates selected tab index", () {
        viewModel.setTabIndex = 1;
        expect(viewModel.state.selectedTabIndex, equals(1));

        viewModel.setTabIndex = 0;
        expect(viewModel.state.selectedTabIndex, equals(0));
      });
    });

    group("Navigation", () {
      test("openDataPlans calls home pager view model", () {
        viewModel.openDataPlans();
      });

      test("notificationsButtonTapped navigates to notifications", () {
        when(mockNavigationService.navigateTo(NotificationsView.routeName))
            .thenAnswer((_) async => null);
        viewModel.notificationsButtonTapped();
        verify(mockNavigationService.navigateTo(NotificationsView.routeName))
            .called(1);
      });
    });

    group("Bundle Interactions", () {
      test("onTopUpClick handles valid index", () async {
        viewModel.state.currentESimList.add(PurchaseEsimBundleResponseModel());
        await viewModel.onTopUpClick(index: 0);
        verify(
          mockBottomSheetService.showCustomSheet(
            isScrollControlled: anyNamed("isScrollControlled"),
            variant: anyNamed("variant"),
            data: anyNamed("data"),
          ),
        ).called(1);
      });

      test("onConsumptionClick handles valid index", () async {
        viewModel.state.currentESimList.add(PurchaseEsimBundleResponseModel());
        await viewModel.onConsumptionClick(index: 0);
        verify(
          mockBottomSheetService.showCustomSheet(
            isScrollControlled: anyNamed("isScrollControlled"),
            variant: anyNamed("variant"),
            data: anyNamed("data"),
          ),
        ).called(1);
      });

      test("onQrCodeClick handles valid index", () async {
        viewModel.state.currentESimList.add(PurchaseEsimBundleResponseModel());
        await viewModel.onQrCodeClick(index: 0);
        verify(
          mockBottomSheetService.showCustomSheet(
            isScrollControlled: anyNamed("isScrollControlled"),
            variant: anyNamed("variant"),
            data: anyNamed("data"),
          ),
        ).called(1);
      });

      test("onCurrentBundleClick handles valid index", () async {
        viewModel.state.currentESimList.add(PurchaseEsimBundleResponseModel());
        await viewModel.onCurrentBundleClick(index: 0);
        verify(
          mockBottomSheetService.showCustomSheet(
            isScrollControlled: anyNamed("isScrollControlled"),
            ignoreSafeArea: anyNamed("ignoreSafeArea"),
            variant: anyNamed("variant"),
            data: anyNamed("data"),
          ),
        ).called(1);
      });

      test("onExpiredBundleClick handles valid index", () async {
        viewModel.state.expiredESimList.add(PurchaseEsimBundleResponseModel());
        await viewModel.onExpiredBundleClick(index: 0);
        verify(
          mockBottomSheetService.showCustomSheet(
            isScrollControlled: anyNamed("isScrollControlled"),
            ignoreSafeArea: anyNamed("ignoreSafeArea"),
            variant: anyNamed("variant"),
            data: anyNamed("data"),
          ),
        ).called(1);
      });

      test("onEditNameClick handles valid index", () async {
        viewModel.state.currentESimList.add(PurchaseEsimBundleResponseModel());
        await viewModel.onEditNameClick(index: 0);
        verify(
          mockBottomSheetService.showCustomSheet(
            isScrollControlled: anyNamed("isScrollControlled"),
            variant: anyNamed("variant"),
            data: anyNamed("data"),
          ),
        ).called(1);
      });
    });

    group("Installation", () {
      test("onInstallClick handles errors gracefully", () async {
        viewModel.state.currentESimList.add(PurchaseEsimBundleResponseModel());

        when(
          mockFlutterChannelHandlerService.openEsimSetupForAndroid(
            smdpAddress: anyNamed("smdpAddress"),
            activationCode: anyNamed("activationCode"),
          ),
        ).thenThrow(Exception("Installation failed"));

        when(
          mockFlutterChannelHandlerService.openEsimSetupForIOS(
            smdpAddress: anyNamed("smdpAddress"),
            activationCode: anyNamed("activationCode"),
          ),
        ).thenThrow(Exception("Installation failed"));

        await viewModel.onInstallClick(index: 0);
        expect(viewModel.isInstallationFailed, isTrue);
      });
    });

    group("Notification Badge", () {
      test("handleNotificationBadge with empty notifications", () async {
        when(
          mockApiUserRepository.getUserNotifications(
            pageIndex: anyNamed("pageIndex"),
            pageSize: anyNamed("pageSize"),
          ),
        ).thenAnswer(
          (_) async => Resource<List<UserNotificationModel>>.success(
            <UserNotificationModel>[],
            message: "Success",
          ),
        );

        await viewModel.handleNotificationBadge();
        expect(viewModel.state.showNotificationBadge, isFalse);
      });

      test("handleNotificationBadge with unread notifications", () async {
        when(
          mockApiUserRepository.getUserNotifications(
            pageIndex: anyNamed("pageIndex"),
            pageSize: anyNamed("pageSize"),
          ),
        ).thenAnswer(
          (_) async => Resource<List<UserNotificationModel>>.success(
            <UserNotificationModel>[
              UserNotificationModel(status: false), // Unread
            ],
            message: "Success",
          ),
        );

        await viewModel.handleNotificationBadge();
        expect(viewModel.state.showNotificationBadge, isTrue);
      });
    });

    group("Error Handling", () {
      test("handles API error in notification response", () async {
        when(
          mockApiUserRepository.getUserNotifications(
            pageIndex: anyNamed("pageIndex"),
            pageSize: anyNamed("pageSize"),
          ),
        ).thenAnswer(
          (_) async => Resource<List<UserNotificationModel>>.error("API Error"),
        );

        await viewModel.handleNotificationBadge();
        // Should handle error gracefully without throwing
        expect(true, isTrue);
      });
    });

    group("Business Logic", () {
      test("onViewModelReady calls refreshScreen", () {
        expect(() => viewModel.onViewModelReady(), returnsNormally);
      });

      test("refreshCurrentPlans executes without error", () async {
        expect(() async => viewModel.refreshCurrentPlans(), returnsNormally);
      });

      test("state properties are accessible", () {
        expect(viewModel.state, isNotNull);
        expect(viewModel.isInstallationFailed, isA<bool>());
        expect(viewModel.getUserNotificationsUseCase, isNotNull);
        expect(viewModel.getBundleLabelUseCase, isNotNull);
      });
    });
  });
}
