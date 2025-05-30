import "package:esim_open_source/data/remote/responses/bundles/bundle_response_model.dart";
import "package:esim_open_source/data/remote/responses/user/payment_details_response_model.dart";
import "package:esim_open_source/utils/parsing_helper.dart";

class OrderHistoryResponseModel {
  OrderHistoryResponseModel({
    this.orderNumber,
    this.orderStatus,
    this.orderAmount,
    this.orderCurrency,
    this.orderDate,
    this.orderType,
    this.quantity,
    this.companyName,
    this.orderDisplayPrice,
    this.paymentDetails,
    this.bundleDetails,
  });

  factory OrderHistoryResponseModel.fromJson({dynamic json}) {
    return OrderHistoryResponseModel(
      orderNumber: json["order_number"],
      orderStatus: json["order_status"],
      orderAmount: (json["order_amount"] as num?)?.toDouble(),
      orderCurrency: json["order_currency"],
      orderDate: json["order_date"],
      orderType: json["order_type"],
      quantity: json["quantity"],
      companyName: json["company_name"],
      orderDisplayPrice: json["order_display_price"],
      paymentDetails: json["payment_details"] != null
          ? PaymentDetailsResponseModel.fromJson(json["payment_details"])
          : null,
      bundleDetails: json["bundle_details"] != null
          ? BundleResponseModel.fromJson(json: json["bundle_details"])
          : null,
    );
  }

  final String? orderNumber;
  final String? orderStatus;
  final double? orderAmount;
  final String? orderCurrency;
  final String? orderDate;
  final String? orderType;
  final int? quantity;
  final String? companyName;
  final String? orderDisplayPrice;
  final PaymentDetailsResponseModel? paymentDetails;
  final BundleResponseModel? bundleDetails;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      "order_number": orderNumber,
      "order_status": orderStatus,
      "order_amount": orderAmount,
      "order_currency": orderCurrency,
      "order_date": orderDate,
      "order_type": orderType,
      "quantity": quantity,
      "company_name": companyName,
      "order_display_price": orderDisplayPrice,
      "payment_details": paymentDetails?.toJson(),
      "bundle_details": bundleDetails?.toJson(),
    };
  }

  static List<OrderHistoryResponseModel> fromJsonList({dynamic json}) {
    return fromJsonListTyped(
      json: json,
      parser: OrderHistoryResponseModel.fromJson,
    );
  }

  List<OrderHistoryResponseModel> mockData() => <OrderHistoryResponseModel>[
        OrderHistoryResponseModel(
          orderNumber: "ada2964e-81df-4a39-ab34-f1adde6e7b15",
          orderStatus: "order status",
          orderAmount: 355,
          orderCurrency: "USD",
          orderDate: "12344",
          orderType: "order Type",
          quantity: 2,
          companyName: "Monty Mobile",
          orderDisplayPrice: "2.5 USD",
          paymentDetails: PaymentDetailsResponseModel().mockData(),
          bundleDetails: BundleResponseModel.getMockGlobalBundles().first,
        ),
        OrderHistoryResponseModel(
          orderNumber: "ada2964e-81df-4a39-ab34-f1adde6e7b15",
          orderStatus: "order status",
          orderAmount: 355,
          orderCurrency: "USD",
          orderDate: "12344",
          orderType: "order Type",
          quantity: 2,
          companyName: "Monty Mobile",
          orderDisplayPrice: "2.5 USD",
          paymentDetails: PaymentDetailsResponseModel().mockData(),
          bundleDetails: BundleResponseModel.getMockGlobalBundles().first,
        ),
        OrderHistoryResponseModel(
          orderNumber: "ada2964e-81df-4a39-ab34-f1adde6e7b15",
          orderStatus: "order status",
          orderAmount: 355,
          orderCurrency: "USD",
          orderDate: "12344",
          orderType: "order Type",
          quantity: 2,
          companyName: "Monty Mobile",
          orderDisplayPrice: "2.5 USD",
          paymentDetails: PaymentDetailsResponseModel().mockData(),
          bundleDetails: BundleResponseModel.getMockGlobalBundles().first,
        ),
        OrderHistoryResponseModel(
          orderNumber: "ada2964e-81df-4a39-ab34-f1adde6e7b15",
          orderStatus: "order status",
          orderAmount: 355,
          orderCurrency: "USD",
          orderDate: "12344",
          orderType: "order Type",
          quantity: 2,
          companyName: "Monty Mobile",
          orderDisplayPrice: "2.5 USD",
          paymentDetails: PaymentDetailsResponseModel().mockData(),
          bundleDetails: BundleResponseModel.getMockGlobalBundles().first,
        ),
        OrderHistoryResponseModel(
          orderNumber: "ada2964e-81df-4a39-ab34-f1adde6e7b15",
          orderStatus: "order status",
          orderAmount: 355,
          orderCurrency: "USD",
          orderDate: "12344",
          orderType: "order Type",
          quantity: 2,
          companyName: "Monty Mobile",
          orderDisplayPrice: "2.5 USD",
          paymentDetails: PaymentDetailsResponseModel().mockData(),
          bundleDetails: BundleResponseModel.getMockGlobalBundles().first,
        ),
        OrderHistoryResponseModel(
          orderNumber: "ada2964e-81df-4a39-ab34-f1adde6e7b15",
          orderStatus: "order status",
          orderAmount: 355,
          orderCurrency: "USD",
          orderDate: "12344",
          orderType: "order Type",
          quantity: 2,
          companyName: "Monty Mobile",
          orderDisplayPrice: "2.5 USD",
          paymentDetails: PaymentDetailsResponseModel().mockData(),
          bundleDetails: BundleResponseModel.getMockGlobalBundles().first,
        ),
      ];
}
