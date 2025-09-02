import "package:esim_open_source/data/remote/responses/bundles/purchase_esim_bundle_response_model.dart";
import "package:esim_open_source/data/remote/responses/user/user_notification_response.dart";
import "package:esim_open_source/domain/repository/api_user_repository.dart";
import "package:esim_open_source/domain/repository/services/app_configuration_service.dart";
import "package:esim_open_source/domain/repository/services/connectivity_service.dart";
import "package:esim_open_source/domain/repository/services/local_storage_service.dart";
import "package:esim_open_source/domain/repository/services/referral_info_service.dart";
import "package:esim_open_source/domain/util/resource.dart";
import "package:esim_open_source/presentation/extensions/stacked_services/custom_route_observer.dart";
import "package:esim_open_source/presentation/reactive_service/bundles_data_service.dart";
import "package:esim_open_source/presentation/reactive_service/user_authentication_service.dart";
import "package:esim_open_source/presentation/views/home_flow_views/main_page/home_pager.dart";
import "package:mockito/mockito.dart";
import "package:stacked_services/stacked_services.dart";

import "../locator_test.dart";
import "../locator_test.mocks.dart";

// ignore_for_file: type=lint
void onViewModelReadyMock({
  String viewName = "",
  bool isConnected = true,
  bool clearTillFirstAndShow = true,
}) {
  MockApiUserRepository mockApiUserRepository =
      locator<ApiUserRepository>() as MockApiUserRepository;
  when(locator<NavigationRouter>().isPageVisible(viewName)).thenReturn(true);
  when(locator<NavigationRouter>().isPageVisible("")).thenReturn(true);
  when(locator<ConnectivityService>().isConnected())
      .thenAnswer((_) async => isConnected);
  when(locator<NavigationService>().clearTillFirstAndShow(HomePager.routeName))
      .thenAnswer((_) async => clearTillFirstAndShow);
  when(locator<NavigationService>().back()).thenReturn(true);
  when(locator<NavigationService>()
          .pushNamedAndRemoveUntil(HomePager.routeName))
      .thenAnswer((_) async => clearTillFirstAndShow);
  when(locator<LocalStorageService>().languageCode).thenReturn("en");
  when(locator<DialogService>().showDialog(
    title: anyNamed("title"),
    description: anyNamed("description"),
  )).thenAnswer((_) async => null);
  when(locator<UserAuthenticationService>().userEmailAddress).thenReturn("");
  when(locator<BundlesDataService>().isBundleServicesLoading).thenReturn(true);
  when(locator<AppConfigurationService>().getCashbackDiscount).thenReturn("10%");
  when(locator<ReferralInfoService>().getReferralAmount).thenReturn("5");
  when(locator<ReferralInfoService>().getReferralAmountAndCurrency).thenReturn("5 \$");
  when(locator<UserAuthenticationService>().userFirstName).thenReturn("");
  when(locator<UserAuthenticationService>().userLastName).thenReturn("");
  when(locator<UserAuthenticationService>().isUserLoggedIn).thenReturn(true);
  when(locator<UserAuthenticationService>().isNewsletterSubscribed)
      .thenReturn(true);
  when(locator<UserAuthenticationService>().userPhoneNumber)
      .thenReturn("expected");

  // Navigation Service mocks
  MockNavigationService mockNavigationService =
      locator<NavigationService>() as MockNavigationService;
  when(mockNavigationService.navigateTo(
    any,
    arguments: anyNamed("arguments"),
    id: anyNamed("id"),
    preventDuplicates: anyNamed("preventDuplicates"),
    parameters: anyNamed("parameters"),
    transition: anyNamed("transition"),
  )).thenAnswer((_) async => null);

  // API mocks
  when(mockApiUserRepository.getUserNotifications(
    pageIndex: anyNamed("pageIndex"),
    pageSize: anyNamed("pageSize"),
  )).thenAnswer(
    (_) async => Resource<List<UserNotificationModel>>.success(
      <UserNotificationModel>[],
      message: "Success",
    ),
  );

  when(mockApiUserRepository.getMyEsims()).thenAnswer(
    (_) async => Resource<List<PurchaseEsimBundleResponseModel>?>.success(
      <PurchaseEsimBundleResponseModel>[],
      message: "Success",
    ),
  );

  // Setup UserGuideDetailedViewModel mock
  // setupUserGuideDetailedViewModelMock();
}

// Empty main function to prevent Flutter test runner from treating this as a test file
void main() {}
