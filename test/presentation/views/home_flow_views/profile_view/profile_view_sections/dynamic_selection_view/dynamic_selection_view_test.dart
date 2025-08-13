import "package:esim_open_source/presentation/enums/bottomsheet_type.dart";
import "package:esim_open_source/presentation/setup_bottom_sheet_ui.dart";
import "package:esim_open_source/presentation/views/home_flow_views/profile_view/profile_view_sections/dynamic_selection_view/dynamic_selection_view.dart";
import "package:esim_open_source/presentation/views/home_flow_views/profile_view/profile_view_sections/dynamic_selection_view/dynamic_selection_view_model.dart";
import "package:esim_open_source/presentation/widgets/common_navigation_title.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";
import "package:mockito/mockito.dart";
import "package:stacked_services/stacked_services.dart";

import "../../../../../../helpers/view_helper.dart";
import "../../../../../../helpers/view_model_helper.dart";
import "../../../../../../locator_test.dart";
import "../../../../../../locator_test.mocks.dart";

Future<void> main() async {
  await prepareTest();
  late MockBottomSheetService mockBottomSheetService;

  group("DynamicSelectionView Widget Tests", () {
    late MockDataSource mockDataSource;

    setUp(() async {
      await setupTest();
      mockBottomSheetService =
          locator<BottomSheetService>() as MockBottomSheetService;
      onViewModelReadyMock(viewName: "DynamicSelectionView");
      mockDataSource = MockDataSource();
    });

    tearDown(() async {
      await tearDownTest();
    });

    testWidgets("renders correctly with initial state",
        (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          DynamicSelectionView(dataSource: mockDataSource),
        ),
      );
      await tester.pump();

      expect(find.byType(DynamicSelectionView), findsOneWidget);
      expect(find.byType(CommonNavigationTitle), findsOneWidget);
      expect(find.byType(ListView), findsOneWidget);
      expect(find.text("Test View"), findsOneWidget);
    });

    testWidgets("displays all data items", (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          DynamicSelectionView(dataSource: mockDataSource),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text("Item 1"), findsOneWidget);
      expect(find.text("Item 2"), findsOneWidget);
      expect(find.text("Item 3"), findsOneWidget);
      expect(find.byType(GestureDetector), findsWidgets);
    });

    testWidgets("handles tap on unselected item", (WidgetTester tester) async {
      final SheetResponse<EmptyBottomSheetResponse> mockResponse =
          SheetResponse<EmptyBottomSheetResponse>(confirmed: true);

      when(
        mockBottomSheetService.showCustomSheet<EmptyBottomSheetResponse,
            ConfirmationSheetRequest>(
          enableDrag: false,
          isScrollControlled: true,
          data: anyNamed("data"),
          variant: BottomSheetType.confirmationSheet,
        ),
      ).thenAnswer((_) async => mockResponse);
      await tester.pumpWidget(
        createTestableWidget(
          DynamicSelectionView(dataSource: mockDataSource),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text("Item 1"));
      await tester.pump();

      // expect(tester.takeException(), isNull);
    });

    testWidgets("handles tap on selected item", (WidgetTester tester) async {
      mockDataSource = MockDataSource(selectedData: "Item 1");

      await tester.pumpWidget(
        createTestableWidget(
          DynamicSelectionView(dataSource: mockDataSource),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text("Item 1"));
      await tester.pump();

      expect(tester.takeException(), isNull);
    });

    test("debugFillProperties method coverage", () {
      final MockDataSource mockDataSource =
          MockDataSource(viewTitle: "Debug Test");
      final DynamicSelectionView widget =
          DynamicSelectionView(dataSource: mockDataSource);

      final DiagnosticPropertiesBuilder builder = DiagnosticPropertiesBuilder();
      widget.debugFillProperties(builder);

      final List<DiagnosticsNode> props = builder.properties;
      final DiagnosticsProperty<DynamicSelectionViewDataSource> dataSourceProp =
          props.firstWhere((DiagnosticsNode p) => p.name == "dataSource")
              as DiagnosticsProperty<DynamicSelectionViewDataSource>;

      expect(dataSourceProp.value, isNotNull);
      expect(dataSourceProp.value, equals(mockDataSource));
    });

    testWidgets("handles empty data list", (WidgetTester tester) async {
      mockDataSource = MockDataSource(data: <String>[]);

      await tester.pumpWidget(
        createTestableWidget(
          DynamicSelectionView(dataSource: mockDataSource),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(ListView), findsOneWidget);
      // Empty list may still have other GestureDetectors in the widget tree
      expect(find.text("Item"), findsNothing);
    });

    testWidgets("handles single item data list", (WidgetTester tester) async {
      mockDataSource = MockDataSource(data: <String>["Single Item"]);

      await tester.pumpWidget(
        createTestableWidget(
          DynamicSelectionView(dataSource: mockDataSource),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text("Single Item"), findsOneWidget);
      expect(find.byType(GestureDetector), findsWidgets);
    });

    testWidgets("selected item styling coverage", (WidgetTester tester) async {
      // Test both selected and unselected states for styling coverage
      mockDataSource = MockDataSource(
        data: <String>["Selected", "Unselected"],
        selectedData: "Selected",
      );

      await tester.pumpWidget(
        createTestableWidget(
          DynamicSelectionView(dataSource: mockDataSource),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text("Selected"), findsOneWidget);
      expect(find.text("Unselected"), findsOneWidget);
      expect(find.byType(DecoratedBox), findsWidgets);
    });

    testWidgets("routeName constant coverage", (WidgetTester tester) async {
      expect(DynamicSelectionView.routeName, equals("DynamicSelectionView"));
    });
  });

  tearDownAll(() async {
    await tearDownAllTest();
  });
}

class MockDataSource implements DynamicSelectionViewDataSource {
  MockDataSource({
    this.viewTitle = "Test View",
    List<String>? data,
    this.dialogTitleText = "Test Dialog Title",
    this.dialogContentText = "Test Dialog Content",
    this.selectedData = "Selected Item",
  }) : _data = data ?? <String>["Item 1", "Item 2", "Item 3"];

  @override
  final String viewTitle;

  List<String> _data;

  @override
  List<String> get data => _data;

  @override
  set data(List<String> newData) {
    _data = newData;
  }

  @override
  final String dialogTitleText;

  @override
  final String dialogContentText;

  @override
  final String selectedData;

  @override
  bool isSelected(int index) => _data[index] == selectedData;

  @override
  Future<List<String>> getSelections() async =>
      Future<List<String>>.value(_data);

  @override
  Future<void> setNewSelection(String code) async {}
}
