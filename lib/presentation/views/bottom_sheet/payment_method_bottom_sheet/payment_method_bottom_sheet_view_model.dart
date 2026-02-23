import "dart:async";

import "package:easy_localization/easy_localization.dart";
import "package:esim_open_source/data/remote/responses/user/saved_payment_method_response_model.dart";
import "package:esim_open_source/di/locator.dart";
import "package:esim_open_source/domain/repository/api_user_repository.dart";
import "package:esim_open_source/domain/util/resource.dart";
import "package:esim_open_source/presentation/enums/payment_type.dart";
import "package:esim_open_source/presentation/setup_bottom_sheet_ui.dart";
import "package:esim_open_source/presentation/shared/ui_helpers.dart";
import "package:esim_open_source/presentation/views/base/base_model.dart";
import "package:esim_open_source/translations/locale_keys.g.dart";
import "package:stacked_services/stacked_services.dart";

class PaymentMethodBottomSheetViewModel extends BaseModel {
  PaymentMethodBottomSheetViewModel({
    required this.request,
    required this.completer,
  });

  final SheetRequest<SavedPaymentMethodSheetRequest> request;
  final Function(SheetResponse<SavedPaymentMethodSheetResult>) completer;

  List<SavedPaymentMethodResponseModel> _allPaymentMethods =
      <SavedPaymentMethodResponseModel>[];
  bool _showAll = false;
  bool isLoadingPaymentMethods = false;

  static const int _initialVisibleCount = 1;

  /// Only show the first (default) card initially; show all on load more.
  List<SavedPaymentMethodResponseModel> get visiblePaymentMethods =>
      _showAll
          ? _allPaymentMethods
          : _allPaymentMethods.take(_initialVisibleCount).toList();

  bool get hasMore =>
      !_showAll && _allPaymentMethods.length > _initialVisibleCount;

  int get hiddenCount =>
      _allPaymentMethods.length - _initialVisibleCount;

  bool get isShowingAll => _showAll;

  int get totalPaymentMethods => _allPaymentMethods.length;

  double get walletBalance =>
      userAuthenticationService.walletAvailableBalance;

  String get currency => request.data?.currency ?? "";

  double get amount => request.data?.amount ?? 0.0;

  bool get hasSufficientWalletBalance => walletBalance >= amount;

  bool get showWallet =>
      (request.data?.showWallet ?? true) && isUserLoggedIn;

  @override
  void onViewModelReady() {
    super.onViewModelReady();
    if (isUserLoggedIn) {
      unawaited(_loadPaymentMethods());
    }
  }

  Future<void> _loadPaymentMethods() async {
    isLoadingPaymentMethods = true;
    notifyListeners();
    final Resource<List<SavedPaymentMethodResponseModel>> response =
        await locator<ApiUserRepository>().getPaymentMethods();
    await handleResponse(
      response,
      onSuccess:
          (Resource<List<SavedPaymentMethodResponseModel>> result) async {
        final List<SavedPaymentMethodResponseModel> all =
            List<SavedPaymentMethodResponseModel>.from(
          result.data ?? <SavedPaymentMethodResponseModel>[],
        );
        // Filter out expired payment methods
        final DateTime now = DateTime.now();
        all.removeWhere(
          (SavedPaymentMethodResponseModel pm) =>
              _isExpired(pm, now),
        );
        // Default PM first
        all.sort(
          (SavedPaymentMethodResponseModel a,
              SavedPaymentMethodResponseModel b) {
            if (a.isDefault ?? false) return -1;
            if (b.isDefault ?? false) return 1;
            return 0;
          },
        );
        _allPaymentMethods = all;
      },
      onFailure:
          (Resource<List<SavedPaymentMethodResponseModel>> result) async {
        _allPaymentMethods = <SavedPaymentMethodResponseModel>[];
      },
    );
    isLoadingPaymentMethods = false;
    notifyListeners();
  }

  /// Check if a payment method is expired based on exp_month / exp_year.
  bool _isExpired(SavedPaymentMethodResponseModel pm, DateTime now) {
    final int? expMonth = pm.expMonth;
    final int? expYear = pm.expYear;
    if (expMonth == null || expYear == null) return false;
    return expYear < now.year ||
        (expYear == now.year && expMonth < now.month);
  }

  void onSelectWallet() {
    if (!hasSufficientWalletBalance) {
      unawaited(showToast(LocaleKeys.no_sufficient_balance_in_wallet.tr()));
      return;
    }
    completer(
      SheetResponse<SavedPaymentMethodSheetResult>(
        confirmed: true,
        data: const SavedPaymentMethodSheetResult(
          paymentType: PaymentType.wallet,
        ),
      ),
    );
  }

  void onSelectSavedPm(SavedPaymentMethodResponseModel pm) {
    completer(
      SheetResponse<SavedPaymentMethodSheetResult>(
        confirmed: true,
        data: SavedPaymentMethodSheetResult(
          paymentType: PaymentType.card,
          paymentMethodId: pm.stripePaymentMethodId,
        ),
      ),
    );
  }

  void onSelectNewCard() {
    completer(
      SheetResponse<SavedPaymentMethodSheetResult>(
        confirmed: true,
        data: const SavedPaymentMethodSheetResult(
          paymentType: PaymentType.card,
        ),
      ),
    );
  }

  void onLoadMore() {
    _showAll = true;
    notifyListeners();
  }

  void onHideCards() {
    _showAll = false;
    notifyListeners();
  }

  void onDismiss() {
    completer(
      SheetResponse<SavedPaymentMethodSheetResult>(
        data: const SavedPaymentMethodSheetResult(
          canceled: true,
          paymentType: PaymentType.card,
        ),
      ),
    );
  }
}
