import "package:esim_open_source/data/remote/responses/promotion/reward_application_type.dart";
import "package:esim_open_source/data/remote/responses/promotion/reward_history_response_model.dart";
import "package:esim_open_source/data/remote/responses/promotion/reward_type.dart";
import "package:flutter_test/flutter_test.dart";
import "../../../../fixtures/reward_history_mock_data.dart";

void main() {
  group("RewardHistoryResponseModel Parsing Tests", () {
    group("Complete Data Cases", () {
      test("parses complete cashback wallet credit data correctly", () {
        final Map<String, dynamic> json =
            rewardHistoryMockData["complete_cashback_wallet"]
                as Map<String, dynamic>;
        final RewardHistoryResponseModel model =
            RewardHistoryResponseModel.fromJson(json: json);

        expect(model.isReferral, true);
        expect(model.amount, "3.0 EUR");
        expect(model.name, "referrer@example.com");
        expect(model.date, "1760856180");
        expect(model.rewardType, RewardType.cashback);
        expect(model.applicationType, RewardApplicationType.walletCredit);
        expect(model.title, "Referrer Cashback");
        expect(
          model.description,
          "Cashback reward for referral code used by newuser@example.com",
        );
        expect(model.promotionCode, null);
        expect(model.referralFrom, "referrer@example.com");
        expect(model.orderId, "1bf20e77-26c8-41ad-a7b3-ac4518c92cdc");
        expect(model.status, "completed");
      });

      test("parses complete percentage discount order data correctly", () {
        final Map<String, dynamic> json =
            rewardHistoryMockData["complete_percentage_discount_order"]
                as Map<String, dynamic>;
        final RewardHistoryResponseModel model =
            RewardHistoryResponseModel.fromJson(json: json);

        expect(model.isReferral, false);
        expect(model.amount, "0.09 EUR");
        expect(model.rewardType, RewardType.discountPercentage);
        expect(model.applicationType, RewardApplicationType.orderDiscount);
        expect(model.title, "Percentage Discount");
        expect(model.promotionCode, "JOHN15");
        expect(model.referralFrom, null);
        expect(model.bundleName, "Turkey");
        expect(model.originalAmount, "0.60 EUR");
      });

      test("parses complete promo discount order data correctly", () {
        final Map<String, dynamic> json =
            rewardHistoryMockData["complete_promo_discount_order"]
                as Map<String, dynamic>;
        final RewardHistoryResponseModel model =
            RewardHistoryResponseModel.fromJson(json: json);

        expect(model.rewardType, RewardType.promoDiscount);
        expect(model.applicationType, RewardApplicationType.orderDiscount);
        expect(model.title, "Promo Code Discount");
        expect(model.promotionCode, "SUMMER2025");
        expect(model.bundleName, "Spain");
      });

      test("parses complete discount amount order data correctly", () {
        final Map<String, dynamic> json =
            rewardHistoryMockData["complete_discount_amount_order"]
                as Map<String, dynamic>;
        final RewardHistoryResponseModel model =
            RewardHistoryResponseModel.fromJson(json: json);

        expect(model.rewardType, RewardType.discountAmount);
        expect(model.applicationType, RewardApplicationType.orderDiscount);
        expect(model.title, "Fixed Discount");
        expect(model.amount, "10.00 EUR");
        expect(model.originalAmount, "50.00 EUR");
      });

      test("parses complete referral credit wallet data correctly", () {
        final Map<String, dynamic> json =
            rewardHistoryMockData["complete_referral_credit_wallet"]
                as Map<String, dynamic>;
        final RewardHistoryResponseModel model =
            RewardHistoryResponseModel.fromJson(json: json);

        expect(model.rewardType, RewardType.referralCredit);
        expect(model.applicationType, RewardApplicationType.walletCredit);
        expect(model.title, "Referral Bonus");
        expect(model.isReferral, true);
        expect(model.referralFrom, "friend@example.com");
      });
    });

    group("Legacy Data Cases (Backward Compatibility)", () {
      test("parses legacy referral data with fallback logic", () {
        final Map<String, dynamic> json =
            rewardHistoryMockData["legacy_referral"] as Map<String, dynamic>;
        final RewardHistoryResponseModel model =
            RewardHistoryResponseModel.fromJson(json: json);

        expect(model.isReferral, true);
        expect(model.amount, "2.5 EUR");
        expect(model.name, "olduser@example.com");
        expect(model.date, "1750000000");
        // New fields should be null
        expect(model.rewardType, null);
        expect(model.applicationType, null);
        expect(model.title, null);
        expect(model.description, null);
      });

      test("parses legacy promotion data with fallback logic", () {
        final Map<String, dynamic> json =
            rewardHistoryMockData["legacy_promotion"] as Map<String, dynamic>;
        final RewardHistoryResponseModel model =
            RewardHistoryResponseModel.fromJson(json: json);

        expect(model.isReferral, false);
        expect(model.amount, "1.50 EUR");
        expect(model.name, "Old Promotion");
        expect(model.promotionName, "Old Promotion");
        // New fields should be null
        expect(model.rewardType, null);
        expect(model.applicationType, null);
      });
    });

    group("Partial Data Cases", () {
      test("parses data with reward_type only", () {
        final Map<String, dynamic> json =
            rewardHistoryMockData["partial_with_reward_type_only"]
                as Map<String, dynamic>;
        final RewardHistoryResponseModel model =
            RewardHistoryResponseModel.fromJson(json: json);

        expect(model.rewardType, RewardType.discountPercentage);
        expect(model.applicationType, null);
        expect(model.title, null);
        expect(model.description, null);
      });

      test("parses data with application_type only", () {
        final Map<String, dynamic> json =
            rewardHistoryMockData["partial_with_application_type_only"]
                as Map<String, dynamic>;
        final RewardHistoryResponseModel model =
            RewardHistoryResponseModel.fromJson(json: json);

        expect(model.rewardType, null);
        expect(model.applicationType, RewardApplicationType.walletCredit);
      });
    });

    group("Null and Empty Value Cases", () {
      test("handles null amount gracefully", () {
        final Map<String, dynamic> json =
            rewardHistoryMockData["null_amount"] as Map<String, dynamic>;
        final RewardHistoryResponseModel model =
            RewardHistoryResponseModel.fromJson(json: json);

        expect(model.amount, null);
        expect(model.rewardType, RewardType.discountAmount);
        expect(model.status, "pending");
      });

      test("handles empty strings", () {
        final Map<String, dynamic> json =
            rewardHistoryMockData["empty_strings"] as Map<String, dynamic>;
        final RewardHistoryResponseModel model =
            RewardHistoryResponseModel.fromJson(json: json);

        expect(model.amount, "0.00 EUR");
        expect(model.name, "");
        expect(model.title, "");
        expect(model.description, "");
        expect(model.promotionCode, "");
        expect(model.referralFrom, "");
      });

      test("handles all null values", () {
        final Map<String, dynamic> json =
            rewardHistoryMockData["all_nulls"] as Map<String, dynamic>;
        final RewardHistoryResponseModel model =
            RewardHistoryResponseModel.fromJson(json: json);

        expect(model.isReferral, null);
        expect(model.amount, null);
        expect(model.name, null);
        expect(model.rewardType, null);
        expect(model.applicationType, null);
        expect(model.title, null);
        expect(model.description, null);
      });
    });

    group("Helper Methods", () {
      test("displayTitle returns title when available", () {
        final Map<String, dynamic> json =
            rewardHistoryMockData["complete_cashback_wallet"]
                as Map<String, dynamic>;
        final RewardHistoryResponseModel model =
            RewardHistoryResponseModel.fromJson(json: json);

        expect(model.displayTitle, "Referrer Cashback");
      });

      test("displayTitle falls back to name when title is null", () {
        final Map<String, dynamic> json =
            rewardHistoryMockData["legacy_promotion"] as Map<String, dynamic>;
        final RewardHistoryResponseModel model =
            RewardHistoryResponseModel.fromJson(json: json);

        expect(model.displayTitle, "Old Promotion");
      });

      test("displayTitle falls back to referralFrom when both title and name are empty",
          () {
        final Map<String, dynamic> json = {
          "is_referral": true,
          "amount": "5.00 EUR",
          "name": "",
          "promotion_name": "",
          "date": "1760000000",
          "title": null,
          "referral_from": "friend@example.com"
        };
        final RewardHistoryResponseModel model =
            RewardHistoryResponseModel.fromJson(json: json);

        expect(model.displayTitle, "friend@example.com");
      });

      test("displayTitle returns default when all fields are null/empty", () {
        final Map<String, dynamic> json =
            rewardHistoryMockData["all_nulls"] as Map<String, dynamic>;
        final RewardHistoryResponseModel model =
            RewardHistoryResponseModel.fromJson(json: json);

        // Falls back to "Reward" when all fields are null
        expect(model.displayTitle, "Reward");
      });

      test("displayDescription returns description when available", () {
        final Map<String, dynamic> json =
            rewardHistoryMockData["complete_cashback_wallet"]
                as Map<String, dynamic>;
        final RewardHistoryResponseModel model =
            RewardHistoryResponseModel.fromJson(json: json);

        expect(
          model.displayDescription,
          "Cashback reward for referral code used by newuser@example.com",
        );
      });

      test("displayDescription falls back to name when description is null",
          () {
        final Map<String, dynamic> json =
            rewardHistoryMockData["legacy_promotion"] as Map<String, dynamic>;
        final RewardHistoryResponseModel model =
            RewardHistoryResponseModel.fromJson(json: json);

        expect(model.displayDescription, "Old Promotion");
      });

      test("displayDescription returns empty string when both are null", () {
        final Map<String, dynamic> json =
            rewardHistoryMockData["all_nulls"] as Map<String, dynamic>;
        final RewardHistoryResponseModel model =
            RewardHistoryResponseModel.fromJson(json: json);

        expect(model.displayDescription, "");
      });

      test("isWalletCredit returns true for wallet_credit application type",
          () {
        final Map<String, dynamic> json =
            rewardHistoryMockData["complete_cashback_wallet"]
                as Map<String, dynamic>;
        final RewardHistoryResponseModel model =
            RewardHistoryResponseModel.fromJson(json: json);

        expect(model.isWalletCredit, true);
      });

      test("isWalletCredit returns false for order_discount application type",
          () {
        final Map<String, dynamic> json =
            rewardHistoryMockData["complete_percentage_discount_order"]
                as Map<String, dynamic>;
        final RewardHistoryResponseModel model =
            RewardHistoryResponseModel.fromJson(json: json);

        expect(model.isWalletCredit, false);
      });

      test("isWalletCredit falls back to is_referral when application_type is null",
          () {
        final Map<String, dynamic> json =
            rewardHistoryMockData["legacy_referral"] as Map<String, dynamic>;
        final RewardHistoryResponseModel model =
            RewardHistoryResponseModel.fromJson(json: json);

        expect(model.isWalletCredit, true); // is_referral is true
      });

      test("isWalletCredit returns false when both are null", () {
        final Map<String, dynamic> json =
            rewardHistoryMockData["all_nulls"] as Map<String, dynamic>;
        final RewardHistoryResponseModel model =
            RewardHistoryResponseModel.fromJson(json: json);

        // Returns false when application_type is null and is_referral is null/false
        expect(model.isWalletCredit, false);
      });
    });

    group("Edge Cases", () {
      test("handles both promotion_code and referral_from present", () {
        final Map<String, dynamic> json =
            rewardHistoryMockData["both_promo_and_referral"]
                as Map<String, dynamic>;
        final RewardHistoryResponseModel model =
            RewardHistoryResponseModel.fromJson(json: json);

        expect(model.promotionCode, "HYBRID2025");
        expect(model.referralFrom, "someone@example.com");
        // UI should prioritize promo code
      });

      test("handles long title string", () {
        final Map<String, dynamic> json =
            rewardHistoryMockData["long_title"] as Map<String, dynamic>;
        final RewardHistoryResponseModel model =
            RewardHistoryResponseModel.fromJson(json: json);

        expect(model.title, isNotEmpty);
        expect(model.title!.length, greaterThan(50));
      });

      test("handles long description string", () {
        final Map<String, dynamic> json =
            rewardHistoryMockData["long_description"] as Map<String, dynamic>;
        final RewardHistoryResponseModel model =
            RewardHistoryResponseModel.fromJson(json: json);

        expect(model.description, isNotEmpty);
        expect(model.description!.length, greaterThan(100));
      });

      test("handles long promo code", () {
        final Map<String, dynamic> json =
            rewardHistoryMockData["long_promo_code"] as Map<String, dynamic>;
        final RewardHistoryResponseModel model =
            RewardHistoryResponseModel.fromJson(json: json);

        expect(model.promotionCode, isNotEmpty);
        expect(model.promotionCode!.length, greaterThan(20));
      });

      test("handles long email addresses", () {
        final Map<String, dynamic> json =
            rewardHistoryMockData["long_referral_email"]
                as Map<String, dynamic>;
        final RewardHistoryResponseModel model =
            RewardHistoryResponseModel.fromJson(json: json);

        expect(model.referralFrom, contains("@"));
        expect(model.referralFrom!.length, greaterThan(30));
      });

      test("handles special characters", () {
        final Map<String, dynamic> json =
            rewardHistoryMockData["special_characters"] as Map<String, dynamic>;
        final RewardHistoryResponseModel model =
            RewardHistoryResponseModel.fromJson(json: json);

        expect(model.title, contains("Spécial"));
        expect(model.name, contains("&"));
      });

      test("handles different status values", () {
        final Map<String, dynamic> json1 =
            rewardHistoryMockData["status_pending"] as Map<String, dynamic>;
        final Map<String, dynamic> json2 =
            rewardHistoryMockData["status_failed"] as Map<String, dynamic>;
        final Map<String, dynamic> json3 =
            rewardHistoryMockData["status_expired"] as Map<String, dynamic>;

        final RewardHistoryResponseModel model1 =
            RewardHistoryResponseModel.fromJson(json: json1);
        final RewardHistoryResponseModel model2 =
            RewardHistoryResponseModel.fromJson(json: json2);
        final RewardHistoryResponseModel model3 =
            RewardHistoryResponseModel.fromJson(json: json3);

        expect(model1.status, "pending");
        expect(model2.status, "failed");
        expect(model3.status, "expired");
      });

      test("handles zero amount", () {
        final Map<String, dynamic> json =
            rewardHistoryMockData["zero_amount"] as Map<String, dynamic>;
        final RewardHistoryResponseModel model =
            RewardHistoryResponseModel.fromJson(json: json);

        expect(model.amount, "0.00 EUR");
      });

      test("handles large amount", () {
        final Map<String, dynamic> json =
            rewardHistoryMockData["large_amount"] as Map<String, dynamic>;
        final RewardHistoryResponseModel model =
            RewardHistoryResponseModel.fromJson(json: json);

        expect(model.amount, "999.99 EUR");
      });

      test("handles invalid reward_type gracefully", () {
        final Map<String, dynamic> json =
            rewardHistoryMockData["invalid_reward_type"]
                as Map<String, dynamic>;

        // Enums return null for invalid values instead of throwing
        final RewardHistoryResponseModel model =
            RewardHistoryResponseModel.fromJson(json: json);
        expect(model.rewardType, null);
      });

      test("handles invalid application_type gracefully", () {
        final Map<String, dynamic> json =
            rewardHistoryMockData["invalid_application_type"]
                as Map<String, dynamic>;

        // Enums return null for invalid values instead of throwing
        final RewardHistoryResponseModel model =
            RewardHistoryResponseModel.fromJson(json: json);
        expect(model.applicationType, null);
      });

      test("handles minimal valid data", () {
        final Map<String, dynamic> json =
            rewardHistoryMockData["minimal_valid"] as Map<String, dynamic>;
        final RewardHistoryResponseModel model =
            RewardHistoryResponseModel.fromJson(json: json);

        expect(model.isReferral, false);
        expect(model.amount, "1.00 EUR");
        expect(model.name, "Min");
        expect(model.date, "1761800000");
      });
    });

    group("Real-World Sample Data", () {
      test("parses real sample 1 correctly", () {
        final Map<String, dynamic> json =
            rewardHistoryMockData["real_sample_1"] as Map<String, dynamic>;
        final RewardHistoryResponseModel model =
            RewardHistoryResponseModel.fromJson(json: json);

        expect(model.isReferral, true);
        expect(model.rewardType, RewardType.cashback);
        expect(model.applicationType, RewardApplicationType.walletCredit);
        expect(model.referralFrom, "user1@example.com");
      });

      test("parses real sample 2 correctly", () {
        final Map<String, dynamic> json =
            rewardHistoryMockData["real_sample_2"] as Map<String, dynamic>;
        final RewardHistoryResponseModel model =
            RewardHistoryResponseModel.fromJson(json: json);

        expect(model.isReferral, true);
        expect(model.rewardType, RewardType.cashback);
        expect(model.referralFrom, "user2@example.com");
      });

      test("parses real sample 3 correctly", () {
        final Map<String, dynamic> json =
            rewardHistoryMockData["real_sample_3"] as Map<String, dynamic>;
        final RewardHistoryResponseModel model =
            RewardHistoryResponseModel.fromJson(json: json);

        expect(model.isReferral, false);
        expect(model.rewardType, RewardType.discountPercentage);
        expect(model.applicationType, RewardApplicationType.orderDiscount);
        expect(model.promotionCode, "REF15");
        expect(model.bundleName, "Turkey");
      });

      test("parses real sample 4 correctly", () {
        final Map<String, dynamic> json =
            rewardHistoryMockData["real_sample_4"] as Map<String, dynamic>;
        final RewardHistoryResponseModel model =
            RewardHistoryResponseModel.fromJson(json: json);

        expect(model.isReferral, false);
        expect(model.rewardType, RewardType.discountPercentage);
        expect(model.promotionCode, "TEST-233");
        expect(model.orderId, null);
        expect(model.bundleName, null);
      });
    });

    group("Enum Parsing", () {
      test("parses all RewardType enum values", () {
        expect(
          RewardType.fromString("referral_credit"),
          RewardType.referralCredit,
        );
        expect(RewardType.fromString("cashback"), RewardType.cashback);
        expect(
          RewardType.fromString("promo_discount"),
          RewardType.promoDiscount,
        );
        expect(
          RewardType.fromString("discount_amount"),
          RewardType.discountAmount,
        );
        expect(
          RewardType.fromString("discount_percentage"),
          RewardType.discountPercentage,
        );
      });

      test("RewardType.fromString returns null for invalid value", () {
        // Enums return null for invalid values instead of throwing
        expect(RewardType.fromString("invalid"), null);
      });

      test("parses all RewardApplicationType enum values", () {
        expect(
          RewardApplicationType.fromString("wallet_credit"),
          RewardApplicationType.walletCredit,
        );
        expect(
          RewardApplicationType.fromString("order_discount"),
          RewardApplicationType.orderDiscount,
        );
      });

      test("RewardApplicationType.fromString returns null for invalid value",
          () {
        // Enums return null for invalid values instead of throwing
        expect(RewardApplicationType.fromString("invalid"), null);
      });
    });

    group("JSON Serialization", () {
      test("toJson includes all fields", () {
        final Map<String, dynamic> json =
            rewardHistoryMockData["complete_cashback_wallet"]
                as Map<String, dynamic>;
        final RewardHistoryResponseModel model =
            RewardHistoryResponseModel.fromJson(json: json);

        final Map<String, dynamic> serialized = model.toJson();

        expect(serialized["is_referral"], true);
        expect(serialized["amount"], "3.0 EUR");
        // reward_type is cashback, not referral_credit
        expect(serialized["reward_type"], "cashback");
        expect(serialized["application_type"], "wallet_credit");
        expect(serialized["title"], "Referrer Cashback");
      });

      test("toJson handles null values", () {
        final Map<String, dynamic> json =
            rewardHistoryMockData["legacy_referral"] as Map<String, dynamic>;
        final RewardHistoryResponseModel model =
            RewardHistoryResponseModel.fromJson(json: json);

        final Map<String, dynamic> serialized = model.toJson();

        expect(serialized["reward_type"], null);
        expect(serialized["application_type"], null);
        expect(serialized["title"], null);
      });
    });
  });
}
