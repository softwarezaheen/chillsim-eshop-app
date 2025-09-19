import "dart:convert";
import "dart:developer";

import "package:easy_localization/easy_localization.dart";
import "package:esim_open_source/app/app.locator.dart";
import "package:esim_open_source/data/remote/responses/user/user_get_billing_info_response_model.dart";
import "package:esim_open_source/domain/repository/api_auth_repository.dart";
import "package:esim_open_source/domain/repository/api_user_repository.dart";
import "package:esim_open_source/domain/use_case/auth/update_user_info_use_case.dart";
import "package:esim_open_source/presentation/enums/view_state.dart";
import "package:esim_open_source/presentation/setup_bottom_sheet_ui.dart";
import "package:esim_open_source/presentation/shared/ui_helpers.dart";
import "package:esim_open_source/presentation/views/base/base_model.dart";
import "package:esim_open_source/translations/locale_keys.g.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:stacked_services/stacked_services.dart";

enum BillingType { individual, business }

class Country {
  Country({required this.name, required this.alpha2, required this.alpha3});
  final String name;
  final String alpha2;
  final String alpha3;
}

class County {
  County({required this.name, required this.alpha3});
  final String name;
  final String alpha3;
}

class BillingInfoBottomSheetViewModel extends BaseModel {

  BillingType billingType = BillingType.individual;
  final TextEditingController vatCodeController = TextEditingController();
  final TextEditingController companyNameController = TextEditingController();
  final TextEditingController registrationController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController countryController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  final UpdateUserInfoUseCase updateUserInfoUseCase =
      UpdateUserInfoUseCase(locator<ApiAuthRepository>());

  bool _saveButtonEnabled = false;
  bool get saveButtonEnabled => _saveButtonEnabled;

  UserGetBillingInfoResponseModel? lastBillingInfo;

  bool get isFormValid =>
      firstNameController.text.trim().isNotEmpty &&
      lastNameController.text.trim().isNotEmpty;

  void setBillingType(BillingType type) {
    billingType = type;
    if (billingType == BillingType.individual) {
      companyNameController.text = "";
      vatCodeController.text = "";
      registrationController.text = "";
    }
    notifyListeners();
  }

  List<Country> _countriesList = <Country>[];
  Country? selectedCountry;

  List<Country> get countriesList => _countriesList;
  Country? get selectedCountryValue => selectedCountry;

  List<County> countiesList = <County>[];
  County? selectedCounty;

  List<String> citiesList = <String>[];
  String? selectedCity;
  
  bool isRomania = false;
  bool isCountyDropdownEnabled = false;
  bool isCityDropdownEnabled = false;
  
  String userEmail="";

  Future<void> loadCountries() async {
    final String jsonString = await rootBundle.loadString("assets/data/countries.json");
    final List<dynamic> jsonList = json.decode(jsonString);
    _countriesList = jsonList.map((e) => Country(
      name: e["name"],
      alpha2: e["alpha2"],
      alpha3: e["alpha3"],
    ),).toList();
    notifyListeners();
  }

  void setSelectedCountry(Country? country) {
    if (country == null) {
      selectedCountry = null;
      countryController.text = "";
    } else {
      // Find the exact instance from the list
      selectedCountry = countriesList.firstWhere(
        (c) => c.alpha2 == country.alpha2,
        orElse: () => countriesList.first,
      );
      countryController.text = selectedCountry?.alpha2 ?? "";
    }
    notifyListeners();
  }
  
  Future<void> loadCounties() async {
    final String jsonString = await rootBundle.loadString("assets/data/counties_ro.json");
    final List<dynamic> jsonList = json.decode(jsonString);
    countiesList = jsonList.map((e) => County(
      name: e["name"],
      alpha3: e["alpha3"],
    ),).toList();
    // log("Loaded countiesList: ${countiesList.map((c) => '${c.name} (${c.alpha3})').toList()}");
    notifyListeners();
  }

  Future<void> loadCitiesForCounty(String countyName) async {
    final String jsonString = await rootBundle.loadString("assets/data/regions_ro.json");
    final Map<String, dynamic> jsonMap = json.decode(jsonString);
    // Find cities for the selected county
    citiesList = [];
    if (jsonMap.containsKey(countyName)) {
      citiesList = (jsonMap[countyName] as List)
        .map((e) => e["name"] ?? "")
        .where((name) => name.isNotEmpty)
        .cast<String>()
        .toList();
    }
    notifyListeners();
  }

  Future<void> onCountryChanged(Country? country) async {
    setSelectedCountry(country);
    // log("onCountryChanged called with: ${country?.name} (${country?.alpha2})");
    isRomania = country?.alpha2 == "RO";
    if (isRomania) {
      selectedCounty = null;
      selectedCity = null;
      stateController.text = "";
      cityController.text = "";
      isCountyDropdownEnabled = true;
      isCityDropdownEnabled = false;
      if (countiesList.isEmpty) {
        await loadCounties();
      }
    } else {
      selectedCounty = null;
      selectedCity = null;
      countiesList = <County>[];
      citiesList = <String>[];
      isCountyDropdownEnabled = false;
      isCityDropdownEnabled = false;
      stateController.text = "";
      cityController.text = "";
      notifyListeners();
    }
    notifyListeners();
  }

  Future<void> onCountyChanged(County? county) async {
    // log("onCountyChanged called with: ${county?.name} (${county?.alpha3})");
    if (county == null) {
      selectedCounty = null;
      stateController.text = "";
      selectedCity = null;
      cityController.text = "";
      isCityDropdownEnabled = false;
      citiesList = <String>[];
    } else {
      // Find the exact instance from countiesList
      selectedCounty = countiesList.firstWhere(
        (County c) => c.name == county.name && c.alpha3 == county.alpha3,
        orElse: () {
          log("County not found in countiesList, using passed county instance");
          return county;
        },
      );
      log("selectedCounty set to: ${selectedCounty?.name} (${selectedCounty?.alpha3})");
      stateController.text = selectedCounty?.name ?? "";
      selectedCity = null;
      cityController.text = "";
      isCityDropdownEnabled = false;
      await loadCitiesForCounty(selectedCounty!.name);
      isCityDropdownEnabled = true;
    }
    notifyListeners();
  }

  void onCityChanged(String? city) {
    selectedCity = city;
    cityController.text = city ?? "";
    notifyListeners();
  }

  void updateButtonState() {
    _saveButtonEnabled = isFormValid;
    notifyListeners();
  }

  String? validateFormFields() {
    if (firstNameController.text.trim().isEmpty) {
      return LocaleKeys.validation_first_name_required.tr();
    }
    if (lastNameController.text.trim().isEmpty) {
      return LocaleKeys.validation_last_name_required.tr();
    }
    if (selectedCountry == null && countryController.text.trim().isEmpty) {
      return LocaleKeys.validation_country_required.tr();
    }
    if (selectedCounty == null && stateController.text.trim().isEmpty) {
      return LocaleKeys.validation_county_required.tr();
    }
    if (selectedCity == null && cityController.text.trim().isEmpty) {
      return LocaleKeys.validation_city_required.tr();
    }
    if (billingType == BillingType.business) {
      if (companyNameController.text.trim().isEmpty) {
        return LocaleKeys.validation_company_name_required.tr();
      }
      if (vatCodeController.text.trim().isEmpty) {
        return LocaleKeys.validation_vat_code_required.tr();
      }
    }
    return null; // No errors
  }

  @override
  Future<void> onViewModelReady() async {
    super.onViewModelReady();
    await loadCountries();
    await loadCounties();

try {
      setViewState( ViewState.busy );
      final dynamic billingInfoResource = await locator<ApiUserRepository>().getUserBillingInfo();
      final UserGetBillingInfoResponseModel? billingInfoResponse = billingInfoResource?.data;
      lastBillingInfo = billingInfoResponse;

      if (billingInfoResponse != null) {
        log("BillingInfoResponse: ${userGetBillingInfoResponseModelToJson(billingInfoResponse)}");
        cityController.text = billingInfoResponse.city ?? "";
        countryController.text = billingInfoResponse.country ?? "";
        addressController.text = billingInfoResponse.billingAddress ?? "";
        companyNameController.text = billingInfoResponse.companyName ?? "";
        vatCodeController.text = billingInfoResponse.vatCode ?? "";
        registrationController.text = billingInfoResponse.tradeRegistry ?? "";
        stateController.text = billingInfoResponse.state ?? "";
        lastNameController.text = billingInfoResponse.lastName ?? userLastName;
        firstNameController.text = billingInfoResponse.firstName ?? userFirstName;

        billingType = (billingInfoResponse.vatCode != null && billingInfoResponse.vatCode!.isNotEmpty)
            ? BillingType.business
            : BillingType.individual;

        selectedCountry = countriesList.isNotEmpty
          ? countriesList.firstWhere(
              (Country c) => c.alpha2 == billingInfoResponse.country,
              orElse: () => countriesList.first,
            )
          : null;
        countryController.text = selectedCountry?.alpha2 ?? "";

        isRomania = selectedCountry?.alpha2 == "RO";
        // log("isRomania: $isRomania");
        if (isRomania || billingInfoResponse.country == "RO") {
          // log("Trying to set selectedCounty with API value: ${billingInfoResponse.state}");
          if (countiesList.isNotEmpty) {
            final Iterable<County> found = countiesList.where(
              (County c) => c.alpha3 == billingInfoResponse.state || c.name == billingInfoResponse.state,
            );
            selectedCounty = found.isNotEmpty ? found.first : null;
          }
          // log("selectedCounty instance: ${selectedCounty?.name} (${selectedCounty?.alpha3})");
          // log("selectedCounty reference: ${selectedCounty?.hashCode}");
          await loadCitiesForCounty(selectedCounty?.name ?? "");
          selectedCity = citiesList.contains(billingInfoResponse.city)
              ? billingInfoResponse.city
              : null;
          cityController.text = selectedCity ?? "";
          isCountyDropdownEnabled = true;
          isCityDropdownEnabled = selectedCounty != null && citiesList.isNotEmpty;
          notifyListeners();
        } else {
          cityController.text = billingInfoResponse.city ?? "";
        }
      } else {
        emailController.text = userEmailAddress;
        
        log("BillingInfoResponse is null");
        cityController.text = "";
        countryController.text = "";
        addressController.text = "";
        companyNameController.text = "";
        vatCodeController.text = "";
        registrationController.text = "";
        stateController.text = "";

        billingType = BillingType.individual;
        selectedCountry = null;
        selectedCounty = null;
        selectedCity = null;
        isRomania = false;
        isCountyDropdownEnabled = false;
        isCityDropdownEnabled = false;
      }
      setViewState( ViewState.idle );
    } on Exception catch (e) {
      log("Error fetching billing info: $e");
      setViewState( ViewState.idle );
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      userEmail = userEmailAddress;
      debugPrint("userEmail: $userEmail");
      log(userEmail);
      // firstNameController.text = userFirstName;
      // lastNameController.text = userLastName;
      emailController.text = userEmailAddress;
      
      firstNameController.addListener(updateButtonState);
      lastNameController.addListener(updateButtonState);
      emailController.addListener(updateButtonState);
      cityController.addListener(updateButtonState);
      countryController.addListener(updateButtonState);
      addressController.addListener(updateButtonState);
      updateButtonState();
      notifyListeners();
    });
  }

  Future<void> saveBillingInfoAndProceed(
    BuildContext context,
    Function(SheetResponse<EmptyBottomSheetResponse>) completer,
  ) async {
    log(  "saveBillingInfoAndProceed called"  );
    final error = validateFormFields();
    
    if (error==null) {
      // Save billing info here (call API or update local state as needed)
      // Example: await locator<ApiUserRepository>().setUserBillingInfo(...);
          bool hasChanged = false;
          if (lastBillingInfo == null ||
              lastBillingInfo!.email != emailController.text ||
              lastBillingInfo!.firstName != firstNameController.text ||
              lastBillingInfo!.lastName != lastNameController.text ||
              lastBillingInfo!.country != countryController.text ||
              lastBillingInfo!.state != (selectedCounty?.alpha3 ?? stateController.text) ||
              lastBillingInfo!.city != cityController.text ||
              lastBillingInfo!.billingAddress != addressController.text ||
              lastBillingInfo!.companyName != companyNameController.text ||
              lastBillingInfo!.vatCode != vatCodeController.text ||
              lastBillingInfo!.tradeRegistry != registrationController.text) {
            hasChanged = true;
          }

          if (hasChanged) {
            setViewState(ViewState.busy);
            await locator<ApiUserRepository>().setUserBillingInfo(
              email: emailController.text,
              firstName: firstNameController.text,
              lastName: lastNameController.text,
              country: countryController.text,
              state: selectedCounty?.alpha3 ?? stateController.text,
              city: cityController.text,
              billingAddress: addressController.text,
              companyName: companyNameController.text,
              vatCode: vatCodeController.text,
              tradeRegistry: registrationController.text,
            );
            setViewState(ViewState.idle);
          }

          completer(
            SheetResponse<EmptyBottomSheetResponse>(
              confirmed: true,
              responseData: {
                "firstName": firstNameController.text,
                "lastName": lastNameController.text,
                // Add other fields as needed
              },
            ),
          );
    } else {
      await showToast(error);
    }
  }
}
