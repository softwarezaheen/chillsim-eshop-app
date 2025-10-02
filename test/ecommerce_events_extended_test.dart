import 'package:flutter_test/flutter_test.dart';
import 'package:esim_open_source/domain/analytics/ecommerce_events.dart';

void main() {
  group('Ecommerce events extended coverage', () {
    test('ViewItemListEvent caps items at 10 and assigns sequential indexes', () {
      final items = List.generate(15, (i) => EcommerceItem(
        id: 'id$i',
        name: 'Name $i',
        category: 'esim_bundle',
        price: 1.0 + i,
        quantity: 1,
      ));
      final evt = ViewItemListEvent(
        listType: 'country',
        listId: 'list123',
        listName: 'Countries',
        items: items,
        platform: 'Android',
        currency: 'usd',
      );
      final firebaseItems = (evt.firebaseParameters['items'] as List).cast<Map<String,Object?>>();
      expect(firebaseItems.length, 10);
      for (int i=0;i<firebaseItems.length;i++) {
        expect(firebaseItems[i]['index'], i+1);
      }
      // Facebook value equals sum of first 10 prices
      final expectedValue = List.generate(10, (i)=>1.0+i).reduce((a,b)=>a+b);
      expect(evt.facebookParameters['value'], double.parse(expectedValue.toStringAsFixed(2)));
      expect(evt.facebookParameters['currency'], 'USD');
    });

    test('CurrencyResolver precedence order > bundle > app > fallback', () {
      expect(CurrencyResolver.resolve(orderCurrency: 'gbp', bundleCurrency: 'eur', appCurrency: 'usd'), 'GBP');
      expect(CurrencyResolver.resolve(orderCurrency: null, bundleCurrency: 'jpy', appCurrency: 'usd'), 'JPY');
      expect(CurrencyResolver.resolve(orderCurrency: null, bundleCurrency: null, appCurrency: 'cad'), 'CAD');
      expect(CurrencyResolver.resolve(orderCurrency: null, bundleCurrency: null, appCurrency: null), 'EUR');
    });

    test('BeginCheckoutEvent value aggregates correctly with shipping & tax', () {
      final items = [
        EcommerceItem(id: 'a', name: 'A', category: 'topup', price: 4.5, quantity: 2),
        EcommerceItem(id: 'b', name: 'B', category: 'topup', price: 1.0, quantity: 3),
      ];
      final evt = BeginCheckoutEvent(
        items: items,
        platform: 'iOS',
        currency: 'eur',
        shipping: 2.2,
        tax: 1.3,
      );
      // value = 4.5*2 + 1*3 = 12.0
      expect(evt.firebaseParameters['value'], 12.0);
      expect(evt.facebookParameters['shipping'], 2.2);
      expect(evt.facebookParameters['tax'], 1.3);
      expect(evt.firebaseParameters['currency'], 'EUR');
    });

    test('PurchaseEvent discount subtraction and non-negative clamp', () {
      final items = [EcommerceItem(id: 'p', name: 'Prod', category: 'esim_bundle', price: 20, quantity: 1)];
      final evt = PurchaseEvent(
        items: items,
        platform: 'Android',
        currency: 'usd',
        transactionId: 'TX1',
        purchaseType: 'bundle',
        discount: 25, // exceeds gross
        tax: 1.0,
      );
      expect(evt.firebaseParameters['value'], 0); // clamped
      expect(evt.facebookParameters['value'], 0); // clamped
      expect(evt.facebookParameters['order_id'], 'TX1');
      expect(evt.facebookParameters['purchase_type'], 'bundle');
    });

    test('AddToCartEvent value = price * quantity', () {
      final evt = AddToCartEvent(
        item: EcommerceItem(id: 'x', name: 'X', category: 'topup', price: 3.2, quantity: 4),
        platform: 'Android',
        currency: 'gbp',
      );
      expect(evt.firebaseParameters['value'], 12.8);
      expect(evt.facebookParameters['value'], 12.8);
      expect(evt.firebaseParameters['currency'], 'GBP');
    });

    test('ViewItemEvent basic mapping', () {
      final evt = ViewItemEvent(
        item: EcommerceItem(id: 'v', name: 'View', category: 'topup', price: 7.77),
        platform: 'iOS',
        currency: 'usd',
      );
      expect(evt.firebaseParameters['items'], isA<List>());
      expect(evt.facebookParameters['value'], 7.77);
      expect(evt.facebookParameters['currency'], 'USD');
    });
  });
}
