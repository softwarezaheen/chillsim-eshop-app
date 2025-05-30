class PaymentDetailsResponseModel {
  PaymentDetailsResponseModel({
    this.id,
    this.description,
    this.paymentMethod,
    this.cardNumber,
    this.receiptEmail,
    this.address,
    this.displayBrand,
    this.country,
    this.cardDisplay,
  });

  factory PaymentDetailsResponseModel.fromJson(Map<String, dynamic> json) {
    return PaymentDetailsResponseModel(
      id: json["id"],
      description: json["description"],
      paymentMethod: json["payment_method"],
      cardNumber: json["card_number"],
      receiptEmail: json["receipt_email"],
      address: json["address"],
      displayBrand: json["display_brand"],
      country: json["country"],
      cardDisplay: json["card_display"],
    );
  }

  final String? id;
  final String? description;
  final String? paymentMethod;
  final String? cardNumber;
  final String? receiptEmail;
  final String? address;
  final String? displayBrand;
  final String? country;
  final String? cardDisplay;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      "id": id,
      "description": description,
      "payment_method": paymentMethod,
      "card_number": cardNumber,
      "receipt_email": receiptEmail,
      "address": address,
      "display_brand": displayBrand,
      "country": country,
      "card_display": cardDisplay,
    };
  }

  PaymentDetailsResponseModel mockData() => PaymentDetailsResponseModel(
        id: "12345",
        description: "description",
        paymentMethod: "payment method",
        cardNumber: "4444",
        receiptEmail: "raed.nakour27@gmail.com",
        address: "Address",
        displayBrand: "display brand",
        country: "country",
        cardDisplay: "Visa ****4242",
      );
}
