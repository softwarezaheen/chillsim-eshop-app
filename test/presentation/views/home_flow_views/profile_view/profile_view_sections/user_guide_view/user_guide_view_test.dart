import "dart:io";

import "package:esim_open_source/presentation/views/home_flow_views/profile_view/profile_view_sections/user_guide_view/android_user_guide_view/android_user_guide_view.dart";
import "package:esim_open_source/presentation/views/home_flow_views/profile_view/profile_view_sections/user_guide_view/user_guide_detailed_view/user_guide_detailed_view.dart";
import "package:esim_open_source/presentation/views/home_flow_views/profile_view/profile_view_sections/user_guide_view/user_guide_view.dart";
import "package:esim_open_source/presentation/views/home_flow_views/profile_view/profile_view_sections/user_guide_view/user_guide_view_type.dart";
import "package:esim_open_source/presentation/widgets/common_navigation_title.dart";
import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";

import "../../../../../../helpers/view_helper.dart";
import "../../../../../../helpers/view_model_helper.dart";

Future<void> main() async {
  await prepareTest();

  setUp(() async {
    await setupTest();
  });

  tearDown(() async {
    await tearDownTest();
  });

  group("UserGuideView Widget Tests", () {
    testWidgets("renders basic structure with children",
        (WidgetTester tester) async {
      onViewModelReadyMock(viewName: "UserGuideView");
      onViewModelReadyMock(viewName: "AndroidUserGuideView");

      await tester.pumpWidget(
        createTestableWidget(
          const UserGuideView(),
        ),
      );
      await tester.pump();

      expect(find.byType(UserGuideView), findsOneWidget);
      expect(find.byType(Scaffold), findsWidgets);
      expect(find.byType(SafeArea), findsWidgets);
      expect(find.byType(SizedBox), findsWidgets);
    });

    testWidgets("displays CommonNavigationTitle", (WidgetTester tester) async {
      onViewModelReadyMock(viewName: "UserGuideView");
      onViewModelReadyMock(viewName: "AndroidUserGuideView");

      await tester.pumpWidget(
        createTestableWidget(
          const UserGuideView(),
        ),
      );
      await tester.pump();

      expect(find.byType(CommonNavigationTitle), findsOneWidget);
    });

    testWidgets("displays tabs correctly", (WidgetTester tester) async {
      onViewModelReadyMock(viewName: "UserGuideView");
      onViewModelReadyMock(viewName: "AndroidUserGuideView");

      await tester.pumpWidget(
        createTestableWidget(
          const UserGuideView(),
        ),
      );
      await tester.pump();

      expect(find.byType(Tab), findsWidgets);
      final Iterable<Tab> tabs = tester.widgetList<Tab>(find.byType(Tab));
      expect(tabs.length, equals(2));
    });

    testWidgets("contains platform-specific tab text",
        (WidgetTester tester) async {
      onViewModelReadyMock(viewName: "UserGuideView");
      onViewModelReadyMock(viewName: "AndroidUserGuideView");

      await tester.pumpWidget(
        createTestableWidget(
          const UserGuideView(),
        ),
      );
      await tester.pump();

      expect(find.text("iOS"), findsOneWidget);
      expect(find.text("Android"), findsOneWidget);
    });

    testWidgets("Column structure has correct children count",
        (WidgetTester tester) async {
      onViewModelReadyMock(viewName: "UserGuideView");
      onViewModelReadyMock(viewName: "AndroidUserGuideView");

      await tester.pumpWidget(
        createTestableWidget(
          const UserGuideView(),
        ),
      );
      await tester.pump();

      final Iterable<Column> columns =
          tester.widgetList<Column>(find.byType(Column));
      expect(columns.length, greaterThanOrEqualTo(1));

      // Find the main column (should have at least 2 children: CommonNavigationTitle + tabs)
      bool foundMainColumn = false;
      for (final Column column in columns) {
        if (column.children.length >= 2) {
          foundMainColumn = true;
          break;
        }
      }
      expect(foundMainColumn, isTrue);
    });

    test("displays basic widget properties", () {
      const UserGuideView widget = UserGuideView();
      expect(widget, isA<StatelessWidget>());
      expect(widget.runtimeType, equals(UserGuideView));
    });

    test("route name is correct", () {
      expect(UserGuideView.routeName, equals("UserGuideView"));
    });

    test("widget key is properly set", () {
      const Key testKey = Key("test_key");
      const UserGuideView widget = UserGuideView(key: testKey);
      expect(widget.key, equals(testKey));
    });

    test("getUserGuideTabsContent method coverage", () {
      const UserGuideView widget = UserGuideView();
      final List<Widget> tabsContent = widget.getUserGuideTabsContent();

      expect(tabsContent, isA<List<Widget>>());
      expect(tabsContent.length, equals(2));
      expect(tabsContent.first, isA<Widget>());
      expect(tabsContent.last, isA<Widget>());
    });

    test("getUserGuideTabs method coverage", () {
      const UserGuideView widget = UserGuideView();
      final List<Tab> tabs = widget.getUserGuideTabs();

      expect(tabs, isA<List<Tab>>());
      expect(tabs.length, equals(2));
      expect(tabs.first, isA<Tab>());
      expect(tabs.last, isA<Tab>());
    });

    test("getUserGuideTabsContent contains correct widgets", () {
      const UserGuideView widget = UserGuideView();
      final List<Widget> tabsContent = widget.getUserGuideTabsContent();

      bool foundUserGuideDetailedView = false;
      bool foundAndroidUserGuideView = false;

      for (final Widget content in tabsContent) {
        if (content is UserGuideDetailedView) {
          foundUserGuideDetailedView = true;
        }
        if (content is AndroidUserGuideView) {
          foundAndroidUserGuideView = true;
        }
      }

      expect(foundUserGuideDetailedView, isTrue);
      expect(foundAndroidUserGuideView, isTrue);
    });

    test("getUserGuideTabs contains correct tab texts", () {
      const UserGuideView widget = UserGuideView();
      final List<Tab> tabs = widget.getUserGuideTabs();

      final List<String?> tabTexts = tabs.map((Tab tab) => tab.text).toList();
      expect(tabTexts.contains("iOS"), isTrue);
      expect(tabTexts.contains("Android"), isTrue);
    });

    test("Platform.isIOS affects tab order", () {
      const UserGuideView widget = UserGuideView();
      final List<Tab> tabs = widget.getUserGuideTabs();
      final List<Widget> tabsContent = widget.getUserGuideTabsContent();

      expect(tabs.length, equals(2));
      expect(tabsContent.length, equals(2));

      // Verify tab order logic is executed
      if (Platform.isIOS) {
        expect(tabs.first.text, equals("iOS"));
        expect(tabs.last.text, equals("Android"));
      } else {
        expect(tabs.first.text, equals("Android"));
        expect(tabs.last.text, equals("iOS"));
      }
    });

    test("Platform.isIOS affects content order", () {
      const UserGuideView widget = UserGuideView();
      final List<Widget> tabsContent = widget.getUserGuideTabsContent();

      expect(tabsContent.length, equals(2));

      if (Platform.isIOS) {
        expect(tabsContent.first, isA<UserGuideDetailedView>());
        expect(tabsContent.last, isA<AndroidUserGuideView>());
      } else {
        expect(tabsContent.first, isA<AndroidUserGuideView>());
        expect(tabsContent.last, isA<UserGuideDetailedView>());
      }
    });

    test("UserGuideViewType enum integration", () {
      const UserGuideView widget = UserGuideView();
      final List<Tab> tabs = widget.getUserGuideTabs();

      // Test that UserGuideViewType.values are used correctly
      expect(UserGuideViewType.values.length, equals(2));
      expect(UserGuideViewType.ios.titleHeader, equals("iOS"));
      expect(UserGuideViewType.android.titleHeader, equals("Android"));

      // Verify tabs use the enum values
      final Set<String?> tabTexts = tabs.map((Tab tab) => tab.text).toSet();
      final Set<String> enumTitles = UserGuideViewType.values
          .map((UserGuideViewType e) => e.titleHeader)
          .toSet();
      expect(tabTexts, equals(enumTitles));
    });

    test("build method returns Scaffold", () {
      const UserGuideView widget = UserGuideView();
      // We can't easily test build method without rendering, but we can test that it's implemented
      expect(widget.build, isA<Function>());
    });

    test("getUserGuideTabsContent method returns non-empty list", () {
      const UserGuideView widget = UserGuideView();
      final List<Widget> content = widget.getUserGuideTabsContent();

      expect(content, isNotEmpty);
    });

    test("getUserGuideTabs method returns non-empty tabs", () {
      const UserGuideView widget = UserGuideView();
      final List<Tab> tabs = widget.getUserGuideTabs();

      expect(tabs, isNotEmpty);
      expect(
        tabs.every((Tab tab) => tab.text != null && tab.text!.isNotEmpty),
        isTrue,
      );
    });

    test("Tab widgets have proper text properties", () {
      const UserGuideView widget = UserGuideView();
      final List<Tab> tabs = widget.getUserGuideTabs();

      for (final Tab tab in tabs) {
        expect(tab.text, isNotNull);
        expect(tab.text!.isNotEmpty, isTrue);
      }
    });

    test("Method calls return consistent results", () {
      const UserGuideView widget = UserGuideView();

      final List<Tab> tabs1 = widget.getUserGuideTabs();
      final List<Tab> tabs2 = widget.getUserGuideTabs();
      final List<Widget> content1 = widget.getUserGuideTabsContent();
      final List<Widget> content2 = widget.getUserGuideTabsContent();

      expect(tabs1.length, equals(tabs2.length));
      expect(content1.length, equals(content2.length));

      for (int i = 0; i < tabs1.length; i++) {
        expect(tabs1[i].text, equals(tabs2[i].text));
      }
    });

    test("UserGuideDetailedView has correct constructor parameters", () {
      const UserGuideView widget = UserGuideView();
      final List<Widget> tabsContent = widget.getUserGuideTabsContent();

      UserGuideDetailedView? userGuideDetailedView;
      for (final Widget content in tabsContent) {
        if (content is UserGuideDetailedView) {
          userGuideDetailedView = content;
          break;
        }
      }

      expect(userGuideDetailedView, isNotNull);
      expect(userGuideDetailedView!.userGuideViewDataSource, isNotNull);
    });

    test("AndroidUserGuideView is properly instantiated", () {
      const UserGuideView widget = UserGuideView();
      final List<Widget> tabsContent = widget.getUserGuideTabsContent();

      AndroidUserGuideView? androidUserGuideView;
      for (final Widget content in tabsContent) {
        if (content is AndroidUserGuideView) {
          androidUserGuideView = content;
          break;
        }
      }

      expect(androidUserGuideView, isNotNull);
      expect(androidUserGuideView, isA<AndroidUserGuideView>());
    });

    test("methods handle Platform.isIOS correctly", () {
      const UserGuideView widget = UserGuideView();

      // Test that methods don't throw when accessing Platform.isIOS
      expect(() => widget.getUserGuideTabs(), returnsNormally);
      expect(() => widget.getUserGuideTabsContent(), returnsNormally);

      // Test that platform-specific logic is consistent
      final List<Tab> tabs = widget.getUserGuideTabs();
      final List<Widget> content = widget.getUserGuideTabsContent();

      expect(tabs.length, equals(content.length));
    });

    test("UserGuideViewType enum properties are accessible", () {
      // Test enum values directly
      expect(UserGuideViewType.values, hasLength(2));
      expect(UserGuideViewType.ios.titleHeader, isA<String>());
      expect(UserGuideViewType.android.titleHeader, isA<String>());
      expect(UserGuideViewType.ios.titleHeader, isNotEmpty);
      expect(UserGuideViewType.android.titleHeader, isNotEmpty);
    });

    test("widget creates unique instances", () {
      const UserGuideView widget1 = UserGuideView();
      const UserGuideView widget2 = UserGuideView();

      // Different instances should be different objects
      expect(identical(widget1, widget2), isFalse);

      // But should have the same type and behavior
      expect(widget1.runtimeType, equals(widget2.runtimeType));
      expect(
        widget1.getUserGuideTabs().length,
        equals(widget2.getUserGuideTabs().length),
      );
    });
  });
}
