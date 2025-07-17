import "dart:async";

import "package:esim_open_source/app/app.locator.dart";
import "package:esim_open_source/app/environment/app_environment.dart";
import "package:esim_open_source/data/remote/responses/bundles/bundle_response_model.dart";
import "package:esim_open_source/data/remote/responses/bundles/country_response_model.dart";
import "package:esim_open_source/data/remote/responses/bundles/regions_response_model.dart";
import "package:esim_open_source/data/remote/responses/user/user_notification_response.dart";
import "package:esim_open_source/domain/repository/api_user_repository.dart";
import "package:esim_open_source/domain/use_case/base_use_case.dart";
import "package:esim_open_source/domain/use_case/user/get_user_notifications_use_case.dart";
import "package:esim_open_source/domain/util/resource.dart";
import "package:esim_open_source/presentation/enums/bottomsheet_type.dart";
import "package:esim_open_source/presentation/enums/view_state.dart";
import "package:esim_open_source/presentation/setup_bottom_sheet_ui.dart";
import "package:esim_open_source/presentation/shared/in_app_redirection_heper.dart";
import "package:esim_open_source/presentation/views/base/base_model.dart";
import "package:esim_open_source/presentation/views/home_flow_views/data_plans_view/bundles_list/bundles_list_screen.dart";
import "package:esim_open_source/presentation/views/home_flow_views/data_plans_view/bundles_list/navigation/esim_arguments.dart";
import "package:esim_open_source/presentation/views/home_flow_views/notifications_view/notifications_view.dart";
import "package:esim_open_source/presentation/views/pre_sign_in/login_view/login_view.dart";
import "package:esim_open_source/utils/display_message_helper.dart";
import "package:flutter/material.dart";

class DataPlansViewModel extends BaseModel {
  final TextEditingController _searchTextFieldController =
      TextEditingController();

  TextEditingController get searchTextFieldController =>
      _searchTextFieldController;

  final GetUserNotificationsUseCase getUserNotificationsUseCase =
      GetUserNotificationsUseCase(locator<ApiUserRepository>());

  bool _showNotificationBadge = false;

  bool get showNotificationBadge => _showNotificationBadge;

  // List<CountryResponseModel> _countries = <CountryResponseModel>[];
  // List<RegionsResponseModel> _regions = <RegionsResponseModel>[];
  // List<BundleResponseModel> _globalBundles = <BundleResponseModel>[];

  List<CountryResponseModel> _filteredCountries = <CountryResponseModel>[];
  List<RegionsResponseModel> _filteredRegions = <RegionsResponseModel>[];
  List<BundleResponseModel> _filteredBundles = <BundleResponseModel>[];
  List<BundleResponseModel> _filteredCruiseBundles = <BundleResponseModel>[];

  Timer? _debounce;
  bool _hasBundleServicesLoaded = false;

  List<CountryResponseModel> get filteredCountries => _filteredCountries;

  List<RegionsResponseModel> get filteredRegions => _filteredRegions;

  List<BundleResponseModel> get filteredBundles => _filteredBundles;

  List<BundleResponseModel> get filteredCruiseBundles => _filteredCruiseBundles;

  static int tabBarSelectedIndex = 0;
  static int cruiseTabBarSelectedIndex = 0;

  @override
  void onViewModelReady() {
    super.onViewModelReady();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _searchTextFieldController.addListener(_updateSearch);
      fetchInitialData();
      notifyListeners();
    });
  }

  void onTabBarChange(int newIndex) {
    tabBarSelectedIndex = newIndex;
    notifyListeners();
  }

  void onCruiseTabBarChange(int newIndex) {
    cruiseTabBarSelectedIndex = newIndex;
    notifyListeners();
  }

  Future<void> loginButtonTapped() async {
    await navigationService.navigateTo(LoginView.routeName);
  }

  Future<void> notificationsButtonTapped() async {
    navigationService.navigateTo(NotificationsView.routeName);
  }

  void _updateSearch() {
    if (_debounce?.isActive ?? false) {
      _debounce?.cancel();
    }
    _debounce = Timer(const Duration(milliseconds: 400), _applySearch);
  }

  Future<void> fetchInitialData() async {
    // _filteredCountries = CountryResponseModel.getMockCountries();
    // _filteredRegions = RegionsResponseModel.getMockRegions();
    // _filteredBundles = BundleResponseModel.getMockGlobalBundles();
    // _filteredCruiseBundles = BundleResponseModel.getMockGlobalBundles();
    //
    // setViewState(ViewState.busy);

    _filteredCountries = isBundleServicesLoading
        ? CountryResponseModel.getMockCountries()
        : countries ?? <CountryResponseModel>[];
    _filteredRegions = isBundleServicesLoading
        ? RegionsResponseModel.getMockRegions()
        : regions ?? <RegionsResponseModel>[];
    _filteredBundles = isBundleServicesLoading
        ? BundleResponseModel.getMockGlobalBundles()
        : globalBundles ?? <BundleResponseModel>[];
    _filteredCruiseBundles = isBundleServicesLoading
        ? BundleResponseModel.getMockGlobalBundles()
        : cruiseBundles ?? <BundleResponseModel>[];

    if (isUserLoggedIn) {
      handleNotificationBadge();
    }

    setViewState(ViewState.idle);
  }

  void _applySearch() {
    final String searchQuery =
        _searchTextFieldController.text.trim().toLowerCase();

    if (searchQuery.isEmpty) {
      _filteredCountries = List<CountryResponseModel>.from(
        countries ?? <CountryResponseModel>[],
      );
      _filteredRegions =
          List<RegionsResponseModel>.from(regions ?? <RegionsResponseModel>[]);
      _filteredBundles = List<BundleResponseModel>.from(
        globalBundles ?? <BundleResponseModel>[],
      );
      _filteredCruiseBundles = List<BundleResponseModel>.from(
        cruiseBundles ?? <BundleResponseModel>[],
      );
    } else {
      _filteredCountries = countries
              ?.where(
                (CountryResponseModel country) =>
                    country.country?.toLowerCase().contains(searchQuery) ??
                    false,
              )
              .toList() ??
          <CountryResponseModel>[];

      _filteredRegions = regions
              ?.where(
                (RegionsResponseModel region) =>
                    region.regionName?.toLowerCase().contains(searchQuery) ??
                    false,
              )
              .toList() ??
          <RegionsResponseModel>[];

      _filteredBundles = globalBundles
              ?.where(
                (BundleResponseModel bundle) =>
                    bundle.bundleName?.toLowerCase().contains(searchQuery) ??
                    false,
              )
              .toList() ??
          <BundleResponseModel>[];

      _filteredCruiseBundles = cruiseBundles
              ?.where(
                (BundleResponseModel bundle) =>
                    bundle.bundleName?.toLowerCase().contains(searchQuery) ??
                    false,
              )
              .toList() ??
          <BundleResponseModel>[];
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  Future<void> navigateToCountryBundles(CountryResponseModel country) async {
    final EsimArguments args = EsimArguments(
      type: EsimArgumentType.country,
      id: country.id ?? "",
      name: country.country ?? "",
    );
    navigationService.navigateTo(
      BundlesListScreen.routeName,
      arguments: <String, EsimArguments>{"key": args},
    );
  }

  Future<void> navigateToRegionBundles(RegionsResponseModel region) async {
    final EsimArguments args = EsimArguments(
      type: EsimArgumentType.region,
      id: region.regionCode ?? "",
      name: region.regionName ?? "",
    );
    navigationService.navigateTo(
      BundlesListScreen.routeName,
      arguments: <String, EsimArguments>{"key": args},
    );
  }

  Future<void> navigateToEsimDetail(BundleResponseModel bundle) async {
    if (!AppEnvironment.appEnvironmentHelper.enableGuestFlowPurchase &&
        !isUserLoggedIn) {
      await navigationService.navigateTo(
        LoginView.routeName,
        arguments: InAppRedirection.purchase(
          PurchaseBundleBottomSheetArgs(
            null,
            null,
            bundle,
          ),
        ),
      );
      return;
    }
    bottomSheetService.showCustomSheet(
      data: PurchaseBundleBottomSheetArgs(
        null,
        null,
        bundle,
      ),
      enableDrag: false,
      isScrollControlled: true,
      variant: BottomSheetType.bundleDetails,
    );
    // navigationService.navigateTo(
    //   BundleDetailsScreen.routeName,
    //   arguments: <String, EsimBundleItem>{
    //     "bundleItem": bundle,
    //   },
    // );
  }

  Future<void> handleNotificationBadge() async {
    Resource<List<UserNotificationModel>?> response =
        await getUserNotificationsUseCase.execute(NoParams());
    handleResponse(
      response,
      onSuccess: (Resource<List<UserNotificationModel>?> result) async {
        if (result.data == null || (result.data?.isEmpty ?? true)) {
          _showNotificationBadge = false;
        } else {
          UserNotificationModel? foundNotRead;
          try {
            foundNotRead = result.data!
                .where(
                  (UserNotificationModel notification) =>
                      !(notification.status ?? false),
                )
                .firstOrNull; // Returns null if no element found
          } on Exception catch (_) {
            foundNotRead = null;
          }

          _showNotificationBadge = (foundNotRead != null);
          notifyListeners();
        }
      },
      onFailure: (Resource<List<UserNotificationModel>?> result) async {
        _showNotificationBadge = false;
        notifyListeners();
      },
    );
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchTextFieldController.dispose();
    super.dispose();
  }

  bool isBundleServicesBusy() {
    if (isBundleServicesLoading) {
      _hasBundleServicesLoaded = false;
    }

    if (!isBundleServicesLoading && !_hasBundleServicesLoaded) {
      if (hasError) {
        DisplayMessageHelper.toast(errorMessage ?? "");
      }
      _hasBundleServicesLoaded = true;
      _applySearch();
    }

    return isBundleServicesLoading;
  }
}
