import "package:esim_open_source/data/remote/responses/bundles/bundle_response_model.dart";
import "package:esim_open_source/data/remote/responses/user/order_history_response_model.dart";
import "package:esim_open_source/domain/use_case/base_use_case.dart";
import "package:esim_open_source/domain/use_case/user/get_order_history_pagination_use_case.dart";
import "package:esim_open_source/domain/util/pagination/paginated_data.dart";
import "package:esim_open_source/presentation/enums/bottomsheet_type.dart";
import "package:esim_open_source/presentation/views/home_flow_views/profile_view/profile_view_sections/order_history_view/order_history_view.dart";
import "package:esim_open_source/presentation/widgets/common_navigation_title.dart";
import "package:esim_open_source/presentation/widgets/empty_paginated_state_list_view.dart";
import "package:esim_open_source/presentation/widgets/empty_state_widget.dart";
import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";
import "package:mockito/mockito.dart";
import "package:stacked_services/stacked_services.dart";

import "../../../../../../helpers/view_helper.dart";
import "../../../../../../helpers/view_model_helper.dart";
import "../../../../../../locator_test.dart";

Future<void> main() async {
  await prepareTest();
  late GetOrderHistoryPaginationUseCase mockUseCase;
  late PaginationService<OrderHistoryResponseModel> mockPaginationService;
  late BottomSheetService mockBottomSheetService;

  // Test data factory methods
  OrderHistoryResponseModel createOrderHistoryItem({
    String? orderDate,
    String? orderNumber,
    bool withBundleDetails = false,
  }) {
    return OrderHistoryResponseModel(
      orderDate: orderDate ?? "1640995200000", // 2022-01-01
      orderNumber:
          orderNumber ?? "test-order-${DateTime.now().millisecondsSinceEpoch}",
      bundleDetails: withBundleDetails
          ? BundleResponseModel.getMockGlobalBundles().first
          : null,
    );
  }

  List<OrderHistoryResponseModel> createOrderHistoryList({
    int count = 3,
    bool withBundleDetails = false,
  }) {
    return List<OrderHistoryResponseModel>.generate(
      count,
      (int index) => createOrderHistoryItem(
        orderNumber: "order-${index + 1}",
        orderDate: "${1640995200000 + (index * 86400000)}", // Add days
        withBundleDetails: withBundleDetails,
      ),
    );
  }

  setUp(() async {
    await setupTest();
    mockUseCase = locator<GetOrderHistoryPaginationUseCase>();
    mockBottomSheetService = locator<BottomSheetService>();

    onViewModelReadyMock(viewName: OrderHistoryView.routeName);

    // Mock the pagination service
    mockPaginationService = PaginationService<OrderHistoryResponseModel>();
    when(mockUseCase.paginationService).thenReturn(mockPaginationService);

    // Mock use case methods
    when(mockUseCase.loadNextPage(NoParams())).thenAnswer((_) async {});
    when(mockUseCase.refreshData(NoParams())).thenAnswer((_) async {});
  });

  tearDown(() async {
    await tearDownTest();
  });

  group("OrderHistoryView Widget Tests", () {
    testWidgets("renders basic structure with navigation title",
        (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const OrderHistoryView(),
        ),
      );
      await tester.pump();

      // Verify navigation title is present
      expect(find.byType(CommonNavigationTitle), findsOneWidget);

      // Verify main structure is present
      expect(find.byType(Column), findsWidgets);
      expect(find.byType(Expanded), findsOneWidget);
    });

    testWidgets("renders empty paginated list view component",
        (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const OrderHistoryView(),
        ),
      );
      await tester.pump();

      // Verify EmptyPaginatedStateListView is present
      expect(
          find.byType(EmptyPaginatedStateListView<OrderHistoryResponseModel>),
          findsOneWidget,);
    });

    testWidgets("renders empty state widget when no orders",
        (WidgetTester tester) async {
      // Set up empty state in pagination service
      mockPaginationService.changeValue(
        paginatedData: PaginatedData<OrderHistoryResponseModel>(
          items: <OrderHistoryResponseModel>[],
          hasMore: false,
        ),
      );

      await tester.pumpWidget(
        createTestableWidget(
          const OrderHistoryView(),
        ),
      );
      await tester.pump();

      // Should show empty state
      expect(find.byType(EmptyStateWidget), findsOneWidget);
    });

    testWidgets("renders shimmer loading state correctly",
        (WidgetTester tester) async {
      // Set up loading state
      mockPaginationService.changeValue(
        paginatedData: PaginatedData<OrderHistoryResponseModel>(
          items: <OrderHistoryResponseModel>[],
          isLoading: true,
        ),
      );

      await tester.pumpWidget(
        createTestableWidget(
          const OrderHistoryView(),
        ),
      );
      await tester.pump();

      // Should show loading shimmer
      expect(find.byType(ListView), findsWidgets);
    });

    testWidgets("displays correct shimmer structure during loading",
        (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const OrderHistoryView(),
        ),
      );
      await tester.pump();

      // The shimmer method creates a ListView with SizedBox items
      final OrderHistoryView orderHistoryView = const OrderHistoryView();
      final Widget shimmerWidget = orderHistoryView.getShimmerData();

      expect(shimmerWidget, isA<ListView>());
    });

    testWidgets("renders order history items with bundleOrderHistoryView",
        (WidgetTester tester) async {
      final List<OrderHistoryResponseModel> testOrders =
          createOrderHistoryList(count: 1, withBundleDetails: true);

      // Set up data state with orders
      mockPaginationService.changeValue(
        paginatedData: PaginatedData<OrderHistoryResponseModel>(
          items: testOrders,
          hasMore: false,
        ),
      );

      await tester.pumpWidget(
        createTestableWidget(
          const OrderHistoryView(),
        ),
      );
      await tester.pump();

      // Should render the bundleOrderHistoryView function
      expect(find.byType(DecoratedBox), findsWidgets);
      expect(find.byType(GestureDetector), findsWidgets);

      when(
        mockBottomSheetService.showCustomSheet(
          data: testOrders[0],
          enableDrag: false,
          isScrollControlled: true,
          variant: BottomSheetType.orderHistory,
        ),
      ).thenAnswer(
        (_) async => SheetResponse<OrderHistoryResponseModel>(
          
        ),
      );
      Finder gesture = find.byType(GestureDetector).at(1);
      await tester.tap(gesture);
    });
  });
}
