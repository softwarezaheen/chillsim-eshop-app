import "package:esim_open_source/presentation/views/home_flow_views/my_esim_view/widgets/bundle_info_row_view.dart";
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
      createTestableWidget(
        const BundleInfoRow(validity: "", expiryDate: "", isLoading: false),
      ),
    );
    await tester.pump();
  });

  testWidgets("debug properties", (WidgetTester tester) async {
    const BundleInfoRow widget =
        BundleInfoRow(validity: "", expiryDate: "", isLoading: false);

    final DiagnosticPropertiesBuilder builder = DiagnosticPropertiesBuilder();
    widget.debugFillProperties(builder);
  });
}
