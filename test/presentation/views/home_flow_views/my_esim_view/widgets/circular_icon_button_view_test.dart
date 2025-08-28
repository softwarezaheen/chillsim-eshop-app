import "package:esim_open_source/presentation/views/home_flow_views/my_esim_view/widgets/circular_icon_button.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
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
        CircularIconButton(icon: Icons.add_ic_call, onPressed: () {}),
      ),
    );
    await tester.pump();
  });

  testWidgets("renders correctly with charts", (WidgetTester tester) async {
    await tester.pumpWidget(
      createTestableWidget(
        CircularIconButton.chart(onPressed: () {}),
      ),
    );
    await tester.pump();
  });

  testWidgets("renders correctly with qrcode", (WidgetTester tester) async {
    await tester.pumpWidget(
      createTestableWidget(
        CircularIconButton.qrCode(onPressed: () {}),
      ),
    );
    await tester.pump();
  });

  testWidgets("renders correctly with share", (WidgetTester tester) async {
    await tester.pumpWidget(
      createTestableWidget(
        CircularIconButton.share(onPressed: () {}),
      ),
    );
    await tester.pump();
  });

  testWidgets("debug properties", (WidgetTester tester) async {
    CircularIconButton widget =
        CircularIconButton(icon: Icons.add_ic_call, onPressed: () {});

    final DiagnosticPropertiesBuilder builder = DiagnosticPropertiesBuilder();
    widget.debugFillProperties(builder);
  });
}
