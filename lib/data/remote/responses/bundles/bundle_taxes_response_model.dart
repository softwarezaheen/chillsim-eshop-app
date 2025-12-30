import "dart:convert";

BundleTaxesResponseModel bundleTaxesResponseModelFromJson(String str) =>
    BundleTaxesResponseModel.fromJson(json: json.decode(str));

String bundleTaxesResponseModelToJson(BundleTaxesResponseModel data) =>
    json.encode(data.toJson());

class BundleTaxesResponseModel {
  BundleTaxesResponseModel({
    this.fee,
    this.vat,
    this.originalAmount,
    this.total,
    this.currency,
    this.displayCurrency,
    this.exchangeRate,
    this.taxMode,
    this.feeEnabled,
  });

  factory BundleTaxesResponseModel.fromJson({dynamic json}) {
    int? parseOriginalAmount(dynamic value) {
      if (value == null) {
        return null;
      }
      if (value is int) {
        return value;
      }
      if (value is double) {
        return value.toInt();
      }
      if (value is String) {
        final double? parsed = double.tryParse(value);
        return parsed?.toInt();
      }
      return null;
    }
    return BundleTaxesResponseModel(
      fee: json["fee"],
      vat: json["vat"],
      originalAmount: parseOriginalAmount(json["original_amount"]),
      total: json["total"],
      currency: json["currency"],
      displayCurrency: json["display_currency"],
      exchangeRate: json["exchange_rate"],
      taxMode: json["tax_mode"] ?? "exclusive",  // inclusive, exclusive, none
      feeEnabled: json["fee_enabled"] ?? true,
    );
  }

  final int? fee;
  final int? vat;
  final int? originalAmount;
  final int? total;
  final String? currency;
  final String? displayCurrency;
  final double? exchangeRate;
  final String? taxMode;  // "inclusive", "exclusive", "none"
  final bool? feeEnabled;

  Map<String, dynamic> toJson() => <String, dynamic>{
        "fee": fee,
        "vat": vat,
        "originalAmount": originalAmount,
        "total": total,
        "currency": currency,
        "displayCurrency": displayCurrency,
        "exchangeRate": exchangeRate,
        "tax_mode": taxMode,
        "fee_enabled": feeEnabled,
      };
}
