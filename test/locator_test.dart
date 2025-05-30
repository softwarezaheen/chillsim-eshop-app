import "package:esim_open_source/domain/data/api_bundles.dart";
// import "package:esim_open_source/domain/data/api_promotion.dart";
import "package:esim_open_source/domain/data/api_user.dart";
import "package:esim_open_source/domain/repository/api_app_repository.dart";
import "package:esim_open_source/domain/repository/api_auth_repository.dart";
import "package:esim_open_source/domain/repository/api_bundles_repository.dart";
import "package:esim_open_source/domain/repository/api_device_repository.dart";
// import "package:esim_open_source/domain/repository/api_promotion_repository.dart";
import "package:esim_open_source/domain/repository/api_user_repository.dart";
import "package:esim_open_source/domain/repository/services/app_configuration_service.dart";
import "package:esim_open_source/domain/repository/services/connectivity_service.dart";
import "package:esim_open_source/domain/repository/services/device_info_service.dart";
import "package:esim_open_source/domain/repository/services/flutter_channel_handler_service.dart";
import "package:esim_open_source/domain/repository/services/local_storage_service.dart";
import "package:esim_open_source/domain/repository/services/payment_service.dart";
import "package:esim_open_source/domain/repository/services/push_notification_service.dart";
import "package:esim_open_source/domain/repository/services/redirections_handler_service.dart";
// import "package:esim_open_source/domain/repository/services/remote_config_service.dart";
import "package:esim_open_source/domain/repository/services/secure_storage_service.dart";
import "package:esim_open_source/domain/repository/services/social_login_service.dart";
import "package:esim_open_source/presentation/extensions/stacked_services/custom_route_observer.dart";
import "package:esim_open_source/presentation/reactive_service/bundles_data_service.dart";
import "package:esim_open_source/presentation/reactive_service/user_authentication_service.dart";
import "package:esim_open_source/presentation/reactive_service/user_service.dart";
import "package:esim_open_source/presentation/view_models/main_model.dart";
import "package:esim_open_source/presentation/views/home_flow_views/data_plans_view/data_plans_view_model.dart";
import "package:esim_open_source/presentation/views/home_flow_views/data_plans_view/purchase_loading_view/purchase_loading_view_model.dart";
import "package:esim_open_source/presentation/views/home_flow_views/main_page/home_pager_view_model.dart";
import "package:esim_open_source/presentation/views/home_flow_views/my_esim_view/my_esim_view_model.dart";
import "package:esim_open_source/presentation/views/home_flow_views/profile_view/profile_view_model.dart";
import "package:get_it/get_it.dart";
import "package:mockito/annotations.dart";
import "package:shared_preferences/shared_preferences.dart";
import "package:stacked/stacked_annotations.dart";
import "package:stacked_services/stacked_services.dart";
import "package:stacked_themes/stacked_themes.dart";

import "locator_test.mocks.dart";

@GenerateMocks(<Type>[
  NavigationRouter,
  CustomRouteObserver,
  DeviceInfoService,
  PushNotificationService,
  SocialLoginService,
  PaymentService,
  SecureStorageService,
  RedirectionsHandlerService,
  LocalStorageService,
  AppConfigurationService,
  FlutterChannelHandlerService,
  //RemoteConfigService,
  ConnectivityService,
  ApiAuthRepository,
  ApiAppRepository,
  APIBundles,
  ApiUser,
  ApiBundlesRepository,
  ApiUserRepository,
  ApiDeviceRepository,
  // APIPromotion,
  // ApiPromotionRepository,
  NavigationService,
  DialogService,
  SnackbarService,
  BottomSheetService,
  ThemeService,
  MainViewModel,
  MyESimViewModel,
  ProfileViewModel,
  DataPlansViewModel,
  HomePagerViewModel,
  PurchaseLoadingViewModel,
  UserService,
  UserAuthenticationService,
  BundlesDataService,
  SharedPreferences,
])
final GetIt locator = GetIt.instance;
Future<void> setupTestLocator() async {
  StackedLocator.instance.registerEnvironment();

  locator
    ..registerLazySingleton<NavigationRouter>(MockNavigationRouter.new)
    ..registerLazySingleton<MockCustomRouteObserver>(
      MockCustomRouteObserver.new,
    )
    ..registerLazySingleton<UserService>(MockUserService.new)
    ..registerLazySingleton<UserAuthenticationService>(
      MockUserAuthenticationService.new,
    )
    ..registerLazySingleton<BundlesDataService>(MockBundlesDataService.new);

  await appServicesModule();
  await appAPIServicesModule();
  await thirdPartyServicesModule();
  await viewModelModules();
}

Future<void> appServicesModule() async {
  locator
    ..registerLazySingleton<DeviceInfoService>(MockDeviceInfoService.new)
    ..registerLazySingleton<PushNotificationService>(
      MockPushNotificationService.new,
    )
    ..registerLazySingleton<SocialLoginService>(MockSocialLoginService.new)
    ..registerLazySingleton<PaymentService>(MockPaymentService.new)
    ..registerLazySingleton<SecureStorageService>(MockSecureStorageService.new)
    ..registerLazySingleton<RedirectionsHandlerService>(
      MockRedirectionsHandlerService.new,
    )
    ..registerLazySingleton<LocalStorageService>(MockLocalStorageService.new)
    ..registerLazySingleton<AppConfigurationService>(
      MockAppConfigurationService.new,
    )
    ..registerLazySingleton<FlutterChannelHandlerService>(
      MockFlutterChannelHandlerService.new,
    )
    //..registerLazySingleton<RemoteConfigService>(MockRemoteConfigService.new)
    ..registerLazySingleton<ConnectivityService>(MockConnectivityService.new)
    ..registerLazySingleton<SharedPreferences>(MockSharedPreferences.new);
  //   ..registerLazySingleton(
  //   () => RedirectionsHandlerServiceImpl.initializeWithNavigationService(
  //     navigationService: locator(),
  //     bottomSheetService: locator(),
  //   ) as RedirectionsHandlerService,
  // )
  // ..registerSingletonAsync<Store>(
  //   () async => openStore(),
  // )
}

Future<void> appAPIServicesModule() async {
  locator
    ..registerLazySingleton<ApiAuthRepository>(MockApiAuthRepository.new)
    ..registerLazySingleton<ApiAppRepository>(
      MockApiAppRepository.new,
    )
    ..registerLazySingleton<APIBundles>(MockAPIBundles.new)
    ..registerLazySingleton<ApiUser>(MockApiUser.new)
    ..registerLazySingleton<ApiBundlesRepository>(MockApiBundlesRepository.new)
    ..registerLazySingleton<ApiUserRepository>(
      MockApiUserRepository.new,
    )
    ..registerLazySingleton<ApiDeviceRepository>(MockApiDeviceRepository.new);
  // ..registerLazySingleton<APIPromotion>(MockAPIPromotion.new)
  // ..registerLazySingleton<ApiPromotionRepository>(
  //   MockApiPromotionRepository.new,
  // );
}

Future<void> thirdPartyServicesModule() async {
  locator
    ..registerLazySingleton<NavigationService>(MockNavigationService.new)
    ..registerLazySingleton<DialogService>(MockDialogService.new)
    ..registerLazySingleton<SnackbarService>(MockSnackbarService.new)
    ..registerLazySingleton<BottomSheetService>(MockBottomSheetService.new)
    ..registerLazySingleton<ThemeService>(MockThemeService.new);
}

Future<void> viewModelModules() async {
  locator
    ..registerLazySingleton<MainViewModel>(MockMainViewModel.new)
    ..registerLazySingleton<MyESimViewModel>(MockMyESimViewModel.new)
    ..registerLazySingleton<ProfileViewModel>(MockProfileViewModel.new)
    ..registerLazySingleton<DataPlansViewModel>(MockDataPlansViewModel.new)
    ..registerLazySingleton<HomePagerViewModel>(MockHomePagerViewModel.new)
    ..registerLazySingleton<PurchaseLoadingViewModel>(
      MockPurchaseLoadingViewModel.new,
    );
}
