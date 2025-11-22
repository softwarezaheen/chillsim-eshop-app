/// Service interface for managing affiliate click ID tracking
abstract class AffiliateClickIdService {
  /// Gets the current affiliate click ID if it's still valid (not expired)
  /// Returns null if no click ID exists or if it has expired
  Future<String?> getValidClickId();

  /// Stores an affiliate click ID with its expiry date
  Future<void> storeClickId(String clickId, DateTime expiryDate);

  /// Removes the affiliate click ID and its expiry date from storage
  Future<void> removeClickId();

  /// Checks if the current click ID has expired
  Future<bool> isClickIdExpired();
}
