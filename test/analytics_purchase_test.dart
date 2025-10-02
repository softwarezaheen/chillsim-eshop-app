import 'package:flutter_test/flutter_test.dart';
import 'package:esim_open_source/test_utils/analytics_test_helper.dart';

void main() {
  group('Analytics Purchase Event Tests', () {
    setUpAll(() {
      // Print test summary when starting tests
      AnalyticsTestHelper.printTestSummary();
    });

    test('should send basic mock purchase event', () async {
      // Test basic purchase scenario
      await AnalyticsTestHelper.sendMockPurchaseEvent();
    });

    test('should send purchase event with coupon', () async {
      // Test purchase with discount coupon
      await AnalyticsTestHelper.sendMockPurchaseEvent(
        couponCode: 'SAVE20',
        discount: 4.0,
      );
    });

    test('should send high value purchase event', () async {
      // Test high-value purchase scenario
      await AnalyticsTestHelper.sendMockPurchaseScenario(
        PurchaseTestScenario.highValuePurchase,
      );
    });

    test('should send multi-item purchase event', () async {
      // Test multiple items in one purchase
      await AnalyticsTestHelper.sendMockPurchaseScenario(
        PurchaseTestScenario.multiItemPurchase,
      );
    });

    test('should send topup purchase event', () async {
      // Test data top-up purchase
      await AnalyticsTestHelper.sendMockPurchaseScenario(
        PurchaseTestScenario.topupPurchase,
      );
    });

    test('should send complete purchase flow', () async {
      // Test complete ecommerce flow from view to purchase
      await AnalyticsTestHelper.sendMockPurchaseFlow(
        couponCode: 'FLOWTEST',
        discount: 2.5,
      );
    });

    test('should send purchase with custom parameters', () async {
      // Test custom purchase configuration
      await AnalyticsTestHelper.sendMockPurchaseEvent(
        couponCode: 'CUSTOM50',
        shipping: 10.0,
        tax: 8.5,
        discount: 15.0,
        currency: 'USD',
        purchaseType: 'bundle',
      );
    });

    test('should test all purchase scenarios', () async {
      // Test all predefined scenarios
      for (final scenario in PurchaseTestScenario.values) {
        await AnalyticsTestHelper.sendMockPurchaseScenario(scenario);
        // Small delay between tests to avoid overwhelming analytics
        await Future.delayed(const Duration(milliseconds: 200));
      }
    });
  });
}