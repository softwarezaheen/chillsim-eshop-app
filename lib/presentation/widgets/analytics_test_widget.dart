import "package:esim_open_source/domain/analytics/ecommerce_events.dart";
import "package:esim_open_source/test_utils/analytics_test_helper.dart";
import "package:flutter/material.dart";

/// Debug widget for manual analytics testing
/// Add this to your app during development to test purchase events
class AnalyticsTestWidget extends StatelessWidget {
  const AnalyticsTestWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("🧪 Analytics Testing"),
        backgroundColor: Colors.orange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: <Widget>[
            const Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "🧪 Analytics Test Center",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "Test purchase events without making real purchases. "
                      "Check your Firebase Analytics and Facebook Events to see the data.",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            
            // Quick Test Buttons
            _buildTestSection(
              title: "🚀 Quick Tests",
              children: <Widget>[
                _buildTestButton(
                  "Basic Purchase",
                  "Single item, no discounts",
                  Icons.shopping_cart,
                  AnalyticsTestHelper.sendMockPurchaseEvent,
                ),
                _buildTestButton(
                  "Purchase with Coupon",
                  "Includes discount code",
                  Icons.local_offer,
                  () => AnalyticsTestHelper.sendMockPurchaseEvent(
                    couponCode: "TEST10OFF",
                    discount: 2,
                  ),
                ),
                _buildTestButton(
                  "Complete Flow",
                  "Full ecommerce journey",
                  Icons.timeline,
                  () => AnalyticsTestHelper.sendMockPurchaseFlow(
                    couponCode: "FLOWTEST",
                  ),
                ),
              ],
            ),
            
            // Scenario Tests
            _buildTestSection(
              title: "📊 Test Scenarios",
              children: PurchaseTestScenario.values.map((PurchaseTestScenario scenario) =>
                _buildTestButton(
                  scenario.name.replaceAll(RegExp(r"([A-Z])"), r" $1").trim(),
                  scenario.description,
                  _getScenarioIcon(scenario),
                  () => AnalyticsTestHelper.sendMockPurchaseScenario(scenario),
                ),
              ).toList(),
            ),
            
            // Custom Test
            _buildTestSection(
              title: "⚙️ Custom Test",
              children: <Widget>[
                _buildTestButton(
                  "High Value + Coupon",
                  "Premium bundle with discount",
                  Icons.diamond,
                  () => AnalyticsTestHelper.sendMockPurchaseEvent(
                    couponCode: "VIP50",
                    customItems: <EcommerceItem>[
                      const EcommerceItem(
                        id: "vip-global-001",
                        name: "VIP Global Unlimited",
                        category: "esim_bundle",
                        price: 149.99,
                      ),
                    ],
                    shipping: 10,
                    tax: 20,
                    discount: 25,
                    currency: "USD",
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 32),
            const Card(
              color: Colors.blue,
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: <Widget>[
                    Icon(Icons.info, color: Colors.white, size: 32),
                    SizedBox(height: 8),
                    Text(
                      "Check Your Analytics",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "• Firebase Analytics: Events appear in real-time\n"
                      "• Facebook Events Manager: Check recent activity\n"
                      "• GA4 Debug View: Enable for detailed event data",
                      style: TextStyle(color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTestSection({
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        ...children,
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildTestButton(
    String title,
    String subtitle,
    IconData icon,
    VoidCallback onPressed,
  ) {
    return Card(
      child: ListTile(
        leading: Icon(icon, color: Colors.orange),
        title: Text(title),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
        trailing: const Icon(Icons.play_arrow),
        onTap: () {
          try {
            onPressed();
            // Could show a snackbar here for success feedback
          } on Exception catch (e) {
            // Could show error feedback here
            debugPrint("Test error: $e");
          }
        },
      ),
    );
  }

  IconData _getScenarioIcon(PurchaseTestScenario scenario) {
    switch (scenario) {
      case PurchaseTestScenario.basicPurchase:
        return Icons.shopping_bag;
      case PurchaseTestScenario.purchaseWithCoupon:
        return Icons.discount;
      case PurchaseTestScenario.highValuePurchase:
        return Icons.star;
      case PurchaseTestScenario.multiItemPurchase:
        return Icons.shopping_cart_checkout;
      case PurchaseTestScenario.topupPurchase:
        return Icons.add_circle;
      case PurchaseTestScenario.completePurchaseFlow:
        return Icons.timeline;
    }
  }
}
