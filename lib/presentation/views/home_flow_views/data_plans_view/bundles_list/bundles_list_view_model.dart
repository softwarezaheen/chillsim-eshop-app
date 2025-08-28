// bundles_list_view_model.dart

import "dart:async";

import "package:esim_open_source/app/environment/app_environment.dart";
import "package:esim_open_source/data/remote/request/related_search.dart";
import "package:esim_open_source/data/remote/responses/bundles/bundle_response_model.dart";
import "package:esim_open_source/data/remote/responses/bundles/country_response_model.dart";
import "package:esim_open_source/presentation/enums/bottomsheet_type.dart";
import "package:esim_open_source/presentation/enums/login_type.dart";
import "package:esim_open_source/presentation/setup_bottom_sheet_ui.dart";
import "package:esim_open_source/presentation/shared/in_app_redirection_heper.dart";
import "package:esim_open_source/presentation/views/base/esim_base_model.dart";
import "package:esim_open_source/presentation/views/home_flow_views/data_plans_view/bundles_list/bundles_by_countries_view/bundles_by_countries_view_model.dart";
import "package:esim_open_source/presentation/views/home_flow_views/data_plans_view/bundles_list/navigation/esim_arguments.dart";
import "package:esim_open_source/presentation/views/pre_sign_in/login_view/login_view.dart";
import "package:flutter/cupertino.dart";

class BundlesListViewModel extends EsimBaseModel {
  BundlesListViewModel(this.esimArguments);

  final EsimArguments esimArguments;

  List<CountryResponseModel> get filteredCountries {
    List<CountryResponseModel> filteredCount = countries
            ?.where(
              (CountryResponseModel country) =>
                  !_selectedCountryChips.contains(country),
            )
            .toList() ??
        <CountryResponseModel>[];

    if (isSearchFocused.value) {
      final String query = searchTextFieldController.text.toLowerCase();
      if (query.isEmpty) {
        return filteredCount;
      } else {
        return filteredCount
            .where(
              (CountryResponseModel country) =>
                  country.country?.toLowerCase().contains(query) ??
                  false ||
                      (country.iso3Code?.toLowerCase().contains(query) ??
                          false),
            )
            .toList();
      }
    } else {
      return <CountryResponseModel>[];
    }
  }

  final List<CountryResponseModel> _selectedCountryChips =
      <CountryResponseModel>[];

  List<CountryResponseModel> get selectedCountryChips => _selectedCountryChips;

  final TextEditingController searchTextFieldController =
      TextEditingController();
  final ValueNotifier<bool> isSearchFocused = ValueNotifier<bool>(false);

  String get countryCodes => selectedCountryChips
      .map((CountryResponseModel country) => country.id)
      .toList()
      .join(",");

  BundlesByCountriesViewModel? childViewModel;

  @override
  void onViewModelReady() {
    super.onViewModelReady();

    searchTextFieldController.addListener(_onSearchChanged);
    childViewModel = BundlesByCountriesViewModel(esimArguments);
    unawaited(getSelectedCountry());
  }

  Future<void> addCountry(CountryResponseModel country) async {
    if (!_selectedCountryChips.contains(country)) {
      _selectedCountryChips.add(country);

      notifyListeners();

      childViewModel?.addAvailableCountries(country);
      childViewModel?.fetchBundles(countryCodes);
    }
  }

  Future<void> removeCountry(CountryResponseModel country) async {
    if (_selectedCountryChips.length == 1) {
      navigationService.back();
    } else {
      _selectedCountryChips.remove(country);
      notifyListeners();
      childViewModel?.removeAvailableCountries(country);
      childViewModel?.fetchBundles(countryCodes);
    }
  }

  void setSearchFocused({required bool focused}) {
    isSearchFocused.value = focused;
    if (!focused) {
      searchTextFieldController.clear();
    }

    notifyListeners();
  }

  Future<void> navigateToEsimDetail(
    BundleResponseModel bundle,
  ) async {
    // fill regions
    RegionRequestModel? regionRequestModel =
        esimArguments.type == EsimArgumentType.region
            ? RegionRequestModel(
                isoCode: esimArguments.id,
                regionName: esimArguments.name,
              )
            : null;
    // fill countries
    List<CountriesRequestModel> countriesRequestModel =
        esimArguments.type == EsimArgumentType.country
            ? _selectedCountryChips
                .map(
                  (CountryResponseModel country) => CountriesRequestModel(
                    isoCode: country.iso3Code,
                    countryName: country.country,
                  ),
                )
                .toList()
            : <CountriesRequestModel>[];
    // SheetResponse<EmptyBottomSheetResponse>? response
    if ((!AppEnvironment.appEnvironmentHelper.enableGuestFlowPurchase ||
            AppEnvironment.appEnvironmentHelper.loginType ==
                LoginType.phoneNumber) &&
        !isUserLoggedIn) {
      await navigationService.navigateTo(
        LoginView.routeName,
        arguments: InAppRedirection.purchase(
          PurchaseBundleBottomSheetArgs(
            regionRequestModel,
            countriesRequestModel,
            bundle,
          ),
        ),
      );
      return;
    }
    await bottomSheetService.showCustomSheet(
      data: PurchaseBundleBottomSheetArgs(
        regionRequestModel,
        countriesRequestModel,
        bundle,
      ),
      enableDrag: false,
      isScrollControlled: true,
      variant: BottomSheetType.bundleDetails,
    );
  }

  void _onSearchChanged() {
    notifyListeners();
  }

  @override
  void onDispose() {
    super.onDispose();
    searchTextFieldController
      ..removeListener(_onSearchChanged)
      ..dispose();
  }

  Future<void> getSelectedCountry() async {
    if (esimArguments.type == EsimArgumentType.country) {
      CountryResponseModel? country = countries?.firstWhere(
        (CountryResponseModel country) => country.id == esimArguments.id,
      );
      if (country != null) {
        _selectedCountryChips.add(country);
        notifyListeners();
      }
    }
  }
}

List<CountryResponseModel> getMockCountries() {
  return List<CountryResponseModel>.of(
    <CountryResponseModel>[
      CountryResponseModel(
        alternativeCountry: "AFG",
        country: "Afghanistan",
        countryCode: "AFG",
        iso3Code: "AF",
        zoneName: "Afghanistan-esim",
      ),
      CountryResponseModel(
        alternativeCountry: "ALB",
        country: "Albania",
        countryCode: "ALB",
        iso3Code: "AL",
        zoneName: "Albania-esim",
      ),
      CountryResponseModel(
        alternativeCountry: "AND",
        country: "Andorra",
        countryCode: "AND",
        iso3Code: "AD",
        zoneName: "Andorra-esim",
      ),
    ],
  );
}
