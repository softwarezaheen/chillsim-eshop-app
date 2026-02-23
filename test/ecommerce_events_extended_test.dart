import "package:esim_open_source/domain/analytics/ecommerce_events.dart";
import "package:flutter_test/flutter_test.dart";

void main() {
  group("Ecommerce events extended coverage", () {
    test("ViewItemListEvent caps items at 10 and assigns sequential indexes", () {
      final List<EcommerceItem> items = List.generate(15, (int i) => EcommerceItem(
        id: "id$i",
        name: "Name $i",
        category: "esim_bundle",
        price: 1.0 + i,
      ),);
      final ViewItemListEvent evt = ViewItemListEvent(
        listType: "country",
        listId: "list123",
        listName: "Countries",
        items: items,
        platform: "Android",
        currency: "usd",
      );
      final List<Map<String, Object?>> firebaseItems = (evt.firebaseParameters["items"]! as List).cast<Map<String,Object?>>();
      expect(firebaseItems.length, 10);
      for (int i=0;i<firebaseItems.length;i++) {
        expect(firebaseItems[i]["index"], i+1);
      }
      // Facebook value equals sum of first 10 prices
      final double expectedValue = List.generate(10, (int i)=>1.0+i).reduce((double a,double b)=>a+b);
      expect(evt.facebookParameters["value"], double.parse(expectedValue.toStringAsFixed(2)));
      expect(evt.facebookParameters["currency"], "USD");
    });

    test("CurrencyResolver precedence order > bundle > app > fallback", () {
      expect(CurrencyResolver.resolve(orderCurrency: "gbp", bundleCurrency: "eur", appCurrency: "usd"), "GBP");
      expect(CurrencyResolver.resolve(bundleCurrency: "jpy", appCurrency: "usd"), "JPY");
      expect(CurrencyResolver.resolve(appCurrency: "cad"), "CAD");
      expect(CurrencyResolver.resolve(), "EUR");
    });

    test("BeginCheckoutEvent value aggregates correctly with shipping & tax", () {
      final List<EcommerceItem> items = <EcommerceItem>[
        const EcommerceItem(id: "a", name: "A", category: "topup", price: 4.5, quantity: 2),
        const EcommerceItem(id: "b", name: "B", category: "topup", price: 1, quantity: 3),
      ];
      final BeginCheckoutEvent evt = BeginCheckoutEvent(
        items: items,
        platform: "iOS",
        currency: "eur",
        shipping: 2.2,
        tax: 1.3,
      );
      // value = 4.5*2 + 1*3 = 12.0
      expect(evt.firebaseParameters["value"], 12.0);
      expect(evt.facebookParameters["shipping"], 2.2);
      expect(evt.facebookParameters["tax"], 1.3);
      expect(evt.firebaseParameters["currency"], "EUR");
    });

    test("PurchaseEvent discount subtraction and non-negative clamp", () {
      final List<EcommerceItem> items = <EcommerceItem>[const EcommerceItem(id: "p", name: "Prod", category: "esim_bundle", price: 20)];
      final PurchaseEvent evt = PurchaseEvent(
        items: items,
        platform: "Android",
        currency: "usd",
        transactionId: "TX1",
        purchaseType: "bundle",
        discount: 25, // exceeds gross
        tax: 1,
      );
      expect(evt.firebaseParameters["value"], 0); // clamped
      expect(evt.facebookParameters["value"], 0); // clamped
      expect(evt.facebookParameters["order_id"], "TX1");
      expect(evt.facebookParameters["purchase_type"], "bundle");
    });

    test("AddToCartEvent value = price * quantity", () {
      final AddToCartEvent evt = AddToCartEvent(
        item: const EcommerceItem(id: "x", name: "X", category: "topup", price: 3.2, quantity: 4),
        platform: "Android",
        currency: "gbp",
      );
      expect(evt.firebaseParameters["value"], 12.8);
      expect(evt.facebookParameters["value"], 12.8);
      expect(evt.firebaseParameters["currency"], "GBP");
    });

    test("ViewItemEvent basic mapping", () {
      final ViewItemEvent evt = ViewItemEvent(
        item: const EcommerceItem(id: "v", name: "View", category: "topup", price: 7.77),
        platform: "iOS",
        currency: "usd",
      );
      expect(evt.firebaseParameters["items"], isA<List>());
      expect(evt.facebookParameters["value"], 7.77);
      expect(evt.facebookParameters["currency"], "USD");
    });
  });
}
