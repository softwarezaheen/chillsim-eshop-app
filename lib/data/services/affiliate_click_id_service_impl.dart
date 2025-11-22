import "dart:developer";

import "package:esim_open_source/domain/repository/services/affiliate_click_id_service.dart";
import "package:esim_open_source/domain/repository/services/local_storage_service.dart";

/// Implementation of AffiliateClickIdService for managing affiliate tracking
class AffiliateClickIdServiceImpl implements AffiliateClickIdService {
  AffiliateClickIdServiceImpl({required this.localStorage});

  final LocalStorageService localStorage;

  @override
  Future<String?> getValidClickId() async {
    // Get the click ID from storage
    String? clickId = localStorage.getString(LocalStorageKeys.affiliateClickId);
    
    if (clickId == null || clickId.isEmpty) {
      return null;
    }

    // Check if it's expired
    if (await isClickIdExpired()) {
      log("Affiliate click ID expired, removing from storage");
      await removeClickId();
      return null;
    }

    return clickId;
  }

  @override
  Future<void> storeClickId(String clickId, DateTime expiryDate) async {
    await localStorage.setString(LocalStorageKeys.affiliateClickId, clickId);
    await localStorage.setString(
      LocalStorageKeys.affiliateClickIdExpiry,
      expiryDate.toIso8601String(),
    );
    log("Affiliate click ID stored: $clickId, expires: ${expiryDate.toIso8601String()}");
  }

  @override
  Future<void> removeClickId() async {
    await localStorage.remove(LocalStorageKeys.affiliateClickId);
    await localStorage.remove(LocalStorageKeys.affiliateClickIdExpiry);
    log("Affiliate click ID removed from storage");
  }

  @override
  Future<bool> isClickIdExpired() async {
    String? expiryString = localStorage.getString(LocalStorageKeys.affiliateClickIdExpiry);
    
    if (expiryString == null || expiryString.isEmpty) {
      // No expiry date means it's considered expired
      return true;
    }

    try {
      DateTime expiryDate = DateTime.parse(expiryString);
      bool expired = DateTime.now().isAfter(expiryDate);
      
      if (expired) {
        log("Affiliate click ID has expired (expiry: $expiryString)");
      }
      
      return expired;
    } on Object catch (e) {
      log("Error parsing expiry date: $e");
      // If we can't parse the date, consider it expired
      return true;
    }
  }
}
