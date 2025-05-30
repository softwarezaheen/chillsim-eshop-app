import "dart:async";
import "dart:developer";
import "dart:io";

import "package:easy_localization/easy_localization.dart";
import "package:esim_open_source/data/remote/responses/bundles/bundle_response_model.dart";
import "package:esim_open_source/data/remote/responses/bundles/country_response_model.dart";
import "package:esim_open_source/data/remote/responses/bundles/regions_response_model.dart";
import "package:esim_open_source/data/services/connectivity_service_impl.dart";
import "package:esim_open_source/di/locator.dart";
import "package:esim_open_source/domain/repository/api_app_repository.dart";
import "package:esim_open_source/domain/repository/api_device_repository.dart";
import "package:esim_open_source/domain/repository/services/connectivity_service.dart";
import "package:esim_open_source/domain/repository/services/flutter_channel_handler_service.dart";
import "package:esim_open_source/domain/repository/services/local_storage_service.dart";
import "package:esim_open_source/domain/repository/services/payment_service.dart";
import "package:esim_open_source/domain/repository/services/redirections_handler_service.dart";
import "package:esim_open_source/domain/repository/services/social_login_service.dart";
import "package:esim_open_source/domain/use_case/app/add_device_use_case.dart";
import "package:esim_open_source/domain/use_case/base_use_case.dart";
import "package:esim_open_source/domain/util/resource.dart";
import "package:esim_open_source/presentation/enums/dialog_icon_type.dart";
import "package:esim_open_source/presentation/enums/dialog_type.dart";
import "package:esim_open_source/presentation/enums/view_state.dart";
import "package:esim_open_source/presentation/extensions/stacked_services/custom_route_observer.dart";
import "package:esim_open_source/presentation/reactive_service/bundles_data_service.dart";
import "package:esim_open_source/presentation/reactive_service/user_authentication_service.dart";
import "package:esim_open_source/presentation/reactive_service/user_service.dart";
import "package:esim_open_source/presentation/setup_dialog_ui.dart";
import "package:esim_open_source/presentation/shared/action_helpers.dart";
import "package:esim_open_source/presentation/shared/haptic_feedback.dart";
import "package:esim_open_source/presentation/shared/shared_styles.dart"
    as shared;
import "package:esim_open_source/presentation/shared/ui_helpers.dart";
import "package:esim_open_source/presentation/views/home_flow_views/data_plans_view/data_plans_view_model.dart";
import "package:esim_open_source/presentation/views/home_flow_views/main_page/home_pager.dart";
import "package:esim_open_source/presentation/views/home_flow_views/main_page/home_pager_view_model.dart";
import "package:esim_open_source/presentation/views/home_flow_views/my_esim_view/my_esim_view_model.dart";
import "package:esim_open_source/presentation/views/home_flow_views/profile_view/profile_view_model.dart";
import "package:esim_open_source/translations/locale_keys.g.dart";
import "package:flutter/material.dart";
import "package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart";
import "package:fluttertoast/fluttertoast.dart";
import "package:stacked/stacked.dart";
import "package:stacked_services/stacked_services.dart";
import "package:stacked_themes/stacked_themes.dart";

class BaseModel extends ReactiveViewModel implements ConnectionListener {
  BaseModel() {
    log("init ${super.runtimeType}");
  }

  final DialogService dialogService = locator<DialogService>();
  final SnackbarService snackBarService = locator<SnackbarService>();
  final ConnectivityService connectivityService =
      locator<ConnectivityService>();

  // final ContactService contactService = locator<ContactService>();
  // final BiometricAuthService biometricAuthService =
  //     locator<BiometricAuthService>();
  final LocalStorageService localStorageService =
      locator<LocalStorageService>();

  final BottomSheetService bottomSheetService = locator<BottomSheetService>();
  final NavigationService navigationService = locator<NavigationService>();
  final NavigationRouter navigationRouter = locator<NavigationRouter>();
  final ThemeService themeService = locator<ThemeService>();
  final UserService userService = locator<UserService>();
  final PaymentService paymentService = locator<PaymentService>();
  final UserAuthenticationService userAuthenticationService =
      locator<UserAuthenticationService>();
  final RedirectionsHandlerService redirectionsHandlerService =
      locator<RedirectionsHandlerService>();

  final AddDeviceUseCase addDeviceUseCase = AddDeviceUseCase(
    locator<ApiAppRepository>(),
    locator<ApiDeviceRepository>(),
  );

  final FlutterChannelHandlerService flutterChannelHandlerService =
      locator<FlutterChannelHandlerService>();
  final BundlesDataService _bundlesService = locator<BundlesDataService>();

  List<BundleResponseModel>? get globalBundles => _bundlesService.globalBundles;

  List<CountryResponseModel>? get countries => _bundlesService.countries;

  List<RegionsResponseModel>? get regions => _bundlesService.regions;

  List<BundleResponseModel>? get cruiseBundles => _bundlesService.cruiseBundles;

  bool get isBundleServicesLoading => _bundlesService.isBundleServicesLoading;

  @override
  bool get hasError => _bundlesService.hasError;

  String? get errorMessage => _bundlesService.errorMessage;

  Future<void> refreshData() async {
    await _bundlesService.refreshData();
    notifyListeners();
  }

  List<BundleResponseModel>? getBundlesForCountry(String countryCode) {
    return _bundlesService.getBundlesByCountry(countryCode);
  }

  String routeName = "";

  bool get showMainBanner => true;

  bool get isUserLoggedIn => userAuthenticationService.isUserLoggedIn;

  String get userFirstName => userAuthenticationService.userFirstName;

  String get userLastName => userAuthenticationService.userLastName;

  String get userEmailAddress => userAuthenticationService.userEmailAddress;

  bool get isNewsletterSubscribed =>
      userAuthenticationService.isNewsletterSubscribed;

  String get userMsisdn => userAuthenticationService.userPhoneNumber;

  bool get isArabic {
    return false;
  }

  Color get themeColor => shared.themeColor;

  ViewState _viewState = ViewState.idle;

  ViewState get viewState => _viewState;

  double? shimmerHeight;

  bool _applyShimmer = false;

  bool get applyShimmer => _applyShimmer;

  set applyShimmer(bool value) {
    _applyShimmer = value;
    notifyListeners();
  }

  @override
  bool get isBusy => _viewState == ViewState.busy;

  void onViewModelReady() {
    log("ViewModel $runtimeType Ready");
    navigationRouter.addListener(_onViewDidAppearHandler);
    if (navigationRouter.isPageVisible(routeName)) {
      _onViewDidAppearHandler();
    }
  }

  void _onViewDidAppearHandler() {
    if (navigationRouter.isPageVisible(routeName)) {
      log("ViewModel: onViewDidAppear $runtimeType");
      onViewDidAppear();
    }
  }

  void onViewDidAppear() {
    connectivityService.addListener(this);
    unawaited(onConnectivityChangedUpdate());
  }

  void onDispose() {
    log("ViewModel $runtimeType Disposed");
    navigationRouter.removeListener(_onViewDidAppearHandler);
  }

  @override
  void dispose() {
    connectivityService.removeListener(this);
    super.dispose();
  }

  void setViewState(ViewState state) {
    _viewState = state;
    notifyListeners();
  }

  Future<DialogResponse<MainDialogResponse>?> showErrorMessageDialog(
    String? message, {
    TextStyle? descriptionTextStyle,
    String? cancelText,
    DialogIconType? iconType,
  }) {
    return dialogService.showCustomDialog(
      variant: DialogType.basic,
      barrierDismissible: true,
      data: MainDialogRequest(
        descriptionTextStyle: descriptionTextStyle,
        informativeOnly: true,
        description: message,
        dismissibleDialog: true,
        cancelText: cancelText,
        iconType: iconType ?? DialogIconType.warning,
      ),
    );
  }

  Future<void> showNativeErrorMessage(
    String? titleMessage,
    String? contentMessage,
  ) async {
    if (Platform.isIOS) {
      await dialogService.showDialog(
        title: titleMessage ?? "Error",
        description: contentMessage ?? "Please try again",
      );
    } else {
      await showToast(
        contentMessage ?? "Error",
        gravity: ToastGravity.BOTTOM,
        toastLength: Toast.LENGTH_LONG,
        backgroundColor: Colors.grey,
      );
    }
  }

  bool isKeyboardVisible(BuildContext context) {
    final bool isKeyboardVisible =
        KeyboardVisibilityProvider.isKeyboardVisible(context);
    return isKeyboardVisible;
    // if (MediaQuery.of(context).viewInsets.bottom > 0.0) {
    //   return true;
    // }
    // return false;
  }

  Future<String?> listenForSMS() async {
    return null;

    // String? sms = await AndroidSmsRetriever.listenForSms();
    // return _getSmsCode(sms);
  }

  Future<void> stopSmsListener() async {
    // return AndroidSmsRetriever.stopSmsListener();
  }

  // String? _getSmsCode(String? code) {
  //   if (code == null) {
  //     return null;
  //   }
  //   try {
  //     RegExp pattern = RegExp(r"\d+");
  //     Iterable<Match> matches = pattern.allMatches(code);
  //
  //     for (Match match in matches) {
  //       String? possibleSmsCode = match.group(0);
  //
  //       if ((possibleSmsCode?.length ?? 0) > 4) {
  //         return possibleSmsCode;
  //       }
  //     }
  //   } on Exception catch (e) {
  //     log(e.toString());
  //   }
  //   return null;
  // }

  Future<T> navigateToHomePager<T>() async {
    DataPlansViewModel.tabBarSelectedIndex = 0;
    DataPlansViewModel.cruiseTabBarSelectedIndex = 0;
    locator
      ..resetLazySingleton(instance: locator<MyESimViewModel>())
      ..resetLazySingleton(instance: locator<ProfileViewModel>())
      ..resetLazySingleton(instance: locator<HomePagerViewModel>())
      ..resetLazySingleton(instance: locator<DataPlansViewModel>());
    return await navigationService.pushNamedAndRemoveUntil(
      HomePager.routeName,
    );
  }

  @override
  List<ListenableServiceMixin> get listenableServices =>
      <ListenableServiceMixin>[
        userService,
        userAuthenticationService,
        _bundlesService,
      ];

  Future<void> logoutUser() async {
    await userAuthenticationService.clearUserInfo();
    locator<SocialLoginService>().logOut();
    addDeviceUseCase.execute(NoParams());
  }

  Future<void> handleResponse<T>(
    Resource<T> response, {
    required Future<void> Function(Resource<T>) onSuccess,
    Future<void> Function(Resource<T>)? onFailure,
  }) async {
    switch (response.resourceType) {
      case ResourceType.success:
        playHapticFeedback(HapticFeedbackType.apiSuccess);
        onSuccess(response);
      case ResourceType.error:
        playHapticFeedback(HapticFeedbackType.apiError);
        if (onFailure == null) {
          handleError(response);
          return;
        }
        onFailure(response);
      case ResourceType.loading:
        handleLoading();
    }
  }

  // Handle error state in base class
  Future<void> handleError(
    Resource<dynamic> response,
  ) async {
    await showNativeErrorMessage(
      response.error?.message,
      response.message,
    );
    setViewState(ViewState.idle);
  }

  // Handle loading state
  void handleLoading() {
    setViewState(ViewState.busy);
  }

  BuildContext? _dialogContext;

  @override
  Future<void> onConnectivityChanged({required bool connected}) async {
    if (connected) {
      locator<HomePagerViewModel>().lockTabBar = false;
      // Close the dialog if it's open
      if (_dialogContext != null) {
        Navigator.pop(_dialogContext!);
        _dialogContext = null; // Reset dialog context
      }
    } else {
      await navigationService.clearTillFirstAndShow(HomePager.routeName);

      int? index = locator<HomePagerViewModel>().getSelectedTabIndex();
      if (index == 1 && isUserLoggedIn) {
        locator<HomePagerViewModel>().lockTabBar = true;
        return;
      }

      if (StackedService.navigatorKey?.currentContext != null &&
          _dialogContext == null &&
          navigationRouter.isPageVisible(routeName)) {
        _dialogContext = StackedService.navigatorKey?.currentContext;
        log("Pop displayed by: $routeName");

        showNativeDialog(
          context: _dialogContext!,
          titleText: LocaleKeys.noConnection_titleText.tr(),
          contentText: LocaleKeys.noConnection_contentText.tr(),
          buttons: <NativeButtonParams>[
            if (isUserLoggedIn)
              NativeButtonParams(
                buttonTitle: LocaleKeys.noConnection_buttonTitleText.tr(),
                buttonAction: () {
                  _dialogContext = null;
                  Navigator.pop(
                    StackedService.navigatorKey!.currentContext!,
                  );
                  locator<HomePagerViewModel>()
                      .changeSelectedTabIndex(index: 1);
                  locator<HomePagerViewModel>().lockTabBar = true;
                },
              ),
          ],
        );
      }
    }
  }

  Future<void> onConnectivityChangedUpdate() async {
    onConnectivityChanged(connected: await connectivityService.isConnected());
  }
}
