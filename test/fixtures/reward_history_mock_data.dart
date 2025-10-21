/// Comprehensive mock data for testing RewardHistoryResponseModel
/// 
/// This file contains edge cases and real-world scenarios including:
/// - All reward_type combinations (referralCredit, cashback, promoDiscount, discountAmount, discountPercentage)
/// - All application_type combinations (wallet_credit, order_discount)
/// - Null values, empty strings, missing optional fields
/// - Legacy data (only old fields present)
/// - Complete data (all fields present)
/// - Various status values
/// - Different date formats
/// - Long strings for testing overflow
/// - Special characters in strings

const Map<String, dynamic> rewardHistoryMockData = {
  // COMPLETE DATA CASES - All fields present
  "complete_cashback_wallet": {
    "is_referral": true,
    "amount": "3.0 EUR",
    "name": "referrer@example.com",
    "promotion_name": "",
    "date": "1760856180",
    "reward_type": "cashback",
    "application_type": "wallet_credit",
    "original_amount": null,
    "title": "Referrer Cashback",
    "description": "Cashback reward for referral code used by newuser@example.com",
    "promotion_code": null,
    "referral_from": "referrer@example.com",
    "order_id": "1bf20e77-26c8-41ad-a7b3-ac4518c92cdc",
    "bundle_name": null,
    "status": "completed"
  },

  "complete_percentage_discount_order": {
    "is_referral": false,
    "amount": "0.09 EUR",
    "name": "Discount 15% for customers referred by John Doe",
    "promotion_name": "Discount 15% for customers referred by John Doe",
    "date": "1760369123",
    "reward_type": "discount_percentage",
    "application_type": "order_discount",
    "original_amount": "0.60 EUR",
    "title": "Percentage Discount",
    "description": "Discount applied: Discount 15% for customers referred by John Doe",
    "promotion_code": "JOHN15",
    "referral_from": null,
    "order_id": "766d6176-1ab1-4f35-82eb-4018c81d9bdc",
    "bundle_name": "Turkey",
    "status": "completed"
  },

  "complete_promo_discount_order": {
    "is_referral": false,
    "amount": "5.00 EUR",
    "name": "Summer Sale 2025",
    "promotion_name": "Summer Sale 2025",
    "date": "1758962700",
    "reward_type": "promo_discount",
    "application_type": "order_discount",
    "original_amount": "25.00 EUR",
    "title": "Promo Code Discount",
    "description": "Special promotional discount for summer season",
    "promotion_code": "SUMMER2025",
    "referral_from": null,
    "order_id": "abc12345-def6-7890-ghij-klmnopqrstuv",
    "bundle_name": "Spain",
    "status": "completed"
  },

  "complete_discount_amount_order": {
    "is_referral": false,
    "amount": "10.00 EUR",
    "name": "Fixed Amount Discount",
    "promotion_name": "Fixed Amount Discount",
    "date": "1760000000",
    "reward_type": "discount_amount",
    "application_type": "order_discount",
    "original_amount": "50.00 EUR",
    "title": "Fixed Discount",
    "description": "Get €10 off your next purchase",
    "promotion_code": "SAVE10",
    "referral_from": null,
    "order_id": "xyz98765-abc4-3210-defg-hijklmnopqrs",
    "bundle_name": "France",
    "status": "completed"
  },

  "complete_referral_credit_wallet": {
    "is_referral": true,
    "amount": "5.00 EUR",
    "name": "friend@example.com",
    "promotion_name": "",
    "date": "1760500000",
    "reward_type": "referral_credit",
    "application_type": "wallet_credit",
    "original_amount": null,
    "title": "Referral Bonus",
    "description": "Thank you for referring a friend!",
    "promotion_code": null,
    "referral_from": "friend@example.com",
    "order_id": "ref12345-6789-0abc-defg-hijklmnopqrs",
    "bundle_name": null,
    "status": "completed"
  },

  // LEGACY DATA CASES - Only old fields present (backward compatibility)
  "legacy_referral": {
    "is_referral": true,
    "amount": "2.5 EUR",
    "name": "olduser@example.com",
    "promotion_name": "",
    "date": "1750000000"
  },

  "legacy_promotion": {
    "is_referral": false,
    "amount": "1.50 EUR",
    "name": "Old Promotion",
    "promotion_name": "Old Promotion",
    "date": "1749000000"
  },

  // PARTIAL DATA CASES - Mix of old and new fields
  "partial_with_reward_type_only": {
    "is_referral": false,
    "amount": "3.00 EUR",
    "name": "Test Promotion",
    "promotion_name": "Test Promotion",
    "date": "1758000000",
    "reward_type": "discount_percentage",
    "application_type": null,
    "title": null,
    "description": null
  },

  "partial_with_application_type_only": {
    "is_referral": true,
    "amount": "4.00 EUR",
    "name": "friend2@example.com",
    "promotion_name": "",
    "date": "1759000000",
    "reward_type": null,
    "application_type": "wallet_credit",
    "title": null,
    "description": null
  },

  // NULL AND EMPTY VALUE CASES
  "null_amount": {
    "is_referral": false,
    "amount": null,
    "name": "Test",
    "promotion_name": "Test",
    "date": "1760000000",
    "reward_type": "discount_amount",
    "application_type": "order_discount",
    "title": "Test Reward",
    "description": "Test description",
    "status": "pending"
  },

  "empty_strings": {
    "is_referral": false,
    "amount": "0.00 EUR",
    "name": "",
    "promotion_name": "",
    "date": "1760000000",
    "reward_type": "promo_discount",
    "application_type": "wallet_credit",
    "title": "",
    "description": "",
    "promotion_code": "",
    "referral_from": "",
    "order_id": "",
    "bundle_name": "",
    "status": "completed"
  },

  "all_nulls": {
    "is_referral": null,
    "amount": null,
    "name": null,
    "promotion_name": null,
    "date": null,
    "reward_type": null,
    "application_type": null,
    "original_amount": null,
    "title": null,
    "description": null,
    "promotion_code": null,
    "referral_from": null,
    "order_id": null,
    "bundle_name": null,
    "status": null
  },

  // EDGE CASE: Both promotion_code and referral_from present (should prioritize promo code)
  "both_promo_and_referral": {
    "is_referral": false,
    "amount": "7.50 EUR",
    "name": "Hybrid Reward",
    "promotion_name": "Hybrid Reward",
    "date": "1760600000",
    "reward_type": "cashback",
    "application_type": "wallet_credit",
    "title": "Special Reward",
    "description": "Both promo and referral data present",
    "promotion_code": "HYBRID2025",
    "referral_from": "someone@example.com",
    "status": "completed"
  },

  // LONG STRING CASES - Testing text overflow
  "long_title": {
    "is_referral": false,
    "amount": "12.00 EUR",
    "name": "Very Long Promotion Name That Should Be Truncated",
    "promotion_name": "Very Long Promotion Name That Should Be Truncated",
    "date": "1760700000",
    "reward_type": "discount_amount",
    "application_type": "order_discount",
    "title": "This is an extremely long title that should be truncated with ellipsis to fit within the card layout constraints",
    "description": "Short description",
    "promotion_code": "LONGCODE123456789",
    "status": "completed"
  },

  "long_description": {
    "is_referral": false,
    "amount": "8.00 EUR",
    "name": "Long Description Test",
    "promotion_name": "Long Description Test",
    "date": "1760800000",
    "reward_type": "promo_discount",
    "application_type": "wallet_credit",
    "title": "Standard Title",
    "description": "This is an extremely long description that spans multiple lines and should be truncated after two lines to maintain a clean card layout. It contains lots of information about the promotion and how it was applied to the customer's account. Additional details would normally be shown in a detail view.",
    "promotion_code": "DESC2025",
    "status": "completed"
  },

  "long_promo_code": {
    "is_referral": false,
    "amount": "15.00 EUR",
    "name": "Long Code Test",
    "promotion_name": "Long Code Test",
    "date": "1760900000",
    "reward_type": "discount_percentage",
    "application_type": "order_discount",
    "title": "Code Test",
    "description": "Testing very long promotion code",
    "promotion_code": "VERYLONGPROMOTIONCODE2025THATSHOULDBETRUNCAT",
    "status": "completed"
  },

  "long_referral_email": {
    "is_referral": true,
    "amount": "3.50 EUR",
    "name": "verylongemailaddress@subdomain.example.com",
    "promotion_name": "",
    "date": "1761000000",
    "reward_type": "referral_credit",
    "application_type": "wallet_credit",
    "title": "Referral Bonus",
    "description": "Long email address test",
    "referral_from": "verylongemailaddresswithlotsocharacters@subdomain.example.com",
    "status": "completed"
  },

  // SPECIAL CHARACTERS CASES
  "special_characters": {
    "is_referral": false,
    "amount": "6.00 EUR",
    "name": "Spécial Prömötîön & Dîsçöunt 50%",
    "promotion_name": "Spécial Prömötîön & Dîsçöunt 50%",
    "date": "1761100000",
    "reward_type": "discount_percentage",
    "application_type": "order_discount",
    "title": "Spécial Öffer!",
    "description": "Promotion with special characters and symbols",
    "promotion_code": "SPECIAL-2025",
    "status": "completed"
  },

  // DIFFERENT STATUS VALUES
  "status_pending": {
    "is_referral": false,
    "amount": "20.00 EUR",
    "name": "Pending Reward",
    "promotion_name": "Pending Reward",
    "date": "1761200000",
    "reward_type": "cashback",
    "application_type": "wallet_credit",
    "title": "Pending Cashback",
    "description": "This reward is pending approval",
    "status": "pending"
  },

  "status_failed": {
    "is_referral": false,
    "amount": "10.00 EUR",
    "name": "Failed Reward",
    "promotion_name": "Failed Reward",
    "date": "1761300000",
    "reward_type": "discount_amount",
    "application_type": "order_discount",
    "title": "Failed Discount",
    "description": "This reward application failed",
    "status": "failed"
  },

  "status_expired": {
    "is_referral": false,
    "amount": "5.00 EUR",
    "name": "Expired Reward",
    "promotion_name": "Expired Reward",
    "date": "1700000000",
    "reward_type": "promo_discount",
    "application_type": "wallet_credit",
    "title": "Expired Promotion",
    "description": "This reward has expired",
    "status": "expired"
  },

  // UNUSUAL BUT VALID CASES
  "zero_amount": {
    "is_referral": false,
    "amount": "0.00 EUR",
    "name": "Free Trial",
    "promotion_name": "Free Trial",
    "date": "1761400000",
    "reward_type": "promo_discount",
    "application_type": "order_discount",
    "title": "Free Trial Discount",
    "description": "100% discount for free trial",
    "promotion_code": "FREETRIAL",
    "status": "completed"
  },

  "large_amount": {
    "is_referral": false,
    "amount": "999.99 EUR",
    "name": "Large Discount",
    "promotion_name": "Large Discount",
    "date": "1761500000",
    "reward_type": "discount_amount",
    "application_type": "wallet_credit",
    "title": "Mega Discount",
    "description": "Unusually large discount amount",
    "promotion_code": "MEGA999",
    "status": "completed"
  },

  "negative_date": {
    "is_referral": false,
    "amount": "5.00 EUR",
    "name": "Old Reward",
    "promotion_name": "Old Reward",
    "date": "0",
    "reward_type": "cashback",
    "application_type": "wallet_credit",
    "title": "Very Old Reward",
    "description": "Reward from 1970",
    "status": "completed"
  },

  // REAL-WORLD DATA FROM PROVIDED SAMPLE (sanitized)
  "real_sample_1": {
    "is_referral": true,
    "amount": "3.0 EUR",
    "name": "user1@example.com",
    "promotion_name": "",
    "date": "1760856180",
    "reward_type": "cashback",
    "application_type": "wallet_credit",
    "original_amount": null,
    "title": "Referrer Cashback",
    "description": "Cashback reward for referral code used by test6@example.com",
    "promotion_code": null,
    "referral_from": "user1@example.com",
    "order_id": "1bf20e77-26c8-41ad-a7b3-ac4518c92cdc",
    "bundle_name": null,
    "status": "completed"
  },

  "real_sample_2": {
    "is_referral": true,
    "amount": "3.0 EUR",
    "name": "user2@example.com",
    "promotion_name": "",
    "date": "1760785540",
    "reward_type": "cashback",
    "application_type": "wallet_credit",
    "original_amount": null,
    "title": "Referrer Cashback",
    "description": "Cashback reward for referral code used by test5@example.com",
    "promotion_code": null,
    "referral_from": "user2@example.com",
    "order_id": "b3eb8ff6-bf1b-4ced-a038-f77fd23160e0",
    "bundle_name": null,
    "status": "completed"
  },

  "real_sample_3": {
    "is_referral": false,
    "amount": "0.09 EUR",
    "name": "Discount 15% for referred customers",
    "promotion_name": "Discount 15% for referred customers",
    "date": "1760369123",
    "reward_type": "discount_percentage",
    "application_type": "order_discount",
    "original_amount": null,
    "title": "Percentage Discount",
    "description": "Discount applied: Discount 15% for referred customers",
    "promotion_code": "REF15",
    "referral_from": null,
    "order_id": "766d6176-1ab1-4f35-82eb-4018c81d9bdc",
    "bundle_name": "Turkey",
    "status": "completed"
  },

  "real_sample_4": {
    "is_referral": false,
    "amount": "0.06 EUR",
    "name": "Test promotion",
    "promotion_name": "Test promotion",
    "date": "1758962700",
    "reward_type": "discount_percentage",
    "application_type": "order_discount",
    "original_amount": null,
    "title": "Percentage Discount",
    "description": "Discount applied: Test promotion",
    "promotion_code": "TEST-233",
    "referral_from": null,
    "order_id": null,
    "bundle_name": null,
    "status": "completed"
  },

  // EDGE CASE: Invalid reward_type (should handle gracefully)
  "invalid_reward_type": {
    "is_referral": false,
    "amount": "5.00 EUR",
    "name": "Unknown Type",
    "promotion_name": "Unknown Type",
    "date": "1761600000",
    "reward_type": "unknown_type",
    "application_type": "wallet_credit",
    "title": "Test Reward",
    "description": "Testing invalid reward type",
    "status": "completed"
  },

  // EDGE CASE: Invalid application_type (should handle gracefully)
  "invalid_application_type": {
    "is_referral": false,
    "amount": "5.00 EUR",
    "name": "Unknown Application",
    "promotion_name": "Unknown Application",
    "date": "1761700000",
    "reward_type": "cashback",
    "application_type": "unknown_application",
    "title": "Test Reward",
    "description": "Testing invalid application type",
    "status": "completed"
  },

  // MINIMAL VALID DATA
  "minimal_valid": {
    "is_referral": false,
    "amount": "1.00 EUR",
    "name": "Min",
    "promotion_name": "Min",
    "date": "1761800000"
  }
};
