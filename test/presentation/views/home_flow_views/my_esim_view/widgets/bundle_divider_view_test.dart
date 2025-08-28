import "package:esim_open_source/presentation/views/home_flow_views/my_esim_view/widgets/bundle_divider_view.dart";
import "package:flutter/foundation.dart";
import "package:flutter_test/flutter_test.dart";

import "../../../../../helpers/view_helper.dart";

Future<void> main() async {
  await prepareTest();

  setUp(() async {
    await setupTest();
  });

  tearDown(() async {
    await tearDownTest();
  });

  testWidgets("renders correctly with all components",
      (WidgetTester tester) async {
    await tester.pumpWidget(
      createTestableWidget(const BundleDivider()),
    );
    await tester.pump();
  });

  testWidgets("debug properties", (WidgetTester tester) async {
    const BundleDivider widget = BundleDivider();

    final DiagnosticPropertiesBuilder builder = DiagnosticPropertiesBuilder();
    widget.debugFillProperties(builder);
  });
}
