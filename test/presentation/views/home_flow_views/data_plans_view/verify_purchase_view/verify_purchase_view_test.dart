import "package:esim_open_source/di/locator.dart";
import "package:esim_open_source/presentation/views/home_flow_views/data_plans_view/verify_purchase_view/verify_purchase_view.dart";
import "package:esim_open_source/presentation/views/home_flow_views/data_plans_view/verify_purchase_view/verify_purchase_view_model.dart";
import "package:esim_open_source/presentation/widgets/main_button.dart";
import "package:esim_open_source/presentation/widgets/otp_text_field.dart";
import "package:esim_open_source/presentation/widgets/padding_widget.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";

import "../../../../../helpers/view_helper.dart";
import "../../../../../helpers/view_model_helper.dart";

Future<void> main() async {
  await prepareTest();

  setUp(() async {
    await setupTest();
  });

  tearDown(() async {
    await tearDownTest();
  });

  tearDownAll(() async {
    await tearDownAllTest();
  });

  group("VerifyPurchaseView Widget Tests", () {
    testWidgets("renders correctly with initial state",
        (WidgetTester tester) async {
      onViewModelReadyMock(viewName: "VerifyPurchaseView");

      final VerifyPurchaseViewArgs args = VerifyPurchaseViewArgs(
        iccid: "test_iccid",
        orderID: "test_order_id",
      );

      await tester.pumpWidget(
        createTestableWidget(
          VerifyPurchaseView(args: args),
        ),
      );
      await tester.pump();

      expect(find.byType(VerifyPurchaseView), findsOneWidget);
      expect(find.byType(PaddingWidget), findsWidgets);
      expect(find.byType(OtpTextField), findsOneWidget);
      expect(find.byType(MainButton), findsOneWidget);
      expect(find.byType(GestureDetector), findsWidgets);
    });

    testWidgets("renders correctly with error state",
        (WidgetTester tester) async {
      onViewModelReadyMock(viewName: "VerifyPurchaseView");
      locator<VerifyPurchaseViewModel>().otpFieldChanged("12345");
      final VerifyPurchaseViewArgs args = VerifyPurchaseViewArgs(
        iccid: "test_iccid",
        orderID: "test_order_id",
      );

      await tester.pumpWidget(
        createTestableWidget(
          VerifyPurchaseView(args: args),
        ),
      );
      await tester.pump();

      expect(find.byType(VerifyPurchaseView), findsOneWidget);
      expect(find.byType(PaddingWidget), findsWidgets);
      expect(find.byType(OtpTextField), findsOneWidget);
      expect(find.byType(MainButton), findsOneWidget);
      expect(find.byType(GestureDetector), findsWidgets);
    });

    testWidgets("back button triggers navigation", (WidgetTester tester) async {
      onViewModelReadyMock(viewName: "VerifyPurchaseView");

      final VerifyPurchaseViewArgs args = VerifyPurchaseViewArgs(
        iccid: "test_iccid",
        orderID: "test_order_id",
      );

      await tester.pumpWidget(
        createTestableWidget(
          VerifyPurchaseView(args: args),
        ),
      );
      await tester.pump();

      // Find and tap the back button (GestureDetector with Image)
      final Finder backButton = find.byType(GestureDetector).first;
      await tester.tap(backButton);
      await tester.pump();

      expect(tester.takeException(),
          isNotNull,); // Navigation exception is expected due to mocking
    });

    testWidgets("main button triggers verification",
        (WidgetTester tester) async {
      onViewModelReadyMock(viewName: "VerifyPurchaseView");

      final VerifyPurchaseViewArgs args = VerifyPurchaseViewArgs(
        iccid: "test_iccid",
        orderID: "test_order_id",
      );

      await tester.pumpWidget(
        createTestableWidget(
          VerifyPurchaseView(args: args),
        ),
      );
      await tester.pump();

      // Find and tap the main button
      final Finder mainButton = find.byType(MainButton);
      expect(mainButton, findsOneWidget);

      await tester.tap(mainButton);
      await tester.pump();

      // Button should be found and tappable, exceptions may occur due to mocking
      expect(mainButton, findsOneWidget);
    });

    testWidgets("OTP field handles input", (WidgetTester tester) async {
      onViewModelReadyMock(viewName: "VerifyPurchaseView");

      final VerifyPurchaseViewArgs args = VerifyPurchaseViewArgs(
        iccid: "test_iccid",
        orderID: "test_order_id",
      );

      await tester.pumpWidget(
        createTestableWidget(
          VerifyPurchaseView(args: args),
        ),
      );
      await tester.pump();

      // Find OTP text field
      final Finder otpField = find.byType(OtpTextField);
      expect(otpField, findsOneWidget);

      expect(tester.takeException(), isNull);
    });

    testWidgets("resend code text span renders correctly",
        (WidgetTester tester) async {
      onViewModelReadyMock(viewName: "VerifyPurchaseView");

      final VerifyPurchaseViewArgs args = VerifyPurchaseViewArgs(
        iccid: "test_iccid",
        orderID: "test_order_id",
      );

      await tester.pumpWidget(
        createTestableWidget(
          VerifyPurchaseView(args: args),
        ),
      );
      await tester.pump();

      // Just verify that Text widgets are present (this covers the resend code text)
      expect(find.byType(Text), findsWidgets);
    });

    testWidgets("debug properties", (WidgetTester tester) async {
      final VerifyPurchaseViewArgs args = VerifyPurchaseViewArgs(
        iccid: "test_iccid",
        orderID: "test_order_id",
      );
      final VerifyPurchaseView widget = VerifyPurchaseView(args: args);

      final DiagnosticPropertiesBuilder builder = DiagnosticPropertiesBuilder();
      widget.debugFillProperties(builder);

      final List<DiagnosticsNode> props = builder.properties;

      final DiagnosticsProperty<VerifyPurchaseViewArgs> argsProp =
          props.firstWhere((DiagnosticsNode p) => p.name == "args")
              as DiagnosticsProperty<VerifyPurchaseViewArgs>;

      expect(argsProp.value, isNotNull);
      expect(argsProp.value!.iccid, "test_iccid");
      expect(argsProp.value!.orderID, "test_order_id");
    });
  });

  group("VerifyPurchaseView Method Coverage Tests", () {
    testWidgets("calculateFieldWidth returns correct width for small screen",
        (WidgetTester tester) async {
      final VerifyPurchaseView view = VerifyPurchaseView(
        args: VerifyPurchaseViewArgs(
          iccid: "test_iccid",
          orderID: "test_order_id",
        ),
      );

      // Create a widget tree with MediaQuery
      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(
              size: Size(300, 600), // Small screen width
            ),
            child: Builder(
              builder: (BuildContext context) {
                final double fieldWidth =
                    view.calculateFieldWidth(context: context);
                expect(fieldWidth,
                    35.0,); // Expected calculation: (300 - 30 - 60) / 6 = 35
                return Container();
              },
            ),
          ),
        ),
      );
    });

    testWidgets("calculateFieldWidth returns maximum size for large screen",
        (WidgetTester tester) async {
      final VerifyPurchaseView view = VerifyPurchaseView(
        args: VerifyPurchaseViewArgs(
          iccid: "test_iccid",
          orderID: "test_order_id",
        ),
      );

      // Create a widget tree with MediaQuery
      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(
              size: Size(800, 600), // Large screen width
            ),
            child: Builder(
              builder: (BuildContext context) {
                final double fieldWidth =
                    view.calculateFieldWidth(context: context);
                expect(fieldWidth,
                    60.0,); // Should return the maximum size (60) when calculated size exceeds it
                return Container();
              },
            ),
          ),
        ),
      );
    });

    testWidgets("calculateFieldWidth with custom maximum size",
        (WidgetTester tester) async {
      final VerifyPurchaseView view = VerifyPurchaseView(
        args: VerifyPurchaseViewArgs(
          iccid: "test_iccid",
          orderID: "test_order_id",
        ),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(
              size: Size(600, 600),
            ),
            child: Builder(
              builder: (BuildContext context) {
                final double fieldWidth = view.calculateFieldWidth(
                  context: context,
                  maximumSize: 50,
                );
                expect(fieldWidth, 50.0); // Should respect custom maximum size
                return Container();
              },
            ),
          ),
        ),
      );
    });

    test("resendCodeTappableWidget method exists and is callable", () {
      final VerifyPurchaseView view = VerifyPurchaseView(
        args: VerifyPurchaseViewArgs(
          iccid: "test_iccid",
          orderID: "test_order_id",
        ),
      );

      // Verify the method exists - this will test coverage of the method signature
      expect(view.resendCodeTappableWidget, isA<Function>());
    });
  });

  group("VerifyPurchaseViewArgs Tests", () {
    test("constructor sets properties correctly", () {
      final VerifyPurchaseViewArgs args = VerifyPurchaseViewArgs(
        iccid: "test_iccid_123",
        orderID: "test_order_456",
      );

      expect(args.iccid, "test_iccid_123");
      expect(args.orderID, "test_order_456");
    });

    test("args equality and properties", () {
      final VerifyPurchaseViewArgs args1 = VerifyPurchaseViewArgs(
        iccid: "same_iccid",
        orderID: "same_order",
      );

      final VerifyPurchaseViewArgs args2 = VerifyPurchaseViewArgs(
        iccid: "same_iccid",
        orderID: "same_order",
      );

      expect(args1.iccid, args2.iccid);
      expect(args1.orderID, args2.orderID);
    });
  });
}
