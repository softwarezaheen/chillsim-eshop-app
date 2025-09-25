import "package:esim_open_source/data/remote/responses/bundles/bundle_response_model.dart";
import "package:esim_open_source/data/remote/responses/user/payment_details_response_model.dart";
import "package:esim_open_source/utils/parsing_helper.dart";

class OrderHistoryResponseModel {
  OrderHistoryResponseModel({
    this.orderNumber,
    this.orderStatus,
    this.orderAmount,
    this.orderCurrency,
    this.orderFee,
    this.orderVat,
    this.orderDiscount,
    this.orderInvoice,
    this.orderDate,
    this.orderType,
    this.quantity,
    this.companyName,
    this.companyAddress,
    this.companyPhone,
    this.companyEmail,
    this.companyWebsite,
    this.orderDisplayPrice,
    this.paymentDetails,
    this.paymentType,
    this.promoCode,
    this.bundleDetails,
  });

  factory OrderHistoryResponseModel.fromJson({dynamic json}) {
    return OrderHistoryResponseModel(
      orderNumber: json["order_number"],
      orderStatus: json["order_status"],
      orderAmount: (json["order_amount"] as num?)?.toDouble(),
      orderCurrency: json["order_currency"],
      orderFee: (json["order_fee"] as num?)?.toDouble(),
      orderVat: (json["order_vat"] as num?)?.toDouble(),
      orderDiscount: (json["order_discount"] as num?)?.toDouble(),
      orderInvoice: json["order_invoice"],
      orderDate: json["order_date"],
      orderType: json["order_type"],
      quantity: json["quantity"],
      companyName: json["company_name"],
      companyAddress: json["company_address"],
      companyPhone: json["company_phone"],
      companyEmail: json["company_email"],
      companyWebsite: json["company_website"],
      orderDisplayPrice: json["order_display_price"],
      paymentDetails: json["payment_details"] != null
          ? PaymentDetailsResponseModel.fromJson(json["payment_details"])
          : null,
      paymentType: json["payment_type"],
      bundleDetails: json["bundle_details"] != null
          ? BundleResponseModel.fromJson(json: json["bundle_details"])
          : null,
      promoCode: json["promo_code"],
    );
  }

  final String? orderNumber;
  final String? orderStatus;
  final double? orderAmount;
  final double? orderFee;
  final double? orderVat;
  final double? orderDiscount;
  final String? orderInvoice;
  final String? orderCurrency;
  final String? orderDate;
  final String? orderType;
  final int? quantity;
  final String? companyName;
  final String? companyAddress;
  final String? companyPhone;
  final String? companyEmail;
  final String? companyWebsite;
  final String? orderDisplayPrice;
  final PaymentDetailsResponseModel? paymentDetails;
  final String? paymentType;
  final BundleResponseModel? bundleDetails;
  final String? promoCode;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      "order_number": orderNumber,
      "order_status": orderStatus,
      "order_amount": orderAmount,
      "order_fee": orderFee,
      "order_vat": orderVat,
      "order_discount": orderDiscount,
      "order_invoice": orderInvoice,
      "order_currency": orderCurrency,
      "order_date": orderDate,
      "order_type": orderType,
      "quantity": quantity,
      "company_name": companyName,
      "company_address": companyAddress,
      "company_phone": companyPhone,
      "company_email": companyEmail,
      "company_website": companyWebsite,
      "order_display_price": orderDisplayPrice,
      "payment_details": paymentDetails?.toJson(),
      "payment_type": paymentType,
      "bundle_details": bundleDetails?.toJson(),
      "promo_code": promoCode,
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
