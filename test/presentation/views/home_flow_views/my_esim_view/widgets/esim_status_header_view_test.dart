import "package:esim_open_source/presentation/views/home_flow_views/my_esim_view/widgets/esim_status_header_view.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";

Future<void> main() async {
  // await prepareTest();
  //
  // setUp(() async {
  //   await setupTest();
  // });
  //
  // tearDown(() async {
  //   await tearDownTest();
  // });

  testWidgets("debug properties", (WidgetTester tester) async {
    ESimStatusHeader widget = ESimStatusHeader(
      status: "",
      statusTextColor: Colors.white,
      statusBgColor: Colors.white,
      onEditTap: () {},
      isLoading: true,
    );

    final DiagnosticPropertiesBuilder builder = DiagnosticPropertiesBuilder();
    widget.debugFillProperties(builder);
  });
}
