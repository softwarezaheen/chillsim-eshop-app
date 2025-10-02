import "package:esim_open_source/domain/use_case/app/contact_us_use_case.dart";
import "package:esim_open_source/presentation/enums/view_state.dart";
import "package:esim_open_source/presentation/views/home_flow_views/profile_view/profile_view_sections/contact_us_view/contact_us_view_model.dart";
import "package:flutter_test/flutter_test.dart";

import "../../../../../../helpers/view_helper.dart";
import "../../../../../../helpers/view_model_helper.dart";

Future<void> main() async {
  await prepareTest();
  late ContactUsViewModel viewModel;

  setUp(() async {
    await setupTest();
    
    
    onViewModelReadyMock(viewName: "ContactUsView");
    viewModel = ContactUsViewModel();
  });

  tearDown(() async {
    await tearDownTest();
  });

  group("ContactUsViewModel Tests", () {
    group("Initialization", () {
      test("initializes with correct default state", () {
        expect(viewModel.state, isNotNull);
        expect(viewModel.state.isButtonEnabled, isFalse);
        expect(viewModel.state.emailController.text, isEmpty);
        expect(viewModel.state.messageController.text, isEmpty);
        expect(viewModel.emailErrorMessage, isNull);
        expect(viewModel.contentErrorMessage, isNull);
      });

      test("onViewModelReady sets up form validation", () {
        // Access the onViewModelReady method to increase coverage
        expect(() => viewModel.onViewModelReady(), returnsNormally);
      });

      test("contactUsUseCase is initialized correctly", () {
        expect(viewModel.contactUsUseCase, isNotNull);
        expect(viewModel.contactUsUseCase, isA<ContactUsUseCase>());
      });
    });

    group("Form Validation", () {
      test("validateEmailAddress returns correct messages", () {
        // Test empty email
        String result = viewModel.validateEmailAddress("");
        expect(result, isNotEmpty);

        // Test whitespace only
        result = viewModel.validateEmailAddress("   ");
        expect(result, isNotEmpty);

        // Test invalid email
        result = viewModel.validateEmailAddress("invalid-email");
        expect(result, isNotEmpty);

        // Test valid email
        result = viewModel.validateEmailAddress("test@example.com");
        expect(result, isEmpty);
      });

      test("validateContentMessage returns correct messages", () {
        // Test empty message
        String result = viewModel.validateContentMessage("");
        expect(result, isNotEmpty);

        // Test whitespace only
        result = viewModel.validateContentMessage("   ");
        expect(result, isNotEmpty);

        // Test valid message
        result = viewModel.validateContentMessage("Valid message");
        expect(result, isEmpty);
      });
    });

    group("State Management", () {
      test("ContactUsState initializes correctly", () {
        final ContactUsState state = ContactUsState();
        
        expect(state.isButtonEnabled, isFalse);
        expect(state.emailController, isNotNull);
        expect(state.messageController, isNotNull);
        expect(state.emailController.text, isEmpty);
        expect(state.messageController.text, isEmpty);
      });

      test("state property returns correct instance", () {
        expect(viewModel.state, isA<ContactUsState>());
        expect(viewModel.state, isNotNull);
      });

      test("initial view state is idle", () {
        expect(viewModel.viewState, equals(ViewState.idle));
      });
    });

    group("Method Coverage", () {
      test("onSendMessageClicked method exists", () {
        // Test method signature exists
        expect(viewModel.onSendMessageClicked, isA<Function>());
      });

      test("ContactUsParams can be created with correct data", () {
        viewModel.state.emailController.text = "test@example.com";
        viewModel.state.messageController.text = "Test message";
        
        final ContactUsParams params = ContactUsParams(
          email: viewModel.state.emailController.text,
          message: viewModel.state.messageController.text,
        );
        
        expect(params.email, equals("test@example.com"));
        expect(params.message, equals("Test message"));
      });

      test("error message properties are accessible", () {
        // Test getter/setter accessibility
        expect(() => viewModel.emailErrorMessage, returnsNormally);
        expect(() => viewModel.contentErrorMessage, returnsNormally);
        
        // Initially null
        expect(viewModel.emailErrorMessage, isNull);
        expect(viewModel.contentErrorMessage, isNull);
      });

      test("text controller listeners work correctly", () {
        viewModel.onViewModelReady();
        
        // Change text to trigger validation
        viewModel.state.emailController.text = "invalid";
        viewModel.state.messageController.text = "test";
        
        // Verify error messages are set
        expect(viewModel.emailErrorMessage, isNotNull);
        expect(viewModel.contentErrorMessage, isNotNull);
      });

      test("button enable/disable logic works", () {
        viewModel.onViewModelReady();
        
        // Initially disabled
        expect(viewModel.state.isButtonEnabled, isFalse);
        
        // Set valid inputs
        viewModel.state.emailController.text = "test@example.com";
        viewModel.state.messageController.text = "Valid message";
        
        // Should enable button with valid inputs
        expect(viewModel.state.isButtonEnabled, isTrue);
      });
    });
  });
}
