import "package:esim_open_source/domain/repository/services/local_storage_service.dart";
import "package:esim_open_source/presentation/shared/in_app_redirection_heper.dart";
import "package:esim_open_source/presentation/views/pre_sign_in/verify_login_view/verify_login_view.dart";
import "package:esim_open_source/presentation/views/pre_sign_in/verify_login_view/verify_login_view_model.dart";
import "package:esim_open_source/presentation/widgets/main_button.dart";
import "package:esim_open_source/presentation/widgets/otp_text_field.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_test/flutter_test.dart";
import "package:mockito/mockito.dart";
import "package:stacked_services/stacked_services.dart";

import "../../../../helpers/haptic_helper.dart";
import "../../../../helpers/view_helper.dart";
import "../../../../helpers/view_model_helper.dart";
import "../../../../locator_test.dart";
import "../../../../locator_test.mocks.dart";

Future<void> main() async {
  await prepareTest();

  // Mock platform channels for plugins
  TestWidgetsFlutterBinding.ensureInitialized();
  const MethodChannel toastChannel =
      MethodChannel("PonnamKarthik/fluttertoast");

  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(
    toastChannel,
    (MethodCall methodCall) async {
      if (methodCall.method == "showToast") {
        return null; // Mock successful toast
      }
      return null;
    },
  );

  late NavigationService mockNavigationService;
  late MockLocalStorageService mockLocalStorageService;

  setUp(() async {
    await setupTest();

    // Initialize haptic feedback mocking
    HapticHelperTest.implementHaptic();
    mockNavigationService =
        locator<NavigationService>() as MockNavigationService;
    mockLocalStorageService =
        locator<LocalStorageService>() as MockLocalStorageService;

    onViewModelReadyMock(viewName: "VerifyLoginView");
    when(mockNavigationService.back()).thenReturn(true);
    when(
      mockNavigationService.pushNamedAndRemoveUntil(
        "HomePager",
        predicate: anyNamed("predicate"),
        arguments: anyNamed("arguments"),
        id: anyNamed("id"),
      ),
    ).thenAnswer((_) async => true);
    when(mockLocalStorageService.getString(any)).thenReturn("test_utm");

    // Create VerifyLoginViewModel instance for testing
    locator<VerifyLoginViewModel>().username = "test@example.com";
  });

  testWidgets("renders correctly with state error not empty",
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(800, 1200);
    tester.view.devicePixelRatio = 1.0;
    // when(viewModel.errorMessage).thenReturn("Some error");
    await tester.pumpWidget(
      createTestableWidget(
        const VerifyLoginView(
          username: "test@example.com",
        ),
      ),
    );

    await tester.pumpAndSettle();
  });

  testWidgets("renders correctly with initial state",
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(800, 1200);
    tester.view.devicePixelRatio = 1.0;

    await tester.pumpWidget(
      createTestableWidget(
        const VerifyLoginView(
          username: "test@example.com",
        ),
      ),
    );
    await tester.pumpAndSettle(const Duration(milliseconds: 500));

    expect(find.byType(VerifyLoginView), findsOneWidget);
    expect(find.byType(OtpTextField), findsOneWidget);
    expect(find.byType(MainButton), findsOneWidget);
    expect(find.byType(Image), findsOneWidget); // Back button icon
  });

  testWidgets("displays back button", (WidgetTester tester) async {
    tester.view.physicalSize = const Size(800, 1200);
    tester.view.devicePixelRatio = 1.0;

    await tester.pumpWidget(
      createTestableWidget(
        const VerifyLoginView(
          username: "test@example.com",
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(GestureDetector), findsAtLeastNWidgets(1));
    expect(find.byType(Image), findsOneWidget);
  });

  testWidgets("displays OTP input field and verify button",
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(800, 1200);
    tester.view.devicePixelRatio = 1.0;

    await tester.pumpWidget(
      createTestableWidget(
        const VerifyLoginView(
          username: "test@example.com",
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(OtpTextField), findsOneWidget);
    expect(find.byType(MainButton), findsOneWidget);
  });

  testWidgets("displays title and content text", (WidgetTester tester) async {
    tester.view.physicalSize = const Size(800, 1200);
    tester.view.devicePixelRatio = 1.0;

    await tester.pumpWidget(
      createTestableWidget(
        const VerifyLoginView(
          username: "test@example.com",
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(Text), findsAtLeastNWidgets(2));
  });

  testWidgets("renders with redirection parameter",
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(800, 1200);
    tester.view.devicePixelRatio = 1.0;

    final InAppRedirection testRedirection = InAppRedirection.cashback();

    await tester.pumpWidget(
      createTestableWidget(
        VerifyLoginView(
          username: "test@example.com",
          redirection: testRedirection,
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(VerifyLoginView), findsOneWidget);
  });

  testWidgets("pressing back button triggers navigation back",
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(800, 1200);
    tester.view.devicePixelRatio = 1.0;

    await tester.pumpWidget(
      createTestableWidget(
        const VerifyLoginView(
          username: "test@example.com",
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Find and tap the back button
    final Finder backButton = find.byType(GestureDetector).first;
    await tester.tap(backButton);
    await tester.pumpAndSettle();

    // Verify that the navigation service was called
    verify(mockNavigationService.back()).called(1);
  });

  testWidgets("verify button is disabled initially",
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(800, 1200);
    tester.view.devicePixelRatio = 1.0;

    await tester.pumpWidget(
      createTestableWidget(
        const VerifyLoginView(
          username: "test@example.com",
        ),
      ),
    );
    await tester.pumpAndSettle();

    final MainButton mainButton =
        tester.widget<MainButton>(find.byType(MainButton));
    expect(mainButton.isEnabled, false);
  });

  testWidgets("displays resend code text", (WidgetTester tester) async {
    tester.view.physicalSize = const Size(800, 1200);
    tester.view.devicePixelRatio = 1.0;

    await tester.pumpWidget(
      createTestableWidget(
        const VerifyLoginView(
          username: "test@example.com",
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Look for RichText widget that contains the resend code text
    expect(find.byType(RichText), findsAtLeastNWidgets(1));
  });

  testWidgets("debug properties", (WidgetTester tester) async {
    final InAppRedirection redirection = InAppRedirection.cashback();
    final VerifyLoginView widget = VerifyLoginView(
      username: "test@example.com",
      redirection: redirection,
    );

    final DiagnosticPropertiesBuilder builder = DiagnosticPropertiesBuilder();
    widget.debugFillProperties(builder);

    final List<DiagnosticsNode> props = builder.properties;

    final StringProperty usernameProp =
        props.firstWhere((DiagnosticsNode p) => p.name == "emailAddress")
            as StringProperty;
    final DiagnosticsProperty<InAppRedirection?> redirectionProp =
        props.firstWhere((DiagnosticsNode p) => p.name == "redirection")
            as DiagnosticsProperty<InAppRedirection?>;

    expect(usernameProp.value, "test@example.com");
    expect(redirectionProp.value, isNotNull);
  });

  tearDown(() async {
    await tearDownTest();
  });

  tearDownAll(() async {
    await tearDownAllTest();
  });
}
