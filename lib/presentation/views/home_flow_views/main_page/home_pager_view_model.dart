import "dart:developer";

import "package:esim_open_source/data/remote/request/related_search.dart";
import "package:esim_open_source/data/remote/responses/bundles/bundle_response_model.dart";
import "package:esim_open_source/data/remote/responses/bundles/country_response_model.dart";
import "package:esim_open_source/data/remote/responses/bundles/regions_response_model.dart";
import "package:esim_open_source/di/locator.dart";
import "package:esim_open_source/domain/repository/services/local_storage_service.dart";
import "package:esim_open_source/domain/use_case/bundles/get_bundle_use_case.dart";
import "package:esim_open_source/domain/util/resource.dart";
import "package:esim_open_source/presentation/setup_bottom_sheet_ui.dart";
import "package:esim_open_source/presentation/shared/haptic_feedback.dart";
import "package:esim_open_source/presentation/shared/in_app_redirection_heper.dart";
import "package:esim_open_source/presentation/views/base/main_base_model.dart";
import "package:esim_open_source/presentation/widgets/lockable_tab_bar.dart";
import "package:flutter/material.dart";

class HomePagerViewModel extends MainBaseModel {
  FocusScopeNode? _currentFocus;
  LockableTabController? _tabController;
  InAppRedirection? redirection;

  late final GetBundleUseCase getBundleUseCase = GetBundleUseCase(locator());

  @override
  void onViewModelReady() {
    super.onViewModelReady();

    if (redirection != null) {
      // Delay redirection until after build completes to avoid setState during build
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        // Check if this is a pending purchase redirection that needs bundle data
        if (redirection is PendingPurchaseRedirection) {
          log("📦 Detected PendingPurchaseRedirection - fetching bundle data");
          final PendingPurchaseRedirection pendingRedirection = redirection! as PendingPurchaseRedirection;
          
          // Fetch full bundle data from API
          final PurchaseRedirection? fullRedirection = await _reconstructPurchaseRedirection(pendingRedirection);
          
          if (fullRedirection != null) {
            log("✅ Successfully reconstructed PurchaseRedirection");
            redirectionsHandlerService.redirectToRoute(redirection: fullRedirection);
          } else {
            log("❌ Failed to reconstruct PurchaseRedirection - bundle data not available");
            // Don't redirect if we couldn't fetch the bundle
          }
        } else {
          // Normal redirection (cashback, referral, or already complete purchase)
          redirectionsHandlerService.redirectToRoute(redirection: redirection!);
        }
        
        // Clear any remaining pending redirection after successful routing
        // This ensures cleanup even if it wasn't removed in login flow
        try {
          localStorageService.remove(LocalStorageKeys.pendingRedirection);
          log("🗑️ Cleared pending redirection after successful routing");
        } on Exception catch (e) {
          log("⚠️ Failed to clear pending redirection: $e");
        }
      });
    }
  }

  /// Reconstructs a full PurchaseRedirection from minimal PendingPurchaseRedirection data
  Future<PurchaseRedirection?> _reconstructPurchaseRedirection(
    PendingPurchaseRedirection pendingRedirection,
  ) async {
    try {
      // 1. Fetch bundle by code
      final Resource<BundleResponseModel?> bundleResource = await getBundleUseCase.execute(
        BundleParams(code: pendingRedirection.bundleCode),
      );

      if (bundleResource.resourceType != ResourceType.success || bundleResource.data == null) {
        log("❌ Failed to fetch bundle: ${pendingRedirection.bundleCode}");
        return null;
      }

      final BundleResponseModel bundle = bundleResource.data!;
      log("✅ Fetched bundle: ${bundle.bundleName}");

      // 2. Construct region model if regionCode provided
      RegionRequestModel? regionRequestModel;
      if (pendingRedirection.regionCode != null) {
        final RegionsResponseModel? region = regions?.firstWhere(
          (RegionsResponseModel r) => r.regionCode == pendingRedirection.regionCode,
          orElse: RegionsResponseModel.new,
        );
        if (region != null && region.regionCode != null) {
          regionRequestModel = RegionRequestModel(
            isoCode: region.regionCode,
            regionName: region.regionName,
          );
          log("✅ Found region: ${region.regionName}");
        }
      }

      // 3. Construct countries list if countryIsoCodes provided
      List<CountriesRequestModel>? countriesRequestModel;
      if (pendingRedirection.countryIsoCodes != null && pendingRedirection.countryIsoCodes!.isNotEmpty) {
        countriesRequestModel = pendingRedirection.countryIsoCodes!
            .map((String isoCode) {
              final CountryResponseModel? country = countries?.firstWhere(
                (CountryResponseModel c) => c.iso3Code == isoCode,
                orElse: CountryResponseModel.new,
              );
              if (country != null && country.iso3Code != null) {
                return CountriesRequestModel(
                  isoCode: country.iso3Code,
                  countryName: country.country,
                );
              }
              return null;
            })
            .whereType<CountriesRequestModel>() // Filter out nulls
            .toList();
        log("✅ Found ${countriesRequestModel.length} countries");
      }

      // 4. Create PurchaseBundleBottomSheetArgs with fetched data
      final PurchaseBundleBottomSheetArgs args = PurchaseBundleBottomSheetArgs(
        regionRequestModel,
        countriesRequestModel,
        bundle,
      );

      // 5. Return full PurchaseRedirection
      return InAppRedirection.purchase(args) as PurchaseRedirection;
    } on Exception catch (e, stackTrace) {
      log("❌ Error reconstructing PurchaseRedirection: $e");
      log("Stack trace: $stackTrace");
      return null;
    }
  }

  set tabController(LockableTabController controller) {
    _tabController = controller;
  }

  LockableTabController get tabController => _tabController!;

  set lockTabBar(bool lock) {
    _tabController?.isLocked = lock;
  }

  void changeSelectedTabIndex({required int index}) {
    playHapticFeedback(HapticFeedbackType.tabBarSelectionChange);
    _tabController?.animateTo(index);
  }

  int? getSelectedTabIndex() {
    return _tabController?.index;
  }

  void setRelatedListeners({required BuildContext context}) {
    _currentFocus = FocusScope.of(context);
    if (_currentFocus?.hasListeners ?? false) {
      _currentFocus?.removeListener(_onFocusChange);
    }
    _currentFocus?.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    log("Focus: ${_currentFocus?.hasFocus}");
    if (_currentFocus != null) {
      notifyListeners();
    }
  }
}
