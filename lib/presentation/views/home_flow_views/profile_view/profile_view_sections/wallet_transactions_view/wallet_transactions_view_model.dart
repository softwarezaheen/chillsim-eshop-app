import "dart:async";
import "dart:developer";

import "package:esim_open_source/di/locator.dart";
import "package:esim_open_source/data/remote/responses/user/wallet_transaction_response.dart";
import "package:esim_open_source/domain/use_case/base_use_case.dart";
import "package:esim_open_source/domain/use_case/user/get_wallet_transactions_pagination_use_case.dart";
import "package:esim_open_source/domain/util/pagination/paginated_data.dart";
import "package:esim_open_source/presentation/views/base/base_model.dart";
import "package:intl/intl.dart";

class WalletTransactionsViewModel extends BaseModel {
  //#region UseCases

  GetWalletTransactionsPaginationUseCase getWalletTransactionsPaginationUseCase =
      GetWalletTransactionsPaginationUseCase(locator());

  //#endregion

  //#region Variables
  PaginationService<WalletTransactionResponse> get walletTransactionsPaginationService =>
      getWalletTransactionsPaginationUseCase.paginationService;

  //#endregion

  //#region Functions
  @override
  void onViewModelReady() {
    super.onViewModelReady();
    
    try {
      // Initialize safely
      _initializeTransactions();
    } catch (e) {
      log("Error initializing wallet transactions: $e");
    }
  }
  
  void _initializeTransactions() {
    unawaited(getTransactions());
  }

  @override
  void onDispose() {
    getWalletTransactionsPaginationUseCase.dispose();
    super.onDispose();
  }

  // Getters for UI
  List<WalletTransactionUiModel> get transactions {
    return walletTransactionsPaginationService.notifier.items
        .map((response) => WalletTransactionUiModel.fromResponse(response))
        .toList();
  }
  
  int get totalTransactions => walletTransactionsPaginationService.notifier.items.length;

  //#endregion

  //#region Apis
  Future<void> getTransactions() async {
    try {
      await getWalletTransactionsPaginationUseCase.loadNextPage(NoParams());
    } catch (e) {
      log("Error loading wallet transactions: $e");
    }
  }

  Future<void> refreshTransactions() async {
    try {
      await getWalletTransactionsPaginationUseCase.refreshData(NoParams());
    } catch (e) {
      log("Error refreshing wallet transactions: $e");
    }
  }

//#endregion
}

class WalletTransactionUiModel {
  WalletTransactionUiModel({
    required this.id,
    required this.transactionType,
    required this.amount,
    required this.title,
    required this.description,
    required this.date,
    required this.status,
    this.voucherCode,
    this.orderId,
    this.sourceDetail,
  });

  final String id;
  final WalletTransactionType transactionType;
  final String amount;
  final String title;
  final String description;
  final String date;
  final String status;
  final String? voucherCode;
  final String? orderId;
  final String? sourceDetail;

  factory WalletTransactionUiModel.fromResponse(WalletTransactionResponse response) {
    // Format date from ISO to locale date time with AM/PM
    String formattedDate = _formatDateToLocale(response.date ?? "");
    
    return WalletTransactionUiModel(
      id: response.id ?? "",
      transactionType: response.transactionTypeEnum,
      amount: response.amount ?? "",
      title: response.title ?? "Transaction",
      description: response.description ?? "",
      date: formattedDate,
      status: response.status ?? "",
      voucherCode: response.voucherCode,
      orderId: response.orderId,
      sourceDetail: response.sourceDetail,
    );
  }

  static String _formatDateToLocale(String dateInput) {
    if (dateInput.isEmpty) return "";
    
    try {
      DateTime dateTime;
      
      // Try to parse as timestamp (milliseconds or seconds)
      if (RegExp(r'^\d+$').hasMatch(dateInput)) {
        int timestamp = int.parse(dateInput);
        
        // If timestamp is in seconds (10 digits), convert to milliseconds
        if (timestamp.toString().length == 10) {
          timestamp = timestamp * 1000;
        }
        
        // Parse as UTC timestamp and convert to local time
        dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp, isUtc: true).toLocal();
      } else {
        // Try to parse as ISO date string (usually UTC) and convert to local time
        dateTime = DateTime.parse(dateInput).toLocal();
      }
      
      // Format as "MMM dd, yyyy h:mm a" (e.g., "Jan 15, 2024 10:30 AM") in local time
      return DateFormat('MMM dd, yyyy h:mm a').format(dateTime);
    } catch (e) {
      return dateInput; // Return original if parsing fails
    }
  }

  bool get isPositive => amount.startsWith("+");
  bool get isNegative => amount.startsWith("-");
  bool get isSuccess => status.toLowerCase() == "success";
  bool get isPending => status.toLowerCase() == "pending";
  bool get isFailed => status.toLowerCase() == "failed";
  
  // Check if this is a balance modification transaction (top_up with negative or positive amount)
  bool get isBalanceChange => transactionType == WalletTransactionType.topUp;
  
  // Get numeric amount value for comparison
  double get numericAmount {
    try {
      String cleanAmount = amount.replaceAll(RegExp(r'[^\d.-]'), '');
      return double.tryParse(cleanAmount) ?? 0.0;
    } catch (e) {
      return 0.0;
    }
  }

  // Mock data for testing
  static List<WalletTransactionUiModel> get mockData => 
      WalletTransactionResponse.mockData
          .map((response) => WalletTransactionUiModel.fromResponse(response))
          .toList();

  static List<WalletTransactionUiModel> get shimmerData => 
      List.generate(5, (index) => WalletTransactionUiModel(
        id: "$index",
        transactionType: WalletTransactionType.topUp,
        amount: "",
        title: "",
        description: "",
        date: "",
        status: "",
      ));
}