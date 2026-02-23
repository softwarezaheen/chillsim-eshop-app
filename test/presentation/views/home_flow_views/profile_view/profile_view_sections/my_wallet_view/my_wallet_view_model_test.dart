import "package:esim_open_source/app/environment/app_environment.dart";
import "package:esim_open_source/data/remote/responses/auth/auth_response_model.dart";
import "package:esim_open_source/domain/repository/api_auth_repository.dart";
import "package:esim_open_source/domain/use_case/user/get_user_info_use_case.dart";
import "package:esim_open_source/domain/util/resource.dart";
import "package:esim_open_source/presentation/views/base/base_model.dart";
import "package:esim_open_source/presentation/views/home_flow_views/profile_view/profile_view_sections/my_wallet_view/my_wallet_view_model.dart";
import "package:esim_open_source/presentation/views/home_flow_views/profile_view/profile_view_sections/my_wallet_view/my_wallet_view_sections.dart";
import "package:flutter_test/flutter_test.dart";
import "package:mockito/mockito.dart";

import "../../../../../../helpers/view_helper.dart";
import "../../../../../../helpers/view_model_helper.dart";
import "../../../../../../locator_test.dart";
import "../../../../../../locator_test.mocks.dart";

Future<void> main() async {
  await prepareTest();
  late MyWalletViewModel viewModel;
  late MockApiAuthRepository mockApiAuthRepository;

  setUp(() async {
    await setupTest();
    onViewModelReadyMock(viewName: "MyWalletView");

    mockApiAuthRepository =
        locator<ApiAuthRepository>() as MockApiAuthRepository;
    viewModel = MyWalletViewModel();
  });

  tearDown(() async {
    await tearDownTest();
  });

  group("MyWalletViewModel Tests", () {
    test("initialization sets wallet sections correctly", () {
      expect(viewModel.walletSections, isNotEmpty);
      // Should have at least voucherCode and walletTransactions (upgradeWallet depends on enableWalletRecharge)
      expect(viewModel.walletSections.length, greaterThanOrEqualTo(2));
      expect(viewModel.walletSections, contains(MyWalletViewSections.voucherCode));
      expect(viewModel.walletSections, contains(MyWalletViewSections.walletTransactions));
    });

    test("getUserInfoUseCase is initialized correctly", () {
      expect(viewModel.getUserInfoUseCase, isA<GetUserInfoUseCase>());
      expect(viewModel.getUserInfoUseCase, isNotNull);
    });

    test("onViewModelReady calls refreshUserInfo", () async {
      when(mockApiAuthRepository.getUserInfo()).thenAnswer(
        (_) async =>
            Resource<AuthResponseModel?>.success(null, message: "Success"),
      );

      await viewModel.onViewModelReady();

      verify(mockApiAuthRepository.getUserInfo()).called(1);
    });

    test("refreshUserInfo sets applyShimmer correctly during execution",
        () async {
      when(mockApiAuthRepository.getUserInfo()).thenAnswer(
        (_) async =>
            Resource<AuthResponseModel?>.success(null, message: "Success"),
      );

      // Initially shimmer should be false
      expect(viewModel.applyShimmer, isFalse);

      // Call refreshUserInfo
      await viewModel.refreshUserInfo();

      // After completion, shimmer should be false
      expect(viewModel.applyShimmer, isFalse);
    });

    test("refreshUserInfo handles success response correctly", () async {
      final AuthResponseModel mockResponse = AuthResponseModel();
      when(mockApiAuthRepository.getUserInfo()).thenAnswer(
        (_) async => Resource<AuthResponseModel?>.success(mockResponse,
            message: "Success",),
      );

      await viewModel.refreshUserInfo();

      verify(mockApiAuthRepository.getUserInfo()).called(1);
      expect(viewModel.applyShimmer, isFalse);
    });

    test("refreshUserInfo calls notifyListeners", () async {
      when(mockApiAuthRepository.getUserInfo()).thenAnswer(
        (_) async =>
            Resource<AuthResponseModel?>.success(null, message: "Success"),
      );

      bool listenerCalled = false;
      viewModel.addListener(() {
        listenerCalled = true;
      });

      await viewModel.refreshUserInfo();

      expect(listenerCalled, isTrue);
    });

    test("wallet sections contain expected sections based on feature flags", () {
      // These sections should always be present
      expect(viewModel.walletSections, contains(MyWalletViewSections.voucherCode));
      expect(viewModel.walletSections, contains(MyWalletViewSections.walletTransactions));
      
      // upgradeWallet is only present when enableWalletRecharge is true
      if (AppEnvironment.appEnvironmentHelper.enableWalletRecharge) {
        expect(viewModel.walletSections, contains(MyWalletViewSections.upgradeWallet));
      }
    });

    test("viewModel extends BaseModel", () {
      expect(viewModel, isA<BaseModel>());
    });

    test("wallet sections maintain correct order", () {
      // First section is always voucherCode
      expect(viewModel.walletSections[0],
          equals(MyWalletViewSections.voucherCode),);
      
      // Determine expected indices based on enabled features
      int expectedCashbackIndex = 1;
      int expectedTransactionsIndex = AppEnvironment.appEnvironmentHelper.enableCashBack ? 2 : 1;
      int? expectedUpgradeIndex;
      
      if (AppEnvironment.appEnvironmentHelper.enableWalletRecharge) {
        expectedUpgradeIndex = viewModel.walletSections.length - 1;
      }
      
      // Check cashbackRewards if enabled
      if (AppEnvironment.appEnvironmentHelper.enableCashBack) {
        expect(
          viewModel.walletSections[expectedCashbackIndex],
          equals(MyWalletViewSections.cashbackRewards),
        );
      }
      
      // walletTransactions should be second or third depending on cashback
      expect(
        viewModel.walletSections[expectedTransactionsIndex],
        equals(MyWalletViewSections.walletTransactions),
      );
      
      // upgradeWallet only if wallet recharge is enabled (last item)
      if (expectedUpgradeIndex != null) {
        expect(viewModel.walletSections[expectedUpgradeIndex],
            equals(MyWalletViewSections.upgradeWallet),);
      }
    });

    test("wallet sections are properly typed", () {
      for (final MyWalletViewSections section in viewModel.walletSections) {
        expect(section, isA<MyWalletViewSections>());
      }
    });

    test("getUserInfoUseCase has correct repository dependency", () {
      expect(viewModel.getUserInfoUseCase.repository, isNotNull);
    });
  });
}
