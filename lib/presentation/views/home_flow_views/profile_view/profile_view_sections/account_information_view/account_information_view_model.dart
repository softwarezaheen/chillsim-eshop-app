import "dart:convert";
import "dart:developer";

import "package:easy_localization/easy_localization.dart";
import "package:esim_open_source/app/environment/app_environment.dart";
import "package:esim_open_source/data/remote/responses/auth/auth_response_model.dart";
import "package:esim_open_source/data/remote/responses/user/user_get_billing_info_response_model.dart";
import "package:esim_open_source/di/locator.dart";
import "package:esim_open_source/domain/repository/api_auth_repository.dart";
import "package:esim_open_source/domain/repository/api_user_repository.dart";
import "package:esim_open_source/domain/use_case/auth/update_user_info_use_case.dart";
import "package:esim_open_source/domain/util/resource.dart";
import "package:esim_open_source/presentation/enums/login_type.dart";
import "package:esim_open_source/presentation/enums/view_state.dart";
import "package:esim_open_source/presentation/extensions/helper_extensions.dart";
import "package:esim_open_source/presentation/shared/ui_helpers.dart";
import "package:esim_open_source/presentation/views/base/base_model.dart";
import "package:esim_open_source/translations/locale_keys.g.dart";
import "package:flutter/cupertino.dart";
import "package:flutter/services.dart" show rootBundle;
import "package:phone_input/phone_input_package.dart";
// import "package:phone_input/src/number_parser/models/phone_number_exceptions.dart";

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


enum BillingType { individual, business }
class AccountInformationViewModel extends BaseModel {
  bool _receiveUpdates = false;
  bool isValidEmail = false;
  String? emailErrorMessage;

  bool get receiveUpdated => _receiveUpdates;
  bool _saveButtonEnabled = false;

  String? _validationError;

  String? get validationError => _validationError;

  bool get saveButtonEnabled => _saveButtonEnabled;

  String userEmail = "";
  String userPhoneNumber = "";
  bool isPhoneValid = false;
  BillingType billingType = BillingType.individual;

  TextEditingController get nameController => _nameController;
  TextEditingController get emailController => _emailController;
  TextEditingController get cityController => _cityController;
  TextEditingController get countryController => _countryController;
  TextEditingController get billingAddressController => _billingAddressController;
  TextEditingController get companyNameController => _companyNameController;
  TextEditingController get vatCodeController => _vatCodeController;
  TextEditingController get registrationCodeController => _registrationCodeController;
  TextEditingController get stateController => _stateController;

  TextEditingController get familyNameController => _familyNameController;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _familyNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _billingAddressController = TextEditingController();
  final TextEditingController _companyNameController = TextEditingController();
  final TextEditingController _vatCodeController = TextEditingController();
  final TextEditingController _registrationCodeController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();

  final UpdateUserInfoUseCase updateUserInfoUseCase =
      UpdateUserInfoUseCase(locator<ApiAuthRepository>());
  PhoneController phoneController =
      PhoneController(const PhoneNumber(isoCode: IsoCode.RO, nsn: ""));

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
      _stateController.text = "";
      _cityController.text = "";
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
      _stateController.text = "";
      _cityController.text = "";
      notifyListeners();
    }
    notifyListeners();
  }

  Future<void> onCountyChanged(County? county) async {
    // log("onCountyChanged called with: ${county?.name} (${county?.alpha3})");
    if (county == null) {
      selectedCounty = null;
      _stateController.text = "";
      selectedCity = null;
      _cityController.text = "";
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
      _stateController.text = selectedCounty?.name ?? "";
      selectedCity = null;
      _cityController.text = "";
      isCityDropdownEnabled = false;
      await loadCitiesForCounty(selectedCounty!.name);
      isCityDropdownEnabled = true;
    }
    notifyListeners();
  }

  void onCityChanged(String? city) {
    selectedCity = city;
    _cityController.text = city ?? "";
    notifyListeners();
  }

  @override
  Future<void> onViewModelReady() async {
    super.onViewModelReady();
    await loadCountries();
    await loadCounties();

    PhoneNumber? parsed;
    
    bool isValidMsisdn(String msisdn) {
      // Basic validation: starts with + and has at least 8 digits after country code
      final RegExp regex = RegExp(r"^\+\d{8,}$");
      return regex.hasMatch(msisdn);
    }

    if (isValidMsisdn(userMsisdn)) {
      try {
        parsed = PhoneNumber.parse(userMsisdn);
      } catch (e) {
        log("Error parsing phone number: $e");
      }
    } else {
      log("userMsisdn is not a valid international phone number: $userMsisdn");
    }
    try {
      setViewState( ViewState.busy );
      final dynamic billingInfoResource = await locator<ApiUserRepository>().getUserBillingInfo();
      final UserGetBillingInfoResponseModel? billingInfoResponse = billingInfoResource?.data;

      if (billingInfoResponse != null) {
        log("BillingInfoResponse: ${userGetBillingInfoResponseModelToJson(billingInfoResponse)}");
        _cityController.text = billingInfoResponse.city ?? "";
        _countryController.text = billingInfoResponse.country ?? "";
        _billingAddressController.text = billingInfoResponse.billingAddress ?? "";
        _companyNameController.text = billingInfoResponse.companyName ?? "";
        _vatCodeController.text = billingInfoResponse.vatCode ?? "";
        _registrationCodeController.text = billingInfoResponse.tradeRegistry ?? "";
        _stateController.text = billingInfoResponse.state ?? "";
        _familyNameController.text = billingInfoResponse.lastName ?? userLastName;
        _nameController.text = billingInfoResponse.firstName ?? userFirstName;

        // Fix: Set email from billing info if available, else from userAuthenticationService
        _emailController.text = billingInfoResponse.email?.isNotEmpty ?? false
            ? billingInfoResponse.email!
            : userEmailAddress;

        billingType = (billingInfoResponse.vatCode != null && billingInfoResponse.vatCode!.isNotEmpty)
            ? BillingType.business
            : BillingType.individual;

        selectedCountry = countriesList.isNotEmpty
          ? countriesList.firstWhere(
              (Country c) => c.alpha2 == billingInfoResponse.country,
              orElse: () => countriesList.first,
            )
          : null;
        _countryController.text = selectedCountry?.alpha2 ?? "";

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
          _cityController.text = selectedCity ?? "";
          isCountyDropdownEnabled = true;
          isCityDropdownEnabled = selectedCounty != null && citiesList.isNotEmpty;
        } else {
          _cityController.text = billingInfoResponse.city ?? "";
        }
      } else {
        _emailController.text = userEmailAddress;
        
        log("BillingInfoResponse is null");
        _cityController.text = "";
        _countryController.text = "";
        _billingAddressController.text = "";
        _companyNameController.text = "";
        _vatCodeController.text = "";
        _registrationCodeController.text = "";
        _stateController.text = "";

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
      _nameController.text = userFirstName;
      _familyNameController.text = userLastName;
      _receiveUpdates = isNewsletterSubscribed;
      _emailController.text = userEmailAddress;
      phoneController.value = PhoneNumber(
        isoCode: parsed?.isoCode ?? IsoCode.RO,
        nsn: parsed?.nsn ?? "",
      );

      _nameController.addListener(updateButtonState);
      _familyNameController.addListener(updateButtonState);
      _emailController.addListener(_validateForm);
      _cityController.addListener(updateButtonState);
      _countryController.addListener(updateButtonState);
      _billingAddressController.addListener(updateButtonState);
      _validateForm();
      notifyListeners();
    });
  }

  void setBillingType(BillingType type) {
    billingType = type;
    notifyListeners();
  }

  void _validateForm() {
    final String emailAddress = _emailController.text;
    emailErrorMessage = validateEmailAddress(emailAddress);
    log("Message: $emailErrorMessage");
    log("email: $userEmailAddress");

    updateButtonState();
  }

  String validateEmailAddress(String text) {
    if (text.trim().isEmpty) {
      isValidEmail = false;

      return LocaleKeys.is_required_field.tr();
    }

    if (text.trim().isValidEmail()) {
      isValidEmail = true;
      return "";
    }
    isValidEmail = false;

    return LocaleKeys.enter_a_valid_email_address.tr();
  }

  void updateSwitch({
    required bool newValue,
  }) {
    _receiveUpdates = newValue;
    updateButtonState();
  }

  void validateNumber(
    String countryCode,
    String phoneNumber, {
    required bool isValid,
  }) {
    debugPrint("validateNumber, code: $countryCode, number: $phoneNumber");
    isPhoneValid = isValid;
    userPhoneNumber = phoneNumber;
    updateButtonState();
  }

  Future<void> saveButtonTapped() async {
    if (!validateFormFields()) {
      // Optionally show a dialog or error message in the UI
      await showToast(_validationError ?? "Please fill in required fields.");
      return;
    }
    setViewState(ViewState.busy);

    Resource<AuthResponseModel> updateInfoResponse = await updateUserInfoUseCase.execute(
        UpdateUserInfoParams(
          email: _emailController.text,
          msisdn:
              "+${phoneController.value?.countryCode}${phoneController.value?.nsn}",
          firstName: _nameController.text,
          lastName: _familyNameController.text,
          isNewsletterSubscribed: _receiveUpdates,
        ),
    );

    // Update billing info
    await locator<ApiUserRepository>().setUserBillingInfo(
      email: _emailController.text,
      phone: "+${phoneController.value?.countryCode}${phoneController.value?.nsn}",
      firstName: _nameController.text,
      lastName: _familyNameController.text,
      country: _countryController.text,
      state: selectedCounty?.alpha3 ?? _stateController.text,
      city: _cityController.text,
      billingAddress: _billingAddressController.text,
      companyName: _companyNameController.text,
      vatCode: _vatCodeController.text,
      tradeRegistry: _registrationCodeController.text,
    );

    // Handle response and UI (existing logic)
    await handleResponse(updateInfoResponse, onSuccess: (Resource<AuthResponseModel> response) async {
      navigationService.back();
    },);

    setViewState(ViewState.idle);
  }

  void updateButtonState() {
    bool isValidPhone = (userPhoneNumber.isEmpty)
        ? true
        : ((userPhoneNumber != userMsisdn) && isPhoneValid);

    _saveButtonEnabled =
        AppEnvironment.appEnvironmentHelper.loginType == LoginType.phoneNumber
            ? ((_receiveUpdates != isNewsletterSubscribed) ||
                    (_nameController.text != userFirstName) ||
                    (_familyNameController.text != userLastName) ||
                    (_emailController.text != userEmailAddress)) &&
                isValidEmail
            : ((_receiveUpdates != isNewsletterSubscribed) ||
                    (_nameController.text != userFirstName) ||
                    (_familyNameController.text != userLastName) ||
                    (userPhoneNumber != userMsisdn)) &&
                isValidPhone;

    if (isPhoneValid) {
      _validationError = null;
    } else if (userPhoneNumber.isNotEmpty) {
      _validationError = LocaleKeys.invalid_phone_number.tr();
    }

    notifyListeners();
  }

  bool validateFormFields() {
  if (_familyNameController.text.trim().isEmpty) {
    _validationError = LocaleKeys.validation_last_name_required.tr();
    notifyListeners();
    return false;
  }
  if (_nameController.text.trim().isEmpty) {
    _validationError = LocaleKeys.validation_first_name_required.tr();
    notifyListeners();
    return false;
  }
  if (billingType == BillingType.business) {
    if (_companyNameController.text.trim().isEmpty) {
      _validationError = LocaleKeys.validation_company_name_required.tr();
      notifyListeners();
      return false;
    }
    if (_vatCodeController.text.trim().isEmpty) {
      _validationError = LocaleKeys.validation_vat_code_required.tr();
      notifyListeners();
      return false;
    }
  }
  _validationError = null;
  notifyListeners();
  return true;
}
}
