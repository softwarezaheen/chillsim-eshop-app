import "dart:developer";
import "dart:io";

import "package:esim_open_source/di/locator.dart";
import "package:esim_open_source/domain/analytics/ecommerce_events.dart";
import "package:esim_open_source/domain/repository/services/analytics_service.dart";

/// Helper class for testing analytics events without making real purchases
class AnalyticsTestHelper {
  static final AnalyticsService _analyticsService = locator<AnalyticsService>();

  /// Creates mock ecommerce items for testing
  static List<EcommerceItem> createMockItems({
    int count = 2,
    String category = "esim_bundle",
  }) {
    return List.generate(count, (int index) {
      return EcommerceItem(
        id: "test-item-${index + 1}",
        name: "Test Bundle ${index + 1}",
        category: category,
        price: 19.99 + (index * 5.0), // 19.99, 24.99, etc.
      );
    });
  }

  /// Sends a complete mock purchase flow with all ecommerce events
  static Future<void> sendMockPurchaseFlow({
    String? couponCode,
    double shipping = 2.50,
    double tax = 3.75,
    double discount = 0.0,
    String currency = "EUR",
    String purchaseType = "bundle",
  }) async {
    final String platform = Platform.isIOS ? "iOS" : "Android";
    final List<EcommerceItem> items = createMockItems();
    final String transactionId = "test-order-${DateTime.now().millisecondsSinceEpoch}";

    log("🧪 [Analytics Test] Starting mock purchase flow...");

    try {
      // 1. View Item List Event
      log("🧪 [Analytics Test] Sending ViewItemListEvent...");
      await _analyticsService.logEvent(
        event: ViewItemListEvent(
          listType: "test_country",
          items: items,
          listId: "test-list-123",
          listName: "Test Country Bundles",
          platform: platform,
          currency: currency,
        ),
      );

      // 2. View Item Event (for first item)
      log("🧪 [Analytics Test] Sending ViewItemEvent...");
      await _analyticsService.logEvent(
        event: ViewItemEvent(
          item: items.first,
          platform: platform,
          currency: currency,
        ),
      );

      // 3. Add to Cart Event
      log("🧪 [Analytics Test] Sending AddToCartEvent...");
      await _analyticsService.logEvent(
        event: AddToCartEvent(
          item: items.first,
          platform: platform,
          currency: currency,
        ),
      );

      // 4. Begin Checkout Event
      log("🧪 [Analytics Test] Sending BeginCheckoutEvent...");
      await _analyticsService.logEvent(
        event: BeginCheckoutEvent(
          items: items,
          platform: platform,
          currency: currency,
          coupon: couponCode,
          shipping: shipping,
          tax: tax,
        ),
      );

      // Small delay to simulate checkout process
      await Future.delayed(const Duration(milliseconds: 500));

      // 5. Purchase Event (the main test target)
      log("🧪 [Analytics Test] Sending PurchaseEvent...");
      await _analyticsService.logEvent(
        event: PurchaseEvent(
          items: items,
          platform: platform,
          currency: currency,
          transactionId: transactionId,
          purchaseType: purchaseType,
          coupon: couponCode,
          shipping: shipping,
          tax: tax,
          discount: discount,
        ),
      );

      log("🧪 [Analytics Test] ✅ Mock purchase flow completed successfully!");
      log("🧪 [Analytics Test] Transaction ID: $transactionId");
      log("🧪 [Analytics Test] Total Value: ${_calculateTotalValue(items, discount)}");
      log('🧪 [Analytics Test] Coupon: ${couponCode ?? 'None'}');

    } catch (e, st) {
      log("🧪 [Analytics Test] ❌ Error in mock purchase flow: $e");
      log("🧪 [Analytics Test] Stack trace: $st");
    }
  }

  /// Sends only a mock purchase event (for focused testing)
  static Future<void> sendMockPurchaseEvent({
    String? couponCode,
    double shipping = 2.50,
    double tax = 3.75,
    double discount = 5.0,
    String currency = "EUR",
    String purchaseType = "bundle",
    List<EcommerceItem>? customItems,
  }) async {
    final String platform = Platform.isIOS ? "iOS" : "Android";
    final List<EcommerceItem> items = customItems ?? createMockItems();
    final String transactionId = "test-purchase-${DateTime.now().millisecondsSinceEpoch}";

    log("🧪 [Analytics Test] Sending standalone PurchaseEvent...");

    try {
      await _analyticsService.logEvent(
        event: PurchaseEvent(
          items: items,
          platform: platform,
          currency: currency,
          transactionId: transactionId,
          purchaseType: purchaseType,
          coupon: couponCode,
          shipping: shipping,
          tax: tax,
          discount: discount,
        ),
      );

      final double totalValue = _calculateTotalValue(items, discount);
      
      log("🧪 [Analytics Test] ✅ Mock purchase event sent successfully!");
      log("🧪 [Analytics Test] 📊 Event Details:");
      log("🧪 [Analytics Test]   - Transaction ID: $transactionId");
      log("🧪 [Analytics Test]   - Items: ${items.length}");
      log("🧪 [Analytics Test]   - Total Value: $totalValue $currency");
      log("🧪 [Analytics Test]   - Shipping: $shipping $currency");
      log("🧪 [Analytics Test]   - Tax: $tax $currency");
      log("🧪 [Analytics Test]   - Discount: $discount $currency");
      log('🧪 [Analytics Test]   - Coupon: ${couponCode ?? 'None'}');
      log("🧪 [Analytics Test]   - Platform: $platform");
      log("🧪 [Analytics Test]   - Purchase Type: $purchaseType");

      // Log item details
      for (int i = 0; i < items.length; i++) {
        final EcommerceItem item = items[i];
        log("🧪 [Analytics Test]   - Item ${i + 1}: ${item.name} (${item.id}) - ${item.price} $currency x${item.quantity}");
      }

    } catch (e, st) {
      log("🧪 [Analytics Test] ❌ Error sending mock purchase event: $e");
      log("🧪 [Analytics Test] Stack trace: $st");
    }
  }

  /// Creates a mock purchase event with specific scenarios
  static Future<void> sendMockPurchaseScenario(PurchaseTestScenario scenario) async {
    switch (scenario) {
      case PurchaseTestScenario.basicPurchase:
        await sendMockPurchaseEvent();
      
      case PurchaseTestScenario.purchaseWithCoupon:
        await sendMockPurchaseEvent(
          couponCode: "TEST10OFF",
          discount: 2,
        );
      
      case PurchaseTestScenario.highValuePurchase:
        await sendMockPurchaseEvent(
          customItems: <EcommerceItem>[
            const EcommerceItem(
              id: "premium-bundle-001",
              name: "Premium Global Bundle",
              category: "esim_bundle",
              price: 99.99,
            ),
          ],
          shipping: 5,
          tax: 12,
        );
      
      case PurchaseTestScenario.multiItemPurchase:
        await sendMockPurchaseEvent(
          customItems: createMockItems(count: 5),
          shipping: 7.5,
          tax: 15,
        );
      
      case PurchaseTestScenario.topupPurchase:
        await sendMockPurchaseEvent(
          customItems: <EcommerceItem>[
            const EcommerceItem(
              id: "topup-001",
              name: "Data Top-up 5GB",
              category: "topup",
              price: 15,
            ),
          ],
          purchaseType: "topup",
          shipping: 0,
          tax: 1.5,
        );
      
      case PurchaseTestScenario.completePurchaseFlow:
        await sendMockPurchaseFlow(
          couponCode: "TESTFLOW",
          discount: 3,
        );
    }
  }

  /// Calculate total value after discount
  static double _calculateTotalValue(List<EcommerceItem> items, double discount) {
    final double gross = items.fold<double>(0, (double acc, EcommerceItem item) => acc + (item.price * item.quantity));
    final double total = (gross - discount) < 0 ? 0 : (gross - discount);
    return double.parse(total.toStringAsFixed(2));
  }

  /// Print analytics test summary
  static void printTestSummary() {
    log("🧪 [Analytics Test] ═══════════════════════════════════════");
    log("🧪 [Analytics Test] 📊 ANALYTICS TEST HELPER SUMMARY");
    log("🧪 [Analytics Test] ═══════════════════════════════════════");
    log("🧪 [Analytics Test] Available test methods:");
    log("🧪 [Analytics Test]   1. sendMockPurchaseEvent() - Single purchase event");
    log("🧪 [Analytics Test]   2. sendMockPurchaseFlow() - Complete ecommerce flow");
    log("🧪 [Analytics Test]   3. sendMockPurchaseScenario() - Predefined scenarios");
    log("🧪 [Analytics Test] ");
    log("🧪 [Analytics Test] Test scenarios available:");
    for (final PurchaseTestScenario scenario in PurchaseTestScenario.values) {
      log("🧪 [Analytics Test]   - ${scenario.name}: ${scenario.description}");
    }
    log("🧪 [Analytics Test] ═══════════════════════════════════════");
  }
}

/// Predefined test scenarios for different purchase types
enum PurchaseTestScenario {
  basicPurchase("Basic single item purchase"),
  purchaseWithCoupon("Purchase with discount coupon applied"),
  highValuePurchase("High-value premium bundle purchase"),
  multiItemPurchase("Multiple items in single purchase"),
  topupPurchase("Data top-up purchase"),
  completePurchaseFlow("Complete ecommerce flow from view to purchase");

  const PurchaseTestScenario(this.description);
  final String description;
}