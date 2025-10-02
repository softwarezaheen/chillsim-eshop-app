import 'package:flutter_test/flutter_test.dart';
import 'package:esim_open_source/domain/analytics/ecommerce_events.dart';

void main() {
  group('Ecommerce dual-provider events', () {
    test('ViewItemEvent parameter mapping', () {
      final item = EcommerceItem(id: 'b1', name: 'Bundle 1', category: 'esim_bundle', price: 9.99);
      final event = ViewItemEvent(item: item, platform: 'android');

      expect(event.firebaseEventName, 'view_item');
      expect(event.facebookEventName, 'ViewContent');
  expect(event.firebaseParameters['items'], isA<List>());
      final fbParams = event.facebookParameters;
      expect(fbParams['content_type'], 'esim_bundle');
      expect(fbParams['value'], 9.99);
    });

    test('AddToCartEvent computes value * quantity', () {
      final item = EcommerceItem(id: 'b2', name: 'Bundle 2', category: 'esim_bundle', price: 5.5, quantity: 3);
      final event = AddToCartEvent(item: item, platform: 'ios', currency: 'eur');
      expect(event.firebaseParameters['value'], 16.5);
      expect(event.facebookParameters['value'], 16.5);
      expect(event.firebaseParameters['currency'], 'EUR');
    });

    test('BeginCheckoutEvent aggregates multiple items', () {
      final items = [
        EcommerceItem(id: 'b1', name: 'Bundle 1', category: 'esim_bundle', price: 5, quantity: 2),
        EcommerceItem(id: 'b2', name: 'Bundle 2', category: 'esim_bundle', price: 3, quantity: 1),
      ];
      final event = BeginCheckoutEvent(items: items, platform: 'android', currency: 'usd', shipping: 2, tax: 1);
      // value = 5*2 + 3*1 = 13
      expect(event.firebaseParameters['value'], 13.0);
      expect(event.facebookParameters['value'], 13.0);
      expect(event.firebaseParameters['shipping'], 2);
      expect(event.firebaseParameters['tax'], 1);
    });

    test('PurchaseEvent calculates gross - discount clamped at 0', () {
      final items = [
        EcommerceItem(id: 't1', name: 'Topup 1', category: 'topup', price: 10, quantity: 1),
      ];
      final event = PurchaseEvent(
        items: items,
        platform: 'ios',
        currency: 'usd',
        transactionId: 'TX123',
        purchaseType: 'topup',
        discount: 12, // discount > gross, expect value 0
      );
      expect(event.firebaseParameters['value'], 0);
      expect(event.facebookParameters['value'], 0);
      expect(event.firebaseParameters['transaction_id'], 'TX123');
      expect(event.facebookParameters['order_id'], 'TX123');
      expect(event.facebookParameters['purchase_type'], 'topup');
    });
  });
}
