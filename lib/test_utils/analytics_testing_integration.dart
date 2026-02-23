// Example: How to add analytics testing to your app during development

// Option 1: Add a floating action button to your main screen
/*
FloatingActionButton(
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AnalyticsTestWidget(),
      ),
    );
  },
  backgroundColor: Colors.orange,
  child: const Icon(Icons.science),
)
*/

// Option 2: Add to debug drawer or settings screen
/*
ListTile(
  leading: const Icon(Icons.analytics),
  title: const Text('🧪 Test Analytics'),
  subtitle: const Text('Test purchase events'),
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AnalyticsTestWidget(),
      ),
    );
  },
)
*/

// Option 3: Quick inline testing (call directly in your code)
/*
import 'package:esim_open_source/test_utils/analytics_test_helper.dart';

// Test basic purchase
await AnalyticsTestHelper.sendMockPurchaseEvent();

// Test purchase with coupon  
await AnalyticsTestHelper.sendMockPurchaseEvent(
  couponCode: 'SAVE20',
  discount: 5.0,
);

// Test complete purchase flow
await AnalyticsTestHelper.sendMockPurchaseFlow();

// Test specific scenario
await AnalyticsTestHelper.sendMockPurchaseScenario(
  PurchaseTestScenario.highValuePurchase,
);
*/

// Option 4: Run tests programmatically
/*
import 'package:flutter_test/flutter_test.dart';

void runAnalyticsTests() {
  // Run all scenarios for comprehensive testing
  for (final scenario in PurchaseTestScenario.values) {
    AnalyticsTestHelper.sendMockPurchaseScenario(scenario);
  }
}
*/

import "package:esim_open_source/presentation/widgets/analytics_test_widget.dart";
import "package:esim_open_source/test_utils/analytics_test_helper.dart";
import "package:flutter/material.dart";

/// Quick access methods for analytics testing
class AnalyticsTestingIntegration {
  
  /// Show analytics test widget as a modal bottom sheet
  static void showTestBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) => Container(
        height: MediaQuery.of(context).size.height * 0.8,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: const AnalyticsTestWidget(),
      ),
    );
  }

  /// Show analytics test widget as a full screen
  static void showTestScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => const AnalyticsTestWidget(),
      ),
    );
  }

  /// Quick test methods that can be called directly
  static Future<void> quickTestBasicPurchase() async {
    await AnalyticsTestHelper.sendMockPurchaseEvent();
  }

  static Future<void> quickTestPurchaseWithCoupon() async {
    await AnalyticsTestHelper.sendMockPurchaseEvent(
      couponCode: "QUICKTEST",
      discount: 3,
    );
  }

  static Future<void> quickTestCompletePurchaseFlow() async {
    await AnalyticsTestHelper.sendMockPurchaseFlow();
  }

  /// Run all test scenarios (for comprehensive testing)
  static Future<void> runAllTestScenarios() async {
    for (final PurchaseTestScenario scenario in PurchaseTestScenario.values) {
      await AnalyticsTestHelper.sendMockPurchaseScenario(scenario);
      // Small delay between tests
      await Future.delayed(const Duration(milliseconds: 300));
    }
  }
}