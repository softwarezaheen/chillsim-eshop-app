// continue_with_email_view_test.dart

import "package:esim_open_source/presentation/enums/view_state.dart";
import "package:esim_open_source/presentation/shared/in_app_redirection_heper.dart";
import "package:esim_open_source/presentation/views/pre_sign_in/continue_with_email_view/continue_with_email_view.dart";
import "package:esim_open_source/presentation/views/pre_sign_in/continue_with_email_view/continue_with_email_view_model.dart";
import "package:esim_open_source/presentation/widgets/main_button.dart";
import "package:esim_open_source/presentation/widgets/main_input_field.dart";
import "package:flutter/cupertino.dart";
import "package:flutter/foundation.dart";
import "package:flutter_test/flutter_test.dart";
import "package:mockito/mockito.dart";

import "../../../../helpers/view_helper.dart";
import "../../../../locator_test.dart";

Future<void> main() async {
  await prepareTest();
  late ContinueWithEmailViewModel mockViewModel;

  setUp(() async {
    await setupTest();
    await locator.resetLazySingleton<ContinueWithEmailViewModel>(
      instance: locator<ContinueWithEmailViewModel>(),
    );
    mockViewModel = locator<ContinueWithEmailViewModel>();
    when(mockViewModel.isBusy).thenReturn(false);
    when(mockViewModel.viewState).thenReturn(ViewState.idle);
    when(mockViewModel.state).thenReturn(ContinueWithEmailState());
  });

  group("View Testing", () {
    testWidgets("Renders ContinueWithEmailView with input and button",
        (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const ContinueWithEmailView(),
        ),
      );
      await tester.pumpAndSettle(
        const Duration(milliseconds: 500),
      );
      expect(find.byType(MainInputField), findsOneWidget);
      expect(find.byType(MainButton), findsOneWidget);
      expect(find.textContaining("terms"), findsOneWidget);
    });

    testWidgets("Tapping on terms checkbox calls updateTermsSelections",
        (WidgetTester tester) async {
      tester.view.physicalSize = Size(tester.view.physicalSize.width, 2556);
      tester.view.devicePixelRatio = 3.0;

      when(mockViewModel.state).thenReturn(
        ContinueWithEmailState()..isTermsChecked = false,
      );

      await tester.pumpWidget(
        createTestableWidget(
          const ContinueWithEmailView(),
        ),
      );

      expect(
        mockViewModel.state?.isTermsChecked,
        false,
      );
      final Finder gesture = find.byType(GestureDetector).at(2);
      await tester.tap(gesture);
      await tester.pumpAndSettle();

      verify(mockViewModel.updateTermsSelections()).called(1);
    });

    testWidgets("Pressing MainButton triggers loginButtonTapped",
        (WidgetTester tester) async {
      tester.view.physicalSize = Size(tester.view.physicalSize.width, 2556);
      tester.view.devicePixelRatio = 3.0;

      when(mockViewModel.state)
          .thenReturn(ContinueWithEmailState()..isLoginEnabled = true);

      await tester.pumpWidget(
        createTestableWidget(
          const ContinueWithEmailView(),
        ),
      );

      await tester.tap(find.byType(MainButton));
      await tester.pumpAndSettle();

      verify(mockViewModel.loginButtonTapped()).called(1);
    });

    testWidgets("debug properties", (WidgetTester tester) async {
      final InAppRedirection redirection = InAppRedirection.cashback();
      final ContinueWithEmailView widget =
          ContinueWithEmailView(redirection: redirection);

      final DiagnosticPropertiesBuilder builder = DiagnosticPropertiesBuilder();
      widget.debugFillProperties(builder);

      final List<DiagnosticsNode> props = builder.properties;

      final DiagnosticsProperty<InAppRedirection?> redirectionProp =
          props.firstWhere((DiagnosticsNode p) => p.name == "redirection")
              as DiagnosticsProperty<InAppRedirection?>;

      expect(redirectionProp.value, isNotNull);
      // expect(redirectionProp.value!.route, '/home');
    });
  });

  tearDown(() async {
    await tearDownTest();
  });

  tearDownAll(() async {
    await tearDownAllTest();
  });
}
