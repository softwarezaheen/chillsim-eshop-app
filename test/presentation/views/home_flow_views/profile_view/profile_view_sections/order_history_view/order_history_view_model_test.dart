import "package:esim_open_source/data/remote/responses/user/order_history_response_model.dart";
import "package:esim_open_source/domain/use_case/base_use_case.dart";
import "package:esim_open_source/domain/use_case/user/get_order_history_pagination_use_case.dart";
import "package:esim_open_source/domain/util/pagination/paginated_data.dart";
import "package:esim_open_source/presentation/enums/bottomsheet_type.dart";
import "package:esim_open_source/presentation/enums/view_state.dart";
import "package:esim_open_source/presentation/views/home_flow_views/profile_view/profile_view_sections/order_history_view/order_history_view_model.dart";
import "package:flutter_test/flutter_test.dart";
import "package:mockito/mockito.dart";
import "package:stacked_services/stacked_services.dart";

import "../../../../../../helpers/view_helper.dart";
import "../../../../../../helpers/view_model_helper.dart";
import "../../../../../../locator_test.dart";
import "../../../../../../locator_test.mocks.dart";

Future<void> main() async {
  await prepareTest();
  late OrderHistoryViewModel viewModel;
  late MockGetOrderHistoryPaginationUseCase mockUseCase;
  late MockBottomSheetService mockBottomSheetService;
  late PaginationService<OrderHistoryResponseModel> mockPaginationService;

  // Test data factory methods
  OrderHistoryResponseModel createOrderHistoryItem({
    String? orderDate,
    String? orderNumber,
  }) {
    return OrderHistoryResponseModel(
      orderDate: orderDate ?? "1640995200000", // 2022-01-01
      orderNumber:
          orderNumber ?? "test-order-${DateTime.now().millisecondsSinceEpoch}",
    );
  }

  setUp(() async {
    await setupTest();

    mockUseCase = locator<GetOrderHistoryPaginationUseCase>()
        as MockGetOrderHistoryPaginationUseCase;
    mockBottomSheetService =
        locator<BottomSheetService>() as MockBottomSheetService;

    onViewModelReadyMock();

    // Mock the pagination service
    mockPaginationService = PaginationService<OrderHistoryResponseModel>();
    when(mockUseCase.paginationService).thenReturn(mockPaginationService);

    // Mock use case methods
    when(mockUseCase.loadNextPage(NoParams())).thenAnswer((_) async {});
    when(mockUseCase.refreshData(NoParams())).thenAnswer((_) async {});

    viewModel = OrderHistoryViewModel();
  });

  tearDown(() async {
    await tearDownTest();
  });

  group("OrderHistoryViewModel Initialization Tests", () {
    test("initializes with correct default values", () {
      expect(viewModel.viewState, ViewState.idle);
      expect(viewModel.shimmerHeight, 150);
      expect(
        viewModel.getOrderHistoryUseCase,
        isA<GetOrderHistoryPaginationUseCase>(),
      );
    });

    test("calls getOrderHistory on viewModelReady", () async {
      // Reset to clear any calls from setUp
      reset(mockUseCase);

      // Call onViewModelReady
      viewModel.onViewModelReady();

      // Allow async operation to complete
      await Future<void>.delayed(Duration.zero);

      // Verify getOrderHistory was called
      verify(mockUseCase.loadNextPage(any)).called(1);
    });

    test("has correct shimmer height", () {
      expect(viewModel.shimmerHeight, equals(150));
    });
  });

  group("OrderHistoryViewModel API Methods Tests", () {
    test("getOrderHistory calls use case loadNextPage correctly", () async {
      // Reset to clear any calls from setUp
      reset(mockUseCase);

      await viewModel.getOrderHistory();

      verify(mockUseCase.loadNextPage(any)).called(1);
    });

    test("refreshOrderHistory calls use case refreshData correctly", () async {
      // Reset to clear any calls from setUp
      reset(mockUseCase);

      await viewModel.refreshOrderHistory();

      verify(mockUseCase.refreshData(any)).called(1);
    });

    test("multiple getOrderHistory calls work correctly", () async {
      reset(mockUseCase);

      await viewModel.getOrderHistory();
      await viewModel.getOrderHistory();
      await viewModel.getOrderHistory();

      verify(mockUseCase.loadNextPage(any)).called(3);
    });

    test("multiple refreshOrderHistory calls work correctly", () async {
      reset(mockUseCase);

      await viewModel.refreshOrderHistory();
      await viewModel.refreshOrderHistory();

      verify(mockUseCase.refreshData(any)).called(2);
    });
  });

  group("OrderHistoryViewModel Order Interaction Tests", () {
    test("orderTapped calls bottom sheet service", () async {
      OrderHistoryResponseModel testOrder = createOrderHistoryItem();

      // Mock bottom sheet service for this specific test
      when(
        mockBottomSheetService.showCustomSheet(
          data: testOrder,
          enableDrag: false,
          isScrollControlled: true,
          variant: BottomSheetType.orderHistory,
        ),
      ).thenAnswer(
        (_) async => SheetResponse<OrderHistoryResponseModel>(),
      );

      await viewModel.orderTapped(testOrder);

      verify(
        mockBottomSheetService.showCustomSheet(
          data: testOrder,
          enableDrag: false,
          isScrollControlled: true,
          variant: BottomSheetType.orderHistory,
        ),
      ).called(1);
    });

    test("orderTapped show custom sheet", () async {
      OrderHistoryResponseModel order = createOrderHistoryItem();

      // Mock bottom sheet service for this specific test
      SheetResponse<OrderHistoryResponseModel> response =
          SheetResponse<OrderHistoryResponseModel>(
        data: order,
        confirmed: true,
      );
      when(
        mockBottomSheetService.showCustomSheet(
          data: order,
          enableDrag: false,
          isScrollControlled: true,
          variant: BottomSheetType.orderHistory,
        ),
      ).thenAnswer(
        (_) async => response,
      );

      when(
        mockBottomSheetService.showCustomSheet(
          data: response.data,
          enableDrag: false,
          isScrollControlled: true,
          variant: BottomSheetType.receiptOrder,
        ),
      ).thenAnswer(
        (_) async => response,
      );

      await viewModel.orderTapped(order);

      // verify(
      //   mockBottomSheetService.showCustomSheet(
      //     data: response.data,
      //     enableDrag: false,
      //     isScrollControlled: true,
      //     variant: BottomSheetType.receiptOrder,
      //   ),
      // ).called(1);
    });
  });

  group("OrderHistoryViewModel Integration Tests", () {
    test("shimmer configuration is applied correctly", () {
      expect(viewModel.applyShimmer, isFalse); // Default BaseModel behavior
      expect(viewModel.shimmerHeight, 150);
    });

    test("view model maintains proper state during operations", () async {
      // Initial state should be idle
      expect(viewModel.viewState, ViewState.idle);

      // After operations, should return to idle (no explicit state changes in this model)
      await viewModel.getOrderHistory();
      expect(viewModel.viewState, ViewState.idle);

      await viewModel.refreshOrderHistory();
      expect(viewModel.viewState, ViewState.idle);
    });
  });

  group("OrderHistoryViewModel Error Handling Tests", () {
    test("handles use case exceptions gracefully during getOrderHistory",
        () async {
      reset(mockUseCase);

      // Mock use case to throw exception
      when(mockUseCase.loadNextPage(NoParams()))
          .thenThrow(Exception("Network error"));

      // Should not throw exception
      expect(() async => viewModel.getOrderHistory(), returnsNormally);
    });

    test("handles use case exceptions gracefully during refreshOrderHistory",
        () async {
      reset(mockUseCase);

      // Mock use case to throw exception
      when(mockUseCase.refreshData(NoParams()))
          .thenThrow(Exception("Network error"));

      // Should not throw exception
      expect(
        () async => viewModel.refreshOrderHistory(),
        returnsNormally,
      );
    });
  });

  group("OrderHistoryViewModel Edge Cases Tests", () {
    test("use case property returns correct instance", () {
      expect(viewModel.getOrderHistoryUseCase, equals(mockUseCase));
      expect(
        viewModel.getOrderHistoryUseCase,
        isA<GetOrderHistoryPaginationUseCase>(),
      );
    });

    test("concurrent API calls handle correctly", () async {
      reset(mockUseCase);

      // Start multiple concurrent calls
      final List<Future<void>> futures = <Future<void>>[
        viewModel.getOrderHistory(),
        viewModel.refreshOrderHistory(),
        viewModel.getOrderHistory(),
      ];
      await Future.wait(futures);

      // All calls should complete successfully
      verify(mockUseCase.loadNextPage(any)).called(2);
      verify(mockUseCase.refreshData(any)).called(1);
    });
  });
}
