// start_up_view_test.dart

import "package:esim_open_source/presentation/views/start_up_view/startup_view.dart";
import "package:flutter_test/flutter_test.dart";

import "../../../helpers/view_helper.dart";

void main() async {
  await prepareTest();
  setUp(() async {
    await setupTest();
  });

  testWidgets("Renders StartupView with input and button",
      (WidgetTester tester) async {
    await tester.pumpWidget(
      createTestableWidget(
        const StartUpView(),
      ),
    );
  });

  tearDown(() async {
    await tearDownTest();
  });
  tearDownAll(() async {
    await tearDownAllTest();
  });
}
