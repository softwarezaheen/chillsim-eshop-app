# 🧪 Analytics Testing System

A comprehensive testing system for purchase events and ecommerce analytics without making real purchases.

## 📁 Files Created

- `lib/test_utils/analytics_test_helper.dart` - Core testing functionality
- `lib/presentation/widgets/analytics_test_widget.dart` - UI widget for manual testing  
- `lib/test_utils/analytics_testing_integration.dart` - Integration helpers
- `test/analytics_purchase_test.dart` - Unit tests
- `ANALYTICS_TESTING_README.md` - This documentation

## 🚀 Quick Start

### Method 1: Manual Testing Widget

Add the analytics test widget to your app for manual testing:

```dart
import 'package:esim_open_source/test_utils/analytics_testing_integration.dart';

// Show as full screen
AnalyticsTestingIntegration.showTestScreen(context);

// Show as bottom sheet  
AnalyticsTestingIntegration.showTestBottomSheet(context);
```

### Method 2: Direct Code Testing

Call test methods directly in your code:

```dart
import 'package:esim_open_source/test_utils/analytics_test_helper.dart';

// Basic purchase event
await AnalyticsTestHelper.sendMockPurchaseEvent();

// Purchase with coupon
await AnalyticsTestHelper.sendMockPurchaseEvent(
  couponCode: 'SAVE20',
  discount: 5.0,
);

// Complete ecommerce flow
await AnalyticsTestHelper.sendMockPurchaseFlow();
```

### Method 3: Unit Tests

Run the provided unit tests:

```bash
flutter test test/analytics_purchase_test.dart
```

## 📊 Test Scenarios Available

| Scenario | Description |
|----------|-------------|
| `basicPurchase` | Single item, no discounts |
| `purchaseWithCoupon` | Purchase with discount coupon |
| `highValuePurchase` | Premium bundle purchase |
| `multiItemPurchase` | Multiple items in single purchase |
| `topupPurchase` | Data top-up purchase |
| `completePurchaseFlow` | Full ecommerce journey |

## 🧪 Testing Methods

### 1. `sendMockPurchaseEvent()`
Sends a single purchase event with customizable parameters.

```dart
await AnalyticsTestHelper.sendMockPurchaseEvent(
  couponCode: 'TEST10',
  shipping: 2.50,
  tax: 3.75,
  discount: 2.0,
  currency: 'EUR',
  purchaseType: 'bundle',
);
```

### 2. `sendMockPurchaseFlow()`
Sends complete ecommerce event sequence:
- ViewItemListEvent
- ViewItemEvent  
- AddToCartEvent
- BeginCheckoutEvent
- PurchaseEvent

### 3. `sendMockPurchaseScenario()`
Sends predefined test scenarios:

```dart
await AnalyticsTestHelper.sendMockPurchaseScenario(
  PurchaseTestScenario.highValuePurchase,
);
```

## 📱 Integration Examples

### Add to Main Screen FAB

```dart
FloatingActionButton(
  onPressed: () => AnalyticsTestingIntegration.showTestScreen(context),
  backgroundColor: Colors.orange,
  child: const Icon(Icons.science),
)
```

### Add to Debug Menu

```dart
ListTile(
  leading: const Icon(Icons.analytics),
  title: const Text('🧪 Test Analytics'),
  onTap: () => AnalyticsTestingIntegration.showTestBottomSheet(context),
)
```

### Quick Access Buttons

```dart
ElevatedButton(
  onPressed: AnalyticsTestingIntegration.quickTestBasicPurchase,
  child: const Text('Test Purchase'),
)
```

## 🔍 Monitoring Results

### Firebase Analytics
- Events appear in real-time in Firebase console
- Enable GA4 Debug View for detailed event data
- Check ecommerce reports for purchase data

### Facebook Events Manager  
- Check recent activity for event data
- Complex parameters are JSON-encoded strings
- Verify event parameters and values

## 📝 Mock Data Generated

Each test creates realistic mock data:

```dart
// Example items generated
EcommerceItem(
  id: 'test-item-1',
  name: 'Test Bundle 1', 
  category: 'esim_bundle',
  price: 19.99,
  quantity: 1,
)

// Example transaction ID
'test-purchase-1728000000000'
```

## ⚙️ Customization

### Custom Items
```dart
final customItems = [
  EcommerceItem(
    id: 'custom-001',
    name: 'Custom Bundle',
    category: 'esim_bundle', 
    price: 49.99,
    quantity: 2,
  ),
];

await AnalyticsTestHelper.sendMockPurchaseEvent(
  customItems: customItems,
);
```

### Custom Parameters
```dart
await AnalyticsTestHelper.sendMockPurchaseEvent(
  couponCode: 'CUSTOM50',
  shipping: 10.0,
  tax: 8.5, 
  discount: 25.0,
  currency: 'USD',
  purchaseType: 'bundle',
);
```

## 🐛 Debugging

All test methods include comprehensive logging:

```
🧪 [Analytics Test] Starting mock purchase flow...
🧪 [Analytics Test] Sending ViewItemListEvent...
🧪 [Analytics Test] Sending PurchaseEvent...
🧪 [Analytics Test] ✅ Mock purchase event sent successfully!
🧪 [Analytics Test] 📊 Event Details:
🧪 [Analytics Test]   - Transaction ID: test-purchase-1728000000000
🧪 [Analytics Test]   - Total Value: 39.98 EUR
🧪 [Analytics Test]   - Coupon: TEST10
```

## 🔒 Safety

- **No Real Purchases**: All data is clearly marked as test data
- **Unique Transaction IDs**: Timestamp-based to avoid conflicts
- **Test Prefixes**: All IDs prefixed with 'test-' for identification
- **Isolated**: Uses existing analytics service without modifications

## 📚 Usage Tips

1. **Use during development** to verify analytics implementation
2. **Test before releases** to ensure events are working
3. **Verify both Firebase and Facebook** receive data correctly
4. **Check GA4 ecommerce reports** for proper data structure
5. **Monitor debug logs** for any issues

## 🛠️ Maintenance

To add new test scenarios:

1. Add to `PurchaseTestScenario` enum
2. Add case to `sendMockPurchaseScenario()` switch
3. Update documentation

## 🚨 Important Notes

- Only use in development/testing environments
- Remove or disable in production builds
- Test data will appear in your analytics
- Use clear test identifiers to filter real vs test data