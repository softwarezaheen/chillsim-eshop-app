// Unified GA4 + Facebook Ecommerce event models
// This file intentionally keeps logic minimal: build provider-specific parameter maps

import "package:esim_open_source/domain/repository/services/analytics_service.dart";

// Currency resolution helper with precedence: order > bundle > app > fallback(EUR)
class CurrencyResolver {
  static String resolve({
    String? orderCurrency,
    String? bundleCurrency,
    String? appCurrency,
    String fallback = "EUR",
  }) {
    final String chosen = (orderCurrency?.trim().isNotEmpty ?? false
            ? orderCurrency!
            : bundleCurrency?.trim().isNotEmpty ?? false
                ? bundleCurrency!
                : appCurrency?.trim().isNotEmpty ?? false
                    ? appCurrency!
                    : fallback)
        .toUpperCase();
    return chosen;
  }
}

class EcommerceItem {
  const EcommerceItem({
    required this.id,
    required this.name,
    required this.category, // esim_bundle | topup | country_bundles | region_bundles | topup_options
    required this.price,
    this.quantity = 1,
    this.index,
  });
  final String id;
  final String name;
  final String category;
  final double price;
  final int quantity;
  final int? index; // 1-based list position

  Map<String, Object?> toGa4() => <String, Object?>{
        "item_id": id,
        "item_name": name,
        "item_category": category,
        "item_brand": "ChillSIM",
        if (index != null) "index": index,
        "price": price,
        "quantity": quantity,
      };

  Map<String, Object?> toFacebookContent() => <String, Object?>{
        "id": id,
        "quantity": quantity,
        "item_price": price,
      };
}

abstract class DualProviderEvent extends AnalyticEvent {
  const DualProviderEvent(super.eventName);
  String get firebaseEventName;
  String get facebookEventName;
  Map<String, Object?> get firebaseParameters;
  Map<String, Object?> get facebookParameters;

  @override
  Map<String, Object>? get parameters {
    // Provide Firebase params flattened for legacy path
    final Map<String, Object> out = <String, Object>{};
    firebaseParameters.forEach((String k, Object? v) {
      if (v != null) {
        out[k] = v;
      }
    });
    return out;
  }
}

class ViewItemListEvent extends DualProviderEvent {
  ViewItemListEvent({
    required this.listType, // country | region | topup
    required List<EcommerceItem> items,
    required this.platform, this.listId,
    this.listName,
    String? currency, // only for FB value metric
  })  : items = items.take(10).toList(growable: false),
        currency = (currency ?? "EUR").toUpperCase(),
        super("view_item_list");

  final String listType;
  final String? listId;
  final String? listName;
  final List<EcommerceItem> items;
  final String platform;
  final String currency; // for Facebook value

  @override
  String get firebaseEventName => "view_item_list";
  @override
  String get facebookEventName => "ViewItemList"; // custom name

  @override
  Map<String, Object?> get firebaseParameters => <String, Object?>{
        if (listId != null) "item_list_id": listId,
        "item_list_name": listName ?? listType,
        "list_type": listType,
        "platform": platform,
        "items": <Map<String, Object?>>[
          for (int i = 0; i < items.length; i++)
            items[i].toGa4()..putIfAbsent("index", () => i + 1),
        ],
      };

  @override
  Map<String, Object?> get facebookParameters => <String, Object?>{
        "content_type": listType,
        "content_ids": <String>[for (final EcommerceItem e in items) e.id],
        "contents": <Map<String, Object?>>[for (final EcommerceItem e in items) e.toFacebookContent()],
        "value": double.parse(items
            .fold<double>(0, (double acc, EcommerceItem e) => acc + e.price * e.quantity)
            .toStringAsFixed(2),),
        "currency": currency,
        "platform": platform,
        "list_type": listType,
      };
}

class ViewItemEvent extends DualProviderEvent {
  ViewItemEvent({
    required this.item,
    required this.platform,
    String? currency,
  })  : currency = (currency ?? "EUR").toUpperCase(),
        super("view_item");
  final EcommerceItem item; // category: esim_bundle | topup
  final String platform;
  final String currency;
  @override
  String get firebaseEventName => "view_item";
  @override
  String get facebookEventName => "ViewContent";
  @override
  Map<String, Object?> get firebaseParameters => <String, Object?>{
        "platform": platform,
        "items": <Map<String, Object?>>[item.toGa4()],
      };
  @override
  Map<String, Object?> get facebookParameters => <String, Object?>{
        "content_type": item.category,
        "content_ids": <String>[item.id],
        "contents": <Map<String, Object?>>[item.toFacebookContent()],
        "value": double.parse((item.price * item.quantity).toStringAsFixed(2)),
        "currency": currency,
        "platform": platform,
      };
}

class AddToCartEvent extends DualProviderEvent {
  AddToCartEvent({
    required this.item,
    required this.platform,
    required String currency,
  })  : currency = currency.toUpperCase(),
        super("add_to_cart");
  final EcommerceItem item;
  final String platform;
  final String currency;
  @override
  String get firebaseEventName => "add_to_cart";
  @override
  String get facebookEventName => "AddToCart";
  @override
  Map<String, Object?> get firebaseParameters => <String, Object?>{
        "platform": platform,
        "currency": currency,
        "value": double.parse((item.price * item.quantity).toStringAsFixed(2)),
        "items": <Map<String, Object?>>[item.toGa4()],
      };
  @override
  Map<String, Object?> get facebookParameters => <String, Object?>{
        "content_type": item.category,
        "content_ids": <String>[item.id],
        "contents": <Map<String, Object?>>[item.toFacebookContent()],
        "value": double.parse((item.price * item.quantity).toStringAsFixed(2)),
        "currency": currency,
        "platform": platform,
      };
}

class BeginCheckoutEvent extends DualProviderEvent {
  BeginCheckoutEvent({
    required List<EcommerceItem> items,
    required this.platform,
    required String currency,
    this.coupon,
    this.shipping = 0.0,
    this.tax = 0.0,
  })  : items = List<EcommerceItem>.unmodifiable(items),
        currency = currency.toUpperCase(),
        super("begin_checkout");
  final List<EcommerceItem> items;
  final String platform;
  final String currency;
  final String? coupon;
  final double shipping; // fee
  final double tax;
  double get value => items.fold<double>(0, (double acc, EcommerceItem e) => acc + e.price * e.quantity);
  @override
  String get firebaseEventName => "begin_checkout";
  @override
  String get facebookEventName => "InitiateCheckout";
  @override
  Map<String, Object?> get firebaseParameters => <String, Object?>{
        "platform": platform,
        "currency": currency,
        "value": double.parse(value.toStringAsFixed(2)),
        if (shipping > 0) "shipping": shipping,
        if (tax > 0) "tax": tax,
        if (coupon != null && coupon!.isNotEmpty) "coupon": coupon,
        "items": <Map<String, Object?>>[for (final EcommerceItem e in items) e.toGa4()],
      };
  @override
  Map<String, Object?> get facebookParameters => <String, Object?>{
        "content_type": items.isNotEmpty ? items.first.category : "bundle",
        "content_ids": <String>[for (final EcommerceItem e in items) e.id],
        "contents": <Map<String, Object?>>[for (final EcommerceItem e in items) e.toFacebookContent()],
        "value": double.parse(value.toStringAsFixed(2)),
        "currency": currency,
        if (shipping > 0) "shipping": shipping,
        if (tax > 0) "tax": tax,
        if (coupon != null && coupon!.isNotEmpty) "coupon": coupon,
        "platform": platform,
      };
}

class PurchaseEvent extends DualProviderEvent {
  PurchaseEvent({
    required List<EcommerceItem> items,
    required this.platform,
    required String currency,
    required this.transactionId,
    required this.purchaseType, // bundle | topup
    this.coupon,
    this.shipping = 0.0,
    this.tax = 0.0,
    this.discount = 0.0,
  })  : items = List<EcommerceItem>.unmodifiable(items),
        currency = currency.toUpperCase(),
        super("purchase");
  final List<EcommerceItem> items;
  final String platform;
  final String currency;
  final String transactionId;
  final String purchaseType; // bundle | topup
  final String? coupon;
  final double shipping;
  final double tax;
  final double discount;
  double get gross => items.fold<double>(0, (double acc, EcommerceItem e) => acc + e.price * e.quantity);
  double get value => (gross - discount) < 0 ? 0 : double.parse((gross - discount).toStringAsFixed(2));
  @override
  String get firebaseEventName => "purchase";
  @override
  String get facebookEventName => "Purchase";
  @override
  Map<String, Object?> get firebaseParameters => <String, Object?>{
        "transaction_id": transactionId,
        "currency": currency,
        "value": value,
        if (tax > 0) "tax": tax,
        if (shipping > 0) "shipping": shipping,
        if (coupon != null && coupon!.isNotEmpty) "coupon": coupon,
        "platform": platform,
        "purchase_type": purchaseType,
        "items": <Map<String, Object?>>[for (final EcommerceItem e in items) e.toGa4()],
      };
  @override
  Map<String, Object?> get facebookParameters => <String, Object?>{
        "content_type": purchaseType,
        "content_ids": <String>[for (final EcommerceItem e in items) e.id],
        "contents": <Map<String, Object?>>[for (final EcommerceItem e in items) e.toFacebookContent()],
        "value": value,
        "currency": currency,
        if (coupon != null && coupon!.isNotEmpty) "coupon": coupon,
        "num_items": items.length,
        "order_id": transactionId,
        if (tax > 0) "tax": tax,
        if (shipping > 0) "shipping": shipping,
        "platform": platform,
        "purchase_type": purchaseType,
      };
}
